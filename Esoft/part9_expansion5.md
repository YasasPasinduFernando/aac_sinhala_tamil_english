

### 2.11 Extended Review: Autism Interventions and Evidence-Based Practice

#### 2.11.1 Overview of Evidence-Based Interventions for ASD

The landscape of interventions for autism spectrum disorder is broad and diverse, encompassing behavioural, developmental, educational, pharmacological, and technology-assisted approaches. Evidence-based practice (EBP) in autism requires the integration of the best available research evidence with clinical expertise and the values and preferences of the individual and their family (Sackett et al., 1996). Several comprehensive reviews and practice guidelines have been published to help practitioners and families navigate the evidence base:

The National Autism Center's National Standards Project, Phase 2 (National Autism Center, 2015) reviewed the evidence for a wide range of interventions and classified them as "established" (sufficient evidence of effectiveness), "emerging" (some evidence but insufficient for definitive conclusions), or "unestablished" (no evidence or insufficient evidence). Among the interventions classified as "established" are Applied Behaviour Analysis (ABA), pivotal response training, social stories, and cognitive behavioural intervention. AAC interventions were classified as "emerging" at that time, reflecting the relative newness of the high-tech AAC evidence base for autism specifically, though the evidence has continued to grow since the review was published.

The National Professional Development Center on Autism Spectrum Disorder (NPDC on ASD; Wong et al., 2015) identified 27 focused intervention practices that met criteria for being evidence-based, including visual supports, prompting, reinforcement, social skills training, and technology-aided instruction and intervention (TAII). TAII includes the use of technology (computers, tablets, apps) to support learning and communication, and is directly relevant to the present project's use of a mobile AAC application with AI-enhanced features.

#### 2.11.2 The Role of Visual Supports

Visual supports—the use of visual cues (pictures, symbols, written words, schedules, timers, maps) to support communication, understanding, and independence—are among the most widely used and well-supported interventions for individuals with ASD (Hume et al., 2014). Visual supports leverage the relative visual processing strength observed in many individuals with ASD and compensate for difficulties with auditory processing, verbal comprehension, and executive function.

Common forms of visual support include:

1. **Visual schedules:** Sequences of pictures or symbols representing activities or tasks in order, helping the individual understand and predict the structure of their day.
2. **Choice boards:** Displays of available options, allowing the individual to make choices by pointing to or selecting a symbol.
3. **First-then boards:** Simple two-step displays showing the current and next activity, used to support transitions.
4. **Social stories and visual scripts:** Visually supported narratives describing social situations and expected behaviours, developed by Carol Gray (Gray and Garand, 1993).

The present project incorporates visual supports at multiple levels: the AAC symbol grid is itself a form of visual communication support; the visual schedule feature provides structured daily routines; and the emotion indicator (Platform B) provides a visual cue about the child's emotional state. This integrated approach to visual support is consistent with the research evidence and with clinical best practices for supporting children with ASD.

#### 2.11.3 Parent-Mediated Interventions

Parent-mediated (or parent-implemented) interventions—programmes in which parents are trained to deliver therapeutic strategies during everyday activities and routines—have a growing evidence base for children with ASD (Oono et al., 2013; Nevill et al., 2018). These interventions address several limitations of clinic-based therapy: they increase the intensity and frequency of intervention (since parents can implement strategies throughout the day), they promote generalisation of skills to natural settings, and they empower parents as active agents in their child's development.

The present project supports parent-mediated intervention through several mechanisms: (a) the AAC app is designed for use by parents in the home, not only by therapists in the clinic; (b) the therapist–parent dashboard enables therapists to guide and support parents remotely; (c) usage logs provide objective data on the child's AAC use, which can inform therapist guidance; and (d) the visual schedule feature supports parents in implementing structured routines, which is a key component of many parent-mediated programmes.

### 6.10 Extended Architecture: Accessibility and Universal Design

#### 6.10.1 Universal Design Principles

Universal design—the design of products and environments to be usable by all people, to the greatest extent possible, without the need for adaptation or specialised design (Mace et al., 1997)—is a guiding philosophy for the present project. While the primary target population is children with ASD and their caregivers, the system is designed to be usable by a broader range of individuals with communication difficulties, including those with intellectual disability, cerebral palsy, acquired brain injury, or other conditions that impair speech.

The seven principles of universal design (equitable use, flexibility in use, simple and intuitive, perceptible information, tolerance for error, low physical effort, and size and space for approach and use) are applied to the system's design as follows:

