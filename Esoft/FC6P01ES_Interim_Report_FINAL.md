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

The author would like to express sincere gratitude to the project supervisor, Ms. Niruni Fonseka, at ESOFT Metro Campus for her continuous guidance, constructive feedback, and support throughout this project.

Special thanks are also extended to the staff at Karapitiya Teaching Hospital, Galle, for their openness to a potential collaboration for the planned pilot study and for sharing valuable clinical insights on children with autism spectrum disorder.

The author is also grateful to the parents, caregivers, and speech-language therapists who provided informal feedback on the AAC interface design. Appreciation is extended to the open-source communities behind Flutter, TensorFlow, Firebase, and MobileNetV2, as well as to the creators of the public facial expression datasets used for initial model testing.

Finally, the author would like to thank family and friends for their encouragement and support throughout this work.

---

## Abstract

Communication impairment is one of the defining features of autism spectrum disorder (ASD), and for many children it creates barriers that extend well beyond language, affecting social participation, education, and daily quality of life. In Sri Lanka, the situation is compounded by the absence of augmentative and alternative communication (AAC) tools that support the country's two official languages, Sinhala and Tamil. The commercially available options are built for Western, English-speaking users and do not reflect the cultural or linguistic realities of Sri Lankan families.

Recent advances in deep learning have made facial expression recognition (FER) a viable addition to AAC systems, allowing emotional state to inform the communication support offered to the user. Despite this potential, the combination of FER with AAC has received limited attention in published research, particularly in low- and middle-income settings where the need is arguably greatest.

This interim report documents the design, methodology, and progress of a final year project developing an AI-powered AAC system with on-device facial expression recognition for children with autism in Sri Lanka. The system takes a dual-platform approach. Platform A offers a customisable, symbol-based AAC interface with trilingual support for children at ASD severity Level 1–2. Platform B extends this with on-device emotion detection using an EfficientNetB0 model with a CBAM attention module, deployed via TensorFlow Lite, targeting children at Level 3 and above. MobileNetV2 was initially evaluated as a baseline but was replaced after EfficientNetB0 with CBAM produced stronger validation results.

The mobile application is built in Flutter and follows an offline-first architecture, with all core data stored locally using SQLite and JSON. Firebase remains a planned option for future synchronisation, but at the interim stage backup is handled through manual export. A therapist-parent dashboard is included to support collaboration and progress monitoring. The emotion recognition component classifies six states, namely happy, sad, angry, fear, neutral, and tired, with a target accuracy of at least 80 per cent.

This report covers the background literature, system architecture, development methodology, work completed to date, and the planned remaining tasks. The objective is to produce a working proof of concept that addresses a genuine gap in assistive technology provision for children with autism in Sri Lanka.

Keywords: augmentative and alternative communication, autism spectrum disorder, facial expression recognition, EfficientNetB0 + CBAM, TensorFlow Lite, Flutter, offline-first architecture, Sri Lanka, affective computing, assistive technology, multilingual.

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
2. Figure 2: Entity Relationship Diagram
3. Figure 3: Use Case Diagram of the AAC System
4. Figure 4: Class Diagram of the AAC System
5. Figure 5: Confusion Matrix
6. Figure 6: Facial Expression Recognition Screen (On-Device Detection)
7. Figure 7: Flutter Unit Test Output
8. Figure 8: Register Screen (UI)
9. Figure 9: Home Screen (UI)
10. Figure 10: Categories Screen (UI)
11. Figure 11: Settings Screen (UI)
12. Figure 12: AAC Interaction Example (Symbol Selection and Output)
13. Figure 13: Model Training in Google Colab
14. Figure 14: Google Play Console Internal Testing
15. Figure 15: Application Running on Real Device
16. Figure 16: Field Exposure at Karapitiya Teaching Hospital
17. Figure 17: Initial Project Gantt Chart
18. Figure 18: Updated Project Gantt Chart
19. Figure 19: Trello Board for Sprint Management

## List of Tables

1. Table 1: ASD Severity Levels and Communication Characteristics
2. Table 2: Comparison of Existing AAC Systems
3. Table 3: Technology Stack Summary
4. Table 4: Non-Functional Requirements Summary
5. Table 5: Data Augmentation Techniques
6. Table 6: Dataset Distribution by Emotion
7. Table 7: Ethical Risk Assessment
8. Table 8: Risk Assessment Matrix
9. Table 9: Work Completed Summary
10. Table 10: Remaining Work Plan

**Formatting note (ESOFT):** When exporting/printing, apply Times New Roman, size 12, 1.5 line spacing, and keep the heading hierarchy as shown in this document.

**NOTE:** When converting this document to Microsoft Word, the Table of Contents should be regenerated using Word's automatic Table of Contents feature so that all section links work correctly.

---

## 1. Introduction

### 1.1 Background and Context

Autism spectrum disorder (ASD) is a neurodevelopmental condition characterised by persistent difficulties in social communication alongside restricted, repetitive patterns of behaviour (American Psychiatric Association, 2013). Global prevalence is estimated at approximately one in 160 children (World Health Organization, 2021), although more recent studies in high-income countries report rates as high as one in 36 (Maenner et al., 2023). Communication impairment is central to the condition. The DSM-5 classifies severity across three levels, from Level 1 ("requiring support") to Level 3 ("requiring very substantial support"). Children at Level 3 often have little or no functional speech and depend heavily on augmentative and alternative communication (AAC) to express basic needs and emotions (Beukelman and Light, 2020).

In Sri Lanka, awareness of ASD has been growing. Perera et al. (2019) reported a prevalence of approximately 1.07 per cent among children aged two to nine, broadly consistent with global estimates. However, specialist services remain difficult to access, particularly outside major cities. Critically, there are no commercially available AAC tools that support both Sinhala and Tamil, the two official languages of the country (Samad et al., 2020). The shortage of trained speech-language therapists further compounds the challenge for families seeking communication support (Wickramasinghe et al., 2021).

### 1.2 Project Overview

The aim of this project is to design and develop a dual-platform, AI-powered AAC system tailored for children with autism in Sri Lanka. The system comprises two platforms.

- **Platform A:** A customisable, symbol-based AAC interface for children at ASD severity Level 1–2, with trilingual support (Sinhala, Tamil, English), configurable vocabulary, text-to-speech output, and visual scheduling.
- **Platform B:** An AI-enhanced AAC platform for children at severity Level 3 and above, extending Platform A with on-device facial expression recognition (FER) using an EfficientNetB0-based model with a CBAM (Convolutional Block Attention Module), deployed via TensorFlow Lite, enabling emotion-adaptive communication support.

The mobile application is developed using Flutter for cross-platform deployment, following an offline-first architecture. At the interim stage, data is stored locally on the device using SQLite and JSON, with backup handled through manual export. Firebase is planned for future optional synchronisation and account-based collaboration but is not yet implemented.

### 1.3 Rationale and Research Gap

A review of existing AAC systems (see Section 2.2.4) confirms that no commercially available tool combines trilingual support for Sinhala, Tamil, and English with on-device facial expression recognition. Tools such as Proloquo2Go, TouchChat, and Avaz AAC serve primarily English-speaking, Western populations. Their vocabularies, symbol sets, and cultural assumptions do not transfer well to Sri Lanka, where the food, clothing, religious practices, and family structures represented in AAC content need to be fundamentally different (Alant and Bornman, 2021). Beyond language and culture, cost is a significant barrier. Dedicated AAC devices can run to several hundred US dollars, which places them out of reach for most Sri Lankan families.

Existing AAC systems are also largely static, presenting the same vocabulary regardless of the child's emotional state. There is growing evidence that emotion-aware interfaces can improve engagement and communication outcomes (Picard, 2000), but the integration of FER into AAC tools remains largely unexplored, particularly for children with autism. Published research has examined FER and AAC as separate domains, yet no existing system brings both together within a mobile application designed for a low- and middle-income context, with multilingual support and full offline capability.

This project directly addresses that gap. The proposed system combines trilingual AAC with on-device emotion recognition, delivered through a mobile application that does not depend on internet connectivity to function.

### 1.4 Project Aim and Objectives

