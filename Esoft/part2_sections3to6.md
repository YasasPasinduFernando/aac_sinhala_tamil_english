

## 3. Problem Statement

### 3.1 Overview of the Problem

Children with autism spectrum disorder (ASD) in Sri Lanka face substantial and multifaceted barriers to effective communication support. These barriers operate at multiple levels: systemic (shortage of trained professionals, limited availability of specialist services, uneven geographic distribution of resources), technological (absence of culturally and linguistically appropriate AAC tools, lack of integration between AAC and affective computing), and contextual (variable internet connectivity, diverse linguistic needs, economic constraints on device affordability). The result is a significant gap between the evidence-based potential of augmentative and alternative communication (AAC) to support communication development in children with ASD and the practical reality of what is available and accessible for families in Sri Lanka (Samad et al., 2020; Perera et al., 2019).

The significance of this problem is underscored by the growing recognition of ASD in Sri Lanka, the increasing demand for specialist services, and the persistent shortage of trained speech-language therapists, developmental paediatricians, and assistive technology specialists. Perera et al. (2019) estimated a prevalence of approximately 1.07 per cent among children aged two to nine years in the study area, suggesting a substantial population of children who could benefit from AAC intervention. Yet the tools available to these children and their families are overwhelmingly designed for English-speaking Western markets and do not accommodate the trilingual reality (Sinhala, Tamil, English) of Sri Lanka or the country's specific cultural, resource, and connectivity constraints.

### 3.2 Inadequacy of Existing AAC Solutions for the Sri Lankan Context

Existing AAC solutions are frequently designed for Western, English-dominant contexts and lack native support for Sinhala and Tamil, the two official languages of Sri Lanka. The comparison of existing systems presented in Table 1 (Section 2.2.4) demonstrates that, while several robust AAC applications exist in the market—including Proloquo2Go, TouchChat, LAMP Words for Life, and Avaz AAC—none provides integrated support for both Sinhala and Tamil. Even Avaz AAC, which includes Tamil among its supported languages, does not offer Sinhala support. This linguistic gap has direct consequences for usability and adoption: a child whose home language is Sinhala cannot be expected to benefit fully from an AAC system that presents vocabulary, symbols, and speech output only in English or Tamil. The mismatch between the language of the AAC system and the language of the child's communicative environment undermines the effectiveness of the intervention and may contribute to low uptake and abandonment (Alant and Bornman, 2021; Samad et al., 2020).

Beyond language, cultural appropriateness is a critical factor that is often overlooked in the design of AAC systems for global markets. Symbols and vocabulary in AAC must reflect the user's cultural context—including familiar foods, activities, social routines, religious and cultural practices, and family structures—to maximise relevance and communicative utility (Alant and Bornman, 2021). AAC systems designed for North American or European markets may include symbols for items and activities that are unfamiliar or irrelevant in the Sri Lankan context (e.g., sandwiches, snow, Halloween), while omitting symbols for culturally significant concepts (e.g., rice and curry, temple visits, Sinhalese or Tamil New Year celebrations, local games and activities). The lack of cultural and contextual relevance can reduce the child's engagement with the system and the family's motivation to continue using it, ultimately limiting the therapeutic benefit of the intervention.

The cost of existing high-tech AAC solutions is a further barrier. Dedicated devices such as those from PRC-Saltillo or Tobii Dynavox can cost several hundred to several thousand US dollars, placing them well beyond the reach of most families in Sri Lanka. Tablet-based applications such as Proloquo2Go are more affordable but still require an iPad or similar device, and the app itself costs approximately USD 250. For a project targeting deployment in a low- and middle-income country, affordability and accessibility on widely available Android smartphones are essential considerations.

### 3.3 Absence of Emotion-Adaptive Communication Support

Conventional AAC systems are largely static: they present a fixed or user-configured set of symbols and phrases without dynamically adapting to the user's current emotional or physiological state. For children with limited verbal ability, emotional state can be difficult to express and for caregivers to interpret accurately. A child who is tired, distressed, or overwhelmed may not be able to use their AAC system to communicate these states, and the caregiver may not recognise the signs until the child's distress escalates into challenging behaviour (Fletcher-Watson and Happé, 2019). Research has shown that children with ASD may have particular difficulty with emotion regulation and expression, and that misinterpretation of emotional cues by caregivers is a common source of frustration for both the child and the family (Mazefsky et al., 2013).