1. **Equitable use:** The system is available on widely used devices (Android/iOS smartphones and tablets) and does not require specialised hardware.
2. **Flexibility in use:** The interface is configurable (grid size, symbol size, language, colour theme), accommodating a range of user abilities and preferences.
3. **Simple and intuitive:** The navigation structure is shallow (maximum two levels), icons are clearly labelled, and the interaction paradigm (tap to select, tap to speak) is straightforward.
4. **Perceptible information:** Visual, auditory, and (optionally) haptic feedback are provided for user actions, ensuring that information is available through multiple channels.
5. **Tolerance for error:** Destructive actions (e.g., deleting a symbol) require confirmation; the undo/back function is easily accessible.
6. **Low physical effort:** The interface requires only simple tap gestures and is compatible with single-finger or switch-based input.
7. **Size and space for approach and use:** Touch targets are sized according to platform accessibility guidelines (minimum 48×48 dp on Android, 44×44 pt on iOS), with configurable spacing.

#### 6.10.2 Switch Access and External Input

For children with motor impairments who cannot use a touchscreen directly, the system is designed to be compatible with external switch access devices. On Android, this is supported through the Switch Access accessibility service, which allows the user to navigate the interface using one or more external switches. The application's layout and focus order are designed to work with scanning patterns (automatic scanning of items in sequence, with the user pressing a switch to select the highlighted item). On iOS, similar functionality is provided through the Switch Control accessibility feature.

While full switch access testing and optimisation are planned for the next development phase, the foundational layout and focus management have been implemented with switch access compatibility in mind from the beginning of the project.

### 8.14 Extended Training Pipeline: Implementation Details

#### 8.14.1 Google Colab Environment Setup

The model training pipeline is implemented in Google Colab, leveraging the free GPU tier (NVIDIA T4 GPU with 15 GB VRAM) for model training. The Colab notebook is structured as follows:

1. **Environment configuration:** Installation of required packages (TensorFlow 2.x, OpenCV, scikit-learn, matplotlib), mounting of Google Drive for dataset and model storage.
2. **Dataset loading:** Loading of the curated dataset from Google Drive, splitting into training, validation, and test sets.
3. **Preprocessing pipeline:** Application of image preprocessing (resizing, normalisation) and data augmentation (as documented in Section 8.4).
4. **Model definition:** Loading of pre-trained MobileNetV2 (ImageNet weights), freezing of base layers, and addition of the custom classification head.
5. **Phase 1 training (classification head):** Training of the classification head only, with the base model frozen.
6. **Phase 2 training (fine-tuning):** Unfreezing of selected base model layers and fine-tuning with a reduced learning rate.
7. **Evaluation:** Generation of confusion matrix, per-class metrics, and summary statistics on the held-out test set.
8. **Export:** Conversion of the trained Keras model to TFLite format, with optional quantization.
9. **Benchmarking:** (Conducted on-device) Measurement of inference latency and resource consumption.

#### 8.14.2 Data Pipeline Implementation

The data pipeline uses TensorFlow's `tf.data.Dataset` API for efficient, parallelised data loading and preprocessing. Key implementation details include:

- **Shuffling:** The training dataset is shuffled with a buffer size of 1000 before each epoch.
- **Batching:** Images are batched in groups of 32 (default batch size).
- **Prefetching:** The dataset is configured with `prefetch(tf.data.AUTOTUNE)` to overlap data loading with model training, maximising GPU utilisation.
- **Caching:** The dataset is cached in memory (for small datasets) or on disk (for larger datasets) to avoid redundant I/O.

#### 8.14.3 Model Export: Keras to TFLite Conversion

The conversion from a Keras model to TFLite format involves the following steps:

```python
import tensorflow as tf

# Load trained Keras model
model = tf.keras.models.load_model('emotion_model.h5')

# Convert to TFLite (float32, full precision)
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()
with open('emotion_model.tflite', 'wb') as f:
    f.write(tflite_model)

# Convert to TFLite (int8, post-training quantization)
converter_quant = tf.lite.TFLiteConverter.from_keras_model(model)
converter_quant.optimizations = [tf.lite.Optimize.DEFAULT]
converter_quant.representative_dataset = representative_data_gen
tflite_quant_model = converter_quant.convert()
with open('emotion_model_quant.tflite', 'wb') as f:
    f.write(tflite_quant_model)
```

The `representative_data_gen` function provides a small set of representative input images to calibrate the quantization ranges, ensuring that the quantized model's accuracy remains close to the full-precision model.

### 10.11 Extended Status of Work: Development Infrastructure