The overall aim of this project is to design and develop an AI-powered AAC system with facial expression recognition, tailored for children with autism in Sri Lanka, and to lay the groundwork for a pilot evaluation in a clinical setting.

The project objectives are as follows.

1. To design a dual-platform system architecture serving children at ASD Level 1–2 (customisable symbol-based AAC) and Level 3+ (AI-enhanced AAC with FER), with trilingual support, offline-first operation, and secure data management.
2. To implement a cross-platform mobile application using Flutter with offline-first architecture, local storage, and manual export backup, targeting Android 8.0+ and iOS 14+.
3. To train and deploy an EfficientNetB0-based FER model with a CBAM attention mechanism, targeting six emotion classes with at least 80% accuracy, deployed on-device via TensorFlow Lite with inference under 500 ms. MobileNetV2 was initially evaluated as a baseline.
4. To develop a therapist-parent dashboard for collaboration, progress monitoring, and vocabulary management.
5. To establish ethical approval protocols and a clinical partnership for a pilot study at Karapitiya Teaching Hospital, Galle.
6. To document the project in accordance with FC6P01ES module requirements using Harvard referencing.

### 1.5 Research Questions

The project is guided by the following research questions.

**RQ1:** How can a dual-platform AAC system be designed to serve children at ASD Level 1–2 and Level 3+, while maintaining trilingual support, offline-first operation, and secure data management?

**RQ2:** What accuracy can an on-device FER model based on EfficientNetB0 with CBAM attention achieve when trained on 2,000–5,000 images across six emotion classes, and what factors most influence performance?

**RQ3:** How can therapist-parent collaboration be effectively supported through a secure dashboard integrated with the mobile application, while respecting privacy and consent requirements?

**RQ4:** What ethical, regulatory, and practical considerations must be addressed for a pilot deployment at Karapitiya Teaching Hospital?

**RQ5:** To what extent does the implemented system meet its functional and non-functional requirements, and what are the key areas for improvement?

Research questions RQ1–RQ4 are addressed partially in this interim report. RQ5 will be most fully addressed in the final report following system completion and pilot evaluation.

### 1.6 Report Structure

The remainder of this report is organised as follows. Section 2 presents the background, including a literature review, system architecture, development methodology, AI model design, and ethical considerations. Section 3 describes the work completed to date, including design artefacts and implementation evidence. Section 4 outlines the further work planned. Section 5 provides a progress review comparing the original plan against actual progress. Sections 6 and 7 list the references and bibliography respectively.

---

## 2. Background

### 2.1 Autism Spectrum Disorder

#### 2.1.1 Definition and Diagnostic Criteria

Autism spectrum disorder (ASD) is defined in the DSM-5 as a neurodevelopmental condition with two core features, namely (1) persistent difficulties in social communication and interaction, and (2) restricted, repetitive patterns of behaviour, interests, or activities (American Psychiatric Association, 2013). The DSM-5 brought together what were previously separate diagnoses, including autistic disorder, Asperger's disorder, and PDD-NOS, into a single spectrum. This change reflected the understanding that these conditions share a common neurobiology and mainly differ in how severe the symptoms are (Lord et al., 2020).

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

AAC refers to a range of strategies, tools, and technologies used to supplement or replace natural speech for people with complex communication needs (American Speech-Language-Hearing Association, 2022). AAC systems fall into two broad categories, namely unaided (such as gestures and sign language) and aided. Aided systems are further split into low-tech options like picture boards and communication books, and high-tech options like speech-generating devices and tablet-based apps (Beukelman and Light, 2020).

One of the most widely used low-tech approaches for children with autism is the Picture Exchange Communication System (PECS), which involves exchanging picture cards to make requests. PECS is effective for building early communication skills, but it has limitations. It relies on physical materials, the vocabulary is hard to scale, and a trained communication partner needs to be present (Ganz, 2015). High-tech alternatives such as tablet-based apps go beyond these limitations by offering dynamic displays, speech output, and vocabularies that can be easily customised.

The move from dedicated speech-generating devices, which can cost thousands of dollars, to tablet-based apps has been called a "revolution" in AAC (McNaughton and Light, 2013). Tablets are cheaper, more socially acceptable, and more widely available. That said, Dawe (2006) pointed out that the success of assistive technology depends not just on what it can do technically, but also on how simple and reliable it is, and whether families are supported in using it. These points have directly shaped the design decisions in this project.

#### 2.2.2 Evidence Base for AAC in Autism

The evidence for AAC in autism is strong and continues to grow. Ganz et al. (2012) carried out a meta-analysis of single-case studies and found moderate to large effect sizes for AAC interventions aimed at helping children make requests, with positive results across different types of AAC and age groups. Lorah et al. (2015) reviewed studies on tablet computers as speech-generating devices and found encouraging evidence, particularly noting their portability, social acceptability, and lower cost compared to dedicated devices.

An important finding from Millar et al. (2006) is that using AAC does not hold back natural speech development. In fact, it can actually help some children develop speech by reducing frustration and giving them a way to practise communication. This has helped address a common worry among parents and clinicians that AAC might discourage children from learning to talk (Light and McNaughton, 2012; Romski and Sevcik, 2005).

Light and McNaughton (2015) identify four types of communicative competence that AAC systems should support, including linguistic (language skills), operational (ability to use the technology), social (interaction and pragmatic skills), and strategic (strategies for when communication breaks down). The proposed system addresses each of these through its structured vocabulary (linguistic), simple grid-based interface (operational), caregiver-mediated use (social), and emotion-adaptive prompting during stressful moments (strategic).

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

Looking at the table above, three clear gaps stand out. First, no existing system supports both Sinhala and Tamil. Second, none of them use on-device FER for emotion-adaptive communication. Third, the proposed system's full offline-first design (with local storage and manual export backup) is particularly well suited to Sri Lanka's connectivity situation.

### 2.3 Facial Expression Recognition and Affective Computing

#### 2.3.1 Theoretical Foundations

Affective computing concerns the development of systems that can recognise, interpret, and respond to human emotions (Picard, 2000). Facial expression recognition (FER) is a key subfield, focusing on automatically classifying emotions from facial images or video. The theoretical basis of FER derives largely from Ekman and Friesen (1971), who proposed a set of universal basic emotions linked to specific facial muscle movements described in the Facial Action Coding System (FACS). Although the universality of these categories has been questioned (Barrett et al., 2019), the Ekman framework remains the most widely used in computational FER due to the availability of large labelled datasets built around these categories (Li and Deng, 2020).

For the proposed system, six emotion classes have been selected, namely happy, sad, angry, fear, neutral, and tired. The "tired" class replaces "surprise" and "disgust" from the standard set, as fatigue detection is more clinically relevant when working with children who may need a simpler vocabulary or a break during a session.

#### 2.3.2 Deep Learning and Transfer Learning for FER

Convolutional neural networks (CNNs) represent the current state of the art for FER, achieving the best results on standard benchmarks such as FER2013, AffectNet, and RAF-DB (Li and Deng, 2020; Goodfellow et al., 2015). CNNs learn hierarchical feature representations directly from pixel data, progressing from low-level features (edges, textures) to high-level abstractions that distinguish emotional expressions (LeCun et al., 2015).

Transfer learning is particularly relevant to this project, where the target dataset is relatively small (2,000–5,000 images). By using a model pre-trained on ImageNet and fine-tuning it for emotion classification, the system can leverage general visual features learned from a much larger dataset (Yosinski et al., 2014).

#### 2.3.3 Model Architecture Selection

MobileNetV2 (Sandler et al., 2018) was initially evaluated as the base architecture due to its efficiency for mobile deployment. With 3.4 million parameters, MobileNetV2 uses depthwise separable convolutions (Howard et al., 2017) to reduce computational cost by approximately 8–9 times compared to standard convolutions, enabling real-time inference on mid-range smartphones.

However, during experimentation, EfficientNetB0 combined with a CBAM (Convolutional Block Attention Module) was found to provide better feature representation and improved validation performance. EfficientNetB0 offers a more balanced trade-off between accuracy and efficiency through compound scaling, while the CBAM attention mechanism helps the model focus on the most informative facial regions. MobileNetV2 is retained as a baseline for comparison purposes.

