import argparse
import json
import math
from pathlib import Path

import numpy as np
import tensorflow as tf

CLASSES = ["anger", "fear", "joy", "Natural", "sadness", "surprise"]
VALID_EXTS = {".jpg", ".jpeg", ".png"}
IMG_SIZE = (224, 224)
SEED = 1337


def collect_files(split_dirs):
    paths = []
    labels = []
    for split_dir in split_dirs:
        if not split_dir.exists():
            continue
        for class_index, class_name in enumerate(CLASSES):
            class_dir = split_dir / class_name
            if not class_dir.exists():
                continue
            for path in class_dir.rglob("*"):
                if path.suffix.lower() in VALID_EXTS:
                    paths.append(str(path))
                    labels.append(class_index)
    return paths, labels


def split_train_val(paths, labels, val_split):
    indices = np.arange(len(paths))
    rng = np.random.default_rng(SEED)
    rng.shuffle(indices)
    val_size = int(len(indices) * val_split)
    val_idx = indices[:val_size]
    train_idx = indices[val_size:]

    train_paths = [paths[i] for i in train_idx]
    train_labels = [labels[i] for i in train_idx]
    val_paths = [paths[i] for i in val_idx]
    val_labels = [labels[i] for i in val_idx]
    return train_paths, train_labels, val_paths, val_labels


def make_dataset(paths, labels, batch_size, augment, repeat):
    ds = tf.data.Dataset.from_tensor_slices((paths, labels))
    if augment:
        ds = ds.shuffle(buffer_size=len(paths), seed=SEED, reshuffle_each_iteration=True)

    augmenter = tf.keras.Sequential(
        [
            tf.keras.layers.RandomFlip("horizontal"),
            tf.keras.layers.RandomRotation(0.05),
            tf.keras.layers.RandomZoom(0.05),
        ]
    )

    def load_image(path, label):
        image = tf.io.read_file(path)
        image = tf.io.decode_image(image, channels=3, expand_animations=False)
        image.set_shape([None, None, 3])
        image = tf.image.resize(image, IMG_SIZE)
        image = tf.cast(image, tf.float32)
        image = tf.keras.applications.mobilenet_v2.preprocess_input(image)
        if augment:
            image = augmenter(image)
        return image, label

    ds = ds.map(load_image, num_parallel_calls=tf.data.AUTOTUNE)
    ds = ds.ignore_errors()
    if repeat:
        ds = ds.repeat()
    ds = ds.batch(batch_size).prefetch(tf.data.AUTOTUNE)
    return ds


def build_model(num_classes, use_pretrained):
    base = tf.keras.applications.MobileNetV2(
        input_shape=IMG_SIZE + (3,),
        include_top=False,
        weights="imagenet" if use_pretrained else None,
    )
    base.trainable = False

    inputs = tf.keras.Input(shape=IMG_SIZE + (3,))
    x = base(inputs, training=False)
    x = tf.keras.layers.GlobalAveragePooling2D()(x)
    x = tf.keras.layers.Dropout(0.2)(x)
    outputs = tf.keras.layers.Dense(num_classes, activation="softmax")(x)
    model = tf.keras.Model(inputs, outputs)
    model.compile(
        optimizer=tf.keras.optimizers.Adam(),
        loss="sparse_categorical_crossentropy",
        metrics=["accuracy"],
    )
    return model, base


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--data_root",
        type=str,
        default=str(Path(__file__).resolve().parents[1] / "data"),
        help="Path to the data folder",
    )
    parser.add_argument("--epochs", type=int, default=8)
    parser.add_argument("--batch_size", type=int, default=32)
    parser.add_argument("--val_split", type=float, default=0.15)
    parser.add_argument("--fine_tune_epochs", type=int, default=4)
    parser.add_argument("--no_pretrained", action="store_true")
    parser.add_argument("--fine_tune", action="store_true")
    args = parser.parse_args()

    data_root = Path(args.data_root)
    train_dirs = [
        data_root / "Autism Facial Recognition Dataset_Augmented" / "train",
        data_root
        / "Autism emotion recogition dataset"
        / "Autism emotion recogition dataset"
        / "train",
        data_root
        / "Autistic Children Emotions - Dr. Fatma M. Talaat"
        / "Autistic Children Emotions - Dr. Fatma M. Talaat"
        / "Train",
    ]
    test_dirs = [
        data_root / "Autism Facial Recognition Dataset_Augmented" / "test",
        data_root
        / "Autism emotion recogition dataset"
        / "Autism emotion recogition dataset"
        / "test",
        data_root
        / "Autistic Children Emotions - Dr. Fatma M. Talaat"
        / "Autistic Children Emotions - Dr. Fatma M. Talaat"
        / "Test",
    ]

    train_paths, train_labels = collect_files(train_dirs)
    test_paths, test_labels = collect_files(test_dirs)

    if not train_paths:
        raise SystemExit("No training images found. Check data folder paths.")

    train_paths, train_labels, val_paths, val_labels = split_train_val(
        train_paths, train_labels, args.val_split
    )

    train_ds = make_dataset(
        train_paths, train_labels, args.batch_size, augment=True, repeat=True
    )
    val_ds = make_dataset(
        val_paths, val_labels, args.batch_size, augment=False, repeat=False
    )
    test_ds = (
        make_dataset(test_paths, test_labels, args.batch_size, augment=False, repeat=False)
        if test_paths
        else None
    )

    train_steps = math.ceil(len(train_paths) / args.batch_size)
    val_steps = math.ceil(len(val_paths) / args.batch_size)
    test_steps = math.ceil(len(test_paths) / args.batch_size) if test_paths else None

    model, base = build_model(len(CLASSES), use_pretrained=not args.no_pretrained)
    history = model.fit(
        train_ds,
        validation_data=val_ds,
        epochs=args.epochs,
        steps_per_epoch=train_steps,
        validation_steps=val_steps,
    )

    if args.fine_tune:
        base.trainable = True
        fine_tune_at = int(len(base.layers) * 0.8)
        for layer in base.layers[:fine_tune_at]:
            layer.trainable = False
        model.compile(
            optimizer=tf.keras.optimizers.Adam(1e-5),
            loss="sparse_categorical_crossentropy",
            metrics=["accuracy"],
        )
        history = model.fit(
            train_ds,
            validation_data=val_ds,
            epochs=args.fine_tune_epochs,
            steps_per_epoch=train_steps,
            validation_steps=val_steps,
        )

    if test_ds is not None:
        model.evaluate(test_ds, verbose=2, steps=test_steps)

    output_dir = Path(__file__).resolve().parents[1] / "outputs"
    output_dir.mkdir(parents=True, exist_ok=True)

    model.save(output_dir / "emotion_model.keras")
    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    tflite_model = converter.convert()
    (output_dir / "emotion_model.tflite").write_bytes(tflite_model)
    (output_dir / "labels.txt").write_text("\n".join(CLASSES))
    (output_dir / "history.json").write_text(json.dumps(history.history, indent=2))


if __name__ == "__main__":
    main()
