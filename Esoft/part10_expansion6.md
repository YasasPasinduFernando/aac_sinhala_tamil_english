

### 7.7 Extended Discussion: Software Engineering Practices Applied

#### 7.7.1 Code Review and Quality Assurance Practices

In a solo development context, traditional peer code review is not possible. However, the project implements several self-review and quality assurance practices to maintain code quality:

1. **Self-review before merge:** Before merging any feature branch into `main`, the developer reviews all changed files in the pull request, checking for: logical errors, adherence to naming conventions, code duplication, missing error handling, incorrect or missing documentation, and compatibility with existing code.

2. **Static analysis:** The Dart analyzer is configured to enforce strict mode, flagging type errors, unused imports, dead code, and potential null safety issues. All analyzer warnings are resolved before code is committed to `main`.

3. **Linting:** The project uses the `flutter_lints` package (or `very_good_analysis` for stricter rules), which enforces community-recommended code style and best practices. Linting rules cover formatting, naming conventions, immutability preferences, and import ordering.

4. **Automated testing:** Unit tests are written for critical components (data models, utility functions, service layer) and are run before each merge. Integration tests cover key user flows (symbol selection, TTS output, settings changes).

5. **Documentation:** All public classes and functions include dartdoc comments describing their purpose, parameters, and return values. This documentation serves as both self-documentation (for the developer's own reference during the project) and external documentation (for a hypothetical future maintainer or contributor).

#### 7.7.2 Dependency Management

The project follows best practices for dependency management in Flutter:

1. **Minimal dependencies:** Only well-maintained, actively supported packages are included. Dependencies are regularly audited for security vulnerabilities using `pub audit` (or equivalent tools).

2. **Version pinning:** All dependencies are pinned to specific version ranges in `pubspec.yaml`, using the caret syntax (e.g., `^2.0.0`) to allow non-breaking updates while preventing unexpected breaking changes.

3. **Platform compatibility:** All dependencies are verified for compatibility with both Android and iOS platforms before inclusion.

4. **Licence compliance:** All included packages are checked for licence compatibility. Only packages with permissive open-source licences (MIT, BSD, Apache 2.0) are used.

### 9.9 Extended Ethical Considerations: Informed Consent Process

#### 9.9.1 Multi-Stage Consent Process

The consent process for the pilot study is designed to be accessible, informative, and respectful of parents' and children's rights. It consists of multiple stages:

**Stage 1: Initial information.** Potential participants receive an information sheet (in their preferred language: Sinhala, Tamil, or English) describing the study's purpose, procedures, risks, benefits, and data handling practices. This may be provided in person (at the hospital), by telephone, or electronically (email or messaging app).

**Stage 2: Question and answer.** The project team is available to answer any questions from potential participants. This may involve an in-person meeting, a phone call, or a messaging conversation. The principle of "teach-back" is applied: after explaining the study and the consent form, the researcher asks the participant to describe in their own words what they understand the study involves, to verify comprehension.

**Stage 3: Written consent.** If the participant agrees to join the study, they sign the informed consent form. A signed copy is provided to the participant, and the original is retained by the project team.

**Stage 4: Child assent.** Where the child is developmentally capable of understanding and indicating their willingness to participate (as assessed by the parent and/or clinician), their assent is sought. Assent may be expressed verbally, through gesture, or through the use of a simplified visual assent form appropriate to the child's communication level and cognitive ability.

**Stage 5: Ongoing consent.** Consent is not a one-time event. Throughout the study, the project team monitors for any signs that the parent or child wishes to withdraw, and reminds participants at each contact point that they may withdraw at any time without consequence.

### 10.12 Extended Work Completed: UI/UX Design Process

#### 10.12.1 Wireframing and Prototyping

The UI/UX design process followed a systematic approach:

1. **Research:** Existing AAC apps (Proloquo2Go, TouchChat, CoughDrop, JABtalk, LetMeTalk) were reviewed using a structured evaluation framework covering: layout patterns, navigation structure, symbol presentation, customisation options, and accessibility features. Key strengths and weaknesses of each were documented to inform the design of the present system.

2. **Persona development:** Two primary user personas were developed: (a) "Amaya" (the child user) — a 6-year-old non-speaking child with ASD Level 2, living in a semi-urban area with Sinhala-speaking parents; and (b) "Rathnayake" (the parent/caregiver) — Amaya's father, a factory worker with basic smartphone skills, motivated to support his daughter's communication but with no prior AAC experience.

3. **User journey mapping:** Key user journeys were mapped out for both personas: (a) first-time setup (selecting language, choosing grid size, previewing symbols); (b) daily communication session (navigating categories, selecting symbols, hearing TTS output); (c) vocabulary customisation (adding a new symbol with a photograph); and (d) reviewing progress (viewing usage history, emotion charts).

4. **Low-fidelity wireframes:** Initial wireframes were sketched on paper, focusing on layout, information hierarchy, and navigation flow. These were reviewed with the project supervisor and informally with a therapist.

5. **High-fidelity mockups:** Based on feedback from the low-fidelity stage, high-fidelity mockups were created in Figma, including detailed colour palettes, typography, iconography, and interaction states (normal, pressed, disabled). Mockups were created for both Platform A and Platform B, and for both light and dark themes.

6. **Interactive prototype:** A clickable prototype was created in Figma, linking the key screens and demonstrating the navigational flow. This prototype was used for informal usability walkthroughs with the supervisor and one therapist.

#### 10.12.2 Symbol Set Design

The symbol set for the initial version includes approximately 200 core vocabulary items distributed across the following categories:

| Category | Example Items | Count |
|---|---|---|
| Feelings | Happy, Sad, Angry, Tired, Scared, Excited | 15 |
| People | Mother (Ammā), Father (Appā), Teacher, Friend, Doctor | 12 |
| Foods | Rice, Bread, Milk, Water, Biscuit, Fruit, Dhal | 20 |
| Activities | Play, Eat, Drink, Sleep, Read, Draw, Sing, Wash | 18 |
| Places | Home, School, Hospital, Temple, Shop, Park | 10 |
| Objects | Ball, Book, Pencil, Phone, Table, Chair, Bed | 15 |
| Actions/Verbs | Want, Give, Go, Come, Help, Stop, More, Done | 20 |
| Social phrases | Hello, Goodbye, Thank you, Sorry, Yes, No, Please | 15 |
| Descriptors | Big, Small, Hot, Cold, Good, Bad, New, Old | 15 |
| Time/Schedule | Morning, Afternoon, Night, Now, Later, Finished | 10 |
| Body | Head, Hand, Stomach, Teeth, Eyes, Ears | 10 |
| Nature | Sun, Rain, Tree, Flower, Dog, Cat, Bird | 10 |
| Transport | Car, Bus, Three-wheeler, Bicycle | 8 |
| Clothing | Shirt, Trousers, Shoes, Hat, Sarong | 8 |
| Miscellaneous | Bathroom, Medicine, Pain, Noise, Quiet | 14 |

Each symbol has labels in Sinhala, Tamil, and English, with corresponding TTS pronunciations. The symbol set can be expanded by caregivers and therapists through the in-app customisation feature.

### 15.5 Extended Timeline and Milestone Analysis

The following table summarises the key milestones of the project, their planned dates, and their current status:

| Milestone | Planned Date | Status | Notes |
|---|---|---|---|
| M1: Project proposal approved | September 2025 | ✅ Complete | Approved by supervisor |
| M2: Literature review draft | October 2025 | ✅ Complete | Comprehensive review of AAC, ASD, FER, mobile tech |
| M3: Architecture design finalised | November 2025 | ✅ Complete | Dual-platform design documented |
| M4: Platform A core (symbol grid, TTS) | December 2025 | ✅ Complete | Functional AAC grid in three languages |
| M5: Initial CNN model trained | January 2026 | ✅ Complete | Preliminary accuracy: 69.3% |
| M6: Interim report submitted | February 2026 | 🔄 In progress | This document |
| M7: Ethics application submitted | March 2026 | ⏳ Planned | Consent forms and info sheets drafted |
| M8: Platform B integration | March 2026 | ⏳ Planned | TFLite + face detection in Flutter |
| M9: Dashboard development | April 2026 | ⏳ Planned | Web-based therapist/parent portal |
| M10: Purpose-built data collection | April–May 2026 | ⏳ Planned | Dependent on ethics approval |
| M11: Model retraining and optimisation | May 2026 | ⏳ Planned | With project-specific data |
| M12: Pilot study execution | June–July 2026 | ⏳ Planned | 5–15 child–caregiver dyads |
| M13: Final report submitted | August 2026 | ⏳ Planned | Comprehensive dissertation |
| M14: Viva/presentation | September 2026 | ⏳ Planned | Demo and oral defence |

---