The integration of facial expression recognition (FER) into AAC offers a potential solution to this problem. By inferring the user's emotional state from facial expressions and adapting the vocabulary or prompts presented by the system, the AAC can proactively offer emotionally relevant communication options (e.g., "I am tired," "I need a break," "I am sad") without relying solely on the child's volitional selection. This approach has the potential to improve the responsiveness and relevance of the AAC system, reduce communicative frustration, and provide caregivers with additional cues to support their interpretation of the child's needs.

However, this integration is not straightforward and must be approached with caution. The accuracy and reliability of FER models for children with ASD, the ethical implications of facial image capture, the risk of misclassification and its consequences for the child and caregiver, and the design of appropriate override mechanisms all require careful consideration. The present project does not claim that FER can or should replace human judgment in interpreting a child's emotional state; rather, it is positioned as an assistive cue that can support the caregiver in identifying and responding to the child's needs, with the caregiver always retaining the ability to override or disable the feature. This positioning is consistent with the recommendations of Fletcher-Watson and Happé (2019) for responsible deployment of AI in sensitive domains.

### 3.4 Access, Equity, and Scalability

Access to specialist services for children with ASD in Sri Lanka is limited by geography, economics, and the supply of trained professionals. Families in rural or semi-urban areas may have limited or no access to speech-language therapists, developmental paediatricians, or assistive technology specialists (Perera et al., 2019; Samad et al., 2020; Wickramasinghe et al., 2021). Even in urban centres, waiting times for assessment and intervention can be long, and the cost of private therapy may be prohibitive for many families. A mobile-based AAC system that can be introduced and configured during a clinical visit and continued at home and in educational settings, that works offline in areas with poor connectivity, and that supports remote collaboration between therapists and parents through a secure dashboard could help bridge these access gaps and extend the reach of specialist services.

The therapist–parent dashboard is a key element of the proposed system's approach to scalability and service extension. By enabling therapists to remotely monitor a child's AAC usage, review progress data, and adjust vocabulary and settings, the dashboard supports a model of distributed care in which the therapist does not need to be physically present for every interaction. This model aligns with emerging approaches to telepractice in speech-language pathology, which have been shown to be feasible and effective for AAC intervention in some contexts (Grogan-Johnson et al., 2013).

The pilot collaboration with Karapitiya Teaching Hospital, subject to institutional ethics committee and Ministry of Health approval, is intended to provide a clinically supervised context for evaluating the feasibility, acceptability, and usability of the system. The hospital's established paediatric and psychiatric services, its role as a regional referral centre in the Southern Province, and its track record of supporting research collaborations make it a suitable partner for this pilot. The pilot is not intended to produce definitive evidence of clinical effectiveness—which would require a larger, controlled study—but rather to generate formative data on the system's usability, user acceptance, technical reliability, and areas for improvement.

### 3.5 Problem Statement Summary

The core problem addressed by this project may therefore be stated as follows:

> There is a need to design, develop, and evaluate a dual-platform, AI-powered AAC system that is linguistically and culturally appropriate for children with autism in Sri Lanka, that integrates facial expression recognition for adaptive communication support, and that is feasible for deployment and clinical evaluation within the country's healthcare, resource, and connectivity constraints.

This overarching problem statement implies several sub-problems: (1) the need for a robust, maintainable, and scalable software architecture that supports two user groups (ASD Levels 1–2 and Level 3+) with differentiated features; (2) the need for an AI model (emotion recognition) that meets defined accuracy and efficiency targets and is deployable on affordable mobile devices; (3) the need for a secure, privacy-respecting data management and collaboration framework; (4) the need for ethical and regulatory compliance, including institutional and governmental approvals for data collection and pilot deployment; and (5) the need for realistic pilot design and evaluation that can be completed within the scope of a final year project.

---

## 4. Aim and Objectives

### 4.1 Aim

The aim of this project is to design and develop an AI-powered augmentative and alternative communication (AAC) system with facial expression recognition, tailored for children with autism spectrum disorder in Sri Lanka, and to establish a foundation for its pilot evaluation in a clinical setting.

