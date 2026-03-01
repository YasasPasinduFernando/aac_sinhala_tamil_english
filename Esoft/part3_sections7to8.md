

## 7. Development Methodology

### 7.1 Choice of Methodology

The project follows an incremental development model, which is characterised by the delivery of the system in a series of increments, each producing a potentially shippable subset of functionality (Sommerville, 2016). This choice is justified by several factors specific to the project context:

1. **Phased delivery:** The dual-platform architecture, with its multiple components (Platform A, Platform B, AI model, backend, dashboard), lends itself naturally to incremental delivery. Platform A (basic AAC) can be developed and validated first, providing a working product that delivers value even before the AI and emotion recognition components are complete. This reduces project risk and enables early feedback.

2. **Stakeholder feedback:** The involvement of multiple stakeholder groups (children with ASD, parents/caregivers, therapists, hospital staff) requires iterative feedback loops. An incremental approach allows each increment to be demonstrated to and reviewed by stakeholders, with feedback informing the design and implementation of subsequent increments.

3. **Dependency management:** Several project activities have external dependencies—most notably, ethics approval from Karapitiya Teaching Hospital and the Ministry of Health, which must be obtained before data collection with children can proceed. The incremental model allows the project to proceed with activities that are not dependent on these approvals (e.g., software development, public dataset validation) while preparing for those that are.

4. **Academic constraints:** A final year project operates within a fixed timeline with defined milestones (interim report, final report). The incremental model provides natural checkpoints that align with these milestones, facilitating progress tracking and reporting.

5. **Risk reduction:** By delivering working increments early and often, the incremental model reduces the risk of discovering fundamental design flaws late in the project. Each increment is tested and validated before the next increment is begun, ensuring that problems are identified and addressed early (Sommerville, 2016).

### 7.2 Incremental Plan

The project is divided into five major increments, each with defined deliverables and validation criteria:

**Increment 1 (Months 1–2): Requirements, Architecture, and Minimal AAC.**
Deliverables: Literature review and requirements document; system architecture design; Flutter project structure; minimal AAC interface with basic symbol grid and single-language support. Validation: Internal review of architecture; manual testing of basic AAC flow on Android emulator.

**Increment 2 (Months 3–4): Full Platform A and Backend.**
Deliverables: Complete Platform A with trilingual support, customisation features, TTS integration, and visual scheduling; Firebase backend (Authentication, Firestore, Storage) configured and integrated; basic therapist–parent dashboard. Validation: Manual testing of full AAC flow in Sinhala, Tamil, and English; sync testing with Firebase; informal usability check with at least one representative user.

**Increment 3 (Months 5–6): AI Model and Platform B Integration.**
Deliverables: Trained MobileNetV2-based emotion recognition model; TFLite export and quantization; on-device inference pipeline integrated into Flutter; Platform B with emotion-adaptive vocabulary; initial model evaluation (accuracy, precision, recall, F1, confusion matrix). Validation: Model evaluation on held-out test set; end-to-end testing of emotion detection pipeline on physical device; latency benchmarking.

**Increment 4 (Months 7–8): Dashboard Completion, Ethics, and Pilot Preparation.**
Deliverables: Complete therapist–parent dashboard with progress visualisation, vocabulary management, and export; ethics application submitted and (ideally) approved; pilot design and participant recruitment materials prepared; consent forms and information sheets in Sinhala, Tamil, and English. Validation: Dashboard feedback from at least one therapist and one parent; ethics approval documentation; pilot protocol review.

**Increment 5 (Months 9–10): Pilot Execution and Final Report.**
Deliverables: Pilot deployment at Karapitiya Teaching Hospital (subject to approval); data collection and analysis; final report and dissertation; presentation or demo for the examining panel. Validation: Pilot data analysis (usability, acceptance, model performance in situ); final report review; supervisor sign-off.

### 7.3 Comparison with Alternative Methodologies

Several alternative development methodologies were considered and evaluated against the project's requirements and constraints:

**Waterfall model:** The waterfall model prescribes a sequential flow through requirements, design, implementation, testing, and maintenance phases. While it provides strong documentation and phase-gate controls, it is poorly suited to projects with evolving requirements, external dependencies, and the need for early feedback—all of which characterise this project. The late integration of testing and the inability to revisit earlier phases without formal change control make the waterfall model inflexible and risky for a project of this nature (Sommerville, 2016).

**Agile (Scrum):** Agile methodologies, and Scrum in particular, emphasise short sprints, continuous delivery, and close collaboration with stakeholders. While the project benefits from some agile practices (e.g., short cycles, iterative feedback), full Scrum was not adopted for several reasons: the single-developer context does not require the roles and ceremonies (product owner, scrum master, sprint planning, daily standups) prescribed by Scrum; the academic project constraint requires documented milestones (interim and final reports) that do not align naturally with sprint-based delivery; and the external dependencies (ethics approval, hospital partnership) cannot be resolved within a two-week sprint cycle.

**Spiral model:** The spiral model combines iterative development with systematic risk analysis, with each iteration involving planning, risk analysis, engineering, and evaluation. While risk analysis is a strength of this model, its formal structure and overhead may be excessive for a single-developer academic project (Boehm, 1988).

**Rapid Application Development (RAD):** RAD emphasises rapid prototyping and user feedback, with short development cycles and heavy use of reusable components. While RAD principles inform the use of Flutter and Firebase (which provide pre-built components and services), the full RAD methodology was not adopted because it may prioritise speed over thoroughness of design and documentation, which are assessed in the FC6P01ES module.

The incremental model was selected as the most appropriate methodology, offering a balance between structure (clear increments, defined deliverables, documented milestones) and adaptability (feedback-driven refinement, phased delivery, separation of dependencies). Within each increment, agile-inspired practices such as short development cycles, regular testing, and supervisor feedback sessions are employed to maintain momentum and quality (Dawe, 2006).

### 7.4 Tools and Practices

The following tools and practices support the development process:

- **Version control:** Git (hosted on GitHub) is used for source code management. The repository follows a branching strategy with main and feature branches.
- **Issue tracking:** GitHub Issues (or a simple task list) is used to track tasks, bugs, and feature requests.
- **Code review:** Self-review and supervisor review of key code changes. Automated linting (Dart analysis) enforces coding standards.
- **Testing:** Unit tests for critical modules (data layer, model inference wrapper); manual testing for UI and end-to-end flows; model evaluation scripts for AI component.
- **Documentation:** In-code documentation (Dart doc comments); design documents; this interim report.
- **Communication:** Regular meetings with the project supervisor; email correspondence with hospital contacts; documented meeting notes.

---

## 8. AI Model Design and Data Collection

### 8.1 Convolutional Neural Network Foundations

A convolutional neural network (CNN) is a class of deep neural network designed to process data with a grid-like topology, such as images (two-dimensional grids of pixels). CNNs have become the dominant approach for image classification, object detection, and many other computer vision tasks, owing to their ability to learn hierarchical feature representations directly from raw data (LeCun et al., 2015; Goodfellow et al., 2015). The fundamental operations of a CNN are convolution, activation, and pooling, which together enable the network to extract increasingly abstract and discriminative features from the input image.

#### 8.1.1 Convolution Operation

The convolution operation is the defining feature of a CNN. In the discrete two-dimensional case, the convolution of an input feature map $I$ with a kernel (filter) $K$ is defined as:

$$
(I * K)_{i,j} = \sum_m \sum_n I_{i+m, j+n} \cdot K_{m,n}
$$

where the indices $m$ and $n$ range over the spatial extent of the kernel, and the output at position $(i, j)$ is the sum of element-wise products over the kernel window. In practice, the operation is technically a cross-correlation rather than a true mathematical convolution (which would involve flipping the kernel), but the term "convolution" is standard in the deep learning literature (Goodfellow et al., 2015).