#### 2.3.4 FER Challenges

Several challenges are directly relevant to the design of this system.

- **Dataset bias:** Major FER datasets are predominantly composed of adult, Western, posed faces and may not generalise well to children or non-Western populations (Barrett et al., 2019; Li and Deng, 2020). Purpose-specific data collection is planned to address this.
- **Atypical expressiveness in ASD:** Children with ASD may display reduced intensity, atypical timing, or unusual facial movements (Trevisan et al., 2018). Grossard et al. (2020) found that such children produce more ambiguous expressions, leading to higher misclassification rates.
- **Environmental variability:** Real-world conditions introduce variability in lighting, head pose, and camera quality. Data augmentation (Section 2.8.2) and robust face detection preprocessing are used to mitigate these effects.
- **Inter-individual variability:** Different children express emotions differently. Confidence thresholding and caregiver override mechanisms are incorporated into the system design to address this.
- **Privacy and ethics:** FER involving vulnerable children raises significant privacy concerns, addressed in Section 2.9.

### 2.4 Technology Stack

#### 2.4.1 Flutter

Flutter is an open-source UI toolkit by Google that allows building cross-platform apps from a single Dart codebase (Flutter, 2023). For this project, its main advantages include code reuse across Android and iOS, fast development cycles through hot reload, a rich set of built-in widgets, and the ability to call native code (including TensorFlow Lite) through platform channels.

#### 2.4.2 TensorFlow Lite

TensorFlow Lite is a lightweight framework for running machine learning models on mobile devices (TensorFlow, 2023). It supports post-training quantisation, which converts 32-bit floating-point weights to 8-bit integers. This reduces the model size by about 4 times and speeds up inference by 2 to 3 times, with only a small drop in accuracy (Jacob et al., 2018). The TFLite model is packaged with the Flutter app and called through platform channels.

#### 2.4.3 Firebase

Firebase is considered as the future backend option for this project (Firebase, 2023). At interim stage, Firebase is **not fully implemented** for end-to-end use. The system follows an offline-first approach where core AAC data is stored locally using SQLite/JSON, and the TFLite model runs entirely on the device. Backup is currently planned as a **manual export** (for example sharing a backup file through WhatsApp or file sharing). Firebase-based authentication, Firestore, and storage are kept as planned components for later sprints when stable sync and access control are ready.

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

The system uses a dual-platform architecture with a shared technology stack and core services. The major components are listed below.

1. Two client-facing mobile applications (Platform A and Platform B) built with Flutter.
2. An on-device FER module using TensorFlow Lite, integrated into Platform B via platform channels.
3. A local data layer (SQLite/JSON) for offline storage.
4. Manual export/import for backup and sharing between caregiver and therapist (current approach).
5. A therapist-parent web-based dashboard (prototype), with planned Firebase integration later.
6. A Firebase backend (planned) for authentication and optional synchronisation in later sprints.

The architecture follows an offline-first principle, meaning all core AAC features and emotion recognition run locally on the device. Firebase is not yet implemented; the current backup approach uses manual export/import. This design decision reflects the variable internet connectivity in many parts of Sri Lanka (International Telecommunication Union, 2022). The system architecture diagram and ER diagram, produced as design artefacts, are presented in Section 3.2.

#### 2.5.2 Platform A: Customisable Symbol-Based AAC (Levels 1–2)

Platform A is designed for children at severity Level 1–2 who can interact with a symbol-based interface and benefit from AAC as a supplement to developing speech. Key features include a configurable symbol grid (2x2 to 6x6), trilingual support (Sinhala, Tamil, English) with language switching, text-to-speech output, customisation options for parents and therapists, optional visual scheduling, and local usage logging with manual export for backup.

#### 2.5.3 Platform B: AI-Enhanced AAC with FER (Level 3+)

Platform B extends Platform A by adding an optional FER pipeline for children at Level 3 and above who may have minimal functional speech. Additional features include on-device facial expression recognition using the front-facing camera, emotion-adaptive vocabulary that adjusts prompts based on the inferred emotion, caregiver override for all emotion suggestions, and aggregated emotion history displayed on the dashboard.

#### 2.5.4 Emotion Detection Pipeline

The emotion detection pipeline operates in five stages. The first is face detection using Google ML Kit. The second is preprocessing, which involves cropping, resizing to 224x224 pixels, and normalisation. The third is inference via the TFLite interpreter, outputting six class probabilities. The fourth is postprocessing, where argmax determines the dominant emotion, with a configurable confidence threshold below which no adaptation is triggered. The fifth is adaptation logic, which adjusts the vocabulary and notifies the caregiver, who can override the result at any time.

#### 2.5.5 Functional Requirements

The following functional requirements have been defined for the system.

1. The system should allow caregivers and therapists to create, edit, and manage user profiles for individual children.
2. The system should display a configurable symbol grid (2x2 to 6x6) with images and text labels organised into categories such as needs, feelings, activities, and common objects.
3. The system should support switching between Sinhala, Tamil, and English for all symbol labels and interface text.
4. The system should produce spoken output of selected symbols using the device's text-to-speech engine in the active language.
5. The system should allow caregivers and therapists to add, remove, and reorder symbols, create custom categories, and adjust visual settings.
6. The system should capture facial images via the front-facing camera, process them on-device using the TFLite model, and classify the user's expression into one of six emotion classes.
7. The system should adapt the presented vocabulary based on the detected emotion, offering contextually appropriate communication options.
8. The system should allow caregivers to override, accept, or dismiss any emotion classification at any time.
9. The system should log symbol selections, session data, and aggregated emotion history locally, with the option to export data manually for backup or sharing.
10. The system should provide a therapist-parent dashboard for reviewing usage data, managing vocabulary, and monitoring progress.

#### 2.5.6 Non-Functional Requirements

The following non-functional requirements have been defined.

1. The system should achieve emotion inference latency of less than 500 ms on a mid-range smartphone.
2. The system should start within 3 seconds of launch.
3. The system should operate fully offline for all core AAC and FER functionality.
4. The system should conform to WCAG 2.1 AA accessibility guidelines, with configurable fonts, contrast, and layout.
5. The system should not transmit raw facial images to any cloud service; only classified emotion labels and timestamps should be stored.
6. The system should encrypt any transmitted data using TLS when synchronisation is implemented.
7. The system should support Android 8.0+ and iOS 14+.

[Table 4: Non-Functional Requirements Summary]

| Requirement | Target |
|---|---|
| Emotion inference latency | Less than 500 ms on mid-range smartphone |
| App startup time | Less than 3 seconds |
| Offline operation | 100% core AAC and FER available offline |
| Accessibility | WCAG 2.1 AA; configurable fonts, contrast, layout |
| Data protection | TLS encryption; no raw facial images transmitted to cloud |
| Platform support | Android 8.0+ and iOS 14+ |

#### 2.5.7 Data Model (Interim)

At the interim stage, the main entities are stored in local storage (SQLite tables and JSON vocabulary files). The data model comprises users, categories, symbols, sessions, and logs. This structure is intended to be mapped to a cloud schema if Firebase synchronisation is implemented in a later sprint. The ER diagram is presented as a completed design artefact in Section 3.2.

### 2.6 Development Methodology

#### 2.6.1 Methodology Selection

The project adopts an Agile development methodology based on an adapted Scrum framework. Several alternative methodologies were considered before arriving at this decision.

- **Waterfall model.** This was not suitable because it assumes all requirements are known upfront. That does not work well for a project involving ongoing stakeholder feedback, iterative AI model training where results are unpredictable, and external dependencies such as ethics approval whose timelines cannot be fixed in advance (Sommerville, 2016).
- **Incremental model.** The incremental model offers structured, phased delivery, but it assumes a relatively stable set of requirements from the outset. In this project, requirements have evolved continuously based on field observations at Karapitiya, feedback from caregivers, and the practical outcomes of model training experiments. The rigidity of predefined increments would not have accommodated these changes well (Sommerville, 2016).
- **Spiral model.** Boehm's (1988) spiral model focuses on risk-driven development, which is relevant given the technical and ethical risks in this project. However, its formal risk analysis cycles were considered unnecessarily complex for a single-developer final year project.
- **Rapid Application Development (RAD).** RAD focuses on speed over rigour. This conflicts with the need for proper ethical documentation, careful AI model validation, and systematic testing, all of which are essential in a healthcare-related project.

