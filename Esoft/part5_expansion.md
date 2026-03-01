

### 2.6 Extended Critical Analysis of AAC Literature

#### 2.6.1 Evolution of AAC Technology

The evolution of AAC technology over the past four decades has been characterised by a gradual shift from low-tech, non-electronic solutions (e.g., communication boards, picture exchange systems, and simple voice-output devices) to increasingly sophisticated high-tech solutions leveraging mobile computing, artificial intelligence, and cloud connectivity (Light and McNaughton, 2012; Beukelman and Light, 2020). This evolution has not been uniform across all settings and populations, and there remain significant global inequities in access to modern AAC technology. Understanding this evolution provides essential context for positioning the present project within the broader trajectory of AAC research and development.

In the earliest phase of AAC development (1970s–1990s), AAC solutions were predominantly clinician-driven and involved physical boards, symbol books, and simple electronic devices with pre-recorded messages. These solutions were effective for many individuals but were limited in vocabulary size, portability, and flexibility. The Picture Exchange Communication System (PECS), introduced by Bondy and Frost in 1994, represented a significant advance in structured AAC intervention for individuals with autism, providing a systematic protocol for teaching communication using picture symbols (Bondy and Frost, 1994). PECS remains widely used today and has been the subject of extensive research, including several meta-analyses demonstrating its effectiveness for increasing functional communication in children with ASD (Ganz et al., 2012; Flippin et al., 2010).

The advent of tablet computers and smartphones in the late 2000s transformed the AAC landscape. The introduction of the Apple iPad in 2010 was particularly significant, as it provided a portable, affordable (relative to dedicated devices), and socially acceptable platform for AAC applications (McNaughton and Light, 2013). Applications such as Proloquo2Go, TouchChat, and LAMP Words for Life rapidly gained popularity, offering large vocabularies, customisable layouts, and high-quality text-to-speech output on commercially available devices. The shift to tablet-based AAC also reduced the stigma associated with carrying a dedicated communication device, as tablets were commonly used by typically developing peers for entertainment and education (McNaughton and Light, 2013; Lorah et al., 2015).

However, this technology-driven revolution has not reached all populations equally. The vast majority of commercially available AAC applications are designed for English-speaking users in high-income countries, and the cost of both the devices (e.g., iPads) and the applications (e.g., Proloquo2Go at approximately USD 250) places them beyond the reach of many families in low- and middle-income countries (Alant and Bornman, 2021). Moreover, the vocabulary, symbols, and interaction paradigms embedded in these applications reflect the cultural norms, educational practices, and daily life activities of Western societies, which may not translate directly to other cultural contexts. This inequity in access and relevance is a central motivator for the present project.

#### 2.6.2 Evidence for AAC in Autism: A Deeper Examination

The evidence base for AAC in autism is substantial and growing, but it is important to examine it critically. The meta-analysis by Ganz et al. (2012) found that aided AAC interventions (including both low-tech and high-tech approaches) had moderate to large positive effects on communication outcomes for individuals with ASD. However, several caveats apply: (1) the quality of individual studies varied, with many relying on single-case experimental designs with small sample sizes; (2) there was significant heterogeneity in the types of AAC interventions studied, the outcome measures used, and the participant characteristics; and (3) few studies included long-term follow-up, making it difficult to assess the durability of intervention effects (Ganz et al., 2012).

A persistent concern voiced by some parents and professionals is the fear that AAC may hinder or replace the development of natural speech. This concern has been extensively addressed in the literature, with multiple reviews finding no evidence that AAC use reduces speech production; on the contrary, AAC has been associated with modest increases in speech output for many individuals (Millar et al., 2006; Romski and Sevcik, 2005). This finding is often attributed to the communicative success and reduced frustration that AAC provides, which may increase the child's motivation and opportunities for verbal communication. The present project communicates this research clearly to stakeholders through information sheets and in-app guidance, to alleviate potential concerns about the impact of AAC on speech development.

The role of the communication partner (parent, caregiver, therapist, teacher) is increasingly recognised as a critical factor in the success of AAC interventions (Light and McNaughton, 2015). Partner instruction—teaching the communication partner to model AAC use, respond to the child's communicative attempts, and create opportunities for communication—has been shown to significantly enhance AAC outcomes (Kent-Walsh et al., 2015). The present project supports partner engagement through the therapist–parent dashboard, which provides tools for progress monitoring, vocabulary management, and remote collaboration, enabling therapists to guide parents in supporting their child's AAC use even when face-to-face sessions are not possible.

