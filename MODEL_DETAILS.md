# Model Details

## Model Artifact (Best Accuracy Run)
- Run folder: outputs/best_all_ft_v1
- Files:
  - outputs/best_all_ft_v1/emotion_model.keras
  - outputs/best_all_ft_v1/emotion_model.tflite
  - outputs/best_all_ft_v1/labels.txt
  - outputs/best_all_ft_v1/history.json

## Classes
anger, fear, joy, Natural, sadness, surprise

## Training Data (Dataset = all)
- data/Autism Facial Recognition Dataset_Augmented
- data/Autism emotion recogition dataset
- data/Autistic Children Emotions - Dr. Fatma M. Talaat

## Model Architecture
- Base: MobileNetV2 (ImageNet pretrained unless --no_pretrained)
- Input size: 224x224 RGB
- Head: GlobalAveragePooling2D -> Dropout(0.2) -> Dense(softmax)

## Preprocessing & Augmentation
- Preprocess: tf.keras.applications.mobilenet_v2.preprocess_input
- Augment: RandomFlip(horizontal), RandomRotation(0.05), RandomZoom(0.05)

## Training Config (from training/train_emotions.py defaults)
- epochs: 8
- batch_size: 32
- val_split: 0.15
- fine_tune: optional (not recorded in history.json)

## Accuracy (from outputs/best_all_ft_v1/history.json)
- Train accuracy by epoch: [0.4959, 0.5701, 0.6200, 0.6627]
- Val accuracy by epoch:   [0.4917, 0.5581, 0.5839, 0.6304]
- Best val accuracy: 0.6304 (epoch 4)