Agile Scrum was selected as the best fit for this project for several reasons.

- The nature of the project is inherently exploratory. The exact requirements for the AAC interface, the symbol vocabulary, and the FER model performance could not be fully determined at the start. Each sprint revealed new information that shaped subsequent work. For example, the field visit to Karapitiya shifted the design towards a simpler symbol grid, and early model training results led to switching from MobileNetV2 to EfficientNetB0 with CBAM.
- AI model development is iterative by nature. Training runs produce results that inform the next round of experimentation. A fixed plan cannot account for this, whereas Scrum sprints allow the backlog to be reprioritised based on the latest findings.
- External dependencies such as ethics approval and hospital coordination have uncertain timelines. Scrum accommodates this by allowing tasks to be moved between sprints without disrupting the overall framework.
- The dual-platform architecture still benefits from phased delivery, with Platform A features developed before Platform B, but within a flexible sprint structure rather than rigid predefined phases.

Since this is a single-developer project, the standard Scrum framework was adapted to suit the context. The roles of developer, product owner, and scrum master were combined and carried out by the same individual. Formal team ceremonies such as daily stand-ups were not applicable, but sprint planning was conducted at the start of each sprint and a sprint review was held with the project supervisor at the end. Retrospective notes were recorded after each sprint to identify what worked well and what needed adjustment in the following cycle. A Trello board was used to manage the product backlog, sprint backlogs, and task progress throughout the project, providing a visual record of how work was prioritised and completed across sprints.

#### 2.6.2 Sprint Plan

The project is organised into five sprints, each approximately two months in duration. The sprint boundaries align with the academic timeline and key project milestones.

**Sprint 1 (Months 1-2), Requirements, Architecture, and Minimal AAC.** This sprint covers literature review completion, requirements analysis, system architecture design, technology stack selection, and initial Flutter project setup. The deliverable is a documented architecture and a basic application skeleton.

**Sprint 2 (Months 3-4), Platform A and Firebase Backend.** This sprint covers the core AAC features for Platform A (symbol grid, trilingual support, basic TTS, navigation), Firebase backend configuration, and initial dashboard implementation. The deliverable is a functional (though incomplete) AAC application and backend.

**Sprint 3 (Months 5-6), AI Model Training and Platform B Integration.** This sprint covers dataset assembly, full model training and evaluation, TFLite export, integration of the FER pipeline into the Flutter application, and implementation of emotion-adaptive vocabulary logic. The deliverable is a working Platform B prototype.

**Sprint 4 (Months 7-8), Dashboard Completion, Ethics Approval, and Pilot Preparation.** This sprint covers full dashboard development, ethics application and approval process, pilot protocol design, and participant recruitment. The deliverable is a complete system ready for pilot deployment.

**Sprint 5 (Months 9-10), Pilot Execution and Final Report.** This sprint covers supervised pilot use, data collection and analysis, final report writing, and preparation of deliverables. The deliverable is the final report and all supporting documentation.

Sprint management and task tracking were carried out using Trello, with columns for Backlog, To Do, In Progress, Review, and Done. Figure 19 presents the Trello board used for sprint management during the project.

Figure 19: Trello Board for Sprint Management
[Insert figure here. To be included in the final submission.]

### 2.7 Research Methodology

This project adopts a mixed-methods approach combining qualitative and quantitative techniques. Qualitative insights were gathered through informal discussions with parents of children with ASD and conversations with speech-language therapists, which informed the understanding of real-world communication challenges and guided design decisions beyond what the literature alone could provide.

Quantitative methods are applied in evaluating the FER model using standard classification metrics such as accuracy, precision, recall, and F1-score. The system as a whole is assessed against defined non-functional requirements, including inference latency and offline reliability.

The development follows an Agile Scrum methodology (described in Section 2.6), with the application built and tested in iterative sprints. For the AI component, training data is sourced from publicly available datasets in the first instance, with purpose-collected data planned following ethics approval. This combined approach helps to validate the system technically while keeping it practically relevant to the intended users and context.

### 2.8 AI Model Design and Data Collection

#### 2.8.1 Transfer Learning Strategy

While MobileNetV2 was initially evaluated as a baseline model, the final training pipeline uses EfficientNetB0 with a CBAM attention module, as it showed better feature representation and improved validation performance.

The FER component uses EfficientNetB0 pre-trained on ImageNet as a feature extractor, and an attention module (CBAM) is added to help the model focus on useful facial regions. The transfer learning approach involves the following steps.

1. Loading EfficientNetB0 without the top classification layers, retaining the pre-trained convolutional layers.
2. Freezing the base model weights during initial training to prevent destruction of pre-learned features.
3. Adding CBAM attention and a custom classification head consisting of global average pooling, dense layers with dropout, and a six-unit output layer with softmax activation.
4. Training the classification head on the emotion dataset.
5. Optionally fine-tuning the full model with a low learning rate.

For training, mixed precision was used to reduce memory usage (float16), but float32 was kept in the final layers to avoid instability. This hybrid approach was mainly done to get better performance in low memory mode. Over time, epoch counts were also tuned (increased in experiments) to improve accuracy step by step.

#### 2.8.2 Data Augmentation

Data augmentation increases the effective diversity of the training set by applying label-preserving transformations during training (Shorten and Khoshgoftaar, 2019).

[Table 5: Data Augmentation Techniques]

| Technique | Parameter Range | Rationale |
|---|---|---|
| Horizontal flip | 50% probability | Faces are approximately symmetrical |
| Rotation | Plus or minus 15 degrees | Simulates head tilt |
| Zoom | Plus or minus 10% | Simulates varying camera distances |
| Brightness | Plus or minus 20% | Simulates varying lighting |
| Contrast | Plus or minus 20% | Simulates varying image quality |
| Translation | Plus or minus 10% horizontal/vertical | Simulates imperfect face centering |

#### 2.8.3 Model Quantisation

Post-training quantisation converts model weights from 32-bit floating point to 8-bit integers, reducing model size by approximately 4x and improving inference speed by 2-3x with minimal accuracy loss (typically less than 1-2 percentage points) (Jacob et al., 2018). Dynamic range quantisation is applied as the default.

#### 2.8.4 Evaluation Metrics

The model is evaluated using the following metrics.

- **Confusion matrix:** Reveals which emotion classes are most often confused.
- **Per-class precision, recall, and F1 score:** Precision measures the proportion of correct positive predictions; recall measures the proportion of actual positives correctly identified; F1 is their harmonic mean.
- **Overall accuracy:** The proportion of correct predictions to total predictions.
- **Inference time and model size:** Measured on a mid-range smartphone to verify non-functional requirements.

#### 2.8.5 Dataset Composition

The target dataset is 2,000-5,000 labelled facial images across six emotion classes.

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

### 2.9 Ethical Considerations

#### 2.9.1 Overview

Since this study involves vulnerable participants (children with ASD), sensitive data (facial images, usage logs), and deployment in a healthcare-related context, ethical considerations have been treated as fundamental design constraints from the start. The ethical framework draws on the Declaration of Helsinki (World Medical Association, 2013), the Belmont Report, and emerging guidelines for ethical AI deployment (Floridi et al., 2018; Jobin et al., 2019).

#### 2.9.2 Informed Consent

Consent is obtained from the parent or legal guardian, with assent sought from the child in an accessible form where possible. The child's willingness to engage is monitored throughout; signs of distress or unwillingness are treated as withdrawal of assent. Draft consent forms and participant information sheets have been prepared in English and are included in Appendix A and Appendix B. Sinhala and Tamil translations are planned for the next phase.

#### 2.9.3 Privacy and Data Protection

Specific measures are outlined below.

