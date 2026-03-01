

### 2.8 Comparative Analysis of Deep Learning Architectures for Mobile FER

#### 2.8.1 Architecture Selection Rationale

The selection of MobileNetV2 as the base architecture for facial expression recognition in this project was informed by a systematic comparative analysis of several candidate architectures. Each architecture was evaluated against criteria specific to the project's deployment constraints: model size (suitability for mobile bundling), inference latency on mid-range devices, accuracy on standard FER benchmarks, and availability of pre-trained weights for transfer learning. This section presents the analysis in detail.

#### 2.8.2 VGGNet

VGGNet (Simonyan and Zisserman, 2015) is a deep convolutional neural network characterised by its use of small (3×3) convolutional filters stacked in very deep architectures (16 or 19 layers). VGGNet achieved strong results on the ImageNet Large Scale Visual Recognition Challenge (ILSVRC) in 2014 and has been widely used as a feature extractor in transfer learning. However, VGGNet has a very large number of parameters (approximately 138 million for VGG-16), resulting in a model size of over 500 MB. This makes VGGNet impractical for mobile deployment, where model size and inference speed are critical constraints. The inference latency of VGGNet on a mid-range smartphone would exceed the 500 ms target by a significant margin, rendering it unsuitable for real-time or near-real-time FER in this project.

#### 2.8.3 ResNet

ResNet (He et al., 2016) introduced the concept of residual connections (skip connections), which allow gradients to flow more easily through very deep networks, enabling the training of architectures with 50, 101, or even 152 layers. ResNet-50, with approximately 25 million parameters and a model size of approximately 100 MB, achieves strong accuracy on ImageNet and has been widely used for FER (Li and Deng, 2020). While ResNet-50 is more efficient than VGGNet, its model size and computational requirements remain substantial for mobile deployment. Inference latency on a mid-range smartphone is typically in the range of 500–1000 ms (without quantization), which is at or above the project's target threshold. ResNet-50 was considered as an alternative but was ultimately not selected due to its larger size and slower inference compared to MobileNetV2.

#### 2.8.4 InceptionV3

InceptionV3 (Szegedy et al., 2016) uses a modular architecture with "inception" blocks that apply multiple convolutional operations (1×1, 3×3, 5×5, and pooling) in parallel and concatenate the results. This design captures features at multiple scales within each layer, improving representational efficiency. InceptionV3 has approximately 23 million parameters and a model size of approximately 92 MB. While more efficient than VGGNet and comparable to ResNet-50, InceptionV3's multi-branch architecture introduces additional computational overhead that makes it less suitable for low-latency mobile inference compared to MobileNetV2.

#### 2.8.5 MobileNetV1

MobileNetV1 (Howard et al., 2017) was the first architecture in the MobileNet family, introducing depthwise separable convolutions to dramatically reduce computational cost and model size. MobileNetV1 has approximately 3.4 million parameters and a model size of approximately 16 MB (float32), making it highly suitable for mobile deployment. However, MobileNetV1 lacks the inverted residual blocks and linear bottlenecks introduced in MobileNetV2, which improve representational power and accuracy for a given computational budget.

#### 2.8.6 MobileNetV2

MobileNetV2 (Sandler et al., 2018) builds on MobileNetV1 by introducing inverted residual blocks with linear bottlenecks, which improve accuracy while maintaining computational efficiency. MobileNetV2 has approximately 3.4 million parameters and a model size of approximately 14 MB (float32) or approximately 3.5 MB after quantization. On ImageNet, MobileNetV2 achieves a top-1 accuracy of approximately 72%, which is competitive with much larger architectures (e.g., ResNet-50 achieves approximately 76%) at a fraction of the computational cost.

For FER tasks, MobileNetV2 has been shown to achieve accuracy comparable to larger models when fine-tuned with appropriate data augmentation and regularisation (Li and Deng, 2020). Its small size and fast inference make it ideal for on-device deployment in resource-constrained settings, which is the primary use case for this project.

#### 2.8.7 MobileNetV3

MobileNetV3 (Howard et al., 2019) further improves upon MobileNetV2 by incorporating neural architecture search (NAS) and the squeeze-and-excitation (SE) module, achieving higher accuracy at a similar or lower computational cost. MobileNetV3 was considered for this project but was not selected for the following reasons: (a) at the time of project initiation, pre-trained MobileNetV3 weights for TensorFlow/Keras were less widely available and less extensively validated for transfer learning in academic settings; (b) the accuracy improvement over MobileNetV2, while measurable, is modest (approximately 1–2 percentage points on ImageNet) and may not translate to a meaningful improvement on the smaller, domain-specific FER dataset used in this project; and (c) MobileNetV2 is better documented and more widely used in the FER literature, facilitating comparison with published results.

