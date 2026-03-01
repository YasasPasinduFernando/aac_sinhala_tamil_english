

### 2.10 Extended Analysis of Sensory Processing and Interface Design for ASD

#### 2.10.1 Sensory Processing Differences in Autism

Sensory processing differences are recognised as a core feature of autism spectrum disorder in DSM-5, which includes "hyper- or hypo-reactivity to sensory input or unusual interest in sensory aspects of the environment" as a diagnostic criterion under the restricted, repetitive patterns of behaviour domain (APA, 2013). Research has consistently demonstrated that between 50% and 96% of individuals with ASD experience atypical sensory processing, depending on the assessment method and sample (Leekam et al., 2007; Ben-Sasson et al., 2009; Tomchek and Dunn, 2007).

Sensory processing differences in ASD are typically described along two dimensions: (1) hyper-reactivity (over-responsiveness), in which the individual responds more intensely or for a longer duration to sensory stimuli than expected; and (2) hypo-reactivity (under-responsiveness), in which the individual shows a reduced or absent response to sensory input. Many individuals with ASD exhibit a combination of both patterns across different sensory modalities (Baranek et al., 2006). Additionally, sensory seeking—actively pursuing intense or unusual sensory experiences—is a common pattern in ASD.

These sensory differences have direct and significant implications for the design of technology-based interventions for children with ASD:

- **Visual processing:** Children who are hypersensitive to visual input may be overwhelmed by bright colours, complex patterns, or animations in an app interface. Conversely, children who are hyposensitive may benefit from bold, high-contrast visuals and animated feedback to maintain attention.
- **Auditory processing:** Children who are hypersensitive to auditory input may be distressed by loud, sudden, or complex sounds, including TTS output at default volume levels. Configurable volume, sound effects toggle, and calm or natural-sounding TTS voices are important accommodations.
- **Tactile processing:** While less directly relevant to a software interface, children who seek or avoid tactile input may have difficulty with touchscreen interactions (e.g., finding the touch experience aversive, or preferring firm, deliberate taps over light touches).

The present project's interface design incorporates the following sensory accommodations: (a) configurable colour themes including a muted/pastel mode; (b) configurable animation settings (full, reduced, off); (c) configurable sound and volume settings; (d) a visual schedule with predictable, sequential structure to reduce cognitive and sensory load; and (e) a clean, uncluttered layout with generous spacing between interactive elements.

#### 2.10.2 Attention and Executive Function in AAC Use

Children with ASD may also experience differences in attention and executive function that affect their ability to use AAC systems effectively. Attention challenges may include difficulty sustaining focus on the AAC screen, difficulty shifting attention between the communication partner and the device, and difficulty filtering out irrelevant stimuli in the environment (Keehn et al., 2013). Executive function challenges may include difficulty planning multi-step communication sequences (e.g., navigating through categories to find a specific symbol), difficulty inhibiting impulsive selections, and difficulty adapting to changes in the interface (Hill, 2004).

These challenges inform several design decisions in the present project:

1. **Shallow navigation hierarchy:** Vocabulary is organised into a maximum of two levels (categories → symbols), minimising the number of navigation steps required to access any item. This reduces the executive function demands of the interaction.

2. **Recently used / favourites:** A "recently used" or "favourites" section on the home screen provides quick access to the child's most frequently used symbols, reducing the need for navigation.

3. **Consistent layout:** The layout and position of key elements (navigation buttons, category tabs, the AAC grid) remain constant across screens, reducing the need for visual search and reorientation.

4. **Confirmation for irreversible actions:** Actions such as deleting a symbol or clearing the communication bar require explicit confirmation, reducing the impact of impulsive selections.

5. **Visual schedule integration:** The visual schedule feature provides a structured, sequential representation of the child's activities, supporting executive planning and time awareness.

### 4.6 Extended Discussion of Research Objectives and Their Relationship to System Design

Each research objective maps to specific system features and evaluation criteria:

**Objective 1 (Provide AAC communication):** This objective requires: (a) a functional symbol grid with a meaningful vocabulary; (b) text-to-speech output in Sinhala, Tamil, and English; (c) support for vocabulary customisation; and (d) an interface that is usable by children with ASD and their caregivers. Evaluation: (i) functional testing of symbol selection and TTS output; (ii) vocabulary coverage assessment; (iii) usability evaluation (heuristic review and stakeholder feedback).

**Objective 2 (Integrate AI-based emotion recognition):** This objective requires: (a) a trained facial expression recognition model with acceptable accuracy on the target classes; (b) on-device inference with acceptable latency; (c) integration of the emotion output with the AAC interface; and (d) caregiver override functionality. Evaluation: (i) model accuracy metrics (precision, recall, F1, accuracy); (ii) inference latency benchmarks; (iii) functional testing of emotion-to-AAC adaptation; (iv) usability of the override mechanism.

**Objective 3 (Trilingual support):** This objective requires: (a) vocabulary labels in Sinhala, Tamil, and English; (b) TTS output in all three languages; (c) a language selection mechanism; and (d) testing of the interface and TTS in each language. Evaluation: (i) completeness of vocabulary translations; (ii) TTS quality assessment in each language; (iii) correct display of Sinhala and Tamil Unicode text.

**Objective 4 (Therapist–parent collaboration):** This objective requires: (a) a web-based dashboard for therapists and parents; (b) user authentication and role-based access; (c) progress visualisation (charts, summaries); (d) remote vocabulary management; and (e) data synchronisation between the app and dashboard. Evaluation: (i) functional testing of dashboard features; (ii) data consistency between app and dashboard; (iii) usability feedback from therapists/parents.

**Objective 5 (Clinical validation through pilot):** This objective requires: (a) ethics approval; (b) participant recruitment; (c) data collection instruments; (d) pilot execution; and (e) analysis and reporting. Evaluation: (i) number of participants enrolled; (ii) completeness and quality of data collected; (iii) participant feedback; (iv) pilot findings as reported in the final report.

### 5.6 Extended Exploration of Research Questions

#### 5.6.1 RQ1: Feasibility of On-Device Emotion Recognition

This question addresses whether a CNN-based FER model can be deployed on a mobile device with acceptable performance in terms of accuracy, latency, and resource consumption. The question is motivated by the tension between the desire for AI-enhanced functionality and the constraints of mobile deployment:

- **Accuracy vs. model size trade-off:** Smaller models (e.g., MobileNetV2) have fewer parameters and thus lower representational capacity compared to larger models (e.g., ResNet-50, EfficientNet-B4). The question is whether the accuracy achieved by MobileNetV2 is sufficient for the application's needs—bearing in mind that the emotion output is presented as a suggestive cue, not a definitive classification.

- **Latency and user experience:** If inference takes too long (e.g., >1 second), the emotion feedback will be delayed and potentially confusing or irrelevant by the time it is displayed. The 500 ms target is based on HCI research suggesting that delays below 500 ms are generally perceived as responsive, while delays above 1 second are perceived as sluggish (Nielsen, 1993).

- **Battery and thermal management:** Continuous inference can drain battery and cause the device to overheat, which may lead to negative user experiences or even safety concerns. The configurable capture frequency and battery-saving mode address these concerns.

#### 5.6.2 RQ2: Impact of Cultural and Linguistic Adaptation

This question examines whether a culturally and linguistically adapted AAC system is perceived as more useful and appropriate than generic (English-only, Western-focused) alternatives. The hypothesis is that adaptation will increase acceptance, engagement, and communicative effectiveness, but this must be tested through stakeholder feedback and (if possible) comparative analysis.

Cultural adaptation encompasses not only language but also symbol design, vocabulary content, daily routines reflected in the visual schedule, and the communication strategies modelled in the user guide and training materials. The pilot study will collect qualitative and quantitative data on the perceived cultural appropriateness of the system.

#### 5.6.3 RQ3: Therapist–Parent Collaboration Through Technology

