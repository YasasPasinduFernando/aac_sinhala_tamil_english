README - Dataset Notes

Location:
C:\Users\yasas\Desktop\aac\aac_sinhala_tamil_english\data

These two datasets were downloaded from Kaggle and unzipped here. Zip files are kept as requested.

1) Autism Facial Emotion Recognition Dataset (Kaggle)
   Source: https://www.kaggle.com/datasets/hasibur013/autism-facial-emotion-recognition
   Kaggle description (summary):
   - Augmented and split dataset for ASD vs Non-ASD facial image classification.
   - Uses extensive Albumentations (flip, rotate, HSV, gamma, blur, noise, resized crop).
   - Images resized to 224x224 JPEG.
   - Train/test split with class folders: Autistic, Non_Autistic.
   Extracted folders:
   - Autism Facial Recognition Dataset_Augmented
   - Autism emotion recogition dataset
   Note: This dataset extracted into two visible folders (original + augmented/split).

2) Autistic Children Emotions - Dr. Fatma M. Talaat (Kaggle)
   Source: https://www.kaggle.com/datasets/fatmamtalaat/autistic-children-emotions-dr-fatma-m-talaat
   Kaggle description (summary):
   - Cleaned photos of autistic children with facial emotions.
   - Stock/duplicate images removed.
   - Six emotion categories: surprise, delight, sadness, fear, joy, anger.
   Extracted folder:
   - Autistic Children Emotions - Dr. Fatma M. Talaat

Zip files kept:
- autism-facial-emotion-recognition.zip
- autistic-children-emotions-dr-fatma-m-talaat.zip

Next (simple path):
- Choose one dataset for training
- Inspect class labels + folder structure
- Train model (e.g., MobileNetV2) and export to TFLite for app use