#### 2.8.8 EfficientNet

EfficientNet (Tan and Le, 2019) is a family of models that use compound scaling (uniformly scaling network width, depth, and resolution) to achieve state-of-the-art accuracy at various computational budgets. EfficientNet-B0, the smallest variant, has approximately 5.3 million parameters and achieves higher accuracy than MobileNetV2 on ImageNet, but at a somewhat higher computational cost. While EfficientNet is a strong candidate for future iterations of the project, MobileNetV2 was preferred for the initial version due to its well-established track record in mobile FER, extensive documentation, and slightly lower inference latency on the target devices.

[Table 12: Comparison of Candidate Architectures for Mobile FER]

| Architecture | Parameters (M) | Model Size (MB, float32) | ImageNet Top-1 (%) | Inference (ms, mid-range) | Selected? |
|---|---|---|---|---|---|
| VGG-16 | 138 | 528 | 71.5 | >2000 | No |
| ResNet-50 | 25.6 | 98 | 76.1 | 500–1000 | No |
| InceptionV3 | 23.8 | 92 | 77.9 | 400–800 | No |
| MobileNetV1 | 3.4 | 16 | 70.9 | 80–200 | No |
| **MobileNetV2** | **3.4** | **14** | **72.0** | **80–250** | **Yes** |
| MobileNetV3 | 5.4 | 22 | 75.2 | 80–200 | Considered |
| EfficientNet-B0 | 5.3 | 20 | 77.3 | 100–300 | Considered |

### 8.12 Extended Discussion of Training Hyperparameters

#### 8.12.1 Learning Rate

The learning rate is the most important hyperparameter in training deep neural networks. It controls the step size of the optimiser's parameter updates. A learning rate that is too high can cause training to overshoot minima and diverge; a learning rate that is too low can result in slow convergence and susceptibility to getting stuck in local minima or poor generalisation.

For this project, a two-phase learning rate schedule is used:

- **Phase 1 (classification head only):** A relatively high learning rate (e.g., 1e-3) is used to quickly train the classification head while the base model weights are frozen.
- **Phase 2 (fine-tuning):** A reduced learning rate (e.g., 1e-5 to 1e-4) is used when fine-tuning the base model, to avoid large gradient updates that could destroy the pre-learned features. A learning rate warm-up (gradually increasing the learning rate over the first few epochs) and cosine annealing (gradually decreasing the learning rate over the training cycle) are explored as additional strategies to improve convergence and final performance.

#### 8.12.2 Batch Size

The batch size determines the number of training samples processed before the model's weights are updated. Larger batch sizes provide more stable gradient estimates but require more memory and may lead to less generalisation due to fewer weight updates per epoch. Smaller batch sizes provide noisier but more frequent updates, which can act as a form of regularisation (Keskar et al., 2017).

