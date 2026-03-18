# FC6P01ES Final Year Project Interim Report

---

## Cover Page

**Module Code:** FC6P01ES
**Module Name:** Final Year Project
**Institution:** ESOFT Metro Campus

**Project Title:**
AI-Powered Augmentative and Alternative Communication (AAC) System with Facial Expression Recognition for Children with Autism in Sri Lanka

**Student Name:** Yasas Pasindu Fernando
**Academic Year:** 2024/2025
**Submission Date:** February 2025

---

## Declaration

This interim report is submitted in partial fulfilment of the requirements for the module FC6P01ES (Final Year Project) at ESOFT Metro Campus. The work presented in this report is original to the best of the author’s knowledge and belief, and all sources have been cited using the Harvard referencing system. No part of this report has been submitted for any other qualification or at any other institution.

The project has been carried out in line with institutional ethical guidelines. All collaborative arrangements, including the planned pilot with Karapitiya Teaching Hospital, are properly documented and subject to the necessary institutional and governmental approvals.

Signed: ______________________________
Date: ______________________________

---

## Acknowledgements

The author would like to thank the project supervisor at ESOFT Metro Campus for their continuous guidance and feedback throughout this project. Special thanks also go to the staff at Karapitiya Teaching Hospital, Galle, for being open to a potential partnership for the planned pilot study and for sharing their valuable clinical insights on children with autism spectrum disorder.

The author is also grateful to the parents, caregivers, and speech-language therapists who provided informal feedback on the AAC interface design. Appreciation is extended to the open-source communities behind Flutter, TensorFlow, Firebase, and MobileNetV2, as well as to the creators of the public facial expression datasets used for initial model testing. Finally, the author would like to thank family and friends for their encouragement and support throughout this work.

---

## Abstract

Autism spectrum disorder (ASD) affects a large number of children worldwide, and communication impairment is one of its core features. This often creates significant barriers to social interaction, education, and overall quality of life. In Sri Lanka, access to culturally and linguistically suitable augmentative and alternative communication (AAC) tools is still quite limited. Most existing solutions are designed for Western, English-speaking users and do not support Sinhala or Tamil, the country’s two official languages.

Facial expression recognition (FER), supported by deep learning, can be used to enhance AAC systems by detecting the user’s emotional state and adjusting communication support accordingly. However, the use of this type of technology in AAC tools for children with autism, especially in low- and middle-income countries, has not been widely explored yet.

This interim report focuses on the design, methodology, and progress of a final year project that aims to develop an AI-powered AAC system with facial expression recognition for children with autism in Sri Lanka. The system follows a dual-platform approach. Platform A provides a customisable, symbol-based AAC interface for children at ASD severity Level 1–2, with trilingual support in Sinhala, Tamil, and English. Platform B extends this by adding on-device facial expression recognition using an EfficientNetB0-based model with CBAM attention (MobileNetV2 was initially evaluated as a baseline model) and TensorFlow Lite, mainly targeting children at Level 3 and above.

The mobile application is developed using Flutter and follows an offline-first approach, where data is stored locally on the device. Currently, Firebase is considered a future option for synchronisation, but it is not fully implemented yet. Backup is currently handled through manual export, such as sharing files via WhatsApp or similar methods. A therapist-parent dashboard is also included to support collaboration and progress monitoring. The emotion recognition model classifies six emotions (happy, sad, angry, fear, neutral, tired), with a target accuracy of at least 80 per cent.

This report covers the background, system architecture, development methodology, work completed so far, and the planned next steps. The main goal is to develop a working proof-of-concept that addresses a real gap in assistive technology for the Sri Lankan context and has the potential to improve everyday communication for children and their families.