- **On-device processing:** FER is performed entirely on the device. Raw facial images are not transmitted to any server.
- **No default image storage:** Only the classified emotion label and timestamp are logged.
- **Access control:** If Firebase is implemented later, security rules will restrict access to authorised users. For the current offline-first stage, access is mainly controlled by the device/user context.
- **Encryption:** When any data is transmitted (for example future sync), it will be protected using TLS. Firebase encryption at rest applies if Firebase storage is used later.
- **Retention policies:** Defined in the ethics protocol with secure deletion after the project analysis period.

#### 2.9.4 Minimisation of Harm

- **Caregiver override:** Emotion recognition can be disabled or overridden at any time.
- **Confidence thresholding:** Low-confidence predictions are not acted upon.
- **Transparency:** The system presents emotion classification as a suggestion, not a certainty.
- **Voluntary participation:** Participants can withdraw at any time without penalty.

#### 2.9.5 Institutional Approval

A pilot at Karapitiya Teaching Hospital requires approval from the hospital's institutional ethics committee and alignment with Ministry of Health research governance requirements (Ministry of Health, Sri Lanka, 2020). The ethics application includes the research protocol, consent forms, and data management plan.

[Table 7: Ethical Risk Assessment]

| Ethical Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Consent not fully informed | Low | High | Multilingual information sheets; assent from child; ongoing monitoring |
| Privacy breach (facial images) | Low | Very High | On-device processing; no default image storage; encryption |
| Misclassification of emotion | Medium | Medium | Confidence thresholding; caregiver override; transparency |
| Child distress during data collection | Low | High | Trained collectors; stop criteria; parental presence |
| Delayed ethics approval | Medium | Medium | Early submission; alternative evaluation plans |

### 2.10 Risk Analysis

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

The critical path runs through ethics approval, dataset collection, model training, Platform B integration, pilot execution, and the final report. The primary contingency is to proceed with model training on public data and complete Platform A independently.

### 2.11 Limitations and Scope

The scope of this work includes the design, development, and pilot evaluation of the dual-platform AAC system with FER in the Sri Lankan context. What falls outside the scope includes full randomised controlled trials, longitudinal studies, nationwide deployment, support for languages beyond Sinhala, Tamil, and English, and integration of modalities other than FER.

Known limitations are as follows.

1. **Dataset representativeness:** The model may not fully represent the diversity of Sri Lankan children, and performance for children with ASD may differ from neurotypical populations.
2. **Pilot constraints:** Sample size and duration will be constrained by ethics approval timelines and participant availability. Findings should be interpreted as preliminary and formative.
3. **Atypical expressiveness in ASD:** The model's ability to recognise emotions in children with ASD is an open question.
4. **TTS quality:** Text-to-speech quality for Sinhala and Tamil may vary across engines.
5. **Single-developer constraints:** As a solo project, the Scrum framework was adapted with all roles combined into one. This limits the breadth of testing, peer review, and formal usability evaluation.
6. **Device variability:** Performance may vary across devices; testing focuses on representative mid-range devices.

---

## 3. Work Completed

### 3.1 Summary of Progress

At the time of this interim submission, Sprint 1 has been completed in full and Sprint 2 is substantially complete. The literature review, system architecture, technology stack selection, and the initial Flutter project setup are all in place. A considerable amount of early effort went into understanding the problem domain, not only through published literature but also through informal conversations with parents and therapists. Those conversations surfaced practical realities that the literature alone did not fully convey, and they directly influenced several design decisions described in the sections that follow.

Some work originally planned for Sprint 3, particularly the AI model pipeline setup and preliminary training experiments, was started ahead of schedule during Sprint 2. This provides a useful head start on model development for the next phase.

The larger tasks remain ahead. Full dataset curation using purpose-collected data, complete model training and evaluation, Platform B integration with the FER pipeline, and the clinical pilot study are all planned for subsequent sprints. There have been some delays in specific areas, notably symbol set licensing, ethics coordination, and TTS quality for Sinhala and Tamil, but these are accounted for in the revised project plan (Section 5.4). Overall, the project is in a reasonable position for this stage of the academic timeline.

### 3.2 Requirements, Design, and Produced Artefacts

A comprehensive literature review covering ASD, AAC, facial expression recognition, and the Sri Lankan context was completed and is presented in Sections 1 and 2. Requirements for both platforms were gathered through published literature analysis, a review of existing AAC systems, and informal discussions with a speech-language therapist and two parents of children with ASD. The architecture, data flow, and technology choices have been documented, together with user roles (child, parent/caregiver, therapist) and use case mapping.

Key design decisions made during this phase include the dual-platform approach to address different ASD severity levels, the selection of Flutter for cross-platform development, the initial evaluation of MobileNetV2 for on-device FER with subsequent adoption of EfficientNetB0 with CBAM for improved feature extraction, and the offline-first architecture to accommodate areas with unreliable connectivity. Firebase remains a planned option for future synchronisation, while the current approach uses local storage with manual export backup.

To support the design phase of the project, several modelling artefacts were produced, including a system architecture diagram, an entity relationship diagram, a use case diagram, and a class diagram. These artefacts were used to clarify user interactions, define the data structure, and guide the system architecture prior to and during implementation. All figures presented in this section include appropriate captions in accordance with academic reporting standards.

Figure 1 presents the overall system architecture, showing the mobile AAC applications, the local storage layer, the on-device FER module, and the planned cloud components.

Figure 1: System Architecture Diagram
[Insert figure here. To be included in the final submission.]

#### 3.2.1 Entity Relationship Diagram

The entity relationship diagram represents the logical data structure of the AAC system at the interim stage. It models the key entities required to support communication, user management, and monitoring features within the application.

The system should store data related to users, child profiles, categories, symbols, sessions, usage logs, and emotion records in a structured manner. Child profiles are linked to sessions, symbol selections, and emotion records, enabling the system to maintain a consistent history of AAC interactions and detected emotional states.

The system should support category and symbol entities to manage vocabulary in a scalable and customisable way. The system should also allow session based logging to capture user interactions over time, which can later be reviewed through the caregiver and therapist dashboard.

At this stage, the data model is implemented using local storage technologies such as SQLite and JSON files, in line with the offline first design approach. The ER diagram also provides a foundation for potential future integration with a cloud based database if synchronisation features are implemented.

Figure 2: Entity Relationship Diagram
[Insert figure here. To be included in the final submission.]

#### 3.2.2 Use Case Diagram

The use case diagram models the primary interactions between the system and its three main user roles, namely the child, the parent or caregiver, and the therapist. It provides a high level representation of how each actor engages with the AAC system.

The child primarily interacts with communication focused features. The system should allow the child to select symbols from a grid based interface, listen to text to speech output, browse categories, view a visual schedule, and use the facial expression recognition functionality. These interactions represent the core AAC usage flow of the application.

The parent or caregiver plays both a support and management role. The system should allow caregivers to create and manage user profiles, switch between Sinhala, Tamil, and English, view detected emotions, override emotion classifications, manage symbols and categories, configure the grid size and theme, record custom audio, export and import backups, and manage child profiles.

The therapist interacts mainly with monitoring and administrative features. The system should allow therapists to access the dashboard, review usage logs and progress, view emotion history, manage vocabulary, and manage child profiles.

This diagram was used to define the functional scope of the system and to verify that all user roles and interactions had been accounted for.

Figure 3: Use Case Diagram of the AAC System
[Insert figure here. To be included in the final submission.]

#### 3.2.3 Class Diagram

The class diagram describes the structural design of the AAC system at the software level by identifying the main classes and their relationships.

The system should include core classes such as User, ChildProfile, Category, Symbol, and SymbolGrid to support profile management and symbol based communication. The system should also include supporting classes such as TTSEngine, Session, and UsageLog to handle speech output and interaction tracking.

For the AI enhanced component, the system should include classes such as FERModule, FaceDetector, EmotionClassifier, AdaptationEngine, and CaregiverOverride. These classes work together to process facial input, classify emotions, and adapt the AAC interface accordingly.

Additional classes such as LocalStorage, BackupManager, Dashboard, VisualSchedule, and SettingsManager are included to support data storage, backup handling, monitoring, scheduling, and personalisation features.