Each convolutional layer applies multiple kernels (filters) to the input, producing multiple output feature maps (also called channels). Each kernel is learned during training and specialises in detecting a particular type of local feature (e.g., an edge at a specific orientation, a colour gradient, a textural pattern). The number of kernels per layer, the kernel size (e.g., 3×3, 5×5), the stride (step size with which the kernel moves across the input), and the padding (whether the input is zero-padded to preserve spatial dimensions) are hyperparameters that are specified as part of the architecture design.

#### 8.1.2 Activation Functions

After each convolution, a non-linear activation function is applied element-wise to the output feature map. The purpose of the activation function is to introduce non-linearity into the network, enabling it to learn complex, non-linear mappings from inputs to outputs. The most commonly used activation function in modern CNNs is the Rectified Linear Unit (ReLU):

$$
f(x) = \max(0, x)
$$

ReLU is computationally efficient (requiring only a comparison and a selection), addresses the vanishing gradient problem that can affect deeper networks using sigmoid or tanh activations, and has been shown to facilitate faster convergence during training (Nair and Hinton, 2010). Variants such as Leaky ReLU, Parametric ReLU (PReLU), and Exponential Linear Unit (ELU) have been proposed to address the "dying ReLU" problem (where neurons that consistently receive negative inputs cease to learn), but standard ReLU remains the most widely used in practice.

#### 8.1.3 Pooling

Pooling (also known as subsampling or downsampling) reduces the spatial dimensions of the feature maps, providing a degree of translation invariance and reducing the number of parameters and computations in subsequent layers. The most common pooling operation is max pooling, which selects the maximum value within each non-overlapping (or overlapping) window:

$$
\text{MaxPool}(I)_{i,j} = \max_{(m,n) \in R_{i,j}} I_{m,n}
$$

where $R_{i,j}$ is the pooling region at position $(i, j)$. A typical pooling window size is 2×2 with a stride of 2, which reduces the spatial dimensions by half. Average pooling, which computes the mean value within each window, is also used, particularly in the later stages of some architectures (e.g., global average pooling before the final classification layer).

#### 8.1.4 Fully Connected Layers and Output

After several convolutional and pooling blocks, the resulting feature maps are flattened into a one-dimensional vector and passed through one or more fully connected (dense) layers. These layers integrate features from across the entire spatial extent of the feature maps and map them to the output space. The final layer has one unit per class (e.g., six units for six emotion classes) and is followed by a softmax activation function to produce class probabilities.

### 8.2 Softmax Function and Class Probabilities

For multi-class classification, the output layer typically has $C$ units (one per class). The raw outputs (logits) $z_i$ are converted to probabilities using the softmax function:

$$
\text{softmax}(z_i) = \frac{e^{z_i}}{\sum_{j=1}^{C} e^{z_j}}
$$

The softmax function has several important properties: (1) all output values are in the range (0, 1); (2) the outputs sum to one, and can therefore be interpreted as a probability distribution over the $C$ classes; (3) the function is differentiable, enabling gradient-based optimisation; and (4) it is invariant to the addition of a constant to all logits, which makes the outputs depend only on the relative magnitudes of the logits (Goodfellow et al., 2015). The predicted class is usually taken as:

$$
\hat{y} = \arg\max_i \, \text{softmax}(z_i)
$$

In the context of this project, the six output units correspond to the six emotion classes: happy, sad, angry, fear, neutral, and tired. The softmax output for each class can be interpreted as the model's confidence that the input image belongs to that class. The maximum softmax probability is used as a confidence score; if it falls below a configurable threshold, the prediction is treated as uncertain and the adaptation logic is not triggered.

### 8.3 Cross-Entropy Loss Function

Training is performed by minimising a loss function that measures the discrepancy between the model's predicted probabilities and the true labels. For multi-class classification, the standard loss function is categorical cross-entropy (also known as log loss):

$$
\mathcal{L} = -\sum_{c=1}^{C} y_c \log \hat{p}_c
$$

where $y$ is the one-hot encoded true label (a vector with a 1 at the position of the true class and 0 elsewhere) and $\hat{p}$ is the vector of predicted probabilities from softmax. For a single sample where the true class is $k$, this simplifies to:

$$
\mathcal{L} = -\log \hat{p}_k
$$

This loss function has the desirable property that it penalises confident but incorrect predictions heavily (since $-\log \hat{p}_k$ approaches infinity as $\hat{p}_k$ approaches zero) and yields a small loss for confident correct predictions (since $-\log \hat{p}_k$ approaches zero as $\hat{p}_k$ approaches one). The loss is averaged over a batch of samples, and backpropagation is used to compute gradients of the loss with respect to all learnable parameters, which are then updated using an optimisation algorithm (Goodfellow et al., 2015).

### 8.4 Optimisation Algorithms

The choice of optimisation algorithm affects training speed, convergence, and final model performance. The most commonly used optimiser in modern deep learning is Adam (Adaptive Moment Estimation), introduced by Kingma and Ba (2015). Adam combines the advantages of two other optimisers—AdaGrad (which adapts the learning rate for each parameter based on the history of gradients) and RMSprop (which uses a moving average of squared gradients)—to provide adaptive, per-parameter learning rates. The Adam update rules are:

$$
m_t = \beta_1 m_{t-1} + (1 - \beta_1) g_t
$$
$$
v_t = \beta_2 v_{t-1} + (1 - \beta_2) g_t^2
$$
$$
\hat{m}_t = \frac{m_t}{1 - \beta_1^t}, \quad \hat{v}_t = \frac{v_t}{1 - \beta_2^t}
$$
$$
\theta_{t+1} = \theta_t - \frac{\alpha}{\sqrt{\hat{v}_t} + \epsilon} \hat{m}_t
$$

where $g_t$ is the gradient at time step $t$, $m_t$ and $v_t$ are the first and second moment estimates, $\beta_1$ and $\beta_2$ are exponential decay rates (typically 0.9 and 0.999), $\alpha$ is the learning rate, and $\epsilon$ is a small constant for numerical stability. Adam is used as the default optimiser in this project due to its robust performance across a wide range of tasks and datasets (Kingma and Ba, 2015).

### 8.5 Transfer Learning with MobileNetV2

#### 8.5.1 Transfer Learning Strategy

Transfer learning involves leveraging a model pre-trained on a large dataset to improve performance on a related but potentially smaller or different target dataset (Yosinski et al., 2014). In this project, MobileNetV2 pre-trained on ImageNet (over 14 million images, 1,000 classes) is used as a feature extractor. The transfer learning strategy consists of the following steps:

1. **Load pre-trained MobileNetV2 without the top (classification) layers.** The base model's convolutional layers, which have learned rich visual features from ImageNet, are retained.
2. **Freeze the base model weights (initially).** During the first phase of training, the weights of the pre-trained layers are frozen (not updated), and only the new classification head is trained. This prevents the pre-learned features from being destroyed by the early, noisy gradient updates.
3. **Add a custom classification head.** A global average pooling layer, one or more dense layers (with dropout for regularisation), and a final dense layer with six units (one per emotion class) and softmax activation are added on top of the base model.
4. **Train the classification head.** The model is trained on the emotion recognition dataset, with only the new layers being updated. This phase typically converges quickly.
5. **Fine-tune the full model (optional).** After the classification head has been trained, some or all of the base model layers may be unfrozen and the entire network fine-tuned with a low learning rate. This allows the pre-learned features to be subtly adapted to the nuances of the emotion recognition task without overfitting or catastrophic forgetting.

[Figure 3: CNN Architecture – MobileNetV2 Adaptation]

#### 8.5.2 MobileNetV2 Architecture Details

MobileNetV2 is built upon depthwise separable convolutions and introduces two key innovations: inverted residual blocks and linear bottlenecks (Sandler et al., 2018). A standard convolution applies a single set of filters across all input channels, resulting in a computational cost proportional to the product of the number of input channels, the number of output channels, and the spatial dimensions of the filter. Depthwise separable convolutions decompose this into two steps: (1) a depthwise convolution, which applies a single filter per input channel, and (2) a pointwise convolution (1×1 convolution), which combines the outputs across channels. This decomposition reduces computational cost by a factor of approximately $1/N + 1/D_K^2$, where $N$ is the number of output channels and $D_K$ is the kernel size.