This aim reflects the project's dual ambition: to produce a functional, deployable software system that addresses a real and pressing need, and to conduct the preparatory work (including ethical approvals, partnership building, and pilot design) necessary for a rigorous evaluation of the system's feasibility, usability, and initial efficacy. The aim is deliberately scoped to be achievable within a final year project, while laying the groundwork for future work that could extend the system's reach and evidence base.

### 4.2 Objectives

The project objectives are as follows:

**Objective 1: Dual-Platform Architecture Design.**
To design a dual-platform architecture comprising: (a) Platform A – a customisable, symbol-based AAC platform for children at ASD severity levels 1–2, with full trilingual support for Sinhala, Tamil, and English, configurable vocabulary and grid layout, text-to-speech output, and visual scheduling; and (b) Platform B – an AI-enhanced AAC platform for children at level 3 and above, extending Platform A's features with on-device facial expression recognition to infer the user's emotional state and adapt communication options accordingly. The architecture must be modular, maintainable, and extensible, supporting iterative development and future enhancements.

**Objective 2: Cross-Platform Mobile Application Development.**
To implement a cross-platform mobile application using Flutter, with an offline-first architecture and secure cloud backup using Firebase, ensuring usability, accessibility, and reliability for the target users (children with ASD) and their communication partners (parents, caregivers, therapists). The application must function fully on Android 8.0+ and iOS 14+ devices, with an emphasis on performance and responsiveness on mid-range devices commonly available in Sri Lanka.

**Objective 3: AI Model Training and Deployment.**
To design, train, and deploy a convolutional neural network–based facial expression recognition model using transfer learning (MobileNetV2) and TensorFlow Lite, targeting six emotion classes (happy, sad, angry, fear, neutral, tired) and achieving an accuracy of at least 80 per cent on a curated dataset of 2,000–5,000 images, with documented precision, recall, F1 score, and confusion matrix analysis. The model must be quantised for efficient on-device inference and demonstrate acceptable latency (< 500 ms per inference) on target devices.

**Objective 4: Therapist–Parent Dashboard Development.**
To develop a therapist–parent dashboard (web-based or web-view within the app) that supports collaboration, progress monitoring, vocabulary management, and backup management, in line with data protection and ethical requirements and integrated with the mobile application and Firebase backend. The dashboard must be accessible, intuitive, and functional for users with varying levels of digital literacy.

**Objective 5: Ethical Approval and Partnership.**
To establish ethical approval and partnership protocols for a pilot study in collaboration with Karapitiya Teaching Hospital, Galle, including engagement with the hospital's institutional ethics committee and Ministry of Health approval processes where applicable. This objective includes the development of consent forms, information sheets, and data management protocols in Sinhala, Tamil, and English.

**Objective 6: Documentation and Reporting.**
To document the system architecture, development methodology, AI model design, data collection strategy, ethical considerations, and project progress in interim and final reports conforming to the FC6P01ES module requirements, with rigorous Harvard referencing and critical academic analysis throughout. The documentation must demonstrate examiner-level quality in terms of academic rigour, technical depth, and clarity of presentation.

### 4.3 Success Criteria

The success of the project will be assessed against the following criteria, which are mapped to the objectives above:

1. **Functional completeness (Objectives 1, 2, 4):** Both Platform A and Platform B are implemented and demonstrate core AAC functionality (symbol-based communication, multilingual support, text-to-speech) and, for Platform B, on-device emotion recognition with adaptive vocabulary. The therapist–parent dashboard is functional and provides useabe progress monitoring and vocabulary management.
2. **Model accuracy (Objective 3):** The emotion recognition model achieves at least 80 per cent accuracy on the held-out test set, with per-class precision, recall, and F1 reported, analysed, and compared against relevant benchmarks.
3. **Offline operation (Objective 2):** Core AAC and emotion recognition function without internet connectivity, as verified through structured testing.
4. **Usability (Objectives 1, 2, 4):** The system is usable by children with ASD (with caregiver/therapist support) as assessed through informal or formal usability evaluation, including feedback from at least one therapist and one parent or caregiver.
5. **Ethical compliance (Objective 5):** All data collection and pilot activities are conducted in accordance with approved ethical protocols, with evidence of engagement with the institutional ethics committee and Ministry of Health.
6. **Documentation quality (Objective 6):** The interim and final reports meet the standards of academic rigour, critical analysis, and presentation expected at the FC6P01ES examination level, with comprehensive Harvard referencing and logical academic flow.