The relationships between these classes illustrate how system components interact. For example, a child profile is associated with sessions and settings, while a session contains usage logs and emotion records. The FER module depends on face detection and emotion classification, and the adaptation engine modifies the symbol grid based on the detected emotional state.

Structuring the system at this level of detail was intended to keep it modular and maintainable as development progresses.

Figure 4: Class Diagram of the AAC System
[Insert figure here. To be included in the final submission.]

### 3.3 Development Environment and Core AAC

The Flutter project follows a standard folder structure with separate directories for models, services, screens, widgets, and utilities. It targets Android 8.0+ and iOS 14+ from a single Dart codebase.

Core AAC features for Platform A have been partially implemented.

- **Navigation and routing:** Screen navigation uses Flutter's Navigator 2.0 pattern, covering the main AAC grid view, category selection, settings, and profile screens.
- **Symbol grid interface:** A basic symbol grid is functional, displaying images with text labels in preliminary categories (needs, feelings, common objects). Grid size is currently fixed; configurable sizes (2x2 to 6x6) are planned for the next sprint.
- **Multilingual support:** The UI framework supports switching between Sinhala, Tamil, and English. Labels and interface text are stored in separate localisation files. The English vocabulary is mostly populated; Sinhala and Tamil vocabularies require further work.
- **Local data layer:** SQLite is used for structured data and local JSON files store vocabulary definitions, enabling full offline operation for vocabulary access and settings.
- **Text-to-speech:** Basic TTS integration using the device's built-in engine is functional for English. Preliminary testing indicated that the default platform TTS for Sinhala and Tamil produces unnatural output, and third-party TTS services will need to be evaluated.

Getting the interface right took considerably longer than the original timeline anticipated. Children with autism can disengage entirely when a screen feels cluttered or visually overwhelming (Fletcher-Watson and Happe, 2019), so every colour choice, every icon, and every tap target required deliberate consideration. Several versions were tested before the current soft palette and rounded component style was settled upon.

The symbol set proved more challenging than expected. Most established AAC symbol libraries are designed for Western contexts, and the food symbols typically show sandwiches and hamburgers, not rice, kottu, or string hoppers. A significant amount of manual sourcing and adaptation was required to build a culturally appropriate vocabulary, and licensing terms added further complexity. This work remains ongoing and has been prioritised for the next sprint.

### 3.4 AI Model Pipeline

Model training was conducted on Google Colab with GPU support, which proved workable but not without friction. The free tier imposes session time limits, and on several occasions training runs were interrupted before completion. In some early instances, unsaved progress was lost entirely. After those setbacks, checkpoint saving was adopted far more aggressively, which added overhead but prevented further losses.

The model architecture went through a deliberate process of iteration. MobileNetV2 was evaluated first as a baseline, being lightweight, well documented for TFLite conversion, and a reasonable starting point for mobile deployment. However, validation performance did not reach the required level. After further experimentation, EfficientNetB0 combined with a CBAM (Convolutional Block Attention Module) was selected, producing noticeably better feature representation.

The training configuration is summarised below.

- Input size: 224x224
- Batch size: 16 (constrained by GPU memory limitations)
- Mixed precision training: float16 for speed and memory efficiency, with float32 retained in the final layers for numerical stability
- Dataset pipeline: tf.data API with optimised loading
- Class balancing: sample_from_datasets to address class imbalance
- Data augmentation: random flip, rotation, zoom, and contrast adjustments
- MixUp regularisation to improve generalisation
- Regularisation: dropout (0.4), L2 regularisation, and label smoothing
- Optimiser: AdamW
- Learning rate scheduling: ReduceLROnPlateau
- Training control: EarlyStopping

Current results show training accuracy of approximately 85–87% and validation accuracy of 82–84%, though test accuracy sits lower at around 66%. Closing that generalisation gap is the primary model objective for the next phase. The model learns the training and validation distributions reasonably well, but still struggles with unseen real world samples, which is a recognised challenge in FER when datasets are limited or imbalanced (Li and Deng, 2020). Per class analysis shows strong performance on the "happy" class, with weaker results for "fear", "sad", and "angry", most likely attributable to class imbalance and environmental variability such as lighting and head pose. Improving dataset balance and adding more diverse samples for the weaker classes will be the focus going forward.

Figure 5 presents the confusion matrix for the current FER model, illustrating which emotion classes are classified correctly and where misclassifications are concentrated.

Figure 5: Confusion Matrix
[Insert figure here. To be included in the final submission.]

Multiple model variants were trained by adjusting epoch counts and precision settings (float32, float16, and mixed). The final model was selected based on validation performance and stability rather than training accuracy alone. Full training on the complete dataset (2,000–5,000 images) will be conducted once the dataset is fully prepared, including purpose-collected data following ethics approval.

Figure 6 shows the facial expression recognition interface in Platform B, demonstrating on-device emotion detection using the front-facing camera and TFLite model. The detected emotion is used to adapt the AAC vocabulary accordingly, supporting contextually appropriate communication.

Figure 6: Facial Expression Recognition Screen (On-Device Detection)
[Insert figure here. To be included in the final submission.]

### 3.5 Backend and Dashboard

Backend work is at an early, prototype level. A Firebase project has been created and basic configuration has been explored, but full end-to-end integration has not been completed. The current data store is local (SQLite/JSON), and backup is handled through manual export and import. A basic therapist-parent dashboard prototype has been started, including login UI and navigation screens, placeholder progress views, and an early vocabulary management interface. Full account linking and Firebase synchronisation are planned for a later stage once the offline core is stable.

### 3.6 Ethics and Partnership

Draft consent forms and participant information sheets have been prepared in English (included in Appendix A and Appendix B). Sinhala and Tamil translations are planned for the next phase. Initial contact with Karapitiya Teaching Hospital has been established, and the formal ethics application is in advanced preparation. Ministry of Health approval requirements have been researched and documented.

### 3.7 Testing

Testing at the interim stage has focused on unit tests for the most critical parts of the codebase. The data layer functions, symbol handling logic in the AAC module, and the emotion-based decision logic in the FER integration have all been covered with automated tests. The AI model itself runs as a TensorFlow Lite component on the device, which makes direct unit testing of the full inference pipeline impractical at this stage. Instead, mock-based tests were written to validate the output handling, for example confirming that the correct dominant emotion is selected from a set of prediction probabilities.

All implemented tests were executed using Flutter's built-in testing framework and passed without failure. That said, full test coverage has not been achieved. During this phase, development priority was given to getting core features functional, with the understanding that test coverage would be expanded in subsequent sprints. Manual testing of the basic AAC communication flow, including symbol selection, category navigation, and text-to-speech output, has been carried out on an Android emulator and one physical device. iOS testing has not yet been conducted, and formal user testing with children and caregivers will only take place after ethics approval is obtained.

Figure 7 presents the output from the Flutter unit test suite at the interim stage.

Figure 7: Flutter Unit Test Output
[Insert figure here. To be included in the final submission.]

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

The following figures present the current state of the mobile application's user interface. The interface follows a child-friendly design approach using soft colours, rounded components, and clear icon-based navigation, intended to minimise cognitive load while supporting intuitive symbol selection.

Figure 8: Register Screen (UI)
[Insert figure here. To be included in the final submission.]

Figure 9: Home Screen (UI)
[Insert figure here. To be included in the final submission.]

Figure 10: Categories Screen (UI)
[Insert figure here. To be included in the final submission.]

Figure 11: Settings Screen (UI)
[Insert figure here. To be included in the final submission.]

Figure 12 demonstrates a typical AAC interaction, showing symbol selection and the resulting text-to-speech output.

Figure 12: AAC Interaction Example (Symbol Selection and Output)
[Insert figure here. To be included in the final submission.]

### 3.9 Model Training Evidence

Model training for the FER component was conducted on Google Colab with GPU support. Multiple training runs were carried out with different combinations of epochs, learning rates, and regularisation settings. Each run was logged, and training/validation loss and accuracy curves were monitored to identify overfitting and guide parameter adjustments.

Figure 13 presents a representative Colab training session showing the loss and accuracy logs across epochs.