#### 10.11.1 Version Control and Code Management

The project uses Git for version control, hosted on GitHub. The repository follows a feature-branch workflow: (a) the `main` branch contains the latest stable, tested code; (b) feature branches (e.g., `feature/emotion-detection`, `feature/trilingual-tts`) are created for each development task; (c) branches are merged into `main` after code review (self-review) and testing. Commit messages follow the Conventional Commits specification (e.g., `feat: add Sinhala TTS integration`, `fix: resolve face detection crash on low-memory devices`).

#### 10.11.2 Development Tools

The primary development tools used in the project include:

| Tool | Purpose |
|---|---|
| Android Studio / VS Code | IDE for Flutter development |
| Flutter SDK (3.x) | Mobile app framework |
| Dart | Programming language for Flutter |
| Google Colab | Cloud-based Jupyter environment for model training |
| Firebase Console | Backend service management |
| Figma | UI/UX wireframing and design |
| Git / GitHub | Version control and code hosting |
| Postman | API testing (for Firebase REST API) |
| Trello / Notion | Task and project management |

### 13.5 Extended Risk Analysis: Non-Technical Risks

#### 13.5.1 Ethics Approval Delay

**Risk:** The ethics approval process (university or hospital) takes significantly longer than anticipated, delaying purpose-built data collection, model retraining, and pilot execution.

**Likelihood:** Medium-High (ethics approval timelines are often unpredictable).

**Impact:** High (cascading effect on data collection, model training, and pilot).

**Mitigation:** (a) Submit the ethics application as early as possible; (b) prepare all data collection instruments, consent forms, and protocols in advance of approval; (c) proceed with model training on public datasets while awaiting approval, deferring purpose-collected data to a supplementary training phase; (d) if approval is not received in time for the pilot, complete all technical work and document the pilot plan in the final report, recommending implementation post-submission.

#### 13.5.2 Participant Recruitment Difficulty

**Risk:** Difficulty recruiting sufficient participants for the pilot study (target: 5–15 child–caregiver dyads).

**Likelihood:** Medium (depending on the cooperation of clinical partners and the willingness of families).

**Impact:** Medium (a smaller sample reduces the generalisability of findings but does not invalidate the feasibility assessment).

**Mitigation:** (a) Engage with clinical partners early and establish clear recruitment pathways; (b) provide information materials in Sinhala, Tamil, and English to reach a broad audience; (c) offer flexibility in participation (e.g., home-based use with remote support, rather than requiring clinic visits); (d) lower the minimum sample size if necessary, documenting the limitation.

#### 13.5.3 Supervisor or Institutional Changes

**Risk:** Changes in supervisor assignment, institutional policies, or module requirements during the project lifecycle.

**Likelihood:** Low.

**Impact:** Medium (potential disruption to guidance, expectations, or deliverables).

**Mitigation:** (a) Maintain comprehensive documentation throughout the project; (b) communicate regularly with the current supervisor; (c) clarify expectations and deliverables early in the project.

#### 13.5.4 Personal Health or Wellbeing

**Risk:** The developer's health, motivation, or wellbeing is adversely affected by the workload, particularly in the final stages of the project.