---

## 5. Research Questions

The project is guided by the following research questions, which are aligned with the objectives and designed to structure the investigation, development, and evaluation phases:

### Research Question 1: System Architecture and Design

**RQ1:** How can a dual-platform AAC system be architecturally designed to serve both children with ASD at severity levels 1–2 (customisable symbol-based interface) and those at level 3 and above (AI-enhanced interface with facial expression recognition), while maintaining consistency in language support (Sinhala, Tamil, English), offline-first operation, and secure data management?

This question addresses the fundamental software engineering challenge of the project: how to design a system that serves two distinct user groups with different needs and capabilities, while sharing core services and design principles and meeting the constraints of mobile deployment, offline operation, and data security. The question is answerable through the design process itself (architecture diagrams, design rationale, and implementation), as well as through evaluation of the implemented system against the defined non-functional requirements. The dual-platform approach is informed by the DSM-5 severity classification (American Psychiatric Association, 2013) and by the AAC literature's emphasis on individualisation and flexibility (Light and McNaughton, 2015; Beukelman and Light, 2020). The architectural decisions made in response to this question are documented in Section 6 and evaluated through the testing activities described in Sections 10 and 12.

### Research Question 2: AI Model Performance

**RQ2:** What is the achievable accuracy of an on-device facial expression recognition model based on MobileNetV2 transfer learning and TensorFlow Lite deployment when trained on a dataset of 2,000–5,000 images across six emotion classes (happy, sad, angry, fear, neutral, tired), and what factors (e.g., data augmentation, class balance, hyperparameter tuning, quantization) most influence performance?

This question addresses the AI and machine learning dimension of the project. It is formulated to be empirically answerable through model training, evaluation, and ablation studies. The choice of MobileNetV2 and TensorFlow Lite is motivated by the need for efficient on-device inference (Sandler et al., 2018), while the dataset size range (2,000–5,000 images) reflects the constraints of a final year project with limited resources for data collection. The question invites investigation of the factors that most influence model performance—including the composition and quality of the training data, the choice and intensity of data augmentation, the balance across emotion classes, the learning rate and optimiser settings, and the effect of post-training quantization on accuracy—which is valuable both for the project itself and for contributing to the broader literature on FER in low-resource and specialised settings. The findings are reported in Sections 8 and 10, with full analysis planned for the final report.

### Research Question 3: Therapist–Parent Collaboration

**RQ3:** How can therapist–parent collaboration and progress monitoring be effectively supported through a secure dashboard integrated with the mobile AAC application and cloud backup (Firebase), while respecting privacy and consent requirements in the Sri Lankan context?

This question addresses the human-computer interaction and clinical workflow dimensions of the project. Effective collaboration between therapists and parents is widely recognised as a critical success factor for AAC intervention (Light and McNaughton, 2015; Beukelman and Light, 2020), and the design of digital tools to support this collaboration must balance functionality, usability, privacy, and regulatory compliance. The Sri Lankan context introduces additional considerations, including the need for multilingual support in the dashboard interface, the varying levels of digital literacy among parents and therapists, and the privacy and data protection landscape. The question is answerable through the design and implementation of the dashboard, feedback from at least one therapist and one parent (or representative informant), and analysis of the data flow and privacy architecture. The design and implementation of the dashboard are documented in Sections 6 and 10, and further feedback will be sought in the next project phase (Section 11).

### Research Question 4: Ethical and Regulatory Considerations

**RQ4:** What ethical, regulatory, and practical considerations must be addressed to conduct a pilot deployment of the system with children with autism at Karapitiya Teaching Hospital, and how can these be navigated within the scope of a final year project in Sri Lanka?