Figure 13: Model Training in Google Colab
[Insert figure here. To be included in the final submission.]

Mixed precision training (float16 for computational layers, float32 for final layers) reduced memory usage and enabled training with reasonable batch sizes on the free-tier GPU. Accuracy improved gradually across experiments as hyperparameters were refined.

### 3.10 Deployment and Play Store Testing

The application was packaged and uploaded to the Google Play Console under the Internal Testing track. An Android App Bundle was generated from the Flutter project and distributed to internal testers. Internal testers installed the application on their own Android devices and verified the main flows, including the AAC grid, navigation, and basic settings. This confirmed that deployment through the Play Store is technically feasible at this stage.

Figure 14 presents the Google Play Console internal testing dashboard.

Figure 14: Google Play Console Internal Testing
[Insert figure here. To be included in the final submission.]

iOS deployment steps, including developer account access, are currently being arranged.

### 3.11 Real Device Testing Sessions

In addition to emulator testing, the application was tested on two physical Android devices under everyday conditions. These sessions focused on basic AAC communication and general stability rather than formal user studies. Symbol selection, text-to-speech output, and screen navigation were tested repeatedly to check for crashes or performance issues. Initial checks of the FER pipeline confirmed that the camera feed and on-device inference could run without freezing.

Figure 15 shows the application running on a real Android device.

Figure 15: Application Running on Real Device
[Insert figure here. To be included in the final submission.]

The application performed acceptably on both devices, providing confidence that the prototype can function on real hardware before any wider pilot deployment.

### 3.12 Initial Field Exposure (Karapitiya Context)

An initial field exposure was conducted at Karapitiya Teaching Hospital in Galle to gain a practical understanding of the real-world context in which the proposed system would be used. This visit was exploratory in nature and did not involve formal data collection, as ethical approval had not yet been obtained at this stage.

Observations from this setting highlighted significant communication challenges faced by children with autism spectrum disorder. Many of the children present did not have reliable means of expressing basic needs such as hunger, discomfort, or emotional distress. Caregivers reported relying on continuous interpretation and guesswork, often without access to suitable digital tools. The absence of AAC applications supporting the Sinhala language was also identified as a critical gap, reinforcing the motivation for this project.

From an environmental perspective, the clinical setting presented several practical constraints. The ward environment was relatively noisy, attention spans among the children were limited, and many families did not have consistent access to tablets or similar devices. Internet connectivity in home environments was also reported as unreliable, even among families who owned compatible devices. These constraints were directly observed and had a clear influence on subsequent design decisions.

In particular, the adoption of an offline-first architecture, the implementation of a simplified user interface, and the decision to maintain a minimal and uncluttered symbol grid were all informed by insights gained during this field exposure.

Figure 16 illustrates the field exposure session conducted at Karapitiya Teaching Hospital, where the AAC application was demonstrated within a real-world context.

Figure 16: Field Exposure at Karapitiya Teaching Hospital
[Insert figure here. To be included in the final submission.]

The formal pilot testing phase will be conducted following ethical approval. However, this initial exposure provided practical insights that the literature review alone could not have fully captured, and it had a noticeable influence on the overall system design.

### 3.13 Supporting Links

The following links will be included in the final submission.

- **Google Colab (Model Training):** [To be provided in final submission]
- **Google Play Testing Link (Internal Testing):** [To be provided in final submission]
- **User Guidance (User Manual / Quick Guide):** [To be provided in final submission]

### 3.14 External Interest

There has been some informal interest in the project concept outside the academic context, although no formal collaboration has been established. The project remains at the prototype stage, and Ministry of Health approval has not yet been obtained. Any external collaboration or outreach will only be pursued after system completion, pilot validation, and all necessary approvals are in place.

---

## 4. Further Work

The following subsections outline the remaining tasks required to complete the project. These tasks are aligned with the revised project plan presented in Section 5.6.

### 4.1 Platform A Completion

The remaining work for Platform A includes finalising the symbol set and resolving licensing issues, completing the full vocabulary in Sinhala, Tamil, and English with culturally appropriate symbols, integrating and evaluating text-to-speech for all three languages, implementing full customisation features (configurable grid size, user-added symbols, custom categories, colour themes, and font size settings), implementing visual scheduling functionality, and conducting internal usability testing with at least one therapist and one parent or caregiver.

Additional personalisation features are planned, including the ability for caregivers to record custom audio for symbols, edit existing cards, and add new symbols using photos from the device camera. These features are intended to improve engagement and communication effectiveness for children at ASD Levels 1–2.

### 4.2 Platform B and AI Integration

The remaining work for Platform B includes completing the curated dataset (2,000–5,000 images) combining public data with purpose-collected data, conducting full model training with hyperparameter tuning, achieving and documenting the 80% accuracy target with full confusion matrix analysis and per-class precision, recall, and F1 scores, integrating the TFLite model into the Flutter application with the face detection and preprocessing pipeline, implementing configurable emotion-adaptive logic and caregiver override, and testing emotion detection on multiple devices (Android and iOS).

### 4.3 Backend and Synchronisation

The remaining backend work includes completing manual export and import backup and restore flows, designing and implementing optional Firebase synchronisation with conflict handling (if pursued), and hardening security through role-based access, encryption, and audit logging.

### 4.4 Dashboard

The dashboard requires completion with progress visualisations, vocabulary management, and data export options. Feedback sessions with at least one therapist and one parent are also planned.

### 4.5 Pilot and Evaluation

The pilot phase requires obtaining ethics approval from Karapitiya Teaching Hospital and completing Ministry of Health processes, recruiting pilot participants (target of 5 to 15 children with ASD and their caregivers and therapists), conducting supervised pilot use over 4 to 8 weeks, collecting quantitative data (usage logs, emotion detection accuracy, task completion rates) and qualitative data (caregiver and therapist feedback), and analysing findings with documentation of limitations and recommendations.

### 4.6 Final Deliverables

Final deliverables include the final report incorporating pilot findings and full model evaluation, user documentation such as an installation guide and user manual, a deployment package containing the APK or IPA, model files, and backend configuration, and a presentation or demonstration for the examining panel.

[Table 10: Remaining Work Plan]

| Task | Target Period | Dependency | Status |
|---|---|---|---|
| Finalise symbol set and licensing | Month 5 | None | Pending |
| Complete Platform A (full trilingual AAC) | Months 5–6 | Symbol set | Pending |
| Complete curated dataset | Months 5–7 | Ethics approval | Pending |
| Full model training and evaluation | Months 6–7 | Dataset | Pending |
| Platform B integration (FER + adaptation) | Months 6–7 | Model | Pending |
| Full dashboard | Months 6–7 | None | Pending |
| Full offline-first sync | Month 7 | None | Pending |
| Ethics approval (hospital + MoH) | Months 5–6 | Application | In preparation |
| Pilot recruitment | Month 7 | Ethics approval | Pending |
| Pilot execution | Months 8–9 | Recruitment | Pending |
| Final report | Months 9–10 | All above | Pending |

---

## 5. Progress Review

### 5.1 Original Project Plan

At the outset of the project, a Gantt chart was prepared as part of the project proposal to establish the planned schedule across the full academic year. This chart divided the work into five sprints spanning approximately ten months, with each sprint building upon the deliverables of the previous one. Figure 17 presents the original project Gantt chart.

Figure 17: Initial Project Gantt Chart
[Insert figure here. To be included in the final submission.]

The five sprints in the original plan were defined as follows.

Sprint 1 (Months 1 to 2) covered requirements analysis, architecture design, literature review, and the initial Flutter project setup. The expected deliverable was a documented system architecture and a basic application skeleton.

Sprint 2 (Months 3 to 4) covered Platform A core AAC features, including the symbol grid, trilingual support, basic TTS, and navigation. It also included Firebase backend configuration and initial dashboard implementation. The expected deliverable was a functional, though incomplete, AAC application and backend.

Sprint 3 (Months 5 to 6) covered dataset assembly, full model training and evaluation, TFLite export, and Platform B FER integration. The expected deliverable was a working Platform B prototype.

Sprint 4 (Months 7 to 8) covered dashboard completion, ethics approval, pilot design, consent form translation, and participant recruitment. The expected deliverable was a complete system ready for pilot deployment.