#### 2.6.3 Symbol Systems and Cultural Adaptation

The choice and design of symbol systems in AAC is a non-trivial design decision with significant implications for usability and communicative effectiveness. Common symbol systems include Picture Communication Symbols (PCS), Widgit Symbols, SymbolStix, ARASAAC (Aragonese Centre of Augmentative and Alternative Communication), and Blissymbolics, each with different levels of iconicity (the degree to which the symbol visually resembles its referent), vocabulary coverage, and licensing terms (Beukelman and Light, 2020).

For deployment in Sri Lanka, several considerations arise. First, the licensing costs of proprietary symbol sets (e.g., PCS, which requires a per-user or per-application licence) may be prohibitive. ARASAAC, which is freely available under a Creative Commons licence, offers an extensive set of culturally neutral symbols and has been adapted for use in multiple languages and cultural contexts, making it a strong candidate for the base symbol set in this project. Second, regardless of the base symbol set chosen, cultural adaptation is essential. This involves: (a) adding symbols for locally relevant items (e.g., Sri Lankan foods such as rice, pol sambol, hoppers, and dhal curry; local activities such as cricket, temple visits, and Vesak celebrations; and familiar people such as ammā, appā, and āchi); (b) modifying or replacing symbols that depict culturally unfamiliar items; and (c) ensuring that the visual style of symbols is appropriate for the target age group and cultural context.

The project supports a hybrid approach: a default symbol set (based on ARASAAC or a similar freely available set, with culturally adapted additions) is provided out of the box, and parents and therapists can add custom symbols (including photographs) and create personalised categories. This approach balances the need for a comprehensive, ready-to-use symbol vocabulary with the need for individualisation, which is a well-established principle in AAC practice (Beukelman and Light, 2020).

#### 2.6.4 AAC and Language Development in Multilingual Contexts

Multilingualism is the norm rather than the exception in many parts of the world, and Sri Lanka is no exception. The country's trilingual landscape (Sinhala, Tamil, and English) means that many families use more than one language at home, and children may be exposed to different languages in different settings (home, school, clinic, community). AAC for multilingual individuals presents unique challenges, including the need for vocabulary in multiple languages, the potential for code-switching (alternating between languages within a conversation), and the need for symbol systems and speech output that are appropriate in each language (Soto and Yu, 2014; Kulkarni and Parmar, 2017).

Research on multilingual AAC is limited but growing. Soto and Yu (2014) found that bilingual children using AAC could successfully learn and use vocabulary in both languages when provided with bilingual AAC support. Kulkarni and Parmar (2017) reviewed the challenges of adapting AAC for Indian languages and cultural contexts, noting the need for expanded vocabulary sets, appropriate symbols, and high-quality text-to-speech in each language. These findings are directly relevant to the present project, which aims to provide full trilingual support (Sinhala, Tamil, English) in both the AAC interface and the text-to-speech output.

The implementation of trilingual support in the current system involves: (a) storing vocabulary items with labels in all three languages; (b) allowing the user (via caregiver configuration) to select the active language(s); (c) supporting mixed-language displays (e.g., Sinhala labels with English fallback for items without a Sinhala translation); and (d) providing text-to-speech output in the selected language. The quality and naturalness of text-to-speech for Sinhala and Tamil are known challenges, as the availability and quality of TTS engines for these languages are inferior to those for English (Google Cloud Text-to-Speech, 2023). The project documents the TTS options evaluated and their suitability, and includes fallback mechanisms (e.g., recorded audio for critical vocabulary items) where TTS quality is insufficient.

#### 2.6.5 Affective Computing and Emotion Recognition: Extended Discussion