This question is particularly important given the involvement of vulnerable children, facial image data, and a healthcare institutional partner. The ethical landscape for research involving children with ASD is complex, encompassing issues of informed consent (from parents/guardians and assent from children where possible), privacy and data protection, minimisation of harm, and institutional and governmental approval processes (Fletcher-Watson and Happé, 2019). In Sri Lanka, the regulatory pathway involves submission of a research proposal to the relevant institutional ethics review committee and compliance with Ministry of Health research governance requirements (Ministry of Health, Sri Lanka, 2020). The question is answerable through the documentation and analysis of the ethics application process, the content of the ethical protocols developed, and reflection on the challenges and lessons learned. The ethical framework and current progress are documented in Section 9.

### Research Question 5: System Evaluation

**RQ5:** To what extent does the implemented system meet the functional and non-functional requirements (usability, accessibility, offline capability, multilingual support, and emotion-adaptive behaviour) defined for the target user groups and the Sri Lankan context, and what are the key areas for improvement?

This question is evaluative and will be most fully addressed in the final report, following completion of the system and, where feasible, the pilot study. In the interim report, the question is addressed through the documentation of requirements, architecture, and design decisions, as well as through the testing that has been conducted to date (Section 10). The question's breadth is intentional: it invites consideration of both technical (performance, reliability, accuracy) and user-centred (usability, acceptance, satisfaction) dimensions of quality, reflecting the project's commitment to developing a system that is not only technically sound but also meaningful and useful in practice. The evaluation framework, including the metrics, methods, and data sources to be used, is outlined in Sections 8 and 11.

---

## 6. System Architecture

### 6.1 Architectural Overview

The system is conceived as a dual-platform architecture that serves two distinct user groups while sharing a common technology stack, core services, and design principles. The architecture is designed to be modular, extensible, and maintainable, supporting iterative development and future enhancements beyond the scope of the current project. This section describes the high-level architecture, the role of each platform, the integration of the AI component and cloud services, and the rationale for key technology choices.

The major architectural components are:

1. **Two client-facing mobile applications** (Platform A and Platform B) built with Flutter, targeting Android and iOS from a single Dart codebase.
2. **An on-device facial expression recognition module** using TensorFlow Lite, integrated into Platform B and invoked via platform channels.
3. **A backend** comprising Firebase Authentication, Cloud Firestore for structured data, and Firebase Cloud Storage for backup and media.
4. **A therapist–parent web-based dashboard** that consumes the same backend services.
5. **A local data layer** (SQLite or equivalent) for offline storage of user profiles, vocabulary, settings, and usage data.

The architecture follows an offline-first design philosophy: all core AAC functionality (symbol display, text-to-speech, vocabulary customisation) and emotion recognition operate locally on the device, without requiring network connectivity. Cloud synchronisation and backup occur opportunistically when connectivity is available, using Firebase's built-in offline persistence and data synchronisation capabilities. This design principle is a direct response to the connectivity constraints that are common in many parts of Sri Lanka, particularly in rural and semi-urban areas (International Telecommunication Union, 2022), and is consistent with best practices for assistive technology deployment in low-resource settings (Divan et al., 2021).

[Figure 1: Overall System Architecture Diagram]

### 6.2 Dual-Platform Design

The dual-platform design reflects the heterogeneity of ASD and the differing needs of children across the severity spectrum. Rather than building a single, monolithic application that attempts to serve all users with a single interface, the project provides two differentiated platforms that share a common codebase and backend but offer distinct feature sets and interaction paradigms tailored to the user's severity level and communication profile. This approach is informed by the DSM-5 severity classification (American Psychiatric Association, 2013) and by the AAC literature's emphasis on individualisation and flexibility (Light and McNaughton, 2015; Beukelman and Light, 2020).

#### 6.2.1 Platform A: Customisable Symbol-Based AAC (Levels 1–2)

Platform A is designed for children with ASD at severity levels 1–2 who can interact with a symbol-based grid or list interface and who benefit from AAC as a supplement to their developing speech. The design of Platform A is informed by established AAC design principles, including vocabulary organisation, symbol clarity, configurable layout, and multimodal output (Beukelman and Light, 2020). Key features include:

- **Symbol grid interface:** A configurable grid of symbols (images with text labels) organised into categories (e.g., basic needs, feelings, activities, foods, people, places). The grid size (e.g., 2×2, 3×3, 4×4, 6×6) is configurable to match the child's visual and motor abilities. Each symbol can trigger text-to-speech output and/or be combined into multi-symbol utterances.
- **Trilingual support:** All symbols and labels are available in Sinhala, Tamil, and English. The language can be switched globally or configured per category. The system supports mixed-language use for bilingual children and families.
- **Text-to-speech (TTS) output:** When a symbol is selected, the corresponding word or phrase is spoken aloud using the device's TTS engine or a third-party TTS API. TTS quality and availability may vary across languages; the project documents the TTS options tested and their suitability for each language.
- **Customisation:** Parents and therapists can add, remove, or reorder symbols; create custom categories; add photographs as symbols; and configure visual and interaction settings (e.g., font size, colour themes, animation preferences, feedback modes).
- **Visual scheduling:** An optional visual schedule feature allows parents and therapists to create daily routines, which the child can follow and interact with. Visual schedules are a well-established intervention strategy for children with ASD (Mesibov et al., 2005).
- **Usage logging:** The app logs symbol selections, session duration, and interaction patterns (locally, with optional cloud backup), providing data for therapists and parents to monitor progress and inform intervention planning.

[Figure 9: Mobile App UI Layout – Level 1–2]

#### 6.2.2 Platform B: AI-Enhanced AAC with Facial Expression Recognition (Level 3+)

Platform B extends Platform A's functionality by adding an optional facial expression recognition pipeline. It is designed for children at level 3 and above who may have minimal or no functional speech and higher support needs. The rationale for adding emotion recognition is that children at this severity level may have greater difficulty communicating their emotional state through conventional means, and caregivers may benefit from additional cues to guide their responses.

Key additional features include:

- **Facial expression recognition:** When enabled by the caregiver, the device camera (typically front-facing) captures the user's face periodically or on demand. The captured image is processed on-device using the TensorFlow Lite model, which classifies the facial expression into one of six emotion classes (happy, sad, angry, fear, neutral, tired).
- **Emotion-adaptive vocabulary:** Based on the inferred emotion, the AAC interface adapts the vocabulary or prompts presented to the child. The adaptation rules are configurable to avoid over-reliance on the model.
- **Caregiver override and transparency:** The system displays the inferred emotion to the caregiver (e.g., as an icon or text indicator), who can accept, override, or dismiss the suggestion. The interface makes clear that the emotion recognition is an assistive cue, not a definitive assessment.
- **Emotion history and trends:** The dashboard can display aggregated emotion data (e.g., distribution of detected emotions over time) to support therapist and parent understanding of the child's emotional patterns. Raw facial images are not stored by default.

[Figure 2: Dual Platform Architecture Diagram]

[Figure 10: Mobile App UI Layout – Level 3+]

### 6.3 Emotion Detection Pipeline

The emotion detection pipeline integrated into Platform B operates as a five-stage process:

1. **Face detection:** A lightweight face detection algorithm (e.g., Google ML Kit face detection API) identifies the presence and bounding box of a face in the camera frame. If no face is detected, the pipeline does not proceed, and no emotion inference is attempted.
2. **Preprocessing:** The detected face region is cropped from the camera frame, resized to the model's input dimensions (224×224 pixels for MobileNetV2), and normalised (pixel values scaled to the range expected by the model, typically [0, 1] or [-1, 1]).
3. **Inference:** The preprocessed image tensor is passed to the TensorFlow Lite interpreter, which runs the MobileNetV2-based model and outputs a vector of six class probabilities (one per emotion class). The interpreter runs on the device's CPU or, where available, on the GPU or neural processing unit via TFLite delegates.
4. **Postprocessing:** The application applies argmax to determine the dominant emotion. If the maximum probability is below a configurable confidence threshold (e.g., 0.5), the system classifies the result as "uncertain" and does not trigger any vocabulary adaptation. This threshold-based filtering reduces the risk of acting on low-confidence predictions and minimises false-positive adaptations.
5. **Adaptation logic:** If a confident emotion is detected, the adaptation module selects or reorders vocabulary items and prompts based on the detected emotion and the configured adaptation rules. The caregiver is notified via a visual indicator and can accept, override, or dismiss the suggestion. The adaptation is designed to be non-intrusive and reversible.