This question explores whether a technology platform can facilitate effective collaboration between therapists and parents/caregivers in supporting a child's AAC use. The dashboard provides a shared data environment, but the quality of collaboration depends on factors beyond the technology itself, including the therapist's engagement, the parent's confidence and motivation, and the therapeutic relationship. The pilot will assess the extent to which the dashboard is actually used by therapists and parents, the perceived value of the features provided, and the barriers to effective remote collaboration.

### 7.6 Extended Discussion of Incremental Model vs. Alternatives

#### 7.6.1 Why Not Agile (Scrum)?

The Agile Scrum framework, widely used in commercial software development, organises work into time-boxed sprints (typically 2–4 weeks), with defined roles (Product Owner, Scrum Master, Development Team), ceremonies (sprint planning, daily standup, sprint review, sprint retrospective), and artefacts (product backlog, sprint backlog, increment) (Schwaber and Sutherland, 2020). While Agile Scrum offers several advantages—rapid feedback, adaptive planning, continuous improvement—it is designed for multi-person teams and its ceremonies and role definitions are not directly applicable to a single-developer academic project.

The project borrows several Agile principles (iterative delivery, prioritised backlog, regular reviews) without adopting the full Scrum framework. This pragmatic approach—sometimes termed "Scrum-inspired" or "Agile-lite"—retains the benefits of iterative development while avoiding the overhead of ceremonies that serve no purpose in a solo context.

#### 7.6.2 Why Not Waterfall?

The Waterfall model (Royce, 1970) organises development into sequential, non-overlapping phases: requirements → design → implementation → testing → deployment. While conceptually straightforward and amenable to documentation-driven academic contexts, the Waterfall model assumes that requirements are stable and well-understood from the outset, and that design and implementation can proceed without feedback until the testing phase. In a project with significant uncertainty (e.g., the performance of the FER model, the outcome of the ethics application, the availability of participants for the pilot), a sequential approach is risky, as problems discovered late in the process may require extensive rework of earlier phases.

#### 7.6.3 Why Not Prototyping?

A prototyping approach (building one or more throwaway prototypes to explore requirements and design alternatives before building the production system) was considered but rejected as the primary methodology for several reasons: (a) the project's academic timeline does not allow for separate prototype and production development cycles; (b) the technologies selected (Flutter, Firebase, TFLite) support rapid iteration within the production codebase (e.g., through hot reload and modular architecture), reducing the need for separate prototypes; and (c) the incremental model achieves many of the same goals as prototyping (early feedback, exploration of design alternatives) without the overhead of maintaining separate codebases.

### 11.9 Extended Future Work Discussion

#### 11.9.1 Advanced AI: Emotion Recognition Enhancements

Future versions of the system could incorporate more sophisticated AI features:

1. **Multimodal emotion recognition:** Combining facial expression analysis with speech prosody analysis (tone, pitch, speaking rate) and physiological signals (heart rate from a wearable device) could improve the accuracy and robustness of emotion recognition. Research has shown that multimodal systems consistently outperform unimodal systems for emotion recognition (D'Mello and Kory, 2015).

2. **Personalised emotion models:** Training or fine-tuning the emotion recognition model on data from the specific child could improve accuracy for that individual, accounting for idiosyncratic expression patterns. Federated learning or on-device model adaptation techniques could enable this personalisation without requiring the data to leave the device.

3. **Longitudinal emotion tracking and trend analysis:** Over time, the emotion history data could be analysed to identify patterns (e.g., particular times of day, activities, or environments associated with specific emotions), providing clinically useful insights to therapists and parents.

4. **Natural language understanding (NLU):** Integrating basic NLU capabilities could enable the system to understand simple spoken instructions from the caregiver (e.g., "show me the feelings category") or to predict the child's communicative intent from context.

#### 11.9.2 Gamification and Social Communication

Gamification elements (e.g., rewards, progress indicators, interactive stories that incorporate AAC use) could increase the child's motivation and engagement with the system. Social communication features (e.g., a peer-to-peer chat function using symbols, or collaborative activities with siblings or peers) could promote social interaction and generalisation of skills.

#### 11.9.3 Wearable and IoT Integration

Integration with wearable devices (e.g., smartwatches for simple communication or alerts) and IoT devices (e.g., smart home controls) could extend the system's utility beyond a single device, supporting communication and independence in a broader range of contexts.

#### 11.9.4 Open-Source and Community Contributions

Making the system open-source could facilitate community contributions, leading to wider language support, symbol set development, and feature enhancements. An open-source model would also support transparency, reproducibility, and ethical scrutiny of the AI components.

### 18.5 Extended Appendices: Key Algorithm Pseudocode

#### Appendix E: Emotion Detection Pipeline Pseudocode

```
FUNCTION DetectEmotion(cameraFrame):
    // Step 1: Face detection
    faces = FaceDetector.detect(cameraFrame)
    IF faces.isEmpty THEN
        RETURN NULL  // No face detected
    END IF
    
    // Step 2: Select the largest face (assumed to be the child)
    face = faces.getLargestFace()
    
    // Step 3: Crop and preprocess the face region
    faceRegion = CropToRect(cameraFrame, face.boundingBox)
    resizedFace = Resize(faceRegion, 224, 224)
    normalised = Normalise(resizedFace, mean=0.5, std=0.5)
    inputTensor = ConvertToFloat32Array(normalised)
    
    // Step 4: Run inference
    outputTensor = TFLiteInterpreter.run(inputTensor)
    probabilities = Softmax(outputTensor)
    
    // Step 5: Determine emotion and confidence
    maxIndex = ArgMax(probabilities)
    confidence = probabilities[maxIndex]
    emotionLabel = EMOTION_LABELS[maxIndex]
    
    // Step 6: Apply confidence threshold
    IF confidence < CONFIDENCE_THRESHOLD THEN
        RETURN EmotionResult(label="uncertain", confidence=confidence)
    END IF
    
    RETURN EmotionResult(label=emotionLabel, confidence=confidence)
END FUNCTION
```

#### Appendix F: Vocabulary Retrieval Pseudocode

```
FUNCTION GetVocabulary(categoryId, language):
    // Attempt local database first
    localData = LocalDB.getSymbols(categoryId)
    
    IF localData.isNotEmpty THEN
        symbols = []
        FOR EACH item IN localData:
            label = item.getLabel(language)
            IF label IS NULL THEN
                label = item.getLabel("en")  // Fallback to English
            END IF
            symbols.ADD(Symbol(
                id=item.id,
                label=label,
                imageUrl=item.imageUrl,
                order=item.order
            ))
        END FOR
        RETURN symbols.sortBy(order)
    END IF
    
    // If local data is empty, attempt cloud sync
    IF NetworkAvailable() THEN
        cloudData = Firestore.getSymbols(categoryId)
        LocalDB.saveSymbols(categoryId, cloudData)
        RETURN GetVocabulary(categoryId, language)  // Recurse with local data
    END IF
    
    RETURN EMPTY_LIST  // No data available
END FUNCTION
```

#### Appendix G: Data Augmentation Pipeline Configuration

The following table documents the augmentation parameters applied to training images:

| Augmentation | Parameter Range | Purpose |
|---|---|---|
| Horizontal flip | 50% probability | Symmetry invariance |
| Rotation | ±15 degrees | Pose variation |
| Brightness adjustment | ±20% | Lighting variation |
| Contrast adjustment | ±20% | Lighting variation |
| Gaussian noise | σ = 0.01 | Sensor noise robustness |
| Random crop | 90–100% of original | Position variation |
| Colour jitter (saturation) | ±15% | Colour variation |
| Perspective transform | ±5% | Head pose variation |
| Gaussian blur | σ = 0–1.0 | Focus variation |

### 18.6 Extended Appendix: Glossary of Terms

| Term | Definition |
|---|---|
| AAC | Augmentative and Alternative Communication: methods and tools used to supplement or replace speech |
| ASD | Autism Spectrum Disorder: a neurodevelopmental condition characterised by differences in social communication and restricted/repetitive behaviours |
| BLoC | Business Logic Component: an architectural pattern for state management in Flutter |
| CNN | Convolutional Neural Network: a class of deep learning model well-suited to image classification |
| CRPD | Convention on the Rights of Persons with Disabilities |
| FER | Facial Expression Recognition: the automated identification of emotional facial expressions |
| Firestore | Cloud Firestore: a NoSQL cloud database service provided by Google Firebase |
| Flutter | An open-source UI toolkit by Google for building cross-platform applications |
| F1 Score | The harmonic mean of precision and recall, used as a single metric for classification quality |
| mHealth | Mobile Health: the use of mobile technology for health service delivery |
| MobileNetV2 | A lightweight CNN architecture optimised for mobile deployment |
| NoSQL | A database paradigm that does not use relational tables; examples include document stores, key-value stores |
| PECS | Picture Exchange Communication System: a structured AAC method using picture symbols |
| Precision | The proportion of positive identifications that are correct |
| Quantization | A technique for reducing model size and inference time by using lower-precision numerical representations |
| Recall | The proportion of actual positives that are correctly identified |
| SDK | Software Development Kit: a collection of tools, libraries, and documentation for building applications |
| SUS | System Usability Scale: a standardised questionnaire for assessing perceived usability |
| TFLite | TensorFlow Lite: a runtime for deploying ML models on mobile and edge devices |
| TTS | Text-to-Speech: technology that converts text input to spoken audio output |
| WCAG | Web Content Accessibility Guidelines: standards for making web content accessible to people with disabilities |

### 18.7 Extended Appendix: List of Figures and Tables

| Figure/Table | Title | Section |
|---|---|---|
| Figure 1 | High-Level System Architecture | Section 6 |
| Figure 2 | Platform A AAC Grid Wireframe | Section 6 |
| Figure 3 | Platform B AAC Grid with Emotion Indicator | Section 6 |
| Figure 4 | Therapist Dashboard Layout | Section 6 |
| Figure 5 | MobileNetV2 Architecture Diagram | Section 8 |
| Figure 6 | Data Augmentation Pipeline | Section 8 |
| Figure 7 | Transfer Learning Process | Section 8 |
| Figure 8 | Gantt Chart (Project Schedule) | Section 15 |
| Figure 9 | Work Breakdown Structure | Section 16 |
| Table 1 | Comparison of Existing AAC Applications | Section 2 |
| Table 2 | FER Dataset Summary | Section 8 |
| Table 3 | Data Augmentation Parameters | Section 8 |
| Table 4 | Functional Requirements (Platform A) | Section 6 |
| Table 5 | Functional Requirements (Platform B) | Section 6 |
| Table 6 | Non-Functional Requirements | Section 6 |
| Table 7 | Use Case: Select Symbol | Section 6 |
| Table 8 | Candidate Architecture Comparison | Section 2/8 |
| Table 9 | Risk Register | Section 13 |
| Table 10 | Pilot Data Collection Instruments | Section 11 |
| Table 11 | Preliminary Model Evaluation Results | Section 10 |
| Table 12 | Comparison of Candidate Architectures for Mobile FER | Section 2 |
| Table 13 | WBS Dictionary | Section 16 |
| Table 14 | Threat Model | Section 6 |
| Table 15 | Data Classification | Section 6 |
| Table 16 | Glossary | Appendix |

### 18.8 Extended Appendix: Consent Form Template

The following is a template for the parental/guardian consent form, to be adapted and translated into Sinhala and Tamil for the pilot study:

---

**INFORMED CONSENT FORM**

**Study Title:** Evaluation of an AI-Enhanced AAC Mobile Application for Children with Autism Spectrum Disorder in Sri Lanka

**Principal Investigator:** [Name], BSc (Hons) Computing Student, ESOFT Metro Campus

**Supervisor:** [Name], Faculty of Computing, ESOFT Metro Campus

**Clinical Collaborator:** [Name], Department of [Paediatrics/Child Psychiatry], Karapitiya Teaching Hospital

**Purpose of the Study:**
This study evaluates a new mobile application designed to support communication in children with autism spectrum disorder (ASD). The application provides a symbol-based communication board with support for Sinhala, Tamil, and English, and optionally includes an AI-based feature that detects the child's facial expression to suggest appropriate communication responses. The purpose of the study is to assess whether the application is feasible, usable, and acceptable for children with ASD and their caregivers.

**What Your Participation Involves:**
If you agree to participate, you will be asked to:
1. Install the mobile application on your smartphone or tablet.
2. Use the application with your child during daily communication activities for a period of [4–8 weeks].
3. Complete a brief questionnaire about your experience at the midpoint and endpoint of the study period.
4. (Optional) Participate in a brief interview about your experience with the application.

**Risks:**
The risks of participation are minimal. The application does not replace any existing communication support or therapy. The AI-based emotion detection feature is optional and can be disabled at any time. No facial images are stored or transmitted; all image processing occurs on your device. You may withdraw from the study at any time without giving a reason, and withdrawal will not affect your child's care or access to services.

**Benefits:**
Potential benefits include access to a free AAC communication tool designed for Sri Lankan languages and cultures. Your feedback will contribute to the improvement of the application and to research on assistive technology for children with ASD in Sri Lanka.

**Confidentiality:**
All data collected during the study (usage logs, questionnaire responses, interview recordings) will be kept confidential and stored securely. Data will be anonymised for analysis and reporting. No identifying information (child's name, photograph, school, address) will be included in any published report.

**Contact Information:**
If you have questions or concerns about the study, please contact [name, phone, email].

**Consent Statement:**
I have read and understood the information above. I have had the opportunity to ask questions. I voluntarily agree to participate in this study with my child.

| Field | Entry |
|---|---|
| Parent/Guardian Name | _______________________________ |
| Child's Name | _______________________________ |
| Signature | _______________________________ |
| Date | _______________________________ |

---

### 18.9 Extended Appendix: Information Sheet Template

---

**PARTICIPANT INFORMATION SHEET**

**Study Title:** Evaluation of an AI-Enhanced AAC Mobile Application for Children with Autism Spectrum Disorder in Sri Lanka

You are invited to participate in a research study conducted as part of a final year undergraduate project at ESOFT Metro Campus. Please read the following information carefully before deciding whether to participate.

**What is AAC?**
Augmentative and Alternative Communication (AAC) refers to methods and tools that help people who have difficulties with spoken language to communicate. AAC can include simple tools (picture boards, communication books) as well as high-tech tools (apps, electronic devices).

**What is this study about?**
We have developed a mobile application (app) that helps children with autism spectrum disorder (ASD) communicate using symbols (pictures) and speech output. The app works in Sinhala, Tamil, and English. It also has an optional feature that uses the device's camera to detect the child's facial expression (e.g., happy, sad, tired) and suggest communication options based on that expression. This feature is called "emotion detection."

**How does the emotion detection work?**
The emotion detection feature uses the device's front camera to take a picture of the child's face. A computer program (artificial intelligence model) on the device analyses the picture to guess the child's emotion. The result is shown to you (the parent/caregiver) as a suggestion—you can accept, change, or dismiss it at any time. **No pictures of your child are stored or sent anywhere.** All processing happens on your device.

**What will you be asked to do?**
Use the app with your child during normal daily activities. Complete two short questionnaires (about 10 minutes each). Optionally, participate in a short interview (about 20 minutes).

**What are the risks?**
The risks are minimal. The app is a communication tool and does not replace any treatment or therapy. You can stop using the app at any time. The emotion detection feature is optional.

**What are the benefits?**
You will have access to a free AAC communication tool. Your feedback will help improve the app for other families.

**Is my information private?**
Yes. All information is kept confidential. We will not use your child's name, photograph, school, or address in any report.

**Can I withdraw?**
Yes, at any time, without giving a reason. Withdrawal will not affect your child's care.

**Who should I contact?**
[Contact information for the project team]

---