For this project, a batch size of 32 is used as the default, balancing memory requirements (compatible with Google Colab's free GPU tier) and training stability. Experiments with batch sizes of 16 and 64 are planned to assess the impact on convergence speed and final accuracy.

#### 8.12.3 Epochs and Early Stopping

The number of training epochs is controlled by early stopping: training continues until the validation loss has not improved for a specified number of consecutive epochs (patience). A patience of 5–10 epochs is used, depending on the training phase (higher patience during fine-tuning). The model checkpoint with the best validation loss is restored after training completes, ensuring that the final model corresponds to the best observed validation performance.

#### 8.12.4 Dropout Rate

Dropout rates of 0.2 to 0.5 are explored for the dense layers of the classification head. Higher dropout rates provide stronger regularisation but may reduce the model's capacity to learn complex relationships. The optimal dropout rate is determined through validation set performance.

### 13.4 Extended Risk Analysis: Technical Risks

#### 13.4.1 TTS Quality in Sinhala and Tamil

Text-to-speech quality for Sinhala and Tamil is a known challenge. While Google's TTS engine supports Sinhala and Tamil, the quality and naturalness of the synthesised speech may be inferior to English TTS, particularly for less common vocabulary, numerals, and proper nouns. The risk is that low-quality TTS output may confuse the child or caregiver, reduce engagement, or even introduce communication errors (e.g., mispronounced words).

Mitigation strategies include: (a) testing all critical vocabulary items with the target TTS engines and documenting quality issues; (b) providing an option for caregivers or therapists to record custom audio for critical vocabulary items, which the app plays instead of synthesised speech; (c) using alternative TTS engines or APIs if the default engine produces unacceptable results; and (d) documenting TTS limitations in the user guide and training materials.

#### 13.4.2 Device Fragmentation

Android device fragmentation—the diversity of hardware specifications, screen sizes, camera qualities, and OS versions across the Android ecosystem—presents a testing and compatibility challenge. While Flutter mitigates many UI-related fragmentation issues through its widget-based rendering pipeline, the TFLite inference performance, camera API behaviour, and TTS quality may vary across devices.

Mitigation strategies include: (a) defining minimum device specifications (Android 8.0+, at least 2 GB RAM, rear and front camera); (b) testing on at least three representative devices (low-end, mid-range, and high-end); (c) implementing graceful degradation for devices that do not meet the recommended specifications (e.g., lower camera resolution, reduced capture frequency); and (d) documenting known device-specific issues.

#### 13.4.3 Battery Consumption

Continuous or frequent camera capture and on-device inference can significantly increase battery consumption, which is a concern for a mobile application intended for extended use. Mitigation strategies include: (a) implementing configurable capture frequency (e.g., one frame per second, or on-demand only); (b) stopping camera capture and inference when the app is in the background; (c) providing a battery-saving mode that reduces or disables emotion detection; and (d) benchmarking battery consumption during testing and documenting the results.

### 14.4 Extended Discussion of Scope Limitations

#### 14.4.1 No RCT or Large-Scale Clinical Trial

The project does not include a randomised controlled trial or a large-scale clinical trial. Such a study would require: (a) a substantially larger sample size (typically 30+ participants per group); (b) a control group (e.g., children using AAC without emotion recognition); (c) randomised allocation; (d) standardised outcome measures; (e) blinding (where feasible); and (f) a longer study duration. These requirements are beyond the scope and resources of a final year project but are recommended for future research.

#### 14.4.2 No Longitudinal Analysis

The pilot study is designed as a short-term (4–8 week) feasibility and usability study, not a longitudinal analysis of communication outcomes. Longitudinal analysis would require tracking each child's communication development over several months or years, comparing outcomes with and without AAC use, and controlling for maturation and other confounding factors. This is a direction for future research.

#### 14.4.3 No Support for Other Languages or Modalities

The project focuses on Sinhala, Tamil, and English, reflecting the languages of the target deployment context. Support for other languages (e.g., Malay, Hindi, Arabic) or other communication modalities (e.g., sign language recognition, physiological sensors) is outside the current scope but could be added in future versions.

### 15.4 Extended Gantt Chart Analysis

The Gantt chart (Figure 8) reveals several important features of the project schedule:

1. **Parallel tracks:** The project operates on two main parallel tracks—software development (Platform A, Platform B, backend, dashboard) and ethical/clinical preparation (ethics application, consent forms, hospital partnership, pilot design). This parallelism allows productive work to continue during the ethics approval process, which is the most significant external dependency.

2. **Float and slack:** Tasks on the non-critical path (e.g., documentation refinement, optional dashboard features, dissemination planning) have positive float, meaning they can be delayed without affecting the overall project deadline. Tasks on the critical path (ethics approval → dataset collection → model training → pilot execution → final report) have zero or minimal float, meaning any delay directly affects the project completion date.

3. **Milestone reviews:** The Gantt chart includes milestone reviews at the end of each increment, aligned with project supervisor meetings and academic milestones (interim report submission, final report submission). These reviews provide opportunities to assess progress, reprioritise tasks, and adjust the plan in response to new information or delays.

4. **Contingency buffer:** A two-week contingency buffer is included before the final report submission deadline, to absorb unexpected delays. If this buffer is not consumed by delays, it can be used for additional testing, documentation polish, or preparation of supplementary materials.

### 16.3 Extended WBS Dictionary

The WBS dictionary provides a brief description of each work package, its estimated effort (in person-hours), its owner (the project developer, with supervisor oversight), and its deliverables:

| WBS Code | Work Package | Estimated Effort (hrs) | Deliverables |
|---|---|---|---|
| 1.1 | Literature review and synthesis | 60 | Literature review section (Sections 1–2) |
| 1.2 | Stakeholder needs analysis | 20 | Stakeholder analysis document; use case descriptions |
| 1.3 | Requirements and design | 30 | Requirements document; architecture diagrams |
| 2.1 | Flutter project setup | 15 | Project scaffold; CI configuration |
| 2.2 | Symbol grid and navigation | 40 | Functional AAC grid with navigation |
| 2.3 | Trilingual vocabulary | 30 | Vocabulary database in Sinhala, Tamil, English |
| 2.4 | TTS integration | 20 | Functional TTS in three languages |
| 2.5 | Customisation features | 25 | Configurable grid size, symbols, themes |
| 2.6 | Visual scheduling | 20 | Visual schedule feature |
| 2.7 | Usage logging | 15 | Local usage log with optional cloud sync |
| 3.1 | Data sourcing (public) | 15 | Curated public dataset subset |
| 3.2 | Purpose-built data collection | 30 | Project-specific facial expression images |
| 3.3 | Augmentation pipeline | 10 | Functional data augmentation pipeline |
| 3.4 | MobileNetV2 transfer learning | 20 | Trained classification head; base model fine-tuning |
| 3.5 | Model evaluation | 15 | Confusion matrix, precision, recall, F1, accuracy report |
| 3.6 | TFLite export and benchmarking | 10 | Quantized TFLite model; latency benchmarks |
| 4.1 | Face detection pipeline | 15 | Functional face detection in Flutter |
| 4.2 | TFLite integration | 15 | Dart ↔ TFLite platform channel; functional inference |
| 4.3 | Emotion-adaptive logic | 20 | Configurable adaptation rules; UI integration |
| 4.4 | Caregiver override | 10 | Override controls; transparency indicators |
| 5.1 | Firebase configuration | 15 | Auth, Firestore, Storage configured |
| 5.2 | Data schema design | 10 | Firestore schema document |
| 5.3 | Security rules | 10 | Firestore/Storage security rules |
| 5.4 | Offline sync | 25 | Offline-first sync with conflict resolution |
| 5.5 | Dashboard (web) | 40 | Functional dashboard with auth, visualisation, vocab mgmt |
| 6.1 | Ethics application | 20 | Ethics application; consent forms; information sheets |
| 6.2 | Translations | 10 | Sinhala and Tamil translations of consent/info materials |
| 6.3 | Hospital liaison | 15 | Documented partnership; MoH engagement |
| 6.4 | Pilot execution | 40 | Pilot data; observation notes; feedback |
| 6.5 | Analysis and reporting | 30 | Pilot analysis; final report sections |
| 7.1 | Interim report | 50 | Complete interim report |
| 7.2 | Final report | 60 | Complete final report/dissertation |
| 7.3 | User documentation | 15 | Installation guide; user manual |
| 7.4 | Presentation preparation | 10 | Slides; demo; rehearsal |

### 17.2 Extended Reflective Conclusion

The process of designing and developing this system has involved not only technical work (coding, model training, architecture design) but also substantial engagement with the broader context of the problem: the lived experiences of children with ASD and their families in Sri Lanka, the systemic barriers to accessing communication support, the ethical complexities of deploying AI in sensitive domains, and the practicalities of navigating institutional and governmental approval processes.

One of the most valuable lessons learned during this process is the importance of co-design and stakeholder engagement. While the project's timeline and scope have limited the extent to which formal co-design activities could be conducted, the informal feedback received from therapists and parents during the design phase has significantly influenced the system's features and interaction paradigms. For example, the decision to make emotion recognition an opt-in, caregiver-controlled feature was directly informed by feedback from a therapist who emphasised the importance of caregiver agency and the risk of over-reliance on automated systems. Similarly, the inclusion of visual scheduling was suggested by a parent who described the importance of routine-based supports for their child's daily life.

Another important lesson is the value of an incremental development approach in managing complexity, uncertainty, and external dependencies. By delivering working increments early and incorporating feedback at each stage, the project has been able to adapt to challenges (e.g., delays in ethics preparation, symbol licensing issues) without compromising overall progress. The incremental model has also facilitated communication with the project supervisor, as each increment provides a tangible demonstration of progress and a basis for focused feedback.

The ethical dimensions of the project have been a constant thread throughout the design and documentation process. The recognition that facial expression recognition for children with autism is not merely a technical challenge but a deeply ethical one—touching on consent, privacy, autonomy, power, and the risk of harm—has shaped the system's design at every level, from the choice to process images on-device to the prominence of caregiver override controls in the user interface. The project aspires to model a responsible approach to AI development in sensitive domains, contributing not only a functional system but also a documented ethical framework that other developers and researchers can draw upon.

Looking ahead, the project is well-positioned to complete its remaining deliverables within the academic timeline. The most significant risk remains the timing of ethics approval, which is the gating factor for purpose-built data collection, model retraining, and pilot execution. Regardless of the pilot's outcome, the system, model, and documentation produced by this project will constitute a substantial and meaningful contribution to the field of assistive technology for children with autism in Sri Lanka and beyond.

---