Keywords: augmentative and alternative communication, autism spectrum disorder, facial expression recognition, EfficientNetB0 + CBAM (MobileNetV2 initially evaluated), TensorFlow Lite, Flutter, Firebase, Sri Lanka, affective computing, assistive technology, multilingual.

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Background](#2-background)
3. [Work Completed](#3-work-completed)
4. [Further Work](#4-further-work)
5. [Progress Review](#5-progress-review)
6. [References](#6-references)
7. [Bibliography](#7-bibliography)

## List of Figures
1. Figure 1: System Architecture Diagram
2. Figure 2: ER Diagram
3. Figure 3: Register Screen (UI)
4. Figure 4: Home Screen (UI)
5. Figure 5: Categories Screen (UI)
6. Figure 6: Settings Screen (UI)
7. Figure 7: Confusion Matrix
8. Figure 8: Model Training in Google Colab
9. Figure 9: Google Play Console - Internal Testing
10. Figure 10: Application Running on Real Device
11. Figure 11: Flutter Unit Test Output
12. Figure 12: AAC Interaction Example (Symbol Selection and Output)
13. Figure 13: Facial Expression Recognition Screen (On-Device Detection)

**Formatting note (ESOFT):** When exporting/printing, apply Times New Roman, size 12, 1.5 line spacing, and keep the heading hierarchy as shown in this document.

**NOTE:** When converting this document to Microsoft Word, the Table of Contents should be regenerated using Word's automatic Table of Contents feature so that all section links work correctly.

---

## 1. Introduction

### 1.1 Background and Context

Autism spectrum disorder (ASD) is a neurodevelopmental condition characterised by persistent difficulties in social communication alongside restricted, repetitive patterns of behaviour (American Psychiatric Association, 2013). Globally, it is estimated that about one in 160 children are affected (World Health Organization, 2021), although more recent studies in high-income countries suggest rates as high as one in 36 (Maenner et al., 2023). Communication impairment is central to the condition. The DSM-5 classifies severity from Level 1 ("requiring support") to Level 3 ("requiring very substantial support"). Children at Level 3 often have little or no functional speech and rely heavily on augmentative and alternative communication (AAC) to express their basic needs and emotions (Beukelman and Light, 2020).

In Sri Lanka, awareness of ASD has been growing. Perera et al. (2019) reported a prevalence of around 1.07 per cent among children aged two to nine. However, specialist services are still hard to access, especially outside major cities. Importantly, there are no commercially available AAC tools that support both Sinhala and Tamil, the two official languages of the country's 22 million population (Samad et al., 2020). The shortage of trained speech-language therapists makes it even harder for families to get proper communication support for their children (Wickramasinghe et al., 2021).

### 1.2 Project Overview

The aim of this study is to develop a dual-platform, AI-powered AAC system tailored for children with autism in Sri Lanka. It comprises two main platforms:

- **Platform A:** A customisable, symbol-based AAC interface for children at ASD severity Level 1–2, with trilingual support (Sinhala, Tamil, English), configurable vocabulary, text-to-speech output, and visual scheduling.
- **Platform B:** An AI-enhanced AAC platform for children at severity Level 3 and above, extending Platform A with on-device facial expression recognition (FER) using an EfficientNetB0-based model with a CBAM (Convolutional Block Attention Module), deployed via TensorFlow Lite, enabling emotion-adaptive communication support.

The mobile application is developed using Flutter for cross-platform deployment, with an offline-first architecture. Currently, the system stores data locally on the device (SQLite/JSON), and backup is handled using manual export (for example via WhatsApp or file sharing). Firebase is planned for future optional synchronisation and account-based collaboration, but it is not fully implemented yet.

### 1.3 Rationale and Research Gap

A review of existing AAC systems (see Section 2) shows that no commercially available tool combines trilingual support for Sinhala, Tamil, and English with on-device facial expression recognition. Tools designed for Western markets often lack cultural and contextual relevance for Sri Lankan users (Alant and Bornman, 2021). Most existing systems are also static, showing a fixed set of symbols without adjusting to how the user is feeling. On top of this, dedicated AAC devices are expensive and out of reach for many families in Sri Lanka.

Bringing facial expression recognition into AAC is what makes this study different from existing work. While emotion recognition has been explored in various settings, combining it with a multilingual, culturally adapted, mobile AAC system for children with autism in a low- and middle-income country has no direct precedent in the published literature.

### 1.4 Project Aim and Objectives

The overall aim is to design and develop an AI-powered AAC system with facial expression recognition, tailored for children with autism in Sri Lanka, and to lay the groundwork for a pilot evaluation in a clinical setting.

The project objectives are:

1. **Dual-platform architecture design:** Design a system serving children at ASD Level 1–2 (customisable symbol-based AAC) and Level 3+ (AI-enhanced AAC with FER), with trilingual support, offline-first operation, and secure data management.
2. **Cross-platform mobile application:** Implement a Flutter-based application with offline-first architecture, local storage, and a manual export backup option, targeting Android 8.0+ and iOS 14+.
3. **AI model training and deployment:** Train an EfficientNetB0-based FER model with a CBAM (Convolutional Block Attention Module) attention mechanism, with MobileNetV2 initially evaluated as a baseline for mobile deployment, targeting six emotion classes with at least 80% accuracy, deployed on-device via TensorFlow Lite with inference under 500 ms.
4. **Therapist-parent dashboard:** Develop a web-based dashboard for collaboration, progress monitoring, and vocabulary management.
5. **Ethical approval and partnership:** Establish ethical approval protocols for a pilot study at Karapitiya Teaching Hospital, Galle.
6. **Documentation and reporting:** Document the project to meet FC6P01ES module requirements with Harvard referencing.

In practice, it is often observed that children with severe autism struggle to communicate even their most basic needs, such as hunger, discomfort, or emotional distress. This can lead to frustration, behavioural difficulties, and increased stress for both the child and their caregivers. In many situations, parents have to rely on guesswork rather than clear communication.

In the Sri Lankan context, where access to specialised AAC tools and speech therapy services is limited, this challenge becomes even more significant. In many cases, families do not have access to affordable, locally relevant communication tools in Sinhala or Tamil.

Because of this, even a simple and accessible AAC system can make a meaningful difference in day-to-day life. It can help children express their needs more clearly, reduce frustration, and support better interaction within families. In this project, the aim is to address not only a technical gap, but also a practical and social need that directly affects quality of life.

### 1.5 Research Questions

The project is guided by the following research questions:

**RQ1:** How can a dual-platform AAC system be designed to serve children at ASD Level 1–2 and Level 3+, while maintaining trilingual support, offline-first operation, and secure data management?

This question gets at the core software engineering challenge: how to build a modular system that serves two user groups with different needs while still sharing core services.

**RQ2:** What accuracy can an on-device FER model based on EfficientNetB0 with CBAM attention achieve when trained on 2,000-5,000 images across six emotion classes, and what factors most influence performance? (MobileNetV2 was initially evaluated as a baseline due to its mobile efficiency.)

This addresses the machine learning dimension, including the effects of data augmentation, class balance, hyperparameter tuning, and quantisation on model performance.

**RQ3:** How can therapist-parent collaboration be effectively supported through a secure dashboard integrated with the mobile application and Firebase, while respecting privacy and consent requirements?

This addresses the human-computer interaction and clinical workflow aspects of the project. In the current stage, collaboration is approached through locally stored profiles and manual export, while Firebase-based collaboration is planned for a later stage.

**RQ4:** What ethical, regulatory, and practical considerations must be addressed for a pilot deployment at Karapitiya Teaching Hospital?

This covers the institutional ethics approval process, informed consent for vulnerable participants, and data protection in the Sri Lankan regulatory context.

**RQ5:** To what extent does the implemented system meet its functional and non-functional requirements, and what are the key areas for improvement?

This evaluative question will be most fully addressed in the final report following system completion and pilot study.

### 1.6 Report Structure

The rest of this report is organised as follows. Section 2 covers the background, including a literature review on ASD, AAC, facial expression recognition, and the technology stack, as well as the system architecture, development methodology, AI model design, and ethical considerations. Section 3 describes the work completed so far. Section 4 outlines the further work planned. Section 5 provides a progress review. Sections 6 and 7 list the references and bibliography respectively.

---

## 2. Background

### 2.1 Autism Spectrum Disorder

#### 2.1.1 Definition and Diagnostic Criteria

Autism spectrum disorder (ASD) is defined in the DSM-5 as a neurodevelopmental condition with two core features: (1) persistent difficulties in social communication and interaction, and (2) restricted, repetitive patterns of behaviour, interests, or activities (American Psychiatric Association, 2013). The DSM-5 brought together what were previously separate diagnoses, including autistic disorder, Asperger's disorder, and PDD-NOS, into a single spectrum. This change reflected the understanding that these conditions share a common neurobiology and mainly differ in how severe the symptoms are (Lord et al., 2020).

The severity classification uses three levels based on how much support a person needs. Level 1 ("requiring support") refers to individuals with noticeable social communication difficulties. Level 2 ("requiring substantial support") applies to those with more marked deficits who have limited ability to start interactions. Level 3 ("requiring very substantial support") describes individuals with severe communication deficits and very little response to social contact (American Psychiatric Association, 2013).

[Table 1: ASD Severity Levels and Communication Characteristics]

| Severity Level | Social Communication | Typical Communication Profile |
|---|---|---|
| Level 1: Requiring support | Noticeable deficits without supports; difficulty initiating interactions | Full sentences; struggles with pragmatics (turn-taking, topic maintenance); benefits from AAC for high-demand situations |
| Level 2: Requiring substantial support | Marked deficits in verbal and nonverbal communication; limited initiation | Simple phrases or short sentences; benefits from consistent AAC support |
| Level 3: Requiring very substantial support | Severe deficits; very limited initiation; minimal response to social overtures | Very limited or no functional speech; depends heavily on AAC for basic needs, preferences, and emotions |

#### 2.1.2 Communication and Emotional Regulation in ASD

Communication difficulties in ASD can range from subtle issues, such as trouble understanding sarcasm or maintaining a conversation, to a complete absence of functional speech. Around 25 to 30 per cent of children with ASD never develop functional spoken language (Lord et al., 2020). These children are often the most underserved when it comes to communication support. Even children who do develop some speech may still struggle with expressive or receptive language and can benefit from AAC as a supplementary tool.

Emotional regulation is another significant challenge. Mazefsky et al. (2013) describe emotion dysregulation as a common feature of ASD, where children have difficulty identifying, understanding, and managing their emotions. This is directly relevant to AAC design. A system that can pick up on the user's emotional state could provide better support, for example by suggesting calming vocabulary or alerting a caregiver when the child seems distressed. This connection between emotional state and communication is one of the key reasons for integrating facial expression recognition into the proposed AAC system.

#### 2.1.3 Epidemiology

Global prevalence estimates for ASD have risen substantially over recent decades. The World Health Organization (2021) cites a figure of roughly one in 160 children, based on a systematic review by Elsabbagh et al. (2012). More recent data from the US CDC, however, put the rate as high as 2.78 per cent (one in 36) among eight-year-old children (Maenner et al., 2023). This rise is largely attributed to broadened diagnostic criteria, greater awareness, improved screening, and changes in how services are accessed (Lord et al., 2020). In low- and middle-income countries (LMICs), prevalence data tend to be limited and probably reflect underdiagnosis rather than genuinely lower rates (Divan et al., 2021).

#### 2.1.4 Autism in Sri Lanka

Perera et al. (2019) carried out a population-based study in Sri Lanka and found a prevalence of 1.07 per cent among children aged two to nine, which is broadly in line with global figures. Samad et al. (2020) highlighted the growing demand for services, the shortage of trained professionals, and the lack of culturally suitable tools, especially in Sinhala and Tamil. Wickramasinghe et al. (2021) suggested that scalable, technology-based interventions could help fill service gaps, but stressed the need for careful local adaptation.

In practice, the clinical pathway in Sri Lanka usually starts with a referral from primary care to a teaching hospital such as Karapitiya or Lady Ridgeway for specialist assessment. From there, children may receive speech-language therapy or applied behaviour analysis, depending on availability. However, access to these services varies a great deal across the country. The Department of Census and Statistics, Sri Lanka (2012) notes that many families live in rural areas where specialist services simply are not available, and travelling for assessments can be difficult. This is where mobile-based AAC technology could make a real difference, bringing communication support directly into homes where regular therapy is not an option (Samad et al., 2020).

### 2.2 Augmentative and Alternative Communication

#### 2.2.1 Definitions and Classification

AAC refers to a range of strategies, tools, and technologies used to supplement or replace natural speech for people with complex communication needs (American Speech-Language-Hearing Association, 2022). AAC systems fall into two broad categories: unaided (such as gestures and sign language) and aided. Aided systems are further split into low-tech options like picture boards and communication books, and high-tech options like speech-generating devices and tablet-based apps (Beukelman and Light, 2020).

One of the most widely used low-tech approaches for children with autism is the Picture Exchange Communication System (PECS), which involves exchanging picture cards to make requests. PECS is effective for building early communication skills, but it has limitations. It relies on physical materials, the vocabulary is hard to scale, and a trained communication partner needs to be present (Ganz, 2015). High-tech alternatives such as tablet-based apps go beyond these limitations by offering dynamic displays, speech output, and vocabularies that can be easily customised.

The move from dedicated speech-generating devices, which can cost thousands of dollars, to tablet-based apps has been called a "revolution" in AAC (McNaughton and Light, 2013). Tablets are cheaper, more socially acceptable, and more widely available. That said, Dawe (2006) pointed out that the success of assistive technology depends not just on what it can do technically, but also on how simple and reliable it is, and whether families are supported in using it. These points have directly shaped the design decisions in this project.

#### 2.2.2 Evidence Base for AAC in Autism

The evidence for AAC in autism is strong and continues to grow. Ganz et al. (2012) carried out a meta-analysis of single-case studies and found moderate to large effect sizes for AAC interventions aimed at helping children make requests, with positive results across different types of AAC and age groups. Lorah et al. (2015) reviewed studies on tablet computers as speech-generating devices and found encouraging evidence, particularly noting their portability, social acceptability, and lower cost compared to dedicated devices.

An important finding from Millar et al. (2006) is that using AAC does not hold back natural speech development. In fact, it can actually help some children develop speech by reducing frustration and giving them a way to practise communication. This has helped address a common worry among parents and clinicians that AAC might discourage children from learning to talk (Light and McNaughton, 2012; Romski and Sevcik, 2005).

Light and McNaughton (2015) identify four types of communicative competence that AAC systems should support: linguistic (language skills), operational (ability to use the technology), social (interaction and pragmatic skills), and strategic (strategies for when communication breaks down). The proposed system addresses each of these through its structured vocabulary (linguistic), simple grid-based interface (operational), caregiver-mediated use (social), and emotion-adaptive prompting during stressful moments (strategic).

#### 2.2.3 AAC in Multilingual and Low-Resource Contexts

Most AAC research has been carried out in high-income, English-speaking countries. This leaves a significant gap for culturally and linguistically diverse populations. Alant and Bornman (2021) argue that implementing AAC in different cultural contexts requires adapting interaction styles, respecting local communication norms, and genuinely involving families as partners rather than just giving them technology to use.

Sri Lanka's trilingual setting, with Sinhala, Tamil, and English, creates specific challenges for AAC design. Symbols, labels, and speech output all need to work properly in each language, with text-to-speech supporting correct pronunciation and natural-sounding output (Samad et al., 2020). The cultural context matters too. Food items, clothing, religious activities, and family structures in Sri Lanka are quite different from those typically represented in Western AAC vocabularies, so local adaptation is essential.

The economic realities also shape what is practical. Internet connectivity can be unreliable in rural parts of the country (International Telecommunication Union, 2022), and many families use mid-range or budget smartphones rather than expensive devices. These constraints are why this project uses an offline-first architecture, making sure the core AAC features work without needing an internet connection.

#### 2.2.4 Comparison of Existing AAC Systems

[Table 2: Comparison of Existing AAC Systems]

| System | Platform | Languages | AI/Adaptive Features | Offline Support | Cost |
|---|---|---|---|---|---|
| Proloquo2Go | iOS | English, Spanish, French, others | Crescendo vocabulary; no FER | Offline core | ~USD 250 |
| TouchChat | iOS, Windows | English primarily | Word prediction; no FER | Offline core | ~USD 300 |
| LAMP Words for Life | iOS | English | Motor-planning based; no FER | Offline core | ~USD 300 |
| LetMeTalk | Android, iOS | User-configurable via TTS | None | Partial | Free |
| CoughDrop | Web, Android, iOS | English primarily | Basic usage logging; no FER | Limited | Subscription |
| Avaz AAC | iOS, Android | English, Hindi, Tamil, others | Word prediction; no FER | Offline core | ~USD 100-200 |
| **Proposed System** | **Android, iOS (Flutter)** | **Sinhala, Tamil, English** | **On-device FER (EfficientNetB0 + CBAM; MobileNetV2 initially evaluated) via TFLite; emotion-adaptive AAC** | **Full offline-first** | **TBD (pilot)** |

Looking at the table above, three clear gaps stand out: (1) no existing system supports both Sinhala and Tamil; (2) none of them use on-device FER for emotion-adaptive communication; and (3) the proposed system's full offline-first design (with local storage and manual export backup) is particularly well suited to Sri Lanka's connectivity situation.

### 2.3 Facial Expression Recognition and Affective Computing

In this system, AI is mainly used to analyse facial expressions using deep learning. The model learns patterns from facial images and predicts the likely emotional state of the user. This is then used to support the AAC system by adjusting communication options based on how the child appears to feel at that moment.

#### 2.3.1 Theoretical Foundations

Affective computing is a field concerned with building systems that can recognise, interpret, and respond to human emotions. The term was first introduced by Picard (2000). Facial expression recognition (FER) is one of the main areas within affective computing, focusing on automatically detecting and classifying emotions from facial images or video. It has applications across healthcare, education, human-computer interaction, and assistive technology.

The theoretical basis of FER comes largely from Ekman and Friesen (1971), who proposed a set of universal basic emotions: happiness, sadness, anger, fear, surprise, and disgust. Each of these emotions is linked to specific facial muscle movements described in the Facial Action Coding System (FACS). While the idea of universal emotions has been questioned by researchers like Barrett et al. (2019), who argue that expressions are more culturally variable than previously thought, the Ekman framework is still the most widely used in computational FER. This is mainly because large labelled datasets are built around these categories (Li and Deng, 2020), and discrete emotion labels are practical for system design.

For the proposed system, six emotion classes have been selected: happy, sad, angry, fear, neutral, and tired. The "tired" class replaces "surprise" and "disgust" from the standard set, since it is more clinically relevant when working with children. A child who is tired or fatigued may need a simpler vocabulary or a break in the session, so detecting this state has genuine practical value.

#### 2.3.2 Deep Learning for FER

Deep learning, and CNNs in particular, has become the go-to approach for FER. CNNs achieve the best results on standard benchmarks like FER2013, AffectNet, and RAF-DB (Li and Deng, 2020; Goodfellow et al., 2015). They work by learning feature representations directly from pixel data in a hierarchical manner. Early layers pick up basic features such as edges and textures. Middle layers combine these into higher-level patterns like facial features (eyes, nose, mouth). The deeper layers learn the more abstract patterns that actually distinguish one emotion from another (LeCun et al., 2015).

A typical CNN used for image classification includes convolutional layers (which extract features using learnable filters), pooling layers (which reduce the spatial size), batch normalisation (which helps training stability; Ioffe and Szegedy, 2015), ReLU activation functions (Nair and Hinton, 2010), and fully connected layers that map features to class probabilities. Dropout is also commonly used to prevent overfitting by randomly switching off some neurons during training (Srivastava et al., 2014).

Transfer learning plays an important role in this work. The idea is to take a model that has already been trained on a large dataset like ImageNet and fine-tune it for a new, smaller task. Yosinski et al. (2014) showed that features learned by early CNN layers are quite general and transfer well between tasks, while later layers become more task-specific. This approach works especially well when the target dataset is small, in this case somewhere between 2,000 and 5,000 images.

#### 2.3.3 MobileNetV2

MobileNetV2 was initially considered as the base architecture due to its efficiency for mobile deployment. However, during experimentation, an EfficientNetB0-based model combined with a CBAM attention module was selected for improved feature extraction and performance.

The architecture builds on depthwise separable convolutions, first introduced in MobileNetV1 (Howard et al., 2017). These split a standard convolution into two parts: a depthwise convolution (one filter per channel) and a pointwise 1x1 convolution to combine outputs. This cuts the number of operations by roughly 8 to 9 times compared to a standard convolution, which is what makes real-time inference possible on phones with limited processing power.

With 3.4 million parameters, MobileNetV2 achieves 72.0% top-1 accuracy on ImageNet. That is much smaller than VGG-16 (138M parameters) or ResNet-50 (25.6M), making it well suited for on-device use where model size and speed really matter. Combined with TensorFlow Lite, it can run inference in real time on mid-range smartphones, which is exactly what the emotion recognition pipeline in this project requires.

MobileNetV2 was initially chosen over newer alternatives like MobileNetV3 (Howard et al., 2019) because it has broader availability of pre-trained weights, better documentation for TFLite conversion, and sufficient accuracy for the six-class classification task in this project.

#### 2.3.4 FER Challenges

Several challenges are relevant to this project and must be addressed in the design:  

- **Dataset bias:** Major FER datasets (FER2013, AffectNet, CK+) are predominantly composed of adult, Western, posed faces. Models trained on these may not generalise well to children, non-Western populations, or the atypical expressions of children with ASD (Barrett et al., 2019; Li and Deng, 2020). This is a well-known problem in the field and is one reason why collecting purpose-specific data is planned.
- **Atypical expressiveness in ASD:** Children with ASD may display reduced intensity, atypical timing, or unusual combinations of facial movements that do not conform to standard emotion categories (Trevisan et al., 2018). Grossard et al. (2020) found that children with ASD produce facial expressions that are more ambiguous and less socially meaningful than those of neurotypical children, leading to higher misclassification rates. This is a fundamental challenge that may limit the achievable accuracy for the target population.
- **Environmental variability:** Real-world conditions introduce variability in lighting, head pose, facial occlusion, and camera quality that can degrade classification accuracy. Data augmentation (Section 2.7.2) and robust face detection preprocessing can partially mitigate these effects.
- **Inter-individual variability:** Different children express emotions with different intensities and patterns, making a one-size-fits-all model inherently limited. The confidence thresholding and caregiver override mechanisms in the system are designed to mitigate the impact of this variability.
- **Privacy and ethics:** FER in assistive technology for vulnerable children raises significant privacy concerns, including the capture and processing of facial images. These are addressed in Section 2.8.

### 2.4 Technology Stack

#### 2.4.1 Flutter

Flutter is an open-source UI toolkit by Google that allows building cross-platform apps from a single Dart codebase (Flutter, 2023). For this project, its main advantages are: code reuse across Android and iOS, fast development cycles through hot reload, a rich set of built-in widgets, and the ability to call native code (including TensorFlow Lite) through platform channels.

#### 2.4.2 TensorFlow Lite

TensorFlow Lite is a lightweight framework for running machine learning models on mobile devices (TensorFlow, 2023). It supports post-training quantisation, which converts 32-bit floating-point weights to 8-bit integers. This reduces the model size by about 4 times and speeds up inference by 2 to 3 times, with only a small drop in accuracy (Jacob et al., 2018). The TFLite model is packaged with the Flutter app and called through platform channels.

#### 2.4.3 Firebase

Firebase is considered as the future backend option for this project (Firebase, 2023). At interim stage, Firebase is **not fully implemented** for end-to-end use. The system follows an offline-first approach: core AAC data is stored locally using SQLite/JSON, and the TFLite model runs entirely on the device. Backup is currently planned as a **manual export** (for example sharing a backup file through WhatsApp or file sharing). Firebase-based authentication, Firestore, and storage are kept as planned components for later increments when stable sync and access control are ready.

[Table 3: Technology Stack Summary]

| Component | Technology | Justification |
|---|---|---|
| Mobile application | Flutter (Dart) | Single codebase for Android and iOS |
| AI/ML model | TensorFlow/Keras; TFLite | Transfer learning, quantisation, mobile deployment |
| Base architecture | EfficientNetB0 + CBAM (MobileNetV2 initially evaluated) | Lightweight, optimised for mobile |
| Backend database (planned) | Cloud Firestore | Planned for collaboration/sync in later stage |
| Authentication (planned) | Firebase Authentication | Planned for secure role-based access later |
| Local storage (current) | SQLite + JSON | Offline-first embedded storage and vocabulary |
| Text-to-speech | Platform TTS / third-party API | Spoken output in Sinhala, Tamil, English |
| Face detection | Google ML Kit | Lightweight, on-device |

### 2.5 System Architecture

#### 2.5.1 Architectural Overview

The system uses a dual-platform architecture sharing a common technology stack and core services. The major components are:

1. Two client-facing mobile applications (Platform A and Platform B) built with Flutter.
2. An on-device FER module using TensorFlow Lite, integrated into Platform B via platform channels.
3. A local data layer (SQLite/JSON) for offline storage.
4. Manual export/import for backup and sharing between caregiver and therapist (current approach).
5. A therapist-parent web-based dashboard (prototype), with planned Firebase integration later.
6. A Firebase backend (planned) for authentication and optional synchronisation in later increments.

The architecture follows an offline-first principle: all core AAC features and emotion recognition run locally on the device. Since Firebase is not fully implemented yet, the current backup/sharing approach is manual export/import. This design decision was made specifically because of Sri Lanka's variable internet connectivity (International Telecommunication Union, 2022).

Figure 1 shows the overall system architecture, including the mobile AAC applications, the local storage layer, and where optional cloud components are planned for future use.

Figure 1: System Architecture Diagram  
[Draw System Architecture Diagram here]  
[Insert figure here - to be included in final submission]

#### 2.5.2 Platform A: Customisable Symbol-Based AAC (Levels 1-2)

Platform A is designed for children at severity Level 1–2 who can interact with a symbol-based interface and benefit from AAC as a supplement to developing speech. Key features include:

- **Symbol grid interface:** Configurable grid of symbols (images with text labels) organised into categories (needs, feelings, activities, foods, people). Grid size (2x2 to 6x6) is configurable.
- **Trilingual support:** Symbols and labels available in Sinhala, Tamil, and English, with language switching.
- **Text-to-speech output:** Selected symbols are spoken aloud using the device's TTS engine.
- **Customisation:** Parents and therapists can add, remove, or reorder symbols; create custom categories; configure visual settings.
- **Visual scheduling:** Optional daily routine display.
- **Usage logging:** Symbol selections and session data logged locally. Backup/sharing is handled through manual export (planned).

#### 2.5.3 Platform B: AI-Enhanced AAC with FER (Level 3+)

Platform B extends Platform A by adding an optional FER pipeline for children at Level 3 and above who may have minimal functional speech. Additional features include:

- **Facial expression recognition:** The front-facing camera captures the user's face, which is processed on-device by the TFLite model to classify into one of six emotion classes.
- **Emotion-adaptive vocabulary:** Based on the inferred emotion, the AAC adapts the vocabulary or prompts presented (e.g., offering comfort-related vocabulary when distress is detected).
- **Caregiver override:** The system displays the inferred emotion as a suggestion; the caregiver can accept, override, or dismiss it at any time.
- **Emotion history:** Aggregated emotion data displayed on the dashboard for progress monitoring.

#### 2.5.4 Emotion Detection Pipeline

The emotion detection pipeline operates in five stages:

1. **Face detection:** Google ML Kit identifies the face bounding box. If no face is detected, no inference is attempted.
2. **Preprocessing:** The face region is cropped, resized to 224x224 pixels, and normalised.
3. **Inference:** The preprocessed image is passed to the TFLite interpreter, which outputs six class probabilities.
4. **Postprocessing:** Argmax determines the dominant emotion. If confidence is below a configurable threshold (e.g., 0.5), the result is treated as uncertain and no adaptation is triggered.
5. **Adaptation logic:** If a confident emotion is detected, the vocabulary adapts accordingly. The caregiver is notified and can override.

#### 2.5.5 Non-Functional Requirements

[Table 4: Non-Functional Requirements Summary]

| Requirement | Target |
|---|---|
| Emotion inference latency | Less than 500 ms on mid-range smartphone |
| App startup time | Less than 3 seconds |
| Offline operation | 100% core AAC and FER available offline |
| Accessibility | WCAG 2.1 AA; configurable fonts, contrast, layout |
| Data protection | TLS encryption; no raw facial images transmitted to cloud |
| Platform support | Android 8.0+ and iOS 14+ |

#### 2.5.6 Data Model (Interim)

Currently, the main entities are kept in local storage (SQLite tables and some JSON vocabulary files). The ER diagram below represents the intended structure for users, categories, symbols, sessions, and logs. This will later be mapped to a cloud schema if Firebase synchronisation is implemented.

Figure 2 shows the main entities (users, symbols, categories, sessions, and logs) and how they are linked inside the local database for the AAC app.

Figure 2: ER Diagram  
[Draw ER Diagram here]  
[Insert figure here - to be included in final submission]

### 2.6 Development Methodology

#### 2.6.1 Methodology Selection

The project uses an incremental development model, where the system is built in a series of planned increments. Each increment produces a working subset of the overall system (Sommerville, 2016). This approach was chosen after considering several alternatives:

- **Waterfall model:** This was not suitable because it assumes all requirements are known upfront. That does not work well for a project with external dependencies like ethics approval, ongoing stakeholder feedback, and iterative AI model development (Sommerville, 2016).
- **Scrum (Agile):** Scrum is great for adaptability, but its roles (Scrum Master, Product Owner) and rituals (daily stand-ups, sprint reviews) are designed for teams. Since this is a single-developer project, following full Scrum would add overhead without real benefit.
- **Spiral model:** Boehm's (1988) spiral model focuses on risk-driven development, which is relevant here given the technical and ethical risks. However, its iterative prototyping approach was considered unnecessarily complex for the scope of this project.
- **Rapid Application Development (RAD):** RAD focuses on speed over rigour. This conflicts with the need for proper ethical documentation, careful AI model validation, and systematic testing, all of which are essential in a healthcare-related project.

The incremental model was selected as the best fit for this project because:

- The dual-platform architecture naturally suits phased delivery, with Platform A built before Platform B.
- Each increment produces something that can be demonstrated and reviewed by the supervisor.
- External dependencies like ethics approval and hospital partnership can progress alongside development work.
- The academic timeline has clear milestones: the interim report around month 4 and the final report at month 10.

#### 2.6.2 Incremental Plan

The project is divided into five increments, each building upon the previous:

**Increment 1 (Months 1-2): Requirements, Architecture, and Minimal AAC.** This increment covers literature review completion, requirements analysis, system architecture design, technology stack selection, and initial Flutter project setup. The deliverable is a documented architecture and a basic application skeleton.

**Increment 2 (Months 3-4): Platform A and Firebase Backend.** This increment covers the core AAC features for Platform A (symbol grid, trilingual support, basic TTS, navigation), Firebase backend configuration, and initial dashboard implementation. The deliverable is a functional (though incomplete) AAC application and backend.

**Increment 3 (Months 5-6): AI Model Training and Platform B Integration.** This increment covers dataset assembly, full model training and evaluation, TFLite export, integration of the FER pipeline into the Flutter application, and implementation of emotion-adaptive vocabulary logic. The deliverable is a working Platform B prototype.

**Increment 4 (Months 7-8): Dashboard Completion, Ethics Approval, and Pilot Preparation.** This increment covers full dashboard development, ethics application and approval process, pilot protocol design, and participant recruitment. The deliverable is a complete system ready for pilot deployment.

**Increment 5 (Months 9-10): Pilot Execution and Final Report.** This increment covers supervised pilot use, data collection and analysis, final report writing, and preparation of deliverables. The deliverable is the final report and all supporting documentation.

### 2.7 AI Model Design and Data Collection

#### 2.7.1 Transfer Learning Strategy

While MobileNetV2 was initially evaluated as a baseline model, the final training pipeline uses EfficientNetB0 with a CBAM attention module, as it showed better feature representation and improved validation performance.

The FER component uses EfficientNetB0 pre-trained on ImageNet as a feature extractor, and an attention module (CBAM) is added to help the model focus on useful facial regions. The transfer learning approach works as follows:

1. Loading EfficientNetB0 without the top classification layers, retaining the pre-trained convolutional layers.
2. Freezing the base model weights during initial training to prevent destruction of pre-learned features.
3. Adding CBAM attention and a custom classification head: global average pooling, dense layers with dropout, and a six-unit output layer with softmax activation.
4. Training the classification head on the emotion dataset.
5. Optionally fine-tuning the full model with a low learning rate.

For training, mixed precision was used to reduce memory usage (float16), but float32 was kept in the final layers to avoid instability. This hybrid approach was mainly done to get better performance in low memory mode. Over time, epoch counts were also tuned (increased in experiments) to improve accuracy step by step.

#### 2.7.2 Data Augmentation

Data augmentation increases the effective diversity of the training set by applying label-preserving transformations during training (Shorten and Khoshgoftaar, 2019):

[Table 5: Data Augmentation Techniques]

| Technique | Parameter Range | Rationale |
|---|---|---|
| Horizontal flip | 50% probability | Faces are approximately symmetrical |
| Rotation | Plus or minus 15 degrees | Simulates head tilt |
| Zoom | Plus or minus 10% | Simulates varying camera distances |
| Brightness | Plus or minus 20% | Simulates varying lighting |
| Contrast | Plus or minus 20% | Simulates varying image quality |
| Translation | Plus or minus 10% horizontal/vertical | Simulates imperfect face centering |

#### 2.7.3 Model Quantisation

Post-training quantisation converts model weights from 32-bit floating point to 8-bit integers, reducing model size by approximately 4x and improving inference speed by 2-3x with minimal accuracy loss (typically less than 1-2 percentage points) (Jacob et al., 2018). Dynamic range quantisation is applied as the default.

#### 2.7.4 Evaluation Metrics

The model is evaluated using:

- **Confusion matrix:** Reveals which emotion classes are most often confused.
- **Per-class precision, recall, and F1 score:** Precision measures the proportion of correct positive predictions; recall measures the proportion of actual positives correctly identified; F1 is their harmonic mean.
- **Overall accuracy:** The proportion of correct predictions to total predictions.
- **Inference time and model size:** Measured on a mid-range smartphone to verify non-functional requirements.

#### 2.7.5 Dataset Composition

The target dataset is 2,000-5,000 labelled facial images across six emotion classes:

[Table 6: Dataset Distribution by Emotion]

| Emotion Class | Target Count (approx.) | Percentage |
|---|---|---|
| Happy | 350-850 | ~17% |
| Sad | 350-850 | ~17% |
| Angry | 300-750 | ~15% |
| Fear | 250-650 | ~13% |
| Neutral | 400-1000 | ~20% |
| Tired | 350-900 | ~18% |
| **Total** | **2,000-5,000** | **100%** |

Data sources include existing public datasets (FER2013, RAF-DB, AffectNet) filtered and relabelled for the target classes, and purpose-collected data (post-ethics approval) from consenting participants at Karapitiya Teaching Hospital. Data collection protocols define consent procedures, capture conditions, and labelling procedures with inter-rater reliability checks.

### 2.8 Ethical Considerations

#### 2.8.1 Overview

Since this study involves vulnerable participants (children with ASD), sensitive data (facial images, usage logs), and deployment in a healthcare-related context, ethical considerations have been treated as fundamental design constraints from the start. The ethical framework draws on the Declaration of Helsinki (World Medical Association, 2013), the Belmont Report, and emerging guidelines for ethical AI deployment (Floridi et al., 2018; Jobin et al., 2019).

#### 2.8.2 Informed Consent

Consent is obtained from parent or legal guardian, with assent sought from the child in an accessible form where possible. The child's willingness to engage is monitored throughout; signs of distress or unwillingness are treated as withdrawal of assent. Consent forms and information sheets have been drafted in English, with Sinhala and Tamil translations planned.

#### 2.8.3 Privacy and Data Protection

Specific measures include:

- **On-device processing:** FER is performed entirely on the device. Raw facial images are not transmitted to any server.
- **No default image storage:** Only the classified emotion label and timestamp are logged.
- **Access control:** If Firebase is implemented later, security rules will restrict access to authorised users. For the current offline-first stage, access is mainly controlled by the device/user context.
- **Encryption:** When any data is transmitted (for example future sync), it will be protected using TLS. Firebase encryption at rest applies if Firebase storage is used later.
- **Retention policies:** Defined in the ethics protocol with secure deletion after the project analysis period.

#### 2.8.4 Minimisation of Harm

- **Caregiver override:** Emotion recognition can be disabled or overridden at any time.
- **Confidence thresholding:** Low-confidence predictions are not acted upon.
- **Transparency:** The system presents emotion classification as a suggestion, not a certainty.
- **Voluntary participation:** Participants can withdraw at any time without penalty.

#### 2.8.5 Institutional Approval

A pilot at Karapitiya Teaching Hospital requires approval from the hospital's institutional ethics committee and alignment with Ministry of Health research governance requirements (Ministry of Health, Sri Lanka, 2020). The ethics application includes the research protocol, consent forms, and data management plan.

[Table 7: Ethical Risk Assessment]

| Ethical Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Consent not fully informed | Low | High | Multilingual information sheets; assent from child; ongoing monitoring |
| Privacy breach (facial images) | Low | Very High | On-device processing; no default image storage; encryption |
| Misclassification of emotion | Medium | Medium | Confidence thresholding; caregiver override; transparency |
| Child distress during data collection | Low | High | Trained collectors; stop criteria; parental presence |
| Delayed ethics approval | Medium | Medium | Early submission; alternative evaluation plans |

### 2.9 Risk Analysis

[Table 8: Risk Assessment Matrix]

| Risk | Category | Likelihood | Impact | Mitigation |
|---|---|---|---|---|
| Emotion model accuracy below 80% | Technical | Medium | High | Data augmentation; class rebalancing; hyperparameter tuning |
| Poor performance on low-end devices | Technical | Medium | Medium | Quantisation; lower-resolution input; minimum device specs |
| Sync conflicts in offline-first design | Technical | Medium | Medium | Conflict resolution policy; comprehensive testing |
| Delayed ethics/Ministry approval | Project | High | High | Early submission; alternative evaluation plans |
| Limited therapist/parent availability | Project | Medium | Medium | Flexible scheduling; remote participation |
| Consent or data breach | Ethical | Low | Very High | Strict access control; encryption; incident response plan |
| Sinhala/Tamil TTS quality insufficient | Technical | Medium | Medium | Multiple TTS engines; recorded audio fallback |
| Scope creep | Project | Medium | Medium | Defined scope; regular supervisor check-ins |

The critical path runs through: ethics approval, dataset collection, model training, Platform B integration, pilot execution, and final report. Primary contingency is to proceed with model training on public data and complete Platform A independently.

### 2.10 Limitations and Scope

The scope of this work includes the design, development, and pilot evaluation of the dual-platform AAC system with FER in the Sri Lankan context. What falls outside the scope includes: full randomised controlled trials, longitudinal studies, nationwide deployment, support for languages beyond Sinhala/Tamil/English, and integration of modalities other than FER.

Known limitations include:

1. **Dataset representativeness:** The model may not fully represent the diversity of Sri Lankan children, and performance for children with ASD may differ from neurotypical populations.
2. **Pilot constraints:** Sample size and duration will be constrained by ethics approval timelines and participant availability. Findings should be interpreted as preliminary and formative.
3. **Atypical expressiveness in ASD:** The model's ability to recognise emotions in children with ASD is an open question.
4. **TTS quality:** Text-to-speech quality for Sinhala and Tamil may vary across engines.
5. **Single-developer constraints:** This limits the breadth of testing and formal usability evaluation.
6. **Device variability:** Performance may vary across devices; testing focuses on representative mid-range devices.

---

## 3. Work Completed

### 3.1 Summary of Progress

Work completed so far covers Increment 1 (fully complete) and the majority of Increment 2 from the incremental plan described in Section 2.6. At this point, the foundational work, including design, architecture, literature review, and initial coding, is substantially done. The larger tasks such as full dataset collection, complete model training, and the pilot deployment are planned for the upcoming phase.

### 3.2 Requirements and Design

A thorough literature review covering ASD, AAC, facial expression recognition, and the Sri Lankan context was completed and is presented in Sections 1 and 2. Requirements for both platforms were gathered through published literature analysis, a review of existing AAC systems, and informal conversations with a speech-language therapist and two parents of children with ASD. During one of these discussions, a parent mentioned how difficult it was to find any digital communication tool that worked in Sinhala, which reinforced the need for trilingual support. The architecture, data flow, and technology choices have all been documented, along with user roles (child, parent/caregiver, therapist) and use case mapping.

Key design decisions made during this phase include: the dual-platform approach to address different ASD severity levels; choosing Flutter for cross-platform development; selecting MobileNetV2 initially for on-device FER, and later using an EfficientNetB0 with CBAM for improved feature extraction; and using an offline-first architecture for areas with poor connectivity. Firebase is kept as a planned option for later, but the current working approach is local storage with manual export backup.

### 3.3 Development Environment and Core AAC

The Flutter project was set up following standard Flutter conventions, with separate directories for models, services, screens, widgets, and utilities. The project targets Android 8.0+ and iOS 14+ from a single Dart codebase.

Core AAC features for Platform A have been partially implemented:

- **Navigation and routing:** A screen navigation system has been built using Flutter's Navigator 2.0 pattern, covering the main AAC grid view, category selection, settings, and profile screens.
- **Symbol grid interface:** A basic symbol grid is in place, displaying images with text labels organised into preliminary categories (needs, feelings, common objects). Grid size is currently fixed, with configurable sizes (2x2 to 6x6) planned for the next increment.
- **Multilingual support:** The UI framework supports switching between Sinhala, Tamil, and English. Labels and interface text are stored in separate localisation files, though the full vocabulary for Sinhala and Tamil still needs to be populated.
- **Local data layer:** SQLite is used for structured data and local JSON files for vocabulary definitions, allowing the app to work offline for vocabulary access and settings.
- **Text-to-speech:** Basic TTS integration using the device's built-in engine is working. English TTS has been tested successfully. Sinhala and Tamil testing is ongoing, and early results suggest that the platform TTS engines may need to be supplemented with third-party services for acceptable quality.

To improve usability for children, particular attention was given to the visual design of the user interface. A child-friendly theme was considered important, including the use of soft colour palettes, rounded UI components, and visually appealing icons. The interface was designed to be simple, consistent, and easy to navigate, with clear visual feedback for user interactions.

Icons and visual elements were selected to be easily recognisable and engaging for children, supporting faster symbol recognition within the AAC grid. Smooth UI transitions and consistent spacing were also considered to reduce cognitive load and improve the overall user experience.

These design choices aim to create a more accessible and comfortable interaction environment, especially for children with autism who may be sensitive to complex or cluttered interfaces.

There were some delays in finalising the symbol set and sorting out licensing for third-party symbol libraries. Finding culturally appropriate symbols and confirming licensing terms took longer than expected. This is now being treated as a priority for the next phase.

### 3.4 AI Model Pipeline

A Python-based training pipeline has been implemented using TensorFlow and Keras. The current model is based on EfficientNetB0 (pretrained on ImageNet), with a custom CBAM (Convolutional Block Attention Module) added on top to improve feature focus.

Initially, MobileNetV2 was explored as a baseline model due to its efficiency for mobile deployment. However, further experimentation showed that EfficientNetB0 combined with a CBAM attention module provided better feature representation and improved validation performance. So, the current implementation uses EfficientNetB0 with CBAM as the primary model.

The main setup used was:
• Input size: 224x224
• Batch size: 16 (used due to memory limitations)
• Mixed precision training: float16 and float32 (float16 was mainly used to improve speed and reduce memory usage, while float32 is kept in the final layers for stability)
• Dataset pipeline: tf.data API with optimised loading
• Class balancing: sample_from_datasets used to reduce imbalance between emotion classes
• Data augmentation: random flip, rotation, zoom, and contrast adjustments
• MixUp: applied to improve generalisation performance
• Regularisation: dropout (0.4), L2 regularisation, and label smoothing
• Optimiser: AdamW
• Learning rate scheduling: ReduceLROnPlateau
• Training control: EarlyStopping

In practice, because of memory limits on Google Colab and typical devices, a small batch size (16) and mixed precision were mainly used to keep training stable and fairly fast.

Several experiments were carried out by adjusting epochs and other training settings. Based on current results, training accuracy is around 85-87% and validation accuracy is around 82-84%, while test accuracy is about 66%. From the results, it looks like the model learns the training and validation data reasonably well, but during testing it still struggles with unseen real-world samples, which is quite common in FER when datasets are limited or slightly imbalanced. There is still a noticeable gap on the test set, which suggests some level of overfitting. For now, this generalisation gap will be addressed in the next phase by improving dataset balance and diversity.

In terms of individual classes, the model performs well on emotions like Joy. However, it is weaker on classes such as Fear, Sadness, and Anger. The likely reasons are dataset imbalance and real-world variability such as lighting conditions, head pose, and subtle differences between similar expressions.

Figure 7 shows the confusion matrix of the current FER model. It highlights which emotion classes are predicted correctly and where most of the misclassifications occur.

Figure 7: Confusion Matrix
[Insert figure here - confusion_matrix.png]
[Insert figure here - to be included in final submission]

From the confusion matrix, the Joy class shows high accuracy, while Fear, Sadness, and Anger show lower accuracy. This mainly comes from class imbalance. For future improvement, the main focus will be on better dataset balancing and adding more realistic samples for the weaker classes.

Across the experiments, more than one model variant was trained by changing epoch counts and switching between pure float32, pure float16, and the mixed float16/float32 setup. The final model was selected mainly based on validation performance and stability, rather than just training accuracy. Overall, the model is expected to be more reliable when deployed on real devices.

Full training on the complete dataset (2,000-5,000 images) will be carried out once the dataset is fully prepared, including purpose-collected data after ethics approval is obtained.

This switch from MobileNetV2 to EfficientNetB0 happened after testing a few architectures, and the final model was picked based on performance and stability.

Figure 13: Facial Expression Recognition Screen (On-Device Detection)  
[Insert figure here - screenshot of camera-based facial expression detection UI]

The figure above shows the real-time facial expression recognition interface used in Platform B. The system captures the user's face through the front-facing camera, processes it using the on-device TensorFlow Lite model, and predicts the emotional state.

The detected emotion is then used to support AAC interaction by suggesting appropriate communication options. This interface was designed to run smoothly on mobile devices without requiring an internet connection, ensuring real-time feedback and usability in low-connectivity environments.

### 3.5 Backend and Dashboard

Currently, backend work is still at an early, mostly prototype level. A Firebase project has been created and some basic configuration has been explored, but full end-to-end integration is not completed yet. Since the system follows an offline-first approach, the current working data store is local (SQLite/JSON), and backup is handled through manual export and import.

A basic therapist-parent dashboard prototype has also been started:
• Basic screens for login UI and navigation (prototype level)
• Placeholder progress views
• Early vocabulary management UI (not yet fully connected to real synchronisation)

Full account linking and synchronisation, if implemented using Firebase, is planned for a later stage once the offline core is stable.

### 3.6 Ethics and Partnership

• Draft consent forms and information sheets have been prepared in English
• Sinhala and Tamil translations are planned for the next phase
• Initial contact with Karapitiya Teaching Hospital has been established
• Formal ethics application is currently in advanced preparation
• Ministry of Health approval requirements have been researched and documented

### 3.7 Testing

• Unit tests have been introduced for critical data layer and utility functions
• Full test coverage has not yet been achieved, as priority was given to feature development
• Manual testing of the basic AAC flow has been carried out on an Android emulator and one physical device
• iOS testing is planned for the next phase
• No formal user testing with children or caregivers has been conducted yet (this will take place after Platform A completion and ethics approval)

In addition to manual testing, basic unit tests were implemented for selected core logic components of the system. These included symbol handling functions in the AAC module and emotion-based decision logic used in the FER integration.

Since the AI model runs as a TensorFlow Lite component, direct unit testing of the full model was not feasible currently. Instead, mock-based tests were used to validate model output handling, such as selecting the dominant emotion from prediction probabilities.

These unit tests were executed using Flutter’s built-in testing framework to ensure that critical logic behaves correctly and consistently.

Test cases were executed using the `flutter test` command, and all implemented tests passed successfully.

Figure 11 shows a screenshot of the Flutter unit test output after running `flutter test`.

Figure 11: Flutter Unit Test Output
[Insert figure here - to be included in final submission]

[Table 9: Work Completed Summary]

| Work Package | Status | Notes |
|---|---|---|
| Literature review | Complete | Documented in Sections 1-2 |
| Requirements and design | Substantially complete | Documented in Section 2 |
| Flutter project setup | Complete | Single codebase for Android/iOS |
| Platform A (core AAC) | Partially complete | Symbol grid, navigation, basic TTS, multilingual placeholders |
| Platform B (AI + FER) | In progress | Pipeline set up; initial training on public data |
| Firebase backend | Early / exploratory | Project created; not fully implemented or synced |
| Therapist-parent dashboard | Early / prototype | Basic UI and placeholders; integration pending |
| Ethics and partnership | In progress | Draft consent forms; hospital contact made |
| AI model training | In progress | Initial experiments; full training pending |
| TFLite export and benchmarking | Complete (preliminary) | Inference time acceptable |
| Testing | In progress | Unit tests; manual testing; no formal user testing |

### 3.8 Current UI Screens (Interim)

The following figures will be included to show the current UI direction of the mobile app.

To support usability and accessibility for children, the interface follows a child-friendly design approach using soft colours, rounded components, and clear icon-based navigation. The UI is designed to minimise cognitive load while making symbol selection intuitive and visually engaging.

Figure 3 shows the Register screen of the app, where a user or caregiver can create a profile before using the AAC features.

Figure 3: Register Screen (UI)  
[Insert figure here - to be included in final submission]

Figure 4 shows the Home screen, giving access to the main AAC grid and navigation to other parts of the app.

Figure 4: Home Screen (UI)  
[Insert figure here - to be included in final submission]

Figure 5 shows the Categories screen, where symbols are grouped into areas like needs, feelings, and activities for easier selection.

Figure 5: Categories Screen (UI)  
[Insert figure here - to be included in final submission]

Figure 6 shows the Settings screen, where basic options such as language, layout, and other preferences can be adjusted.

Figure 6: Settings Screen (UI)  
[Insert figure here - to be included in final submission]

Figure 12: AAC Interaction Example (Symbol Selection and Output)
[Insert figure here - showing symbol tap and TTS output flow]

This figure demonstrates how a child interacts with the AAC grid, selects a symbol, and receives immediate audio feedback. This flow is designed to be simple and consistent, supporting faster learning and communication.

### 3.9 Model Training Evidence

Model training for the FER component was mainly done using Google Colab with GPU support. This made it easier to run longer experiments without overloading the local machine. Several training runs were carried out with different settings (epochs, learning rates, and regularisation) to slowly improve accuracy.

Figure 8 illustrates a typical Google Colab training run, including the loss and accuracy logs for the model across epochs.

Figure 8: Model Training in Google Colab  
[Insert figure here - screenshot of training logs will be included in final submission]

The Colab notebook shows the training and validation loss/accuracy curves for each run. Mixed precision training was enabled to speed up training and reduce memory usage, while keeping key parts in float32 for stability. Across experiments, accuracy improved gradually as the number of epochs and other parameters were tuned.

During testing, monitoring these logs during runs was helpful for spotting when the model started to overfit and when to stop or adjust the epochs.

### 3.10 Deployment and Play Store Testing

To move closer to a real deployment, the application was packaged and uploaded to the Google Play Console under the **Internal Testing** track. An Android App Bundle / APK was generated from the Flutter project and then distributed to internal testers through the Play Console.

At this time, the project work is being carried out at IdeaHub in Nugegoda (Pagoda Road), Sri Lanka, and discussions are ongoing for the iOS release steps, including developer account access.

Figure 9 shows the Google Play Console internal testing dashboard for the app, used to manage builds and distribute them to selected testers.

Figure 9: Google Play Console - Internal Testing  
[Insert figure here - screenshot will be included in final submission]

Internal testers installed the app on their own Android devices and checked the main flows, especially the AAC grid, navigation, and basic settings. This helped to confirm that the app can be installed and launched through a normal Play Store flow. A proper Play Store link will be added in the final version after further testing and polishing.

These internal tests mainly showed that, at this stage, deployment through the Play Store route is technically feasible even though the app is still in a pilot state.

### 3.11 Real Device Testing Sessions

In addition to emulators, the app was tested on two physical Android devices in everyday conditions. These sessions focused on basic AAC communication and general stability rather than formal user studies.

Figure 10 shows the AAC application running on a real Android device, demonstrating the live UI and basic interaction flow.

Figure 10: Application Running on Real Device  
[Insert figure here - screenshots/photos will be included in final submission]

During these tests, symbol selection, text-to-speech output, and screen navigation were tried repeatedly to see if any crashes or major delays occurred. Initial checks of the FER pipeline were also done to see if the camera feed and inference could run on-device without freezing. Overall, the app ran smoothly on both devices, with acceptable performance for an early-stage prototype.

So far, it appears that the app can run on real devices without major issues, which provides confidence before moving to any wider pilot.

### 3.12 Initial Field Exposure (Karapitiya Context)

As part of understanding the real-world context, informal exposure and discussions related to the autism unit at Karapitiya Teaching Hospital were carried out. These were not a formal pilot or official data collection, but more about observing and listening to staff and families about the day-to-day communication challenges they see.

From these initial informal observations and conversations, it became clearer that many children have very limited ways to express basic needs and feelings, and that language (Sinhala/Tamil) and cultural fit are important. Parents and staff also highlighted issues like device availability, attention span, and noise in the clinic environment. These points helped to keep the design grounded in real needs, even though the proper pilot study will only happen after full ethics approval.

### 3.13 Supporting Links (Optional)

The following links are planned to be added in the final submission once all materials are finalised:

- **Google Colab (Model Training):**  
  [Link will be provided in final submission]

- **Google Play Testing Link (Internal Testing):**  
  [Link will be provided in final submission]

- **User Guidance (User Manual / Quick Guide) - Drive link:**  
  [Drive link will be pasted in final submission]

### 3.14 External Interest and Future Outreach

There has been some informal interest in the concept outside the academic context, although no formal collaboration has been established at this stage. The project is still in the pilot stage and Ministry of Health approval has **not** yet been obtained. Any kind of media exposure or external collaboration will only be considered **after** the system is more complete, the pilot is properly validated, and all official approvals are in place.

---

## 4. Further Work

### 4.1 Platform A Completion

- Finalise symbol set and resolve licensing issues.
- Complete full vocabulary in Sinhala, Tamil, and English, including culturally appropriate symbols.
- Integrate and evaluate text-to-speech for all three languages.
- Implement full customisation features: configurable grid size, user-added symbols, custom categories, colour themes, font size settings.
- Implement visual scheduling functionality.
- Conduct internal usability testing with at least one therapist and one parent/caregiver.

Additional user-centred features are also planned for Platform A to improve flexibility and personalisation. These include the ability for caregivers to record custom audio for symbols (for example, a parent’s voice), edit existing cards, and add new symbols using photos captured from the device camera.

These features are especially useful for children at ASD Levels 1–2, as they allow familiar voices, real-life objects, and personalised content to be incorporated into the AAC system. This can improve engagement, recognition, and overall communication effectiveness in daily use.

Personalised content is particularly important in AAC systems, as familiarity can reduce cognitive load and improve communication outcomes.

### 4.2 Platform B and AI Integration

- Complete curated dataset (2,000-5,000 images) combining public data with purpose-collected data.
- Conduct full model training with hyperparameter tuning (learning rate, batch size, fine-tuned layers, dropout rate).
- Achieve and document the 80% accuracy target with full confusion matrix analysis, per-class precision, recall, and F1.
- Integrate TFLite model into the Flutter app with face detection and preprocessing pipeline.
- Implement configurable emotion-adaptive logic and caregiver override.
- Test emotion detection on multiple devices (Android and iOS, varying screen sizes and camera qualities).

### 4.3 Backend and Synchronisation

- Complete manual export/import backup and restore flows (shareable backup file).
- If Firebase is implemented later, design and implement optional synchronisation with conflict handling.
- Harden security (role-based access, encryption, audit logging) once accounts/sync are finalised.

### 4.4 Dashboard

- Complete dashboard with progress visualisations, vocabulary management, and export options.
- Conduct feedback sessions with at least one therapist and one parent.

### 4.5 Pilot and Evaluation

- Obtain ethics approval from Karapitiya Teaching Hospital.
- Complete Ministry of Health processes.
- Recruit pilot participants (target: 5-15 children with ASD and their caregivers/therapists).
- Conduct supervised pilot use over 4-8 weeks.
- Collect quantitative data (usage logs, emotion detection accuracy, task completion rates) and qualitative data (caregiver and therapist feedback).
- Analyse findings and document limitations, lessons learned, and recommendations.

### 4.6 Final Deliverables

- Finalise the final report incorporating pilot findings and full model evaluation.
- Prepare user documentation (installation guide, user manual).
- Prepare deployment package (APK/IPA, model files, backend configuration).
- Prepare presentation or demo for the examining panel.

[Table 10: Remaining Work Plan]

| Task | Target Period | Dependency | Status |
|---|---|---|---|
| Finalise symbol set and licensing | Month 5 | None | Pending |
| Complete Platform A (full trilingual AAC) | Months 5-6 | Symbol set | Pending |
| Complete curated dataset | Months 5-7 | Ethics approval | Pending |
| Full model training and evaluation | Months 6-7 | Dataset | Pending |
| Platform B integration (FER + adaptation) | Months 6-7 | Model | Pending |
| Full dashboard | Months 6-7 | None | Pending |
| Full offline-first sync | Month 7 | None | Pending |
| Ethics approval (hospital + MoH) | Months 5-6 | Application | In preparation |
| Pilot recruitment | Month 7 | Ethics approval | Pending |
| Pilot execution | Months 8-9 | Recruitment | Pending |
| Final report | Months 9-10 | All above | Pending |

---

## 5. Progress Review

### 5.1 Overall Assessment

Overall, the project is on track for the interim submission. There have been a few minor delays, but these are not expected to affect the final deadline as long as the planned mitigation strategies are followed. So far, good progress has been made on the literature review, system architecture design, initial development work, AI model pipeline setup, and preparation of the required ethics documentation.

### 5.2 Areas on Track

Literature review: Nearly complete, covering ASD, AAC, FER, and the Sri Lankan context with a reasonable level of critical analysis.

System architecture and design: Completed for the interim stage. The dual-platform architecture, backend planning, emotion detection pipeline, and technology stack have all been documented.

Development methodology: The incremental approach is being followed, and overall progress is in line with the planned schedule.

AI model pipeline: Set up and tested using public datasets. Initial results are reasonably promising at this stage.

Flutter project and core AAC: The project structure is in place, and basic AAC features have been partially implemented and tested.

Backend planning: The Firebase approach and dashboard prototype have been initiated, although full integration has not yet been completed. Currently, an offline-first local storage approach is being used.

Ethics documentation: Draft consent forms have been prepared, and initial communication with the hospital has already taken place.

### 5.3 Areas with Minor Delays

Symbol set and licensing: Finalising this took slightly longer than expected, mainly due to identifying culturally appropriate symbols and resolving licensing issues. This has now been prioritised for the next increment.

Ethics application: There has been a delay due to administrative coordination. However, the application is now close to completion and is expected to be submitted in the next reporting period.

Dataset collection: Purpose-built data collection has not yet started, as ethics approval is required before proceeding. For now, public datasets are being used mainly to validate the model pipeline.

### 5.4 Impact Assessment

Currently, these delays are not expected to significantly affect the final deadline.

Decoupled dependencies: Platform A development and model training using public data can continue in parallel while the ethics application process is ongoing.

Buffer period: The project plan includes a buffer period before the final submission, which should help absorb minor delays.

Contingency planning: If the pilot cannot be fully completed, the final report will still present the implemented system, model performance based on available data, and a reflective discussion of the limitations and challenges. This is considered acceptable within the scope of a final year project.

### 5.5 Work Breakdown Structure

The project is divided into the following main work packages:

Requirements and Design: Literature review, stakeholder analysis, requirements gathering, system architecture design, and technology selection.

Platform A Development: Flutter setup, symbol grid implementation, trilingual support, text-to-speech, customisation, visual scheduling, and usage logging.

AI Model: Data sourcing, preprocessing, transfer learning setup, model training, evaluation, quantisation, and benchmarking.

Platform B Integration: Face detection, TFLite inference, emotion-adaptive logic, caregiver override, and end-to-end testing.

Backend and Dashboard: Firebase configuration, schema design, security considerations, offline synchronisation handling, dashboard development, and progress visualisation.

Ethics and Pilot: Consent forms, translations, ethics application, Ministry coordination, participant recruitment, pilot execution, and analysis.

Documentation: Interim report, final report, user documentation, presentation materials, and code archival.

### 5.6 Gantt Chart Summary

The project schedule covers the full academic year in five phases, aligned with the defined increments:

Phase 1 (Months 1-2): Requirements, Architecture, and Literature Review. Tasks included literature review, requirements elicitation, system architecture design, and project setup. Milestone: Architecture design complete. Status: Complete.

Phase 2 (Months 3-4): Platform A and Backend Development. Tasks included Platform A AAC features, multilingual vocabulary, TTS integration, Firebase setup, and initial dashboard work. Milestone: Platform A basic version demo. Status: Substantially complete.

Phase 3 (Months 5-6): AI Model and Platform B Integration. Tasks include dataset assembly, model training, TFLite export, Platform B FER pipeline, and emotion-adaptive vocabulary. Milestone: Model accuracy target achieved and Platform B demo. Status: Early stages (pipeline setup and preliminary training completed).

Phase 4 (Months 7-8): Dashboard Completion, Ethics, and Pilot Preparation. Tasks include dashboard completion, ethics application and approval, pilot design, consent form translation, and participant recruitment. Milestone: Ethics approval and pilot readiness. Status: Early stages (ethics preparation and hospital coordination ongoing).

Phase 5 (Months 9-10): Pilot Execution and Final Report. Tasks include pilot deployment, data collection, analysis, final report writing, and presentation preparation. Milestone: Pilot completion and final report submission. Status: Not yet started.

The critical path includes ethics approval, dataset collection, model training, Platform B integration, pilot execution, and final report completion. Non-critical tasks, such as documentation refinements and optional dashboard features, can be adjusted if needed to manage time effectively.

### 5.7 Conclusion

This interim report has outlined the design, methodology, and current progress of an AI-powered AAC system with facial expression recognition for children with autism in Sri Lanka. The project addresses a clear gap, as there are currently no culturally and linguistically appropriate AAC tools that combine affective computing with support for Sinhala and Tamil.

The dual-platform approach provides a practical and structured solution. Platform A focuses on customisable, trilingual AAC for children at Level 1–2, while Platform B extends this with on-device FER for children at Level 3 and above. Using Flutter and TensorFlow Lite allows the system to run on affordable mobile devices, which is important in environments where internet access may be limited. Currently, data is stored locally and backup is handled through manual export, while Firebase remains a planned option for future synchronisation.

So far, key areas such as the literature review, system design, initial development, AI model pipeline, and ethics preparation have been completed or are well underway. Backend development is still at a prototype level. Overall, the project remains on track, with minor delays being actively managed.

The remaining work will focus on completing both platforms, achieving the target model accuracy, finalising the dashboard, obtaining ethics approval, conducting the pilot study, and completing the final report. The aim is to deliver a working proof-of-concept and contribute practical insights into AI-enhanced AAC systems in a Sri Lankan context.

---

## 6. References

Abadi, M., Barham, P., Chen, J., Chen, Z., Davis, A., Dean, J., Devin, M., Ghemawat, S., Irving, G., Isard, M., Kudlur, M., Levenberg, J., Mane, R., Monga, R., Moore, S., Murray, D.G., Steiner, B., Tucker, P., Vasudevan, V., Warden, P., Wicke, M., Yu, Y. and Zheng, X. (2016) 'TensorFlow: a system for large-scale machine learning', in *Proceedings of the 12th USENIX Symposium on Operating Systems Design and Implementation (OSDI '16)*. Berkeley, CA: USENIX Association, pp. 265-283.

Alant, E. and Bornman, J. (2021) *Augmentative and alternative communication: engagement and participation*. San Diego, CA: Plural Publishing.

American Psychiatric Association (2013) *Diagnostic and statistical manual of mental disorders*. 5th edn. Washington, DC: American Psychiatric Publishing.

American Speech-Language-Hearing Association (2022) *Augmentative and alternative communication (AAC)*. Available at: https://www.asha.org/public/speech/disorders/aac/ (Accessed: 22 February 2025).

Barrett, L.F., Adolphs, R., Marsella, S., Martinez, A.M. and Pollak, S.D. (2019) 'Emotional expressions reconsidered: challenges to inferring emotion from human facial movements', *Psychological Science in the Public Interest*, 20(1), pp. 1-68.

Beukelman, D.R. and Light, J.C. (2020) *Augmentative and alternative communication: supporting children and adults with complex communication needs*. 5th edn. Baltimore, MD: Paul H. Brookes.

Boehm, B.W. (1988) 'A spiral model of software development and enhancement', *Computer*, 21(5), pp. 61-72.

Dawe, M. (2006) 'Desperately seeking simplicity: how young adults with cognitive disabilities and their families adopt assistive technologies', in *Proceedings of the SIGCHI Conference on Human Factors in Computing Systems*. New York: ACM, pp. 1143-1152.

Department of Census and Statistics, Sri Lanka (2012) *Census of population and housing - 2012*. Colombo: Department of Census and Statistics.

Divan, G., Vajaratkar, V., Desai, M.U., Strik-Lievers, L. and Patel, V. (2021) 'Prevalence and risk factors for autism spectrum disorder in low- and middle-income countries: a systematic review and meta-analysis', *Global Mental Health*, 8, e30.

Ekman, P. and Friesen, W.V. (1971) 'Constants across cultures in the face and emotion', *Journal of Personality and Social Psychology*, 17(2), pp. 124-129.

Elsabbagh, M., Divan, G., Koh, Y.J., Kim, Y.S., Kauchali, S., Marcin, C., Montiel-Nava, C., Patel, V., Paula, C.S., Wang, C., Yasamy, M.T. and Fombonne, E. (2012) 'Global prevalence of autism and other pervasive developmental disorders', *Autism Research*, 5(3), pp. 160-179.

Firebase (2023) *Firebase documentation*. Available at: https://firebase.google.com/docs (Accessed: 15 January 2025).

Fletcher-Watson, S. and Happe, F. (2019) *Autism: a new introduction to psychological theory and current debate*. 2nd edn. Abingdon: Routledge.

Floridi, L., Cowls, J., Beltrametti, M., Chatila, R., Chazerand, P., Dignum, V., Luetge, C., Madelin, R., Pagallo, U., Rossi, F., Schafer, B., Valcke, P. and Vayena, E. (2018) 'AI4People: an ethical framework for a good AI society', *Minds and Machines*, 28(4), pp. 689-707.

Flutter (2023) *Flutter documentation*. Available at: https://flutter.dev/docs (Accessed: 15 January 2025).

Ganz, J.B. (2015) *AAC for individuals with autism spectrum disorders*. New York: Springer.

Ganz, J.B., Davis, J.L., Lund, E.M., Goodwyn, F.D. and Simpson, R.L. (2012) 'A meta-analysis of single case research studies on aided augmentative and alternative communication systems with individuals with autism spectrum disorders', *Journal of Autism and Developmental Disorders*, 42(1), pp. 60-74.

Goodfellow, I., Bengio, Y. and Courville, A. (2015) *Deep learning*. Cambridge, MA: MIT Press.

Grossard, C., Dapogny, A., Cohen, D., Bernheim, S., Martinerie, J., Janvier, M., Grynszpan, O., Chaby, L., Bailly, K. and Dubuisson, S. (2020) 'Children with autism spectrum disorder produce more ambiguous and less socially meaningful facial expressions', *Molecular Autism*, 11(1), p. 5.

Howard, A.G., Zhu, M., Chen, B., Kalenichenko, D., Wang, W., Weyand, T., Andreetto, M. and Adam, H. (2017) 'MobileNets: efficient convolutional neural networks for mobile vision applications', *arXiv preprint arXiv:1704.04861*.

Howard, A., Sandler, M., Chen, B., Wang, W., Chen, L.C., Tan, M., Chu, G., Vasudevan, V., Zhu, Y., Pang, R., Adam, H. and Le, Q. (2019) 'Searching for MobileNetV3', in *Proceedings of the IEEE/CVF International Conference on Computer Vision*. Piscataway, NJ: IEEE, pp. 1314-1324.

International Telecommunication Union (2022) *Measuring digital development: facts and figures 2022*. Geneva: ITU.

Ioffe, S. and Szegedy, C. (2015) 'Batch normalization: accelerating deep network training by reducing internal covariate shift', in *Proceedings of the 32nd International Conference on Machine Learning*. Lille, France: JMLR, pp. 448-456.

Jacob, B., Kligys, S., Chen, B., Zhu, M., Tang, M., Howard, A., Adam, H. and Kalenichenko, D. (2018) 'Quantization and training of neural networks for efficient integer-arithmetic-only inference', in *Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition*. Piscataway, NJ: IEEE, pp. 2704-2713.

Jobin, A., Ienca, M. and Vayena, E. (2019) 'The global landscape of AI ethics guidelines', *Nature Machine Intelligence*, 1(9), pp. 389-399.

LeCun, Y., Bengio, Y. and Hinton, G. (2015) 'Deep learning', *Nature*, 521(7553), pp. 436-444.

Li, S. and Deng, W. (2020) 'Deep facial expression recognition: a survey', *IEEE Transactions on Affective Computing*, 13(3), pp. 1195-1215.

Light, J.C. and McNaughton, D. (2012) 'The changing face of augmentative and alternative communication: past, present, and future challenges', *Augmentative and Alternative Communication*, 28(4), pp. 197-204.

Light, J.C. and McNaughton, D. (2015) 'Designing AAC research and intervention to improve outcomes for individuals with complex communication needs', *Augmentative and Alternative Communication*, 31(2), pp. 85-96.

Lord, C., Brugha, T.S., Charman, T., Cusack, J., Dumas, G., Frazier, T., Jones, E.J.H., Jones, R.M., Pickles, A., State, M.W., Taylor, J.L. and Veenstra-VanderWeele, J. (2020) 'Autism spectrum disorder', *Nature Reviews Disease Primers*, 6(1), p. 5.

Lorah, E.R., Parnell, A., Whitby, P.S. and Hantula, D. (2015) 'A systematic review of tablet computers and portable media players as speech generating devices for individuals with autism spectrum disorder', *Journal of Autism and Developmental Disorders*, 45(12), pp. 3792-3804.

Maenner, M.J., Warren, Z., Williams, A.R. et al. (2023) 'Prevalence and characteristics of autism spectrum disorder among children aged 8 years', *MMWR Surveillance Summaries*, 72(2), pp. 1-14.

Mazefsky, C.A., Herrington, J., Siegel, M., Scarpa, A., Maddox, B.B., Scahill, L. and White, S.W. (2013) 'The role of emotion regulation in autism spectrum disorder', *Journal of the American Academy of Child and Adolescent Psychiatry*, 52(7), pp. 679-688.

McNaughton, D. and Light, J. (2013) 'The iPad and mobile technology revolution: benefits and challenges for individuals who require augmentative and alternative communication', *Augmentative and Alternative Communication*, 29(2), pp. 107-116.

Millar, D.C., Light, J.C. and Schlosser, R.W. (2006) 'The impact of augmentative and alternative communication intervention on the speech production of individuals with developmental disabilities', *Journal of Speech, Language, and Hearing Research*, 49(2), pp. 248-264.

Ministry of Health, Sri Lanka (2020) *National guideline for ethics review of health research in Sri Lanka*. Colombo: Ministry of Health.

Nair, V. and Hinton, G.E. (2010) 'Rectified linear units improve restricted Boltzmann machines', in *Proceedings of the 27th International Conference on Machine Learning*. Madison, WI: Omnipress, pp. 807-814.

Perera, H., Wijewardena, K., Aluthwelage, R., Seneviratne, S. and Buddhika, K. (2019) 'Prevalence of autism spectrum disorder in Sri Lanka: a population-based study', *Sri Lanka Journal of Child Health*, 48(2), pp. 133-138.

Picard, R.W. (2000) *Affective computing*. Cambridge, MA: MIT Press.

Romski, M. and Sevcik, R.A. (2005) 'Augmentative communication and early intervention: myths and realities', *Infants and Young Children*, 18(3), pp. 174-185.

Samad, A., Razick, S., De Silva, M.V.C. and Hettiarachchi, S. (2020) 'Challenges and opportunities for autism services in Sri Lanka', *Journal of Autism and Developmental Disorders*, 50(8), pp. 3023-3029.

Sandler, M., Howard, A., Zhu, M., Zhmoginov, A. and Chen, L.C. (2018) 'MobileNetV2: inverted residuals and linear bottlenecks', in *Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition*. Piscataway, NJ: IEEE, pp. 4510-4520.

Shorten, C. and Khoshgoftaar, T.M. (2019) 'A survey on image data augmentation for deep learning', *Journal of Big Data*, 6(1), p. 60.

Sommerville, I. (2016) *Software engineering*. 10th edn. Harlow: Pearson Education.

Srivastava, N., Hinton, G., Krizhevsky, A., Sutskever, I. and Salakhutdinov, R. (2014) 'Dropout: a simple way to prevent neural networks from overfitting', *Journal of Machine Learning Research*, 15(1), pp. 1929-1958.

TensorFlow (2023) *TensorFlow Lite documentation*. Available at: https://www.tensorflow.org/lite (Accessed: 15 January 2025).

Trevisan, D.A., Hoskyn, M. and Birmingham, E. (2018) 'Facial expression production in autism: a meta-analysis', *Autism Research*, 11(12), pp. 1586-1601.

Wickramasinghe, N., Dissanayake, A. and Samarasinghe, D. (2021) 'Parent training and support programmes for autism in low-resource settings: a scoping review', *Global Health Action*, 14(1), 1910556.

World Health Organization (2021) *Autism spectrum disorders*. Available at: https://www.who.int/news-room/fact-sheets/detail/autism-spectrum-disorders (Accessed: 22 February 2025).

World Medical Association (2013) 'World Medical Association Declaration of Helsinki: ethical principles for medical research involving human subjects', *JAMA*, 310(20), pp. 2191-2194.

Yosinski, J., Clune, J., Bengio, Y. and Lipson, H. (2014) 'How transferable are features in deep neural networks?', in *Advances in Neural Information Processing Systems*, 27. Red Hook, NY: Curran Associates, pp. 3320-3328.

---

## 7. Bibliography

The following sources were consulted during preparation of this report and have informed the background, methodology, or discussion.

Bishop, C.M. (2006) *Pattern recognition and machine learning*. New York: Springer.

Chollet, F. (2017) *Deep learning with Python*. Shelter Island, NY: Manning Publications.

Deng, J., Dong, W., Socher, R., Li, L.J., Li, K. and Fei-Fei, L. (2009) 'ImageNet: a large-scale hierarchical image database', in *Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition*. Piscataway, NJ: IEEE, pp. 248-255.

Ekman, P. and Friesen, W.V. (1978) *Facial Action Coding System: a technique for the measurement of facial movement*. Palo Alto, CA: Consulting Psychologists Press.

He, K., Zhang, X., Ren, S. and Sun, J. (2016) 'Deep residual learning for image recognition', in *Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition*. Piscataway, NJ: IEEE, pp. 770-778.

Kaggle (2013) *FER-2013: Facial Expression Recognition 2013 Dataset*. Available at: https://www.kaggle.com/datasets/msambare/fer2013 (Accessed: 15 January 2025).

Mollahosseini, A., Hasani, B. and Mahoor, M.H. (2019) 'AffectNet: a database for facial expression, valence, and arousal computing in the wild', *IEEE Transactions on Affective Computing*, 10(1), pp. 18-31.

Pressman, R.S. and Maxim, B.R. (2019) *Software engineering: a practitioner's approach*. 9th edn. New York: McGraw-Hill Education.

Simonyan, K. and Zisserman, A. (2015) 'Very deep convolutional networks for large-scale image recognition', in *Proceedings of the 3rd International Conference on Learning Representations (ICLR)*. San Diego, CA: ICLR.

---

*End of Interim Report*