The inverted residual block in MobileNetV2 proceeds as follows: (1) a 1×1 convolution expands the input to a higher-dimensional space (expansion factor of 6 is typical); (2) a 3×3 depthwise convolution processes the expanded features; (3) a 1×1 convolution projects the features back to a lower-dimensional bottleneck; and (4) a skip connection adds the input to the output (if the input and output dimensions match). The "linear" aspect of the linear bottleneck refers to the absence of a non-linear activation function after the final projection layer. Sandler et al. (2018) argue that applying a non-linear activation (e.g., ReLU) to low-dimensional features can destroy information, and that a linear projection preserves more of the learned representation.

### 8.6 Data Augmentation Techniques

Data augmentation is a regularisation technique that involves applying label-preserving transformations to the training data to artificially increase the effective size and diversity of the dataset (Shorten and Khoshgoftaar, 2019). For facial expression recognition, the following augmentation techniques are employed:

[Table 8: Data Augmentation Techniques and Parameters]

| Technique | Parameter Range | Rationale |
|---|---|---|
| Random horizontal flip | 50% probability | Faces are approximately symmetrical; flipping preserves emotion labels |
| Random rotation | ±15 degrees | Simulates head tilt; within range that preserves face visibility |
| Random zoom | ±10% | Simulates varying camera distances |
| Random brightness adjustment | ±20% | Simulates varying lighting conditions |
| Random contrast adjustment | ±20% | Simulates varying image quality and exposure |
| Random translation (shift) | ±10% horizontal and vertical | Simulates imperfect face centering |
| Gaussian noise (optional) | Low intensity | Simulates camera noise on low-quality devices |

Augmentation is applied dynamically during training (on-the-fly), so that each training epoch sees slightly different versions of the images, effectively increasing the diversity of the training set without requiring additional storage. The choice and intensity of augmentation are guided by the characteristics of the target deployment environment (e.g., variable lighting and head pose in real-world use) and by the need to avoid introducing unrealistic distortions that could harm model performance (Shorten and Khoshgoftaar, 2019).

### 8.7 Model Quantization for Mobile Deployment

TensorFlow Lite supports post-training quantization, which reduces the precision of model weights and activations from 32-bit floating point to lower precision (e.g., 8-bit integers or 16-bit floating point). This has several benefits for mobile deployment:

1. **Reduced model size:** An 8-bit quantized model is approximately one-quarter the size of the original float32 model, reducing storage requirements and app download size.
2. **Faster inference:** Integer arithmetic is faster than floating-point arithmetic on many mobile processors, resulting in lower inference latency.
3. **Lower power consumption:** Reduced computational requirements translate to lower power consumption, which is important for battery-powered mobile devices.

The quantization process in TensorFlow Lite involves the following steps:

1. **Train the model in full precision** (float32) using TensorFlow/Keras on a suitable training platform (e.g., Google Colab with GPU).
2. **Save the trained model** in the Keras or SavedModel format.
3. **Convert to TensorFlow Lite format** using the TFLite Converter, specifying the desired quantization scheme (e.g., dynamic range quantization, full integer quantization, or float16 quantization).
4. **Evaluate the quantized model** on the test set to verify that accuracy is maintained within acceptable bounds.

Jacob et al. (2018) demonstrated that post-training quantization can reduce model size by 4× and improve inference speed by 2–3× with minimal accuracy loss (typically less than 1–2 percentage points) for many architectures, including MobileNet. In this project, dynamic range quantization is applied as the default, with full integer quantization explored if further size or speed reduction is needed.

### 8.8 Evaluation Metrics

#### 8.8.1 Confusion Matrix

A confusion matrix is a table that summarises the performance of a classification model by comparing predicted labels to true labels for each class. For a six-class problem, the confusion matrix is a 6×6 table, where the element at row $i$ and column $j$ represents the number of samples whose true class is $i$ and whose predicted class is $j$. The diagonal elements represent correct classifications (true positives for each class), and off-diagonal elements represent misclassifications.