Sprint 5 (Months 9 to 10) covered pilot execution, data collection and analysis, final report writing, and preparation of deliverables. The expected deliverable was the final report and all supporting documentation.

At the interim submission point, which falls at the end of Month 4, Sprints 1 and 2 were expected to be fully complete.

### 5.2 Progress Against the Original Plan

Sprint 1 (Months 1 to 2) was completed on schedule. The literature review, requirements analysis, system architecture, and technology stack selection were all delivered within the planned timeframe. The Flutter project was initialised with the intended folder structure and build targets for both Android and iOS. No significant issues arose during this phase.

Sprint 2 (Months 3 to 4) is substantially complete, though progress was uneven across different work packages. The core AAC features for Platform A, including the symbol grid, screen navigation, basic text-to-speech, and the multilingual switching framework, have been partially implemented and are functional at a prototype level. The AI model pipeline was set up ahead of schedule, with preliminary training experiments on public datasets completed during this sprint rather than in Sprint 3 as originally planned. This early start on the model work provides a useful buffer for the next phase.

However, four areas did not progress as quickly as the original plan anticipated.

The symbol set and licensing process proved more time-consuming than expected. Identifying symbols that are culturally appropriate for Sri Lankan users, and then navigating the licensing terms of various symbol libraries, required correspondence and research that had not been fully accounted for in the original estimate. This work remains in progress.

The Firebase backend is at an early prototype level. The decision was taken to prioritise the offline-first architecture and local storage layer over cloud integration. Firebase configuration has been started, but full synchronisation and authentication have been deliberately deferred. This was a conscious scope prioritisation rather than an unplanned delay.

Text-to-speech quality for Sinhala and Tamil fell short of expectations. The assumption that the default platform TTS engines would produce acceptable output proved incorrect during initial testing. Alternative TTS services will need to be evaluated in the next sprint.

The ethics application for Karapitiya Teaching Hospital has taken longer to coordinate than originally anticipated. The process involves both the hospital's institutional ethics committee and Ministry of Health governance requirements. The application is in advanced preparation but has not yet been formally submitted.

### 5.3 Justification for Delays

The delays identified above are minor and have specific, identifiable causes.

First, regarding the symbol set licensing, most established AAC symbol libraries are designed for Western contexts. Finding and licensing symbols that represent Sri Lankan food, clothing, and cultural activities required additional research and correspondence with symbol library providers. The time required for this task was underestimated in the original plan.

Second, regarding ethics coordination, the ethics approval process at Karapitiya Teaching Hospital involves coordination with both the hospital institutional ethics committee and the Ministry of Health. The administrative timelines for these processes were not fully known at the planning stage and have proved longer than initially assumed.

Third, regarding TTS quality, the original assumption that platform native TTS engines would provide acceptable Sinhala and Tamil output was incorrect. This limitation was only identified during implementation and now requires evaluation of third party alternatives.

Fourth, regarding AI model training, the training pipeline was developed and executed on Google Colab using the free tier GPU allocation. The free tier imposes session time limits, which meant that longer training runs were sometimes interrupted before completion, resulting in lost checkpoints and the need to repeat experiments. This slowed the pace of iterative experimentation. More frequent checkpoint saving was adopted as a mitigation measure, and overall training progress continued, but the rate of experimentation was slower than originally anticipated.

None of these delays affect the critical path in a way that compromises the final deadline, provided the revised plan outlined below is followed. The critical path runs through ethics approval, dataset collection, model training, Platform B integration, pilot execution, and the final report. Platform A development and model training on public data can proceed independently of the ethics timeline.

### 5.4 Revised Plan for Remaining Work

Based on the progress to date and the delays identified, the project plan has been revised for the remaining sprints. The key adjustment is the introduction of an overlap between Sprints 3 and 4, where Platform A completion, model training, and ethics preparation proceed in parallel. This is feasible because these tasks have limited interdependencies and Scrum allows the backlog to be reprioritised between sprints as needed. Figure 18 presents the updated project Gantt chart reflecting these changes.

Figure 18: Updated Project Gantt Chart
[Insert figure here. To be included in the final submission.]

The revised schedule is as follows.

Months 5 to 6 (Revised Sprint 3). The focus during this period will be on finalising the symbol set, completing Platform A vocabulary and TTS integration, submitting the ethics application, continuing model training on public datasets, and beginning dataset curation.

Months 6 to 7 (Overlap between Revised Sprints 3 and 4). This period will focus on full model training and evaluation once the dataset is ready, Platform B FER integration and testing, and dashboard completion.

Months 7 to 8 (Revised Sprint 4). Ethics approval is expected during this period. Tasks include pilot preparation, participant recruitment, and finalisation of backup and synchronisation flows.

Months 8 to 9 (Revised Sprint 5). This period covers pilot execution at Karapitiya Teaching Hospital, data collection, and preliminary analysis.

Months 9 to 10 (Final phase). The final period is reserved for final report writing, preparation of deliverables, and the project presentation.

The main difference between the original and revised plans is the parallel scheduling of previously sequential tasks during Months 5 to 8. This approach absorbs the minor delays without extending the overall project timeline.

### 5.5 Risk Assessment for Remaining Work

The most significant risk to the revised plan is a delay in ethics approval, which would prevent purpose collected data from being included in the training dataset and would delay the pilot study. The primary contingency is to complete model training and evaluation using public datasets only, and to conduct Platform A usability testing with informal participants rather than a formal pilot. This would still produce a valid proof of concept, though with acknowledged limitations.

Other risks, including model accuracy below the 80 per cent target, insufficient TTS quality for Sinhala and Tamil, and limited therapist or parent availability for the pilot, are mitigated through the strategies documented in Section 2.10.

### 5.6 Work Breakdown Structure

The project is divided into the following main work packages.

Requirements and Design covers the literature review, stakeholder analysis, requirements gathering, system architecture design, and technology selection.

Platform A Development covers Flutter setup, symbol grid implementation, trilingual support, text to speech integration, customisation features, visual scheduling, and usage logging.

AI Model covers data sourcing, preprocessing, transfer learning setup, model training, evaluation, quantisation, and benchmarking.

Platform B Integration covers face detection, TFLite inference, emotion adaptive logic, caregiver override, and end to end testing.

Backend and Dashboard covers Firebase configuration, schema design, security considerations, offline synchronisation handling, dashboard development, and progress visualisation.

Ethics and Pilot covers consent forms, translations, the ethics application, Ministry coordination, participant recruitment, pilot execution, and analysis.

Documentation covers the interim report, final report, user documentation, presentation materials, and code archival.

### 5.7 Conclusion

The project has completed Sprint 1 in full and the majority of Sprint 2. The literature review, system architecture, technology selection, Flutter project setup, and preliminary AI model training are all in place. Some tasks have taken longer than the original plan allowed for, particularly symbol set licensing, ethics coordination with Karapitiya Teaching Hospital, and the discovery that platform TTS engines do not produce acceptable Sinhala and Tamil output. These delays are acknowledged but none of them are severe enough to compromise the final deadline, provided the revised plan is followed.

The amount of work remaining is substantial. Platform A needs to be completed with full trilingual vocabulary and customisation features. The FER model needs to be trained on a larger, more balanced dataset and integrated into the Flutter application. The ethics application needs to be submitted and approved before any pilot data collection can begin. The revised plan introduces parallel scheduling for these tasks during Months 5 to 8, which is feasible because the tasks have limited interdependencies.

The most significant risk is a delay in ethics approval, which would prevent purpose-collected data from being included in the training set and would push back the pilot study. A contingency plan exists for this scenario. Model training and evaluation would proceed using public datasets only, and Platform A usability testing would be conducted with informal participants. This would still produce a valid proof of concept, though with acknowledged limitations in the evaluation.

At this stage, the project is in a reasonable position relative to the academic timeline. The foundational and architectural work is solid, the early model experiments have produced informative results, and the remaining tasks are clearly defined. The goal remains to deliver a working system that addresses the identified gap in AAC provision for children with autism in Sri Lanka.

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