**Likelihood:** Medium (the project's scope is ambitious for a single developer).

**Impact:** High (potential for delayed or incomplete deliverables).

**Mitigation:** (a) Plan a realistic schedule with built-in breaks and contingency buffers; (b) seek support from the supervisor, peers, or student support services if needed; (c) prioritise high-impact deliverables and deprioritise lower-priority features if time is constrained.

### 19.4 Extended Bibliography: Additional Sources

The following additional sources are referenced throughout this report:

- Anderson, D.K., Lord, C., Risi, S., DiLavore, P.S., Shulman, C., Thurm, A., Welch, K., and Pickles, A. (2007). Patterns of Growth in Verbal Abilities Among Children With Autism Spectrum Disorder. *Journal of Consulting and Clinical Psychology*, 75(4), pp.594–604.
- Asperger, H. (1944). Die "Autistischen Psychopathen" im Kindesalter. *Archiv für Psychiatrie und Nervenkrankheiten*, 117(1), pp.76–136.
- Baranek, G.T., David, F.J., Poe, M.D., Stone, W.L., and Watson, L.R. (2006). Sensory Experiences Questionnaire: Discriminating Sensory Features in Young Children with Autism, Developmental Delays, and Typical Development. *Journal of Child Psychology and Psychiatry*, 47(6), pp.591–601.
- Barrett, L.F., Adolphs, R., Marsella, S., Martinez, A.M., and Pollak, S.D. (2019). Emotional Expressions Reconsidered: Challenges to Inferring Emotion From Human Facial Movements. *Psychological Science in the Public Interest*, 20(1), pp.1–68.
- Ben-Sasson, A., Hen, L., Fluss, R., Cermak, S.A., Engel-Yeger, B., and Gal, E. (2009). A Meta-Analysis of Sensory Modulation Symptoms in Individuals with Autism Spectrum Disorders. *Journal of Autism and Developmental Disorders*, 39(1), pp.1–11.
- Bettelheim, B. (1967). *The Empty Fortress: Infantile Autism and the Birth of the Self*. New York: Free Press.
- Bölte, S., Girdler, S., and Marschik, P.B. (2019). The Contribution of Environmental Exposure to the Etiology of Autism Spectrum Disorder. *Cellular and Molecular Life Sciences*, 76(7), pp.1275–1297.
- Braun, V. and Clarke, V. (2006). Using Thematic Analysis in Psychology. *Qualitative Research in Psychology*, 3(2), pp.77–101.
- Brooke, J. (1996). SUS—A Quick and Dirty Usability Scale. In: P.W. Jordan, B. Thomas, B.A. Weerdmeester, and I.L. McClelland, eds., *Usability Evaluation in Industry*. London: Taylor & Francis, pp.189–194.
- Calvo, R.A. and D'Mello, S. (2010). Affect Detection: An Interdisciplinary Review of Models, Methods, and Their Applications. *IEEE Transactions on Affective Computing*, 1(1), pp.18–37.
- D'Mello, S.K. and Kory, J. (2015). A Review and Meta-Analysis of Multimodal Affect Detection Systems. *ACM Computing Surveys*, 47(3), Article 43.
- Divan, G., Bhavnani, S., Leadbitter, K., Ellis, C., Dasgupta, J., and Patel, V. (2021). Annual Research Review: Achieving Universal Health Coverage for Young Children with Autism Spectrum Disorder in Low- and Middle-Income Countries: A Review of Evidence, Gaps and Needs. *Journal of Child Psychology and Psychiatry*, 62(5), pp.518–535.
- Fombonne, E. (2018). Editorial: The Rising Prevalence of Autism. *Journal of Child Psychology and Psychiatry*, 59(7), pp.717–720.
- Gray, C.A. and Garand, J.D. (1993). Social Stories: Improving Responses of Students with Autism with Accurate Social Information. *Focus on Autistic Behavior*, 8(1), pp.1–10.
- Hertzog, M.A. (2008). Considerations in Determining Sample Size for Pilot Studies. *Research in Nursing & Health*, 31(2), pp.180–191.
- Hill, E.L. (2004). Executive Dysfunction in Autism. *Trends in Cognitive Sciences*, 8(1), pp.26–32.
- Hume, K., Loftin, R., and Lantz, J. (2014). Increasing Independence in Autism Spectrum Disorders: A Review of Three Focused Interventions. *Journal of Autism and Developmental Disorders*, 39(9), pp.1329–1338.
- Kanner, L. (1943). Autistic Disturbances of Affective Contact. *Nervous Child*, 2, pp.217–250.
- Keehn, B., Müller, R.A., and Townsend, J. (2013). Atypical Attentional Networks and the Emergence of Autism. *Neuroscience & Biobehavioral Reviews*, 37(2), pp.164–183.
- Keskar, N.S., Mudigere, D., Nocedal, J., Smelyanskiy, M., and Tang, P.T.P. (2017). On Large-Batch Training for Deep Learning: Generalization Gap and Sharp Minima. *Proceedings of ICLR 2017*.
- Labrique, A.B., Vasudevan, L., Kochi, E., Fabricant, R., and Mehl, G. (2013). mHealth Innovations as Health System Strengthening Tools: 12 Common Applications and a Visual Framework. *Global Health: Science and Practice*, 1(2), pp.160–171.
- Landis, J.R. and Koch, G.G. (1977). The Measurement of Observer Agreement for Categorical Data. *Biometrics*, 33(1), pp.159–174.
- Leekam, S.R., Nieto, C., Libby, S.J., Wing, L., and Gould, J. (2007). Describing the Sensory Abnormalities of Children and Adults with Autism. *Journal of Autism and Developmental Disorders*, 37(5), pp.894–910.
- Mace, R.L., Hardie, G.J., and Place, J.P. (1997). *Accessible Environments: Toward Universal Design*. In: W.F.E. Preiser, J.C. Vischer, and E.T. White, eds., *Design Interventions: Toward a More Humane Architecture*. New York: Van Nostrand Reinhold.
- Maenner, M.J., Warren, Z., Williams, A.R., et al. (2023). Prevalence and Characteristics of Autism Spectrum Disorder Among Children Aged 8 Years—Autism and Developmental Disabilities Monitoring Network, 11 Sites, United States, 2020. *MMWR Surveillance Summaries*, 72(2), pp.1–14.
- Mesibov, G.B., Shea, V., and Schopler, E. (2005). *The TEACCH Approach to Autism Spectrum Disorders*. New York: Springer.
- National Autism Center (2015). *Findings and Conclusions: National Standards Project, Phase 2*. Randolph, MA: Author.
- Nevill, R.E., Lecavalier, L., and Stratis, E.A. (2018). Meta-Analysis of Parent-Mediated Interventions for Young Children with Autism Spectrum Disorder. *Autism*, 22(2), pp.84–98.
- Nielsen, J. (1993). *Usability Engineering*. San Diego: Academic Press.
- Oliver, M. (1990). *The Politics of Disablement*. London: Macmillan.
- Oono, I.P., Honeybourne, S., and McConachie, H. (2013). Parent-Mediated Early Intervention for Young Children with Autism Spectrum Disorders (ASD). *Evidence-Based Child Health*, 8(6), pp.2380–2479.
- Picard, R.W. (2000). *Affective Computing*. Cambridge, MA: MIT Press.
- Prizant, B.M. and Duchan, J.F. (1981). The Functions of Immediate Echolalia in Autistic Children. *Journal of Speech and Hearing Disorders*, 46(3), pp.241–249.
- Rutter, M. (1978). Diagnosis and Definition of Childhood Autism. *Journal of Autism and Childhood Schizophrenia*, 8(2), pp.139–161.
- Sackett, D.L., Rosenberg, W.M., Gray, J.A., Haynes, R.B., and Richardson, W.S. (1996). Evidence-Based Medicine: What It Is and What It Isn't. *BMJ*, 312(7023), pp.71–72.
- Schwaber, K. and Sutherland, J. (2020). *The Scrum Guide*. Available at: https://scrumguides.org/ [Accessed: 15 January 2026].
- Shakespeare, T. (2013). *Disability Rights and Wrongs Revisited*. 2nd ed. London: Routledge.
- Tager-Flusberg, H. and Kasari, C. (2013). Minimally Verbal School-Aged Children with Autism Spectrum Disorder: The Neglected End of the Spectrum. *Autism Research*, 6(6), pp.468–478.
- Tager-Flusberg, H., Paul, R., and Lord, C. (2005). Language and Communication in Autism. In: F.R. Volkmar, R. Paul, A. Klin, and D. Cohen, eds., *Handbook of Autism and Pervasive Developmental Disorders*. 3rd ed. Hoboken, NJ: Wiley, pp.335–364.
- Tomlinson, M., Rotheram-Borus, M.J., Swartz, L., and Tsai, A.C. (2013). Scaling Up mHealth: Where Is the Evidence? *PLoS Medicine*, 10(2), e1001382.
- Tomchek, S.D. and Dunn, W. (2007). Sensory Processing in Children With and Without Autism: A Comparative Study Using the Short Sensory Profile. *American Journal of Occupational Therapy*, 61(2), pp.190–200.
- United Nations (2006). *Convention on the Rights of Persons with Disabilities*. New York: United Nations.
- United Nations (2015). *Transforming Our World: The 2030 Agenda for Sustainable Development*. New York: United Nations.
- Wing, L. (1981). Asperger's Syndrome: A Clinical Account. *Psychological Medicine*, 11(1), pp.115–129.
- Wing, L. and Gould, J. (1979). Severe Impairments of Social Interaction and Associated Abnormalities in Children: Epidemiology and Classification. *Journal of Autism and Developmental Disorders*, 9(1), pp.11–29.
- Wong, C., Odom, S.L., Hume, K.A., et al. (2015). Evidence-Based Practices for Children, Youth, and Young Adults with Autism Spectrum Disorder: A Comprehensive Review. *Journal of Autism and Developmental Disorders*, 45(7), pp.1951–1966.
- World Health Organization (2011). *mHealth: New Horizons for Health Through Mobile Technologies*. Geneva: WHO.
- World Health Organization and UNICEF (2022). *Global Report on Assistive Technology*. Geneva: WHO.

---