[Figure 6: Emotion Detection Pipeline]

### 6.4 Backend Architecture and Data Management

#### 6.4.1 Firebase Services

The backend is built on Firebase, a platform developed by Google that provides an integrated suite of services for mobile and web application development (Firebase, 2023). Firebase was selected for its low operational overhead, its support for real-time synchronisation and offline persistence, and its integrated security and authentication features, which are well suited to the needs of a final year project with limited backend infrastructure resources. The following Firebase services are used:

- **Firebase Authentication:** Provides secure authentication for therapists, parents, and administrators. Supported methods include email/password and, optionally, Google Sign-In. Role-based access control is implemented through custom claims and Firestore security rules.
- **Cloud Firestore:** A NoSQL document database used for storing structured data such as user profiles, vocabulary customisations, usage logs, emotion history, and collaboration records. Firestore's built-in offline persistence ensures that data is available even when the device is offline.
- **Firebase Cloud Storage:** Used for storing backup files, exported data, and any consented media.

#### 6.4.2 Offline-First Design

The offline-first architecture is a core design principle. The application stores all essential data locally (user profiles, vocabulary sets, settings, usage logs) using SQLite or a similar embedded database. The TensorFlow Lite model runs entirely on-device, with no dependency on cloud-based processing. Firebase synchronisation occurs opportunistically, with conflict resolution handled according to a defined policy.

#### 6.4.3 Security and Privacy Architecture

Security and privacy are foundational to the architecture. All data in transit is encrypted via HTTPS/TLS. Firebase security rules enforce role-based access control. Data minimisation is practised: raw facial images are not stored or transmitted by default. Audit logging tracks access to sensitive data.

### 6.5 Therapist–Parent Dashboard

The dashboard provides authorised users with tools for collaboration, progress monitoring, vocabulary management, and data export. Features include linked accounts, progress visualisation (charts and summaries), vocabulary management, export capabilities, and backup/restore functions. The dashboard is designed to be accessible on standard web browsers and responsive to different screen sizes.

[Figure 5: Therapist–Parent Collaboration Flow]

### 6.6 Technology Stack Summary

[Table 7: Technology Stack Summary]

| Component | Technology | Justification |
|---|---|---|
| Mobile application | Flutter (Dart) | Single codebase for Android and iOS; rich widget library; platform channel support |
| AI/ML model | TensorFlow/Keras (training); TensorFlow Lite (deployment) | Industry-standard; supports transfer learning, quantization, mobile deployment |
| Base architecture | MobileNetV2 | Lightweight; optimised for mobile; competitive accuracy |
| Backend database | Cloud Firestore (Firebase) | Real-time sync; offline persistence; NoSQL flexibility |
| Authentication | Firebase Authentication | Secure; multiple sign-in methods; integrated security rules |
| Cloud storage | Firebase Cloud Storage | Scalable; integrated; access control |
| Local storage | SQLite | Embedded; efficient; well-supported on mobile |
| Text-to-speech | Platform TTS / third-party TTS API | Necessary for spoken output |
| Face detection | Google ML Kit | Lightweight; on-device; well-integrated |
| Version control | Git (GitHub) | Industry-standard |

### 6.7 Non-Functional Requirements

[Table 10: Non-Functional Requirements Summary]

| Requirement Category | Requirement | Target/Metric |
|---|---|---|
| Performance | Emotion inference latency | < 500 ms per frame on mid-range smartphone |
| Performance | App startup time | < 3 seconds |
| Availability | Offline operation | 100% core AAC and emotion recognition available offline |
| Usability | Accessibility | WCAG 2.1 AA guidelines; configurable fonts, contrast, layout |
| Usability | Learnability | Caregiver configures basic settings within 10 minutes |
| Security | Data protection | TLS encryption; no raw facial images transmitted to cloud |
| Scalability | User capacity | 50+ concurrent users for pilot |
| Reliability | Data integrity | No data loss during offline/online transitions |
| Maintainability | Code quality | Modular architecture; documented; automated tests |
| Portability | Platform support | Android 8.0+ and iOS 14+ |

---