The confusion matrix is a valuable diagnostic tool because it reveals not only how often the model is incorrect, but also which specific classes are most often confused with each other. For example, if the model frequently confuses "sad" with "tired," this may indicate that these two expressions share visual features that are difficult for the model to distinguish, or that the training data for these classes is insufficiently diverse or distinctively labelled.

#### 8.8.2 Precision, Recall, and F1 Score

From the confusion matrix, the following per-class metrics are derived:

**Precision** (positive predictive value) for class $c$:

$$
P_c = \frac{TP_c}{TP_c + FP_c}
$$

Precision measures the proportion of predicted positives that are true positives. High precision means that when the model predicts class $c$, it is usually correct.

**Recall** (sensitivity, true positive rate) for class $c$:

$$
R_c = \frac{TP_c}{TP_c + FN_c}
$$

Recall measures the proportion of actual positives that are correctly identified. High recall means that the model correctly identifies most instances of class $c$.

**F1 Score** for class $c$:

$$
F1_c = 2 \cdot \frac{P_c \cdot R_c}{P_c + R_c}
$$

The F1 score is the harmonic mean of precision and recall, providing a single metric that balances both. It is particularly useful when class distributions are imbalanced, as it penalises models that achieve high precision at the expense of recall or vice versa.

**Macro-averaged F1** is the unweighted mean of per-class F1 scores, giving equal weight to each class regardless of its frequency in the dataset. **Weighted-averaged F1** weights each class's F1 by its frequency, giving more weight to classes with more samples. Both are reported to provide a comprehensive view of model performance.

#### 8.8.3 Overall Accuracy

Overall accuracy is defined as:

$$
\text{Accuracy} = \frac{\text{Number of correct predictions}}{\text{Total number of predictions}}
$$

Accuracy is a widely used and intuitive metric, but it can be misleading for imbalanced datasets (e.g., if "neutral" accounts for 40% of the data, a model that always predicts "neutral" would achieve 40% accuracy without learning anything useful). For this reason, precision, recall, F1, and the confusion matrix are reported alongside accuracy to provide a more complete picture of model performance.

#### 8.8.4 ROC Curve and AUC

Receiver operating characteristic (ROC) curves and the area under the curve (AUC) may be computed for each class in a one-vs-rest manner. The ROC curve plots the true positive rate (recall) against the false positive rate at various classification thresholds, and the AUC summarises the overall discriminative ability of the model for each class. An AUC of 1.0 indicates perfect discrimination; 0.5 indicates chance-level performance. These metrics are primarily used for diagnostic purposes and to compare model variants.

#### 8.8.5 Inference Time and Model Size

Practical deployment metrics include inference time (milliseconds per frame), model size (MB), and memory usage. These are measured on a representative mid-range smartphone to ensure that the model meets the non-functional performance requirements (< 500 ms inference, reasonable model size for app bundling).

### 8.9 Data Collection Strategy

#### 8.9.1 Dataset Composition

Data collection aims to assemble 2,000–5,000 labelled facial images across the six emotion classes (happy, sad, angry, fear, neutral, tired). The target distribution is approximately balanced across classes, with some allowance for natural class imbalance (e.g., "neutral" may be more common than "fear" in a typical data collection setting). The planned distribution is:

[Table 3: Dataset Distribution by Emotion]

| Emotion Class | Target Count (approx.) | Percentage |
|---|---|---|
| Happy | 350–850 | ~17% |
| Sad | 350–850 | ~17% |
| Angry | 300–750 | ~15% |
| Fear | 250–650 | ~13% |
| Neutral | 400–1000 | ~20% |
| Tired | 350–900 | ~18% |
| **Total** | **2,000–5,000** | **100%** |

#### 8.9.2 Data Sources

The dataset is assembled from two complementary sources:

1. **Existing public datasets:** Established facial expression datasets (e.g., FER2013, RAF-DB, AffectNet, or subsets thereof) are filtered and relabelled to match the six target classes. The "tired" class, which is not standard in most FER datasets, is approximated by selecting images labelled as "fatigue," "drowsy," or similar, or by collecting purpose-built data for this class. Public datasets provide a large and diverse foundation for training but may not fully represent the target population (children in Sri Lanka).

2. **Purpose-collected data:** Following ethics approval from the institutional ethics committee and, where required, the Ministry of Health, purpose-built data is collected from consenting participants in collaboration with Karapitiya Teaching Hospital. Data collection protocols define consent procedures, capture conditions (lighting, pose constraints, device specifications), and labelling procedures (single or multiple annotators, with inter-rater reliability checks). Efforts are made to include children of the target age group and cultural background, while respecting the constraints of ethics approval and participant availability.

#### 8.9.3 Data Collection Protocol

The data collection protocol includes the following elements:

- **Informed consent:** Written consent from parents/guardians; accessible assent from children where appropriate.
- **Capture conditions:** Images captured using standard smartphones in naturalistic settings (e.g., clinic room, waiting area) with adequate lighting. Front-facing camera at approximately arm's length. No special equipment required.
- **Labelling:** Each image is labelled with the appropriate emotion class by at least one trained annotator. For a subset, two or more annotators provide independent labels, and inter-rater reliability (e.g., Cohen's kappa) is computed to assess labelling consistency.
- **Quality control:** Corrupt, blurred, or unrecognisable images are excluded. Images in which the face is not clearly visible (>30% occlusion) are excluded.
- **Metadata:** Age, gender, and consent status are recorded for each image (anonymised). Device type and capture conditions (indoor/outdoor, lighting) are noted where feasible.
- **Storage and security:** All images are stored securely (encrypted at rest), with access restricted to authorised project personnel. Images are de-identified (no names or identifiers linked to images; random numeric IDs used). Retention and disposal policies are defined in the ethics protocol.

[Figure 4: Facial Expression Data Collection Workflow]

### 8.10 Regularisation Techniques

To prevent overfitting and improve generalisation, the following regularisation techniques are employed:

- **Dropout:** Randomly deactivating a proportion of neurons during training (typically 20–50% of units in dense layers) forces the network to learn more robust features that do not depend on any single neuron (Srivastava et al., 2014). Dropout is applied to the dense layers of the classification head.
- **Early stopping:** Training is monitored on a validation set, and training is stopped when validation performance ceases to improve for a defined number of epochs (patience), preventing the model from overfitting to the training data.
- **Weight decay (L2 regularisation):** A penalty proportional to the squared magnitude of the weights is added to the loss function, discouraging large weights and promoting simpler models.
- **Data augmentation:** As described in Section 8.6, augmentation increases the effective diversity of the training data.
- **Batch normalisation:** Normalising the activations within each mini-batch stabilises training and can act as a mild regulariser (Ioffe and Szegedy, 2015).

### 8.11 Training Pipeline Summary

The training pipeline proceeds as follows:

1. Load and preprocess training, validation, and test datasets (resize, normalise, augment).
2. Load MobileNetV2 pre-trained on ImageNet, excluding the top layers.
3. Freeze the base model weights.
4. Add custom classification head (global average pooling, dense layers with dropout, output layer with softmax).
5. Compile the model (optimiser: Adam; loss: categorical cross-entropy; metrics: accuracy).
6. Train the classification head for a defined number of epochs, monitoring validation accuracy.
7. (Optional) Unfreeze some or all base model layers and fine-tune the entire network with a reduced learning rate.
8. Evaluate on the test set: compute accuracy, precision, recall, F1, confusion matrix, and (optionally) ROC/AUC.
9. Convert the trained model to TensorFlow Lite format with post-training quantization.
10. Benchmark the TFLite model on a target device (inference time, model size).
11. Integrate the TFLite model into the Flutter application via platform channels.

The training infrastructure uses Google Colab (or equivalent) with GPU acceleration for model training, and a local development machine for Flutter application development and testing. The TensorFlow ecosystem (Abadi et al., 2016) is used throughout for training, evaluation, conversion, and deployment.

---
