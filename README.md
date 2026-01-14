# aac_sinhala_tamil_english

Flutter AAC app with Sinhala, Tamil, and English support.

## Owner

Yasas Pasindu Fernando

## Emotion Model Training (Local)

This project trains a facial emotion classifier using three local dataset folders:

- `data/Autism Facial Recognition Dataset_Augmented`
- `data/Autism emotion recogition dataset`
- `data/Autistic Children Emotions - Dr. Fatma M. Talaat`

All three datasets share these classes:

`anger`, `fear`, `joy`, `Natural`, `sadness`, `surprise`

### Step-by-step

1) Create a Python environment (recommended Python 3.10 or 3.11)
2) Install dependencies
3) Run the training script
4) Use the exported TFLite model in the Flutter app

### Commands

```bash
python -m venv training\.venv
training\.venv\Scripts\activate
python -m pip install -r training\requirements.txt
python training\train_emotions.py
```

### Outputs

After training completes, you will get:

- `outputs/emotion_model.keras`
- `outputs/emotion_model.tflite`
- `outputs/labels.txt`

### Notes

- If TensorFlow install fails on Python 3.12, switch to Python 3.11.
- The script ignores corrupt images automatically.