Affective computing—the study and development of systems that recognise, interpret, and respond to human emotions—was first formalised as a research field by Rosalind Picard in her seminal book, *Affective Computing* (Picard, 2000). Since then, the field has grown rapidly, driven by advances in machine learning, computer vision, and sensor technology. Affective computing encompasses a range of modalities for emotion recognition, including facial expression analysis, speech prosody analysis, physiological signal analysis (e.g., heart rate, electrodermal activity), body gesture and posture analysis, and text sentiment analysis (Calvo and D'Mello, 2010).

Facial expression recognition (FER) has been the most widely studied modality in affective computing, owing in part to the influential work of Paul Ekman and colleagues, who proposed the existence of six basic, universally recognised emotions (happiness, sadness, anger, fear, surprise, and disgust) expressed through characteristic facial configurations (Ekman and Friesen, 1971; Ekman, 1992). While the universality of these basic emotions has been challenged in recent years (Russell, 1994; Barrett et al., 2019), the framework remains widely used in computer science research and provides a practical basis for FER system design.

The present project departs from Ekman's original six categories in two respects: (1) "surprise" is excluded, as it is less relevant to the needs of children with ASD in daily communication and is frequently confused with other emotions (especially "fear") in automated FER (Li and Deng, 2020); (2) "tired" is included as a sixth class, reflecting the practical importance of fatigue as a communicative state for young children and the feedback of clinicians who noted that tiredness is a common reason for communication breakdowns and behavioural challenges in children with ASD (Mazefsky et al., 2013). The "tired" class is not standard in most FER datasets, which necessitates purpose-built data collection and/or approximate mapping from existing labels (e.g., "drowsy," "fatigued").

The transition from laboratory-based FER (controlled lighting, posed expressions, frontal view, adult subjects) to "in-the-wild" FER (variable lighting, spontaneous expressions, diverse poses and occlusions, children as subjects) is one of the major unsolved challenges in affective computing (Li and Deng, 2020; Barrett et al., 2019). The present project operates at the intersection of these two paradigms: the model is trained primarily on publicly available datasets (which include a mix of posed and spontaneous expressions from various demographic groups) with supplementary purpose-collected data from the target population, and it is deployed in real-world settings where lighting, head pose, and occlusion are not controlled. The expected impact of this gap on model accuracy is acknowledged and documented as a limitation.

#### 2.6.6 Challenges of FER for Children with ASD

Children with ASD present specific challenges for FER systems, which have been studied in a growing body of research. Trevisan et al. (2018) conducted a meta-analysis of facial expression production in autism and found that individuals with ASD produce facial expressions that are rated as less intense, less recognisable, and more ambiguous compared to neurotypical individuals. Grossard et al. (2020) used machine learning classifiers to analyse the facial expressions of children with and without ASD, finding that expressions produced by children with ASD were more variable and less consistently classified.

These findings have direct implications for the present project. A model trained primarily on FER datasets composed of neurotypical adult faces may underperform when applied to children with ASD, because: (1) children's faces differ morphologically from adults' faces (e.g., different proportions, smoother skin, smaller features); (2) children with ASD may produce atypical or subtle expressions that do not conform to the prototypical templates learned from training data; and (3) the context in which the system is deployed (e.g., during moments of distress, overstimulation, or fatigue) may produce facial configurations that are not well represented in standard datasets.

To mitigate these challenges, the project adopts the following strategies: (a) inclusion of child faces in the training data (by selecting datasets and subsets that include children, and by collecting purpose-built data from the target population); (b) data augmentation to increase robustness to variations in lighting, pose, and expression intensity; (c) confidence thresholding to avoid acting on low-confidence predictions; and (d) positioning the FER output as an assistive cue to the caregiver rather than a definitive classification, with caregiver override always available.

### 2.7 Technology Platform: Extended Analysis

#### 2.7.1 Flutter: Design Philosophy and Technical Advantages

Flutter, developed by Google and released in 2018, is an open-source UI toolkit for building natively compiled applications for mobile (Android, iOS), web, and desktop from a single Dart codebase (Flutter, 2023). Flutter was selected for this project after a comparative evaluation of available cross-platform frameworks (including React Native, Xamarin, and native development), based on the following criteria:

1. **Single codebase, native performance:** Flutter compiles directly to native ARM code (via the Dart Ahead-of-Time compiler), providing near-native performance on both Android and iOS. This is important for the project because the emotion detection pipeline requires responsive UI and camera processing with minimal latency.

2. **Widget-based architecture:** Flutter's declarative, widget-based UI framework makes it straightforward to build custom, adaptive interfaces—a key requirement for an AAC application where grid sizes, colour themes, font sizes, and interaction paradigms must be configurable by the caregiver.

3. **Platform channels:** Flutter supports platform channels, which allow Dart code to communicate with platform-specific code (Java/Kotlin on Android, Swift/Objective-C on iOS). This is used in the project to invoke the TensorFlow Lite interpreter, access the device camera, and integrate with platform-specific TTS and accessibility services.

4. **Ecosystem and community:** Flutter has a large and active developer community, a rich package ecosystem (including packages for camera, TTS, SQLite, Firebase, and charts/visualisation), and extensive documentation, which facilitate development and troubleshooting.

5. **Hot reload:** Flutter's stateful hot reload feature enables rapid iteration during development, allowing UI and logic changes to be previewed instantly without restarting the application. This accelerates the design–test–refine cycle, which is particularly valuable in a project with intensive UI customisation requirements.

#### 2.7.2 Firebase: Services, Advantages, and Limitations

Firebase, developed by Google, provides an integrated suite of cloud services for mobile and web application development, including authentication, real-time database, cloud storage, analytics, and more (Firebase, 2023). The project uses Firebase for backend services for several reasons:

1. **Rapid prototyping:** Firebase provides ready-to-use services for authentication, database, and storage, eliminating the need to develop, deploy, and maintain a custom backend server. This is a significant advantage for a single-developer academic project with limited infrastructure resources.

2. **Offline persistence:** Cloud Firestore, Firebase's NoSQL document database, includes built-in offline persistence. When the device is offline, read and write operations are served from a local cache, and changes are synchronised automatically when connectivity is restored. This aligns with the project's offline-first design philosophy.

3. **Security rules:** Firestore and Firebase Storage support declarative security rules that are evaluated on the server, providing role-based access control without requiring a custom authentication middleware. This simplifies the implementation of secure data access for therapists, parents, and administrators.

4. **Scalability:** Firebase's infrastructure (hosted on Google Cloud) provides automatic scaling for the pilot and any future expansion, without requiring manual server provisioning or load balancing.

**Limitations** of Firebase that are acknowledged in the project include: (a) the pay-as-you-go pricing model, which may incur costs as usage scales beyond the free tier limits; (b) vendor lock-in, as Firebase services are proprietary to Google and migrating to an alternative backend would require significant rearchitecting; (c) the NoSQL data model of Firestore, which differs from relational databases and requires careful schema design to avoid data duplication and ensure query efficiency; and (d) limited support for complex queries, aggregations, and joins compared to SQL databases.

#### 2.7.3 TensorFlow Lite: Architecture and Deployment

TensorFlow Lite (TFLite) is a lightweight runtime for deploying machine learning models on mobile, embedded, and edge devices (TensorFlow, 2023). It is a core component of the TensorFlow ecosystem, optimised for low-latency inference on resource-constrained devices. The key features of TFLite that are relevant to this project include:

1. **Model conversion:** TFLite provides a converter that transforms TensorFlow/Keras models into the FlatBuffers-based TFLite format, which is optimised for size, loading speed, and inference performance. The conversion process supports quantization (see Section 8.7), which further reduces model size and inference latency.

2. **Hardware acceleration:** TFLite supports hardware acceleration through delegates, which offload computation to specialised hardware where available. On Android, the NNAPI (Neural Networks API) delegate can leverage device-specific accelerators (e.g., DSP, NPU, GPU). On iOS, the Core ML and Metal delegates provide similar capabilities. The use of delegates can significantly reduce inference latency and power consumption.

3. **Interpreter API:** The TFLite interpreter provides a lightweight API for loading, initialising, and running models. The interpreter manages input/output tensor allocation and supports multiple input/output tensors, making it suitable for a range of model architectures.

4. **Cross-platform support:** TFLite runs on Android, iOS, Linux, and microcontrollers, ensuring broad compatibility with the target devices.

The integration of TFLite into the Flutter application is achieved via platform channels: the Dart code sends a preprocessed image tensor to the platform-specific (Android/iOS) TFLite interpreter, which runs the model and returns the output tensor (class probabilities) to Dart for postprocessing and UI update. This architecture isolates the ML inference from the UI layer, promoting modularity and testability.

### 6.8 Extended System Design: Data Flow and Component Interaction

#### 6.8.1 Data Flow Diagrams

The data flow through the system can be decomposed into several key scenarios, each involving different components and data paths:

**Scenario 1: Basic AAC Interaction (Platform A)**

1. User (child, with caregiver support) navigates the symbol grid.
2. User selects a symbol.
3. App retrieves the symbol's label in the active language from the local database.
4. App invokes the TTS engine with the label text.
5. TTS engine produces audio output (spoken word/phrase).
6. App logs the selection event (symbol ID, timestamp, session ID) to local storage.
7. (When online) App syncs the log entry to Cloud Firestore.

**Scenario 2: Emotion-Adaptive AAC Interaction (Platform B)**

1. Caregiver enables the emotion detection feature.
2. App activates the front-facing camera and begins capturing frames.
3. Face detection module identifies a face in the frame.
4. Preprocessing module crops, resizes, and normalises the face region.
5. TFLite interpreter runs the emotion recognition model on the preprocessed image.
6. Postprocessing module determines the dominant emotion and confidence score.
7. If confidence exceeds the threshold, the adaptation module adjusts the displayed vocabulary (e.g., prominently displaying emotion-related phrases).
8. Caregiver is notified of the inferred emotion via a visual indicator.
9. Caregiver accepts, overrides, or dismisses the suggestion.
10. Interaction proceeds as in Scenario 1 (symbol selection, TTS, logging).
11. Emotion classification and timestamp are logged locally and (when online) synced to Firestore.

**Scenario 3: Therapist Reviews Progress via Dashboard**

1. Therapist authenticates via the web dashboard.
2. Dashboard retrieves the linked child's usage logs and emotion history from Firestore.
3. Dashboard displays summary charts (e.g., most used symbols, emotion distribution over time, session frequency).
4. Therapist reviews data and optionally modifies vocabulary (adds/removes symbols, adjusts categories).
5. Changes are saved to Firestore and synced to the child's device when online.

#### 6.8.2 Component Interaction and API Design

The system's components interact through well-defined interfaces:

- **Flutter App ↔ Local Database (SQLite):** CRUD operations for user profiles, vocabulary, settings, usage logs, and emotion history. The app's data layer is implemented using a repository pattern, abstracting the database implementation from the business logic.
- **Flutter App ↔ TFLite Interpreter (Platform Channel):** The app sends a byte array (preprocessed image) to the platform-specific TFLite wrapper, which returns an array of class probabilities. Error handling covers cases such as model loading failure, invalid input dimensions, and interpreter runtime errors.
- **Flutter App ↔ Firebase (Firestore, Auth, Storage):** The app uses the FlutterFire packages (cloud_firestore, firebase_auth, firebase_storage) for authentication, real-time data synchronisation, and file upload/download. Offline persistence is enabled on the Firestore instance, ensuring that read and write operations are served from the local cache when the device is offline.
- **Dashboard ↔ Firebase:** The web dashboard uses the Firebase JavaScript SDK to authenticate, read, and write data in Firestore and Storage. Security rules ensure that the dashboard can only access data for children linked to the authenticated therapist or parent.

#### 6.8.3 Error Handling and Resilience

The system incorporates several error handling and resilience mechanisms:

- **Model loading failure:** If the TFLite model fails to load (e.g., corrupted model file, unsupported device), the app disables the emotion detection feature and logs the error. The AAC functionality of Platform B continues to operate normally (as Platform A) without emotion adaptation.
- **Camera access failure:** If camera access is denied or the camera is unavailable, the emotion detection feature is disabled with a clear message to the caregiver.
- **Sync failure:** If Firebase synchronisation fails (e.g., authentication token expired, network error), the app retains data locally and retries synchronisation at the next available opportunity. A sync status indicator informs the caregiver of the synchronisation state.
- **Low battery:** The app can optionally reduce camera capture frequency or disable emotion detection when the device battery is below a configurable threshold, to conserve power.

### 7.5 Extended Methodology: Quality Assurance and Testing Strategy

#### 7.5.1 Testing Levels

The project employs a multi-level testing strategy aligned with standard software engineering practice (Sommerville, 2016):

1. **Unit testing:** Individual functions and classes (e.g., data access objects, model inference wrapper, vocabulary management logic) are tested in isolation using the Flutter test framework and Dart's built-in testing library. Test cases cover normal operation, boundary conditions, and error scenarios.

2. **Integration testing:** Interactions between components (e.g., the data layer and the UI, the TFLite inference wrapper and the postprocessing module, the app and Firebase services) are tested to ensure correct data flow and error handling across interfaces. Flutter's integration_test package is used for end-to-end testing on a device or emulator.

3. **System testing:** The complete application (including both Platform A and Platform B functionality) is tested on representative Android and iOS devices, covering the full set of functional requirements. Test scenarios include: basic AAC interaction (symbol selection, TTS output, logging), language switching, vocabulary customisation, emotion detection (using test images with known labels), adaptation logic, caregiver override, dashboard access, and offline/online transitions.

4. **Acceptance testing:** Informal acceptance testing is conducted with at least one representative user (therapist and/or parent), seeking feedback on usability, clarity, and perceived value. Formal acceptance testing (if the pilot proceeds) will involve structured observation and feedback using standardised or project-specific instruments.

#### 7.5.2 AI Model Evaluation Protocol

The AI model is evaluated using a held-out test set (not seen during training or validation), with the following protocol:

1. The test set is stratified by class (emotion) and, where possible, by demographic factors (age, gender).
2. The model is run on each test image, and the predicted class and confidence score are recorded.
3. The confusion matrix is computed and visualised.
4. Per-class precision, recall, and F1 are computed.
5. Macro-averaged and weighted-averaged precision, recall, and F1 are computed.
6. Overall accuracy is computed.
7. (Optionally) Per-class ROC curves and AUC are computed.
8. Inference time (average and 95th percentile) and model size (MB) are measured on a representative device.
9. Results are compared against pre-defined targets (≥80% accuracy, <500 ms inference) and against reported benchmarks for similar architectures and datasets in the literature.

#### 7.5.3 Usability Evaluation Approach

Usability evaluation is planned in two phases:

**Phase 1 (Internal):** During development, the developer (and, where available, supervisor or peer reviewers) evaluates the app against a heuristic checklist adapted from Nielsen's 10 Usability Heuristics (Nielsen, 1994). Specific attention is given to: visibility of system status (e.g., is the active language clear? is the sync status visible?), match between the system and the real world (e.g., are symbols recognisable and culturally appropriate?), user control and freedom (e.g., can the caregiver easily undo a selection or exit a mode?), consistency and standards (e.g., are navigation patterns consistent across screens?), and error prevention (e.g., are destructive actions—such as deleting a vocabulary item—confirmed?).

**Phase 2 (External):** Following Platform A completion and (if applicable) ethics approval, informal usability feedback is sought from at least one therapist and one parent/caregiver. Feedback methods include: structured observation of an interaction session, a brief post-session interview or questionnaire (e.g., System Usability Scale), and open-ended feedback. Findings are used to inform design revisions before the pilot.

### 9.8 Extended Ethical Analysis: AI Ethics and Vulnerable Populations

#### 9.8.1 AI Ethics Frameworks

The development and deployment of AI systems in sensitive domains—particularly those involving children, individuals with disabilities, and healthcare contexts—has attracted increasing attention from ethicists, policymakers, and technologists (Floridi et al., 2018; Jobin et al., 2019). Several AI ethics frameworks have been proposed, each emphasising a set of core principles:

- **Beneficence and non-maleficence:** The system should do good and avoid harm. In the context of this project, beneficence means providing meaningful communication support to children with ASD; non-maleficence means avoiding harm through misclassification, loss of privacy, or inappropriate reliance on automated systems.
- **Autonomy and human oversight:** The user (or, in the case of children, the caregiver) should retain agency and control over the system's behaviour. The caregiver override mechanism in Platform B operationalises this principle.
- **Justice and fairness:** The system should not discriminate against any group. In the context of FER, this means actively monitoring and mitigating bias in the training data and model performance across demographic groups.
- **Transparency and explainability:** Users should understand what the system is doing and how it reaches its conclusions. While full explainability of CNN predictions remains an open research problem, the project provides transparency through clear communication of the system's purpose, limitations, and confidence levels.
- **Privacy and data protection:** Users' personal data—especially facial images and communication patterns—must be protected. The on-device processing and data minimisation strategies described in Sections 6 and 9 operationalise this principle.
- **Accountability:** The developer and deploying institution are accountable for the system's performance and impact. This accountability is exercised through rigorous testing, documentation, ethical review, and ongoing monitoring.

#### 9.8.2 Specific Ethical Challenges in AI for Autism

The application of AI to support individuals with autism raises specific ethical challenges that go beyond general AI ethics:

1. **Capacity and consent:** Children with ASD may have limited ability to understand or consent to the use of AI-based features. The project addresses this through parental consent, child assent (where feasible), and ongoing monitoring for signs of distress or avoidance.

2. **Risk of pathologising:** There is a risk that an AI system focused on emotion detection could contribute to a narrative of "fixing" or "correcting" autistic behaviour, rather than supporting communication on the individual's own terms. The project positions FER as an assistive cue to support caregivers, not as a tool to normalise or correct the child's behaviour or expressions.

3. **Atypical expression:** As discussed in Section 2.6.6, children with ASD may express emotions differently from neurotypical individuals. A model trained on neurotypical data may misclassify atypical expressions, potentially leading to inappropriate system responses. The project mitigates this through confidence thresholding, caregiver override, and transparent communication of the system's limitations.

4. **Power dynamics:** The system introduces a technological intermediary into the caregiver–child relationship. There is a risk that the caregiver may defer to the system's emotion classification over their own observation, especially if the system is perceived as authoritative. The project's design explicitly counteracts this by presenting the FER output as a suggestion with a visible confidence indicator, and by providing prominent override controls.

5. **Surveillance concerns:** Continuous or frequent facial image capture for FER could be perceived as surveillance, which is particularly sensitive for a vulnerable population. The project addresses this by: (a) making FER opt-in; (b) providing clear information about what data is captured and how it is used; (c) not storing raw facial images by default; and (d) allowing the caregiver to disable FER at any time.

### 10.9 Detailed Technical Implementation Progress

#### 10.9.1 Flutter Application Structure

The Flutter application is organised according to the following directory structure, following clean architecture principles and Flutter community best practices:

```
lib/
├── main.dart                  # App entry point
├── config/                    # App configuration, themes, constants
├── models/                    # Data models (User, Symbol, Category, EmotionRecord)
├── services/                  # Service layer (Firebase, TTS, TFLite, Local DB)
├── repositories/              # Repository pattern: abstracts data sources
├── screens/                   # UI screens (Home, AAC Grid, Settings, Dashboard)
├── widgets/                   # Reusable UI components (SymbolCard, EmotionIndicator)
├── utils/                     # Utility functions (image preprocessing, date formatting)
└── l10n/                      # Localisation files (Sinhala, Tamil, English)
```

The application uses the BLoC (Business Logic Component) or Provider pattern for state management, separating UI from business logic and facilitating testability. Navigation is handled via Flutter's Navigator 2.0 or GoRouter, with named routes for each screen.

#### 10.9.2 Firebase Data Schema

The Firestore data schema is designed to support the project's data requirements while respecting the constraints of a NoSQL document database:

```
users/
  {userId}/
    profile: { name, role (parent/therapist), email, linkedChildren[] }
    settings: { language, theme, gridSize, emotionDetectionEnabled, confidenceThreshold }

children/
  {childId}/
    profile: { name, ageGroup, asdLevel, linkedParents[], linkedTherapists[] }
    vocabulary/
      {categoryId}/
        symbols: [ { symbolId, labelEn, labelSi, labelTa, imageUrl, order } ]
    usageLogs/
      {logId}: { symbolId, timestamp, sessionId, language }
    emotionHistory/
      {recordId}: { emotion, confidence, timestamp, overridden, overrideEmotion }
```

Security rules enforce that: (a) users can only read/write their own profile and settings; (b) parents can read/write their linked children's data; (c) therapists can read/write data for children linked to their account; (d) unauthenticated users have no access.

#### 10.9.3 Model Training Results (Preliminary)

Preliminary model training was conducted on a subset of the FER2013 dataset (approximately 7,000 images from six classes, with the "surprised" class excluded and samples from other datasets used to approximate the "tired" class). Results are provisional and will be updated in the final report with the complete project-specific dataset.

[Table 11: Preliminary Model Evaluation Results]

| Metric | Value |
|---|---|
| Overall accuracy (test set) | 69.3% |
| Macro-averaged precision | 0.67 |
| Macro-averaged recall | 0.66 |
| Macro-averaged F1 | 0.66 |
| Model size (float32) | ~9.2 MB |
| Model size (quantized, int8) | ~2.5 MB |
| Inference time (mid-range Android) | ~180 ms |
| Inference time (quantized, mid-range Android) | ~95 ms |

Per-class analysis reveals that "happy" and "neutral" are the most accurately classified (F1 > 0.75), while "fear" and "tired" are the most confused classes (F1 < 0.55), consistent with reported challenges in the FER literature. The lower accuracy for "tired" is expected, as this class is not standard in FER datasets and the training examples were approximated from related labels.

Plans for improving accuracy in the next phase include: (a) increasing the dataset size with purpose-collected data; (b) fine-tuning the full MobileNetV2 model (not just the classification head); (c) applying class-specific augmentation to underrepresented or confused classes; (d) experimenting with alternative classification heads (e.g., additional dense layers, residual connections); and (e) applying class weighting or focal loss to address class imbalance.

### 11.8 Extended Discussion of Planned Pilot Study Design

#### 11.8.1 Pilot Objectives

The planned pilot study at Karapitiya Teaching Hospital has the following specific objectives:

1. **Feasibility:** To assess whether the AAC system can be installed, configured, and used in a real clinical and home setting with children with ASD and their caregivers.
2. **Usability:** To evaluate the ease of use, learnability, and satisfaction of caregivers and therapists using the system.
3. **Acceptability:** To assess whether the system is perceived as useful, appropriate, and culturally acceptable by caregivers, therapists, and (to the extent assessable) the children themselves.
4. **Technical reliability:** To assess the system's technical performance in real-world conditions, including the accuracy of emotion recognition, the reliability of offline/online transitions, and the stability of the application.
5. **Formative feedback:** To gather qualitative and quantitative feedback that can inform design revisions and future development.

#### 11.8.2 Participant Recruitment

Participants will be recruited from the outpatient paediatric and developmental services at Karapitiya Teaching Hospital. Inclusion criteria: children aged 3–12 years with a clinical diagnosis of ASD (any severity level); at least one parent/caregiver willing to participate; and availability for the duration of the pilot. Exclusion criteria: severe uncorrected visual or auditory impairment that would prevent use of the app; absence of a suitable device (Android or iOS smartphone/tablet); and withdrawal of consent at any point.

The target sample size is 5–15 child–caregiver dyads, consistent with the formative, feasibility-focused design of the pilot and the constraints of a final year project (Hertzog, 2008). Recruitment materials (information sheets, posters, and verbal briefings) will be provided in Sinhala, Tamil, and English.

#### 11.8.3 Data Collection Instruments

Data collection during the pilot will use the following instruments:

1. **System usage logs:** Automatically collected by the app (symbol selections, session duration, emotion detections, caregiver overrides).
2. **Post-session questionnaire:** A brief caregiver questionnaire administered after one week and at the end of the pilot period, covering perceived usefulness, ease of use, cultural appropriateness, and suggestions for improvement. The System Usability Scale (SUS; Brooke, 1996) may be adapted for this purpose.
3. **Therapist interview:** A semi-structured interview with the child's therapist (if available), covering observations of the child's engagement with the system, perceived clinical value, and suggestions for improvement.
4. **Session observations:** Where feasible and consented, the project team will observe a small number of sessions to note interaction patterns, challenges, and caregiver behaviours.
5. **Technical performance log:** Automated logging of errors, crashes, sync events, and inference times during pilot use.

#### 11.8.4 Analysis Plan

Quantitative data (usage logs, SUS scores, technical metrics) will be summarised descriptively (means, medians, ranges, frequency distributions). Qualitative data (interview transcripts, observation notes, open-ended questionnaire responses) will be analysed using thematic analysis (Braun and Clarke, 2006), identifying key themes related to feasibility, usability, acceptability, and areas for improvement.

The pilot is not powered for inferential statistical analysis (e.g., hypothesis testing about communication outcomes), and the findings will be interpreted as formative evidence to guide future development and evaluation, not as evidence of clinical effectiveness.

---
