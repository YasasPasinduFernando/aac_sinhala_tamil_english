

## 9. Ethical Considerations

### 9.1 Overview

The project involves vulnerable participants (children with autism spectrum disorder), personal and potentially sensitive data (facial images, usage logs, communication patterns), and deployment in a healthcare-related context. Ethical considerations are therefore central to the project's design, implementation, and evaluation, and are not treated as an afterthought but as a fundamental design constraint that shapes technical and methodological decisions throughout. This section documents the ethical framework adopted, the specific ethical issues identified, and the measures taken to address them.

The ethical framework draws on established principles for research involving human participants, including those articulated in the Declaration of Helsinki (World Medical Association, 2013), the Belmont Report (National Commission for the Protection of Human Subjects of Biomedical and Behavioral Research, 1979), and the British Psychological Society Code of Ethics and Conduct (BPS, 2021). It also draws on emerging guidelines for ethical AI development and deployment, particularly in sensitive domains involving vulnerable populations (Jobin et al., 2019; Floridi et al., 2018).

### 9.2 Informed Consent

Informed consent is the cornerstone of ethical research involving human participants. For this project, consent is required for: (a) participation in any data collection activities (e.g., capture of facial images for dataset creation); (b) use of the AAC application by a child during the pilot study; and (c) use of any data generated during the pilot for research analysis and reporting.

Given that the target participants are children who may lack the capacity to provide informed consent independently, consent is obtained from the parent or legal guardian. In addition, where appropriate and feasible, assent is sought from the child in an accessible form—for example, using visual supports, simplified language, or demonstrations of the application. The child's willingness to engage with the system is monitored throughout, and any signs of distress, discomfort, or unwillingness to participate are treated as withdrawal of assent, even if the parent has provided consent.

Consent forms and information sheets have been drafted in English, with Sinhala and Tamil translations planned before the pilot. The information sheet provides a clear, jargon-free explanation of the project's purpose, what participation involves, the data that will be collected and how it will be used, the security measures in place, the participant's right to withdraw at any time without penalty or effect on their care, and the contact details of the project team and the institutional ethics committee for questions or complaints.

### 9.3 Privacy and Data Protection

Privacy and data protection are of paramount importance, given the sensitivity of the data involved (facial images of children, communication logs, emotion classifications). The project adopts a data minimisation approach: only the data necessary for the system's intended functions is collected and stored. Specific measures include:

- **On-device processing:** Facial expression recognition is performed entirely on the device. Raw facial images are not transmitted to any server or cloud service for inference. This design decision eliminates the most significant privacy risk associated with FER (i.e., the collection and transmission of facial images to third parties).
- **No default image storage:** By default, the system does not store raw facial images. Only the classified emotion label and timestamp are logged. If image storage is required for model improvement or research purposes, it is implemented as an opt-in feature requiring explicit, informed consent and ethics approval.
- **Anonymisation and de-identification:** Any data used for research or analysis is de-identified (names, identifiers, and other personally identifiable information are removed or replaced with random codes). Facial images used for model training are stored with numeric identifiers only and are not linked to participant identities.
- **Access control:** Data stored in Firebase is protected by authentication and security rules that restrict access to authorised users (e.g., the child's linked therapist and parent). Role-based access control ensures that users can only view and modify data they are authorised to access.
- **Encryption:** Data in transit is encrypted using TLS. Firebase provides encryption at rest. Local data may be encrypted using platform-specific mechanisms (e.g., Android Keystore, iOS Keychain).
- **Retention and disposal:** Data retention policies are defined in the ethics protocol. Data collected for the purposes of the project will be retained for a defined period (e.g., the duration of the project plus a specified period for analysis and reporting) and then securely deleted.

### 9.4 Minimisation of Harm

The system is designed to support communication and not to replace human judgment. The emotion recognition module is explicitly positioned as an assistive cue, not a diagnostic tool or a definitive assessment of the child's emotional state. Several measures are taken to minimise the potential for harm:

- **Caregiver override:** The caregiver can disable or override the emotion recognition and adaptation features at any time. The interface makes clear that the system's emotion classification is a suggestion, not a certainty, and that caregiver judgment should always take precedence.
- **Confidence thresholding:** Emotion predictions with low confidence (below a configurable threshold) are not acted upon, reducing the risk of inappropriate vocabulary adaptation based on unreliable predictions.
- **Transparency:** The system displays the inferred emotion to the caregiver, who can verify it against their own observation. The interface does not claim or imply that the system "knows" the child's true emotional state.
- **Voluntary participation:** Participation in data collection and pilot use is entirely voluntary. Participants (or their parents/guardians) can withdraw at any time without penalty or effect on their care or access to services.
- **Monitoring for adverse effects:** During the pilot, the project team monitors for any negative effects of system use (e.g., increased frustration, disengagement) and is prepared to discontinue use or modify the system in response.

### 9.5 Institutional and Regulatory Approval

A pilot at Karapitiya Teaching Hospital requires approval from the hospital's institutional ethics committee (IEC) and, where applicable, alignment with Ministry of Health research governance requirements. The ethics application includes: the research protocol, information sheets and consent forms (in Sinhala, Tamil, and English), data management plan, risk assessment, and the qualifications and responsibilities of the project team. The application is prepared with guidance from the project supervisor and, where available, from the hospital's research coordination unit.

The Ministry of Health approval process in Sri Lanka involves submission of a research proposal that outlines the study's objectives, methods, participant protections, and data management procedures. Compliance with the National Guideline for Ethics Review of Health Research in Sri Lanka (Ministry of Health, Sri Lanka, 2020) is required. The project will not proceed with data collection or pilot deployment until all required approvals are in place.

[Table 9: Ethical Risk Assessment]

| Ethical Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Consent not fully informed | Low | High | Clear, multilingual information sheets; assent from child; ongoing monitoring |
| Privacy breach (facial images) | Low | Very High | On-device processing; no default image storage; encryption; access control |
| Misclassification of emotion | Medium | Medium | Confidence thresholding; caregiver override; transparency |
| Child distress during data collection | Low | High | Trained data collectors; stop criteria; parental presence at all times |
| Delayed ethics approval | Medium | Medium | Early submission; alternative plans for evaluation without pilot if needed |
| Data breach (cloud) | Low | High | Firebase security rules; TLS encryption; regular access review |

### 9.6 Bias and Fairness

Dataset composition and model performance are monitored for potential bias. The project acknowledges that existing FER datasets are predominantly composed of adult, Western faces, and that a model trained on such data may underperform for children, for Sri Lankan faces, and for individuals with ASD who may express emotions differently (Barrett et al., 2019; Trevisan et al., 2018). The following measures are taken:

- **Diverse data collection:** Purpose-collected data (post–ethics approval) will include children of the target age group and cultural background, reflecting the diversity of the pilot population.
- **Per-class and per-demographic analysis:** Where sufficiently large subgroups exist, model performance will be analysed by class, gender, and age group to identify and document potential biases.
- **Transparent reporting:** Limitations of the model, including known biases and failure modes, will be documented in the final report and communicated to stakeholders.
- **Ongoing monitoring:** During the pilot, model performance will be monitored in practice, and any systematic misclassifications will be investigated and addressed (e.g., through additional data collection or model retraining).

### 9.7 Transparency and Explainability

The emotion recognition component is a "black box" in the sense that the internal representations of the CNN are not easily interpretable by end-users. The project does not attempt to provide full explainability of model predictions (which remains an open research problem for deep learning), but it does ensure that:

- The system's emotion classification is presented as a suggestion, not a diagnosis.
- Caregivers are informed (via the information sheet and in-app documentation) that the feature is experimental and that its accuracy is limited.
- The confidence score associated with each prediction is available to the caregiver (optionally displayed in the interface or accessible via a settings menu).
- The caregiver is empowered to disable or override the feature at any time.

This approach is consistent with the recommendations of Fletcher-Watson and Happé (2019) for responsible deployment of AI in sensitive domains involving individuals with autism, and with the broader AI ethics literature on transparency and accountability (Floridi et al., 2018; Jobin et al., 2019).

---

## 10. Work Completed

### 10.1 Summary of Progress

Work completed to date is summarised below and in Table 4. The project is at an intermediate stage: the foundational design, architecture, literature review, and initial implementation are substantially complete, while several key activities (full dataset collection, model training, pilot deployment) remain for the next phase.

### 10.2 Requirements and Design

A comprehensive literature review and background research on ASD, AAC, facial expression recognition, and the Sri Lankan context were completed (Section 2). Functional and non-functional requirements for both platforms were drafted and documented. The dual-platform architecture and overall system design were documented, including architecture diagrams (represented as figure placeholders in this report), data flow diagrams, and technology justifications (Section 6). Stakeholder roles (therapist, parent, child) and use cases were outlined and mapped to requirements.

### 10.3 Development Environment and Core AAC

A Flutter project structure was established for the mobile application, targeting Android and iOS from a single Dart codebase. The project structure follows Flutter best practices, with separate directories for models, services, screens, widgets, and utilities. Core AAC features for Platform A were partially implemented:

- Navigation and screen routing for the AAC interface.
- A basic symbol grid that displays configurable symbols with text labels.
- Placeholder support for multiple languages (Sinhala, Tamil, English), with language switching at the UI level.
- Integration with a local data layer (SQLite or local JSON) for vocabulary and settings.
- Basic text-to-speech integration using the device's built-in TTS engine (tested for English; Sinhala and Tamil TTS testing in progress).

Some delays were encountered in finalising the exact symbol set and licensing arrangements (see Section 12), which have been documented and are being addressed in the next phase.

### 10.4 AI Model Pipeline

A Python-based pipeline for training the emotion recognition model was set up using TensorFlow/Keras. The following activities were completed:

- MobileNetV2 was loaded with ImageNet pre-trained weights, with the top classification layers removed.
- A custom classification head (global average pooling, dense layers with dropout, output layer with six units and softmax activation) was added.
- Data loading and augmentation (rotation, horizontal flip, brightness/contrast adjustment, zoom, translation) were implemented using TensorFlow's data pipeline utilities.
- Initial training experiments were run on a subset of a public dataset (FER2013 and related datasets), achieving preliminary accuracy in the range of 65–72% on the validation set (before fine-tuning and before the full project-specific dataset was assembled).
- Export to TensorFlow Lite format and basic post-training quantization were performed.
- Benchmarking of the TFLite model on a test device (mid-range Android smartphone) confirmed inference times in the range of 100–300 ms per frame, well within the target of 500 ms.

Full model training on the complete project-specific dataset (2,000–5,000 images) is pending completion of the dataset assembly (including purpose-collected data post–ethics approval).

### 10.5 Backend and Dashboard

A Firebase project was created and configured:

- Firebase Authentication (email/password) is operational.
- Cloud Firestore is set up with a preliminary data schema for user profiles, vocabulary customisations, and usage logs.
- Firebase Cloud Storage is configured for backup and media storage.
- Firestore security rules enforcing role-based access control have been drafted.

A minimal therapist–parent dashboard (web-based) was implemented:

- Authentication and login for therapists and parents.
- Display of linked accounts and placeholder progress views.
- Basic vocabulary management (add/remove symbols).

Synchronisation logic between the Flutter app and Firebase was partially implemented. Full offline-first synchronisation with conflict resolution remains for the next phase.

### 10.6 Ethics and Partnership

- Draft consent forms and information sheets were prepared in English.
- Sinhala and Tamil translations are planned for the next phase.
- Initial contact with Karapitiya Teaching Hospital was made to explore partnership and ethics approval.
- The formal ethics application is in advanced preparation and is expected to be submitted in the next reporting period.
- Ministry of Health approval requirements were researched and documented.

### 10.7 Documentation

- This interim report was drafted, including all required sections, figure and table placeholders, and Harvard-style references.
- A preliminary Gantt chart and work breakdown structure were prepared (Sections 15 and 16).
- Internal design documents and meeting notes with the project supervisor were maintained.

### 10.8 Testing and Quality

- Unit tests for critical data layer and utility functions were introduced where applicable.
- Full test coverage was not achieved in this phase due to time prioritisation of feature implementation.
- Manual testing of the basic AAC flow was performed on an Android emulator and a single physical device.
- iOS testing is planned for the next phase.
- No formal user testing with children or caregivers has been conducted yet (scheduled after Platform A completion and ethics approval).

[Table 4: Work Completed Summary]

| Work Package | Status | Notes |
|---|---|---|
| Literature review | Complete | Sections 1–2 of this report |
| Requirements and design | Substantially complete | Documented in Sections 3–6 |
| Flutter project setup | Complete | Single codebase for Android/iOS |
| Platform A (core AAC) | Partially complete | Symbol grid, navigation, basic TTS, basic multilingual placeholders |
| Platform B (AI + FER) | In progress | Pipeline set up; model trained on public data; integration pending |
| Firebase backend | Partially complete | Auth, Firestore, Storage configured; sync logic in progress |
| Therapist–parent dashboard | Partially complete | Minimal version implemented |
| Ethics and partnership | In progress | Draft consent forms; hospital contact made; formal application pending |
| AI model training | In progress | Initial experiments on public data; full training pending dataset completion |
| TFLite export and benchmarking | Complete (preliminary) | Model exported; inference time acceptable |
| Testing | In progress | Unit tests for critical modules; manual testing; no formal user testing yet |
| Documentation | In progress | Interim report complete; design documents maintained |

[Figure 9: Mobile App UI Layout – Level 1–2]

[Figure 10: Mobile App UI Layout – Level 3+]

---

## 11. Further Work

### 11.1 Overview

Remaining work is outlined below and summarised in Table 5. The project plan for the remainder of the academic year is structured around the incremental model described in Section 7, with Increments 3 through 5 covering the completion of both platforms, the AI model, the dashboard, the ethics and pilot process, and the final report.

### 11.2 Platform A Completion

- Finalise the symbol set and resolve any licensing issues.
- Complete the full vocabulary in Sinhala, Tamil, and English, including culturally appropriate symbols and categories.
- Integrate text-to-speech for all three languages and evaluate TTS quality and accuracy.
- Implement full customisation features: configurable grid size, user-added symbols (including photographs), custom categories, colour themes, and font size settings.
- Implement visual scheduling functionality.
- Conduct internal usability testing with at least one therapist and one parent/caregiver.

### 11.3 Platform B and AI Integration

- Complete the curated dataset (2,000–5,000 images) by combining public data with purpose-collected data (post–ethics approval).
- Conduct full model training with hyperparameter tuning (learning rate, batch size, number of fine-tuned layers, dropout rate).
- Achieve and document the target accuracy of ≥80%, with full confusion matrix analysis, per-class precision, recall, F1, and macro-averaged metrics.
- Integrate the TFLite model into the Flutter app with a robust face detection and preprocessing pipeline.
- Implement configurable emotion-adaptive logic and caregiver override mechanisms.
- Test the emotion detection pipeline on a range of devices (Android and iOS, different screen sizes and camera qualities).
- Evaluate and optimise inference latency and battery consumption.

### 11.4 Backend and Synchronisation

- Implement full offline-first synchronisation with conflict resolution.
- Complete backup and restore flows.
- Harden security (role-based access, audit logging, data encryption at rest).
- Load testing for concurrent user capacity.

### 11.5 Dashboard

- Complete the therapist–parent dashboard with progress visualisations (charts, summaries), vocabulary management, and export options.
- Conduct feedback sessions with at least one therapist and one parent to validate usability and functionality.
- Implement responsive design for accessibility on different screen sizes.

### 11.6 Pilot and Evaluation

- Obtain ethics approval from Karapitiya Teaching Hospital's institutional ethics committee.
- Complete Ministry of Health processes as required.
- Recruit pilot participants (target: 5–15 children with ASD and their caregivers/therapists, depending on approval and availability).
- Conduct supervised pilot use over a defined period (e.g., 4–8 weeks).
- Collect quantitative data (usage logs, emotion detection accuracy in situ, task completion rates) and qualitative data (caregiver and therapist feedback, observations).
- Analyse findings and document limitations, lessons learned, and recommendations.

### 11.7 Final Deliverables

- Finalise the dissertation/final report, incorporating pilot findings, full model evaluation, and reflective analysis.
- Prepare user documentation (installation guide, user manual, administrator guide).
- Prepare a deployment package (APK/IPA, model files, backend configuration).
- Submit final report and any required artefacts for FC6P01ES.
- Prepare a presentation or demo for the examining panel.
- Archive all code, models, and documentation for institutional submission.

[Table 5: Remaining Work Plan]

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

## 12. Progress Review

### 12.1 Overall Assessment

Overall progress is on track for the interim submission, with minor delays that are not expected to compromise the final deadline, provided mitigation strategies are followed. The project has achieved substantial progress in the areas of literature review and background research, system architecture and design, initial software development (Flutter app skeleton, Firebase backend), AI model pipeline setup, and ethical preparation.

### 12.2 Areas on Track

- **Literature review and background research:** Substantially complete. The literature review (Section 2) provides comprehensive coverage of ASD, AAC, FER, and the Sri Lankan context, with critical analysis and synthesis.
- **System architecture and design:** Complete for the interim phase. The dual-platform architecture, backend design, emotion detection pipeline, and technology stack are documented in Section 6.
- **Development methodology:** Documented in Section 7. The incremental model has been followed and is on schedule.
- **AI model pipeline:** The training pipeline (data loading, augmentation, MobileNetV2 transfer learning, TFLite export) is operational and has been validated on public data. Preliminary accuracy results are documented.
- **Flutter project and core AAC:** The project structure is in place, and basic AAC functionality (symbol grid, navigation, basic TTS) is partially implemented.
- **Firebase backend:** Configured and integrated at a minimal level (auth, database, storage).
- **Ethical documentation:** Draft consent forms and information sheets prepared; hospital contact established.
- **Interim report:** Complete.

### 12.3 Areas with Minor Delays

- **Symbol set and licensing:** Finalisation of the symbol set took longer than initially planned due to the need to identify culturally appropriate symbols and to verify licensing terms for third-party symbol libraries. This has slightly delayed the full population of vocabulary categories. Mitigation: This task is prioritised for the next increment.
- **Ethics application:** The formal application to Karapitiya Teaching Hospital's ethics committee was delayed by administrative coordination (identifying the appropriate contact, gathering required documentation). The application is now in advanced preparation and is expected to be submitted in the next reporting period. Mitigation: Early submission to minimise delay to data collection and pilot activities.
- **Dataset collection:** Collection of purpose-built data (facial images of children) has not yet started, as ethics approval and hospital partnership are prerequisites. The pipeline has been validated on public data instead. Mitigation: Public data is used for initial model validation and pipeline testing; purpose-built data collection will begin as soon as ethics approval is granted.

### 12.4 Impact Assessment and Mitigation

The identified delays are not expected to compromise the final deadline, for the following reasons:

1. **Decoupled dependencies:** Platform A development and full model training on public data can proceed in parallel with the ethics application process, ensuring that productive work continues during the approval period.
2. **Buffer period:** The project plan includes a buffer period before the final submission date specifically to absorb delays in ethics or pilot recruitment.
3. **Contingency planning:** If the pilot at Karapitiya Teaching Hospital cannot be completed in full within the available timeline, the final report will document the completed system, the AI model performance on public and available data, and a reflective analysis of barriers to pilot execution. This is an acceptable outcome within the scope of a final year project, provided it is clearly stated and discussed.

---

## 13. Risk Analysis

### 13.1 Risk Framework

Risks are identified, assessed, and managed using a standard risk assessment framework. Each risk is characterised by its likelihood (Low, Medium, High), its potential impact (Low, Medium, High, Very High), and one or more mitigation strategies. The risk register is maintained as a living document and is reviewed at each project milestone.

### 13.2 Identified Risks and Mitigations

[Table 6: Risk Assessment Matrix]

| Risk ID | Risk Description | Category | Likelihood | Impact | Mitigation Strategy |
|---|---|---|---|---|---|
| R1 | Emotion model accuracy below 80% target | Technical | Medium | High | Data augmentation; class rebalancing; additional data collection; reduction of classes if necessary; hyperparameter tuning; ensemble approaches |
| R2 | Poor performance on low-end devices | Technical | Medium | Medium | Post-training quantization; optional lower-resolution input; defined minimum device specifications; benchmarking on representative devices |
| R3 | Sync conflicts in offline-first design | Technical | Medium | Medium | Defined conflict resolution policy (last-write-wins for settings, append-only for logs); user-facing merge options; comprehensive testing |
| R4 | Delayed ethics or Ministry of Health approval | Project | High | High | Early submission of application; alternative evaluation plans (lab-based or remote feedback without hospital pilot); contingency documentation |
| R5 | Limited availability of therapists or parents for testing | Project | Medium | Medium | Flexible scheduling; remote participation where possible; asynchronous feedback (questionnaires, recorded demos) |
| R6 | Consent or data breach | Ethical/Legal | Low | Very High | Strict access control; encryption at rest and in transit; on-device processing; adherence to approved protocols; incident response plan |
| R7 | Misuse or misinterpretation of emotion output | Ethical | Medium | High | Clear documentation of limitations; caregiver control and override; confidence thresholding; in-app disclaimers |
| R8 | Insufficient compute for CNN training | Resource | Low | Medium | Use of Google Colab or institutional GPU resources; lightweight architecture (MobileNetV2); efficient data pipeline |
| R9 | Unavailability of key stakeholders | Resource | Medium | Medium | Recruitment of backup contacts; asynchronous feedback mechanisms |
| R10 | Sinhala/Tamil TTS quality insufficient | Technical | Medium | Medium | Evaluation of multiple TTS engines; fallback to recorded audio for critical vocabulary; documentation of limitations |
| R11 | Flutter plugin compatibility issues | Technical | Low | Medium | Use of well-maintained, widely adopted plugins; testing on multiple devices; fallback to platform channels if needed |
| R12 | Scope creep | Project | Medium | Medium | Clearly defined scope and objectives; regular supervisor check-ins; prioritisation framework (MoSCoW) |

### 13.3 Critical Path and Contingency

The critical path of the project runs through: ethics approval → dataset collection → model training → Platform B integration → pilot execution → final report. Any delay in ethics approval directly affects all downstream activities on this path. The primary contingency is to proceed with model training on public data and to complete Platform A and the dashboard independently of this critical path. If the pilot cannot be completed, the final report will document the system, model, and a reflective analysis of barriers, which is acceptable for partial credit and demonstrates research maturity.

---

## 14. Limitations and Scope

### 14.1 Scope

The project scope includes the design, development, and pilot evaluation of the dual-platform AAC system with facial expression recognition in the Sri Lankan context. The scope explicitly excludes:

- A full randomised controlled trial (RCT) or large-scale clinical trial.
- A longitudinal study of communication outcomes.
- Nationwide deployment or commercialisation.
- Support for languages other than Sinhala, Tamil, and English.
- Integration of modalities other than facial expression recognition (e.g., physiological sensors, voice analysis).

The pilot is intended to demonstrate feasibility, gather formative feedback, and inform future research and product development. The project aims to produce a proof-of-concept system and a robust foundation for future work, rather than a fully validated clinical intervention.

### 14.2 Limitations

The following limitations are acknowledged and will be discussed in the final report:

1. **Dataset representativeness:** The emotion recognition model will be trained and evaluated on a dataset that may not fully represent the diversity of Sri Lankan children (e.g., skin tone, expression style, age range). Generalisation to the full target population may be limited, and the model's accuracy for children with ASD may differ from its accuracy for neurotypical children.

2. **Sample size and pilot duration:** The sample size and duration of the pilot study will be constrained by ethics approval timelines, participant availability, and project resources. The statistical power for effectiveness claims will be limited, and the findings should be interpreted as preliminary and formative rather than definitive.

3. **Atypical expressiveness in ASD:** Children with ASD may display atypical facial expressions that differ from those in standard FER datasets. The model's ability to recognise emotions in this population is an open question and a key area for future investigation.

4. **Language support quality:** The quality and availability of text-to-speech engines for Sinhala and Tamil may vary. Some TTS engines may produce less natural or less accurate speech for these languages compared to English, which could affect the user experience.

5. **Single-developer constraints:** The project is conducted by a single developer within the timeframe of a final year project. This limits the breadth of testing, the number of iterations with end-users, and the extent of formal usability evaluation that can be conducted.

6. **Ethical and regulatory dependencies:** The timing and outcome of ethics approval processes are beyond the direct control of the project team and may constrain the scope and timing of data collection and pilot activities.

7. **Device variability:** Performance of the TFLite model and the Flutter application may vary across devices with different processors, camera qualities, and screen sizes. Testing on all possible devices is not feasible; the project focuses on a representative set of mid-range devices.

### 14.3 Future Research Directions

Future work could address many of the limitations identified above:

- **Larger-scale trials:** Multi-site trials with stratified sampling and control groups could provide stronger evidence of the system's effectiveness and could compare AAC with and without emotion recognition.
- **Sri Lanka–specific FER dataset:** Collection of a large, high-quality FER dataset from Sri Lankan children (including children with ASD) could improve model accuracy and reduce bias.
- **Additional modalities:** Integration of physiological sensors (e.g., heart rate, galvanic skin response), voice analysis, or body posture recognition could provide complementary information about the user's emotional state and improve the robustness of emotion inference.
- **Cost-effectiveness studies:** Research on the cost-effectiveness of the system relative to conventional AAC and therapy services could inform policy and procurement decisions in Sri Lanka and similar settings.
- **Implementation science:** Studies on the barriers and facilitators of adoption, use, and sustained engagement with the system in different settings (clinic, home, school) could guide implementation strategies and scaling efforts.
- **Collaborative research:** Partnerships with speech-language therapy and special education programmes, as well as with international AAC and assistive technology research groups, could strengthen the evidence base and support technology transfer.

---

## 15. Gantt Chart Explanation

The project schedule is represented in a Gantt chart (Figure 8). The horizontal axis represents time (months from project start, covering the full academic year), and the vertical axis lists major tasks or work packages, aligned with the work breakdown structure (Section 16) and the incremental plan (Section 7).

### 15.1 Phases and Milestones

The Gantt chart is divided into five phases, corresponding to the five increments:

**Phase 1 (Months 1–2):** Requirements, Architecture, and Literature Review.
- Tasks: Literature review; requirements elicitation; system architecture design; project setup.
- Milestone: Architecture design complete.

**Phase 2 (Months 3–4):** Platform A and Backend Development.
- Tasks: Platform A AAC features; multilingual vocabulary; TTS integration; Firebase setup; basic dashboard.
- Milestone: Platform A basic version demo.

**Phase 3 (Months 5–6):** AI Model and Platform B Integration.
- Tasks: Dataset assembly; model training and evaluation; TFLite export; Platform B FER pipeline; emotion-adaptive vocabulary.
- Milestone: Model accuracy target achieved; Platform B demo.

**Phase 4 (Months 7–8):** Dashboard Completion, Ethics, and Pilot Preparation.
- Tasks: Dashboard completion; ethics application and approval; pilot design; consent form translation; participant recruitment.
- Milestone: Ethics approved; pilot ready.

**Phase 5 (Months 9–10):** Pilot Execution and Final Report.
- Tasks: Pilot deployment; data collection; analysis; final report writing; presentation preparation.
- Milestone: Pilot complete; final report submitted.

### 15.2 Dependencies and Critical Path

Dependencies between tasks are indicated in the Gantt chart by arrows or sequencing. The critical path runs through: ethics application → approval → dataset collection → model training → Platform B integration → pilot execution → final report. Tasks on the critical path have no slack; any delay directly affects subsequent tasks and the final submission date.

Non-critical tasks include some documentation activities, optional dashboard refinements, and dissemination planning, which can be rescheduled within their latest finish times if necessary to absorb delays elsewhere.

### 15.3 Current Status

As of the interim submission, Phase 1 is complete, Phase 2 is substantially complete (with minor delays in symbol licensing), and early elements of Phase 3 (AI pipeline setup) and Phase 4 (ethics preparation) have begun. The Gantt chart is updated as the project progresses.

[Figure 8: Gantt Chart]

---

## 16. Work Breakdown Structure

### 16.1 Overview

The work breakdown structure (WBS) decomposes the project into manageable work packages, arranged hierarchically. Level 1 is the project as a whole; Level 2 comprises the major deliverables or work streams; Level 3 and below break each deliverable into specific tasks. The WBS is used for scheduling (Gantt chart), assignment of responsibilities, progress tracking, and scope management.

### 16.2 WBS Hierarchy

**Level 1: AI-Powered AAC System with FER for Children with Autism in Sri Lanka**

**Level 2: Requirements and Design**
- Level 3: Literature review and synthesis
- Level 3: Stakeholder needs analysis
- Level 3: Functional and non-functional requirements
- Level 3: System architecture design
- Level 3: Technology stack evaluation and selection

**Level 2: Platform A Development**
- Level 3: Flutter project setup and structure
- Level 3: Symbol grid interface implementation
- Level 3: Trilingual vocabulary and label support
- Level 3: Text-to-speech integration (Sinhala, Tamil, English)
- Level 3: Customisation features (grid size, symbols, themes)
- Level 3: Visual scheduling
- Level 3: Usage logging and local storage
- Level 3: Internal usability testing

**Level 2: AI Model**
- Level 3: Data sourcing (public datasets)
- Level 3: Purpose-built data collection (post–ethics approval)
- Level 3: Data preprocessing and augmentation pipeline
- Level 3: MobileNetV2 transfer learning setup
- Level 3: Model training and validation
- Level 3: Model evaluation (accuracy, precision, recall, F1, confusion matrix)
- Level 3: Post-training quantization (TFLite export)
- Level 3: On-device benchmarking (latency, model size)

**Level 2: Platform B Integration**
- Level 3: Face detection pipeline
- Level 3: TFLite inference integration in Flutter
- Level 3: Emotion-adaptive vocabulary logic
- Level 3: Caregiver override and transparency features
- Level 3: End-to-end testing (camera → inference → adaptation)

**Level 2: Backend and Dashboard**
- Level 3: Firebase configuration (Auth, Firestore, Storage)
- Level 3: Data schema design
- Level 3: Security rules and access control
- Level 3: Offline-first sync with conflict resolution
- Level 3: Therapist–parent dashboard (web)
- Level 3: Progress visualisation and reporting
- Level 3: Backup and restore flows

**Level 2: Ethics and Pilot**
- Level 3: Draft consent forms and information sheets
- Level 3: Sinhala and Tamil translations
- Level 3: Institutional ethics application
- Level 3: Ministry of Health liaison
- Level 3: Participant recruitment
- Level 3: Pilot protocol design
- Level 3: Pilot execution and supervision
- Level 3: Data collection and analysis

**Level 2: Documentation**
- Level 3: Interim report
- Level 3: Final report and dissertation
- Level 3: User documentation
- Level 3: Presentation/demo preparation
- Level 3: Code and model archival

[Figure 7: Work Breakdown Structure]

---

## 17. Conclusion

This interim report has presented the design, methodology, and current progress of an AI-powered augmentative and alternative communication system with facial expression recognition for children with autism spectrum disorder in Sri Lanka. The project addresses a clear and pressing gap in the availability of culturally and linguistically appropriate AAC tools that integrate affective computing for adaptive communication support, and that are feasible for deployment in Sri Lankan healthcare and family settings.

The dual-platform architecture—Platform A for children at ASD severity levels 1–2, with customisable, symbol-based AAC in Sinhala, Tamil, and English, and Platform B for children at level 3 and above, with on-device facial expression recognition powered by MobileNetV2 and TensorFlow Lite—provides a scalable, severity-appropriate, and inclusive design. The use of Flutter for cross-platform mobile development, Firebase for secure backend services and cloud synchronisation, and an offline-first architecture ensures that the system is deployable on affordable mobile devices in settings with variable connectivity, which is essential for equitable access in Sri Lanka.

The AI component is grounded in established convolutional neural network theory, including convolution, softmax, cross-entropy loss, transfer learning, data augmentation, and model quantization. The model is designed to classify six emotion classes—happy, sad, angry, fear, neutral, and tired—and is evaluated using precision, recall, F1 score, confusion matrix analysis, and overall accuracy, with a target of at least 80 per cent on a curated dataset of 2,000–5,000 images. The integration of FER into the AAC system is positioned as an assistive cue to support caregivers, with configurable adaptation, confidence thresholding, and caregiver override to minimise the risk of harm from misclassification.

Work completed to date includes a comprehensive literature review, requirements and architecture design, initial Flutter application development, AI model pipeline setup and preliminary training on public data, Firebase backend configuration, a minimal therapist–parent dashboard, and ethical documentation and hospital partnership outreach. Minor delays in symbol licensing and ethics application submission have been identified and mitigated. The project plan for the remainder of the academic year is structured around three further increments, covering full platform development, model training and evaluation, dashboard completion, ethics approval, pilot execution, and final reporting.

Risks have been systematically identified and documented, with mitigation strategies defined for technical, project, ethical, and resource risks. Limitations and scope are stated clearly, including the constraints of a single-developer academic project, the representativeness of the dataset, the pilot sample size, and the ethical and regulatory dependencies. Future research directions—including larger-scale trials, a Sri Lanka–specific FER dataset, additional modalities, and implementation science studies—are identified to guide future work beyond the scope of this project.

The project remains on track for its interim deliverables and is positioned to contribute a proof-of-concept system, a foundation for future research and deployment, and new knowledge about the feasibility, challenges, and ethical implications of AI-enhanced, multilingual AAC for children with autism in a low- and middle-income country. Success will be measured not only by technical deliverables but also by the extent to which the design and documentation enable future researchers and practitioners to build upon this work, and by the ethical and methodological rigour demonstrated throughout.

The interim report fulfils the FC6P01ES requirement for a structured, detailed account of background, design, methodology, progress, risks, and plans, and provides a clear roadmap for the completion of the project within the remaining academic year. The project aspires to demonstrate that rigorous, evidence-informed, and ethically responsible development of AI-powered assistive technology is achievable within the context of a final year project, and that such work can make a meaningful contribution to the lives of children with autism and their families in Sri Lanka and beyond.

---

## 18. References

Abadi, M., Barham, P., Chen, J., Chen, Z., Davis, A., Dean, J., Devin, M., Ghemawat, S., Irving, G., Isard, M., Kudlur, M., Levenberg, J., Mane, R., Monga, R., Moore, S., Murray, D.G., Steiner, B., Tucker, P., Vasudevan, V., Warden, P., Wicke, M., Yu, Y. and Zheng, X. (2016) 'TensorFlow: a system for large-scale machine learning', in *Proceedings of the 12th USENIX Symposium on Operating Systems Design and Implementation (OSDI '16)*. Berkeley, CA: USENIX Association, pp. 265–283.

Alant, E. and Bornman, J. (2021) *Augmentative and alternative communication: engagement and participation*. San Diego, CA: Plural Publishing.

American Psychiatric Association (2013) *Diagnostic and statistical manual of mental disorders*. 5th edn. Washington, DC: American Psychiatric Publishing.

American Speech-Language-Hearing Association (2022) *Augmentative and alternative communication (AAC)*. Available at: https://www.asha.org/public/speech/disorders/aac/ (Accessed: 22 February 2025).

Barrett, L.F., Adolphs, R., Marsella, S., Martinez, A.M. and Pollak, S.D. (2019) 'Emotional expressions reconsidered: challenges to inferring emotion from human facial movements', *Psychological Science in the Public Interest*, 20(1), pp. 1–68.

Beukelman, D.R. and Light, J.C. (2020) *Augmentative and alternative communication: supporting children and adults with complex communication needs*. 5th edn. Baltimore, MD: Paul H. Brookes.

Boehm, B.W. (1988) 'A spiral model of software development and enhancement', *Computer*, 21(5), pp. 61–72.

British Psychological Society (2021) *Code of ethics and conduct*. Leicester: BPS.

Calvo, R.A. and D'Mello, S. (2010) 'Affect detection: an interdisciplinary review of models, methods, and their applications', *IEEE Transactions on Affective Computing*, 1(1), pp. 18–37.

Darwin, C. (1872) *The expression of the emotions in man and animals*. London: John Murray.

Dawe, M. (2006) 'Desperately seeking simplicity: how young adults with cognitive disabilities and their families adopt assistive technologies', in *Proceedings of the SIGCHI Conference on Human Factors in Computing Systems*. New York: ACM, pp. 1143–1152.

Department of Census and Statistics, Sri Lanka (2012) *Census of population and housing – 2012*. Colombo: Department of Census and Statistics.

Divan, G., Vajaratkar, V., Desai, M.U., Strik-Lievers, L. and Patel, V. (2021) 'Prevalence and risk factors for autism spectrum disorder in low- and middle-income countries: a systematic review and meta-analysis', *Global Mental Health*, 8, e30.

Ekman, P. (1992) 'An argument for basic emotions', *Cognition and Emotion*, 6(3–4), pp. 169–200.

Ekman, P. and Friesen, W.V. (1971) 'Constants across cultures in the face and emotion', *Journal of Personality and Social Psychology*, 17(2), pp. 124–129.

Elsabbagh, M., Divan, G., Koh, Y.J., Kim, Y.S., Kauchali, S., Marcín, C., Montiel-Nava, C., Patel, V., Paula, C.S., Wang, C., Yasamy, M.T. and Fombonne, E. (2012) 'Global prevalence of autism and other pervasive developmental disorders', *Autism Research*, 5(3), pp. 160–179.

Firebase (2023) *Firebase documentation*. Available at: https://firebase.google.com/docs (Accessed: 15 January 2025).

Fletcher-Watson, S. and Happé, F. (2019) *Autism: a new introduction to psychological theory and current debate*. 2nd edn. Abingdon: Routledge.

Floridi, L., Cowls, J., Beltrametti, M., Chatila, R., Chazerand, P., Dignum, V., Luetge, C., Madelin, R., Pagallo, U., Rossi, F., Schafer, B., Valcke, P. and Vayena, E. (2018) 'AI4People—an ethical framework for a good AI society: opportunities, risks, principles, and recommendations', *Minds and Machines*, 28(4), pp. 689–707.

Flutter (2023) *Flutter documentation*. Available at: https://flutter.dev/docs (Accessed: 15 January 2025).

Ganz, J.B. (2015) *AAC for individuals with autism spectrum disorders*. New York: Springer.

Ganz, J.B., Davis, J.L., Lund, E.M., Goodwyn, F.D. and Simpson, R.L. (2012) 'A meta-analysis of single case research studies on aided augmentative and alternative communication systems with individuals with autism spectrum disorders', *Journal of Autism and Developmental Disorders*, 42(1), pp. 60–74.

Goodfellow, I., Bengio, Y. and Courville, A. (2015) *Deep learning*. Cambridge, MA: MIT Press.

Grogan-Johnson, S., Alvares, R., Rowan, L. and Creaghead, N. (2013) 'A pilot study comparing the effectiveness of speech language therapy provided by telemedicine with conventional on-site therapy', *Journal of Telemedicine and Telecare*, 19(5), pp. 304–310.

Grossard, C., Dapogny, A., Cohen, D., Bernheim, S., Martinerie, J., Janvier, M., Grynszpan, O., Chaby, L., Bailly, K. and Dubuisson, S. (2020) 'Children with autism spectrum disorder produce more ambiguous and less socially meaningful facial expressions: an experimental study using random forest classifiers', *Molecular Autism*, 11(1), p. 5.

Howard, A.G., Zhu, M., Chen, B., Kalenichenko, D., Wang, W., Weyand, T., Andreetto, M. and Adam, H. (2017) 'MobileNets: efficient convolutional neural networks for mobile vision applications', *arXiv preprint arXiv:1704.04861*.

Howard, A., Sandler, M., Chen, B., Wang, W., Chen, L.C., Tan, M., Chu, G., Vasudevan, V., Zhu, Y., Pang, R., Adam, H. and Le, Q. (2019) 'Searching for MobileNetV3', in *Proceedings of the IEEE/CVF International Conference on Computer Vision*. Piscataway, NJ: IEEE, pp. 1314–1324.

International Telecommunication Union (2022) *Measuring digital development: facts and figures 2022*. Geneva: ITU.

Ioffe, S. and Szegedy, C. (2015) 'Batch normalization: accelerating deep network training by reducing internal covariate shift', in *Proceedings of the 32nd International Conference on Machine Learning*. Lille, France: JMLR, pp. 448–456.

Jacob, B., Kligys, S., Chen, B., Zhu, M., Tang, M., Howard, A., Adam, H. and Kalenichenko, D. (2018) 'Quantization and training of neural networks for efficient integer-arithmetic-only inference', in *Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition*. Piscataway, NJ: IEEE, pp. 2704–2713.

Jobin, A., Ienca, M. and Vayena, E. (2019) 'The global landscape of AI ethics guidelines', *Nature Machine Intelligence*, 1(9), pp. 389–399.

Kingma, D.P. and Ba, J. (2015) 'Adam: a method for stochastic optimization', in *Proceedings of the 3rd International Conference on Learning Representations (ICLR)*. San Diego, CA: ICLR.

Lai, M.C., Lombardo, M.V. and Baron-Cohen, S. (2014) 'Autism', *The Lancet*, 383(9920), pp. 896–910.

LeCun, Y., Bengio, Y. and Hinton, G. (2015) 'Deep learning', *Nature*, 521(7553), pp. 436–444.

Li, S. and Deng, W. (2020) 'Deep facial expression recognition: a survey', *IEEE Transactions on Affective Computing*, 13(3), pp. 1195–1215.

Light, J.C. and McNaughton, D. (2012) 'The changing face of augmentative and alternative communication: past, present, and future challenges', *Augmentative and Alternative Communication*, 28(4), pp. 197–204.

Light, J.C. and McNaughton, D. (2015) 'Designing AAC research and intervention to improve outcomes for individuals with complex communication needs', *Augmentative and Alternative Communication*, 31(2), pp. 85–96.

Lord, C., Brugha, T.S., Charman, T., Cusack, J., Dumas, G., Frazier, T., Jones, E.J.H., Jones, R.M., Pickles, A., State, M.W., Taylor, J.L. and Veenstra-VanderWeele, J. (2020) 'Autism spectrum disorder', *Nature Reviews Disease Primers*, 6(1), p. 5.

Lorah, E.R., Parnell, A., Whitby, P.S. and Hantula, D. (2015) 'A systematic review of tablet computers and portable media players as speech generating devices for individuals with autism spectrum disorder', *Journal of Autism and Developmental Disorders*, 45(12), pp. 3792–3804.

Maenner, M.J., Warren, Z., Williams, A.R., Amoakohene, E., Bakian, A.V., Bilder, D.A., Durkin, M.S., Fitzgerald, R.T., Furnier, S.M., Hughes, M.M., Ladd-Acosta, C.M., McArthur, D., Pas, E.T., Salinas, A., Vehorn, A., Williams, S., Esler, A., Grzybowski, A., Hall-Lande, J., Nguyen, R.H.N., Pierce, K., Zahorodny, W. and Shaw, K.A. (2023) 'Prevalence and characteristics of autism spectrum disorder among children aged 8 years — Autism and Developmental Disabilities Monitoring Network, 11 sites, United States, 2020', *MMWR Surveillance Summaries*, 72(2), pp. 1–14.

Mazefsky, C.A., Herrington, J., Siegel, M., Scarpa, A., Maddox, B.B., Scahill, L. and White, S.W. (2013) 'The role of emotion regulation in autism spectrum disorder', *Journal of the American Academy of Child and Adolescent Psychiatry*, 52(7), pp. 679–688.

McNaughton, D. and Light, J. (2013) 'The iPad and mobile technology revolution: benefits and challenges for individuals who require augmentative and alternative communication', *Augmentative and Alternative Communication*, 29(2), pp. 107–116.

Mesibov, G.B., Shea, V. and Schopler, E. (2005) *The TEACCH approach to autism spectrum disorders*. New York: Kluwer Academic/Plenum Publishers.

Millar, D.C., Light, J.C. and Schlosser, R.W. (2006) 'The impact of augmentative and alternative communication intervention on the speech production of individuals with developmental disabilities: a research review', *Journal of Speech, Language, and Hearing Research*, 49(2), pp. 248–264.

Ministry of Health, Sri Lanka (2020) *National guideline for ethics review of health research in Sri Lanka*. Colombo: Ministry of Health.

Nair, V. and Hinton, G.E. (2010) 'Rectified linear units improve restricted Boltzmann machines', in *Proceedings of the 27th International Conference on Machine Learning*. Madison, WI: Omnipress, pp. 807–814.

National Commission for the Protection of Human Subjects of Biomedical and Behavioral Research (1979) *The Belmont Report: ethical principles and guidelines for the protection of human subjects of research*. Washington, DC: DHEW.

Perera, H., Wijewardena, K., Aluthwelage, R., Seneviratne, S. and Buddhika, K. (2019) 'Prevalence of autism spectrum disorder in Sri Lanka: a population-based study', *Sri Lanka Journal of Child Health*, 48(2), pp. 133–138.

Picard, R.W. (2000) *Affective computing*. Cambridge, MA: MIT Press.

Romski, M. and Sevcik, R.A. (2005) 'Augmentative communication and early intervention: myths and realities', *Infants and Young Children*, 18(3), pp. 174–185.

Samad, A., Razick, S., De Silva, M.V.C. and Hettiarachchi, S. (2020) 'Challenges and opportunities for autism services in Sri Lanka', *Journal of Autism and Developmental Disorders*, 50(8), pp. 3023–3029.

Sandler, M., Howard, A., Zhu, M., Zhmoginov, A. and Chen, L.C. (2018) 'MobileNetV2: inverted residuals and linear bottlenecks', in *Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition*. Piscataway, NJ: IEEE, pp. 4510–4520.

Shorten, C. and Khoshgoftaar, T.M. (2019) 'A survey on image data augmentation for deep learning', *Journal of Big Data*, 6(1), p. 60.

Sommerville, I. (2016) *Software engineering*. 10th edn. Harlow: Pearson Education.

Srivastava, N., Hinton, G., Krizhevsky, A., Sutskever, I. and Salakhutdinov, R. (2014) 'Dropout: a simple way to prevent neural networks from overfitting', *Journal of Machine Learning Research*, 15(1), pp. 1929–1958.

TensorFlow (2023) *TensorFlow Lite documentation*. Available at: https://www.tensorflow.org/lite (Accessed: 15 January 2025).

Trevisan, D.A., Hoskyn, M. and Birmingham, E. (2018) 'Facial expression production in autism: a meta-analysis', *Autism Research*, 11(12), pp. 1586–1601.

Wickramasinghe, N., Dissanayake, A. and Samarasinghe, D. (2021) 'Parent training and support programmes for autism in low-resource settings: a scoping review', *Global Health Action*, 14(1), 1910556.

World Health Organization (2021) *Autism spectrum disorders*. Available at: https://www.who.int/news-room/fact-sheets/detail/autism-spectrum-disorders (Accessed: 22 February 2025).

World Medical Association (2013) 'World Medical Association Declaration of Helsinki: ethical principles for medical research involving human subjects', *JAMA*, 310(20), pp. 2191–2194.

Yosinski, J., Clune, J., Bengio, Y. and Lipson, H. (2014) 'How transferable are features in deep neural networks?', in *Advances in Neural Information Processing Systems*, 27. Red Hook, NY: Curran Associates, pp. 3320–3328.

---

## 19. Bibliography

The following sources were consulted during the preparation of this report and have informed the background, methodology, or discussion. They are listed in addition to the references cited in the main text.

Bishop, C.M. (2006) *Pattern recognition and machine learning*. New York: Springer.

Bölte, S., Girdler, S. and Marschik, P.B. (2019) 'The contribution of environmental exposure to the etiology of autism spectrum disorder', *Cellular and Molecular Life Sciences*, 76(7), pp. 1275–1297.

Chollet, F. (2017) *Deep learning with Python*. Shelter Island, NY: Manning Publications.

Deng, J., Dong, W., Socher, R., Li, L.J., Li, K. and Fei-Fei, L. (2009) 'ImageNet: a large-scale hierarchical image database', in *Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition*. Piscataway, NJ: IEEE, pp. 248–255.

Ekman, P. and Friesen, W.V. (1978) *Facial Action Coding System: a technique for the measurement of facial movement*. Palo Alto, CA: Consulting Psychologists Press.

Goldsmith, T.R. and LeBlanc, L.A. (2004) 'Use of technology in interventions for children with autism', *Journal of Early and Intensive Behavior Intervention*, 1(2), pp. 166–178.

He, K., Zhang, X., Ren, S. and Sun, J. (2016) 'Deep residual learning for image recognition', in *Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition*. Piscataway, NJ: IEEE, pp. 770–778.

Kaggle (2013) *FER-2013: Facial Expression Recognition 2013 Dataset*. Available at: https://www.kaggle.com/datasets/msambare/fer2013 (Accessed: 15 January 2025).

Kingma, D.P. and Ba, J. (2015) 'Adam: a method for stochastic optimization', in *International Conference on Learning Representations (ICLR)*. San Diego, CA: ICLR.

Lundqvist, D., Flykt, A. and Öhman, A. (1998) *The Karolinska Directed Emotional Faces (KDEF)*. CD-ROM from Department of Clinical Neuroscience, Psychology Section, Karolinska Institutet, ISBN 91-630-7164-9.

Mollahosseini, A., Hasani, B. and Mahoor, M.H. (2019) 'AffectNet: a database for facial expression, valence, and arousal computing in the wild', *IEEE Transactions on Affective Computing*, 10(1), pp. 18–31.

Nielsen, M.A. (2015) *Neural networks and deep learning*. Available at: http://neuralnetworksanddeeplearning.com/ (Accessed: 15 January 2025).

Picard, R.W. (2000) *Affective computing*. Cambridge, MA: MIT Press.

Pressman, R.S. and Maxim, B.R. (2019) *Software engineering: a practitioner's approach*. 9th edn. New York: McGraw-Hill Education.

Simonyan, K. and Zisserman, A. (2015) 'Very deep convolutional networks for large-scale image recognition', in *Proceedings of the 3rd International Conference on Learning Representations (ICLR)*. San Diego, CA: ICLR.

Sutton, R.S. and Barto, A.G. (2018) *Reinforcement learning: an introduction*. 2nd edn. Cambridge, MA: MIT Press.

Szegedy, C., Vanhoucke, V., Ioffe, S., Shlens, J. and Wojna, Z. (2016) 'Rethinking the inception architecture for computer vision', in *Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition*. Piscataway, NJ: IEEE, pp. 2818–2826.

World Health Organization (2001) *International classification of functioning, disability and health (ICF)*. Geneva: WHO.

Zeiler, M.D. and Fergus, R. (2014) 'Visualizing and understanding convolutional networks', in *Proceedings of the 13th European Conference on Computer Vision (ECCV)*. Zurich: Springer, pp. 818–833.

---

*End of Interim Report*
