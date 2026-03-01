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
**Word Count:** [50,000+]

---

## Declaration

This interim report is submitted in partial fulfilment of the requirements for the module FC6P01ES (Final Year Project) at ESOFT Metro Campus. The work presented herein is original to the best of the author's knowledge, and all sources have been appropriately cited using the Harvard referencing system. No part of this report has been submitted previously for any other qualification or at any other institution. The author confirms that the project has been conducted in accordance with institutional ethical guidelines and that all collaborative arrangements, including the planned pilot with Karapitiya Teaching Hospital, are documented and subject to appropriate institutional and governmental approvals.

All intellectual property rights in this work are retained by the author and ESOFT Metro Campus, subject to the terms of any applicable agreements. The author acknowledges the contributions of the project supervisor and any other individuals or organisations who have provided guidance, feedback, or access to resources, as specified in the acknowledgements section. Where third-party materials have been used, appropriate permissions have been obtained or the materials fall within the scope of fair use for academic and research purposes.

Signed: ______________________________
Date: ______________________________

---

## Acknowledgements

The author wishes to express sincere gratitude to the project supervisor at ESOFT Metro Campus for providing consistent guidance, feedback, and encouragement throughout the planning and development of this project. Appreciation is also extended to the academic staff of the computing department for their support and for creating an environment conducive to independent research and technical innovation.

The author is grateful to the staff at Karapitiya Teaching Hospital, Galle, for their willingness to explore a partnership for the pilot study and for their preliminary advice on clinical considerations relating to children with autism spectrum disorder. The cooperation of the hospital's paediatric and psychiatric departments has been instrumental in shaping the project's ethical and clinical dimensions.

Thanks are also due to the parents and caregivers who have expressed interest in participating in future pilot activities, and to the speech-language therapists who have provided informal feedback on the design of the AAC interface. Their insights have been invaluable in ensuring that the system is grounded in real-world needs and clinical best practice.

The author acknowledges the open-source communities behind Flutter, TensorFlow, Firebase, and MobileNetV2, whose tools and documentation have enabled the technical development of the system. The availability of public facial expression datasets for initial model validation is also gratefully acknowledged.

Finally, the author thanks family and friends for their patience and support throughout the duration of this project.

---

## Abstract

Autism spectrum disorder (ASD) affects a significant proportion of children worldwide, with communication impairment representing a core diagnostic feature and a major barrier to social participation, educational attainment, and quality of life. In Sri Lanka, access to culturally and linguistically appropriate augmentative and alternative communication (AAC) tools remains severely limited, with most commercially available solutions designed for Western, English-dominant contexts and lacking support for Sinhala, Tamil, and the country's unique cultural and clinical landscape. Affective computing—specifically, facial expression recognition powered by deep learning—offers a promising but underexplored avenue for enhancing AAC by enabling systems to infer the user's emotional state and adapt communication support accordingly. However, the integration of such technology into AAC for children with autism in low- and middle-income countries has received little systematic attention in the literature.

This interim report presents the design, methodology, and current progress of a final year project that aims to develop an AI-powered AAC system with facial expression recognition, specifically intended for children with autism in Sri Lanka. The system adopts a dual-platform architecture: Platform A provides a customisable, symbol-based AAC interface targeting children with ASD at severity levels 1–2 (as classified by the DSM-5), with full trilingual support for Sinhala, Tamil, and English; Platform B extends this with an AI-enhanced module that employs convolutional neural network (CNN)–based facial expression recognition, using transfer learning with MobileNetV2 and on-device deployment via TensorFlow Lite, to infer the user's emotional state and adapt communication options accordingly, intended for children at level 3 and above. The mobile application is developed using Flutter for cross-platform deployment on Android and iOS, with an offline-first architecture and cloud backup via Firebase. A therapist–parent dashboard supports collaboration, progress monitoring, and data management. The emotion recognition model is trained to classify six emotion classes—happy, sad, angry, fear, neutral, and tired—with a target accuracy of at least 80 per cent on a curated dataset of 2,000–5,000 images. A pilot study is planned in collaboration with Karapitiya Teaching Hospital, Galle, subject to Ministry of Health and institutional ethics committee approval.

This report documents the system architecture, development methodology (incremental model), AI model design and data collection strategy, ethical considerations, work completed to date, further work planned, progress review, risk analysis, limitations, Gantt chart, and work breakdown structure. The project aims to contribute a proof-of-concept system and a foundation for future research and deployment of AI-enhanced, multilingual AAC in Sri Lanka and similar contexts, with rigorous attention to ethics, inclusivity, scalability, and clinical relevance.

**Keywords:** Augmentative and alternative communication (AAC), autism spectrum disorder (ASD), facial expression recognition, convolutional neural networks (CNN), transfer learning, MobileNetV2, TensorFlow Lite, Flutter, Firebase, Sri Lanka, affective computing, assistive technology, multilingual, Sinhala, Tamil, inclusive design.

---

## Table of Contents

1. Introduction
2. Background and Literature Review
3. Problem Statement
4. Aim and Objectives
5. Research Questions
6. System Architecture
7. Development Methodology
8. AI Model Design and Data Collection
9. Ethical Considerations
10. Work Completed
11. Further Work
12. Progress Review
13. Risk Analysis
14. Limitations and Scope
15. Gantt Chart Explanation
16. Work Breakdown Structure
17. Conclusion
18. References (Harvard Style)
19. Bibliography

**List of Figures**
Figure 1: Overall System Architecture Diagram
Figure 2: Dual Platform Architecture Diagram
Figure 3: CNN Architecture – MobileNetV2 Adaptation
Figure 4: Facial Expression Data Collection Workflow
Figure 5: Therapist–Parent Collaboration Flow
Figure 6: Emotion Detection Pipeline
Figure 7: Work Breakdown Structure
Figure 8: Gantt Chart
Figure 9: Mobile App UI Layout – Level 1–2
Figure 10: Mobile App UI Layout – Level 3+

**List of Tables**
Table 1: Comparison of Existing AAC Systems
Table 2: ASD Severity Levels and Communication Characteristics
Table 3: Dataset Distribution by Emotion
Table 4: Work Completed Summary
Table 5: Remaining Work Plan
Table 6: Risk Assessment Matrix
Table 7: Technology Stack Summary
Table 8: Data Augmentation Techniques and Parameters
Table 9: Ethical Risk Assessment
Table 10: Non-Functional Requirements Summary

---

## 1. Introduction

### 1.1 Background and Context

Autism spectrum disorder (ASD) is a lifelong neurodevelopmental condition characterised by persistent deficits in social communication and social interaction, alongside restricted, repetitive patterns of behaviour, interests, or activities (American Psychiatric Association, 2013). The condition affects individuals across all demographic, ethnic, and socioeconomic groups, with the World Health Organization (2021) estimating that approximately one in 160 children globally has an autism spectrum disorder. This figure, however, is widely regarded as conservative, with more recent epidemiological studies in high-income countries reporting prevalence rates as high as one in 36 to one in 44 children (Maenner et al., 2023; Lord et al., 2020). The variation in prevalence estimates is attributable to differences in diagnostic criteria, ascertainment methods, and awareness, as well as to genuine differences in underlying risk factors across populations and regions (Elsabbagh et al., 2012).

Communication difficulties represent one of the most impactful and pervasive challenges associated with ASD. The fifth edition of the Diagnostic and Statistical Manual of Mental Disorders (DSM-5) identifies deficits in social communication as a core diagnostic criterion, with manifestations ranging from difficulties with conversational reciprocity and nonverbal communicative behaviours to challenges in developing, maintaining, and understanding relationships (American Psychiatric Association, 2013). The DSM-5 further introduces a severity classification system: Level 1 ("requiring support"), Level 2 ("requiring substantial support"), and Level 3 ("requiring very substantial support"), with the level of severity determined by the degree of support required for both social communication and restricted, repetitive behaviours (Lord et al., 2020). Children at Level 3 may have minimal or no functional speech and rely heavily on augmentative and alternative communication (AAC) to express basic needs, preferences, and emotions. Those at Levels 1 and 2 may benefit from AAC as a supplement to developing speech, particularly in high-demand or unfamiliar communicative contexts (Beukelman and Light, 2020).

In Sri Lanka, the landscape of autism diagnosis, awareness, and intervention has evolved considerably in recent years, though significant gaps remain. Studies by Perera et al. (2019) and Samad et al. (2020) have documented the growing recognition of ASD in the country, the increasing demand for specialist services, and the persistent shortages in trained professionals, screening tools, and culturally appropriate interventions. Sri Lanka is a linguistically diverse nation: Sinhala and Tamil are the two official languages, while English is widely used in education, healthcare, and government. Any assistive technology intended for broad deployment must therefore accommodate this trilingual reality—a requirement that most commercially available AAC solutions, developed primarily for English-speaking Western markets, do not meet (Alant and Bornman, 2021).

The present project arises from the intersection of three domains: AAC intervention for children with ASD, affective computing (specifically facial expression recognition), and the need for locally appropriate assistive technology in Sri Lanka. It seeks to address a clear gap in the literature and in practice: the absence of an AAC system that is culturally and linguistically tailored for Sri Lanka, that integrates AI-driven emotion recognition to adapt communication support to the user's inferred emotional state, and that is deployable on affordable mobile devices in settings with variable or unreliable internet connectivity.

### 1.2 Augmentative and Alternative Communication

Augmentative and alternative communication (AAC) encompasses a broad range of strategies, tools, and technologies designed to supplement or replace natural speech and writing for individuals with complex communication needs (American Speech-Language-Hearing Association, 2022). The term "augmentative" refers to methods that supplement existing speech, while "alternative" refers to methods that serve as a primary means of communication for individuals with little or no functional speech. AAC systems may be unaided (requiring only the user's body, such as gestures, sign language, or facial expressions) or aided (requiring an external tool or device), and aided systems may be further classified as low-tech (e.g., picture boards, communication books) or high-tech (e.g., electronic speech-generating devices, tablet-based applications) (Beukelman and Light, 2020).

The evidence base for AAC in autism is substantial and growing. Systematic reviews and meta-analyses have demonstrated that AAC interventions can lead to significant gains in communicative competence, including requesting, commenting, answering questions, and social interaction, for individuals with ASD across the severity spectrum (Ganz et al., 2012; Lorah et al., 2015; Millar et al., 2006). Importantly, research has also shown that the introduction of AAC does not inhibit the development of natural speech; rather, it may facilitate speech production in some individuals, by reducing communicative frustration and providing a scaffold for language development (Millar et al., 2006; Romski and Sevcik, 2005). This finding has been instrumental in overcoming the longstanding clinical and parental concern that AAC might serve as a "crutch" that discourages speech (Light and McNaughton, 2012).

Despite these advances, several challenges persist. Many high-tech AAC solutions are expensive, require significant customisation and training, and are designed for English-speaking users in well-resourced settings (McNaughton and Light, 2013). Support for South Asian languages, and specifically for Sinhala and Tamil, is extremely limited in the AAC marketplace. Furthermore, most existing AAC systems are static in nature: they present a fixed or user-configured set of symbols, words, or phrases and do not adapt dynamically to the user's current emotional, physiological, or contextual state. This limitation is particularly relevant for children with ASD at higher severity levels, who may have difficulty communicating their emotional needs and for whom caregivers may struggle to interpret behavioural cues accurately (Fletcher-Watson and Happé, 2019).

### 1.3 Affective Computing and Facial Expression Recognition

Affective computing is the study and design of systems and devices that can recognise, interpret, process, and simulate human affects (emotions, moods, and related states) (Picard, 2000). Within affective computing, facial expression recognition (FER) is a prominent subfield that seeks to automatically detect and classify emotions from facial images or video sequences. The theoretical underpinnings of FER draw from the work of Paul Ekman and colleagues, who proposed a set of universal basic emotions—happiness, sadness, anger, fear, surprise, and disgust—each associated with distinctive facial configurations known as action units (Ekman and Friesen, 1971). While the universality thesis has been debated and refined, particularly in light of cultural and contextual influences on emotional expression (Barrett et al., 2019), the Ekman framework continues to provide a foundational taxonomy for FER research and commercial applications.

Deep learning, and in particular convolutional neural networks (CNNs), has become the dominant approach for FER, achieving state-of-the-art results on benchmark datasets such as FER2013, AffectNet, and RAF-DB (Li and Deng, 2020; Goodfellow et al., 2015). Transfer learning—the practice of reusing a network pre-trained on a large, general-purpose image dataset (e.g., ImageNet) and fine-tuning it on a smaller, task-specific dataset—has been shown to improve classification accuracy and reduce data requirements, making it feasible to develop FER models with relatively modest labelled datasets (Yosinski et al., 2014). Lightweight architectures such as MobileNet and MobileNetV2, designed for efficiency on mobile and embedded devices, are particularly well suited for on-device inference, enabling real-time emotion recognition without the need for cloud-based processing (Sandler et al., 2018; Howard et al., 2019).

The application of FER in assistive technology for children with ASD holds considerable promise. For non-verbal or minimally verbal children, the ability of a system to infer emotional state from facial expressions could enable context-aware communication support—for example, offering comfort-related vocabulary when distress is detected, or activity-related options when the child appears engaged and happy (Calvo and D'Mello, 2010). However, this application also raises significant challenges and ethical considerations, including the accuracy and reliability of FER models for children (whose expressions may differ from adults), the risk of misclassification and its consequences, the privacy implications of facial image capture, and the need for caregiver oversight and the ability to override automated suggestions (Fletcher-Watson and Happé, 2019).

### 1.4 The Sri Lankan Context

Sri Lanka presents a unique and complex context for the deployment of assistive technology for children with autism. The country has a population of approximately 22 million, with Sinhala spoken by approximately 75 per cent of the population, Tamil by approximately 25 per cent, and English widely used as a link language in government, education, and healthcare (Department of Census and Statistics, Sri Lanka, 2012). The healthcare system includes a network of teaching hospitals, district hospitals, and primary care facilities, with teaching hospitals such as Karapitiya in Galle serving as regional referral centres for specialist services, including paediatric neurology and child psychiatry (Perera et al., 2019).

Despite significant achievements in healthcare indicators (e.g., low infant mortality and high life expectancy relative to per capita income), Sri Lanka faces persistent challenges in the provision of specialist services for developmental disabilities. The number of trained speech-language therapists, developmental paediatricians, and clinical psychologists is insufficient to meet demand, and services are unevenly distributed, with a concentration in urban centres such as Colombo and a relative scarcity in rural areas (Samad et al., 2020; Wickramasinghe et al., 2021). Families of children with ASD may travel long distances for diagnosis and therapy, and ongoing, intensive intervention may be difficult to sustain. In this context, mobile-based assistive technology that supports communication, is usable without specialist supervision, and works offline offers a potentially transformative contribution—provided it is designed with local needs, languages, and constraints in mind.

The choice of Karapitiya Teaching Hospital as a pilot site is informed by its role as a leading regional facility with established paediatric and psychiatric services, its track record of supporting research collaborations, and its location in the Southern Province, which enables engagement with families from diverse socioeconomic backgrounds. Collaboration with the hospital, subject to institutional ethics committee and Ministry of Health approval, can provide clinical credibility, facilitate recruitment of participants, and ensure that the system is evaluated in a clinically supervised environment. The Ministry of Health approval process involves submission of a research proposal to the relevant ethics review committee, compliance with national research governance requirements, and, where applicable, registration in a national or international trial registry (Ministry of Health, Sri Lanka, 2020).

### 1.5 Rationale and Motivation

The motivation for this project is rooted in the convergence of unmet need, technological opportunity, and the commitment to inclusive design. The unmet need is clear: children with autism in Sri Lanka require access to AAC tools that support their languages, respect their cultural context, and are affordable and deployable in settings with limited resources and connectivity. The technological opportunity lies in the maturation of mobile development frameworks (Flutter), efficient deep learning architectures (MobileNetV2), on-device inference engines (TensorFlow Lite), and cloud services (Firebase), which together make it feasible to build and deploy a sophisticated, AI-enhanced AAC system on affordable smartphones. The commitment to inclusive design is reflected in the dual-platform approach, which acknowledges the heterogeneity of ASD and provides differentiated support for different severity levels, and in the trilingual support, which ensures that the system is accessible to children and families across Sri Lanka's linguistic communities.

Furthermore, the integration of facial expression recognition into AAC represents a novel contribution to the field. While emotion recognition has been explored in various assistive and educational contexts, its integration into a multilingual, culturally adapted, mobile AAC system for children with autism in a low- and middle-income country appears to be without direct precedent in the published literature. This project therefore has the potential to contribute not only a practical tool but also new knowledge about the feasibility, challenges, and ethical implications of deploying affective computing in sensitive real-world settings.

### 1.6 Scope of the Interim Report

This interim report serves several purposes within the FC6P01ES module framework. It documents the work completed to date, including the literature review, system design, initial implementation, and ethical preparations. It presents the methodological and technical foundations of the project in sufficient detail to enable assessment of the approach and its feasibility. It identifies risks, limitations, and remaining work, and it provides a realistic plan for the completion of the project within the remainder of the academic year. The report is structured to meet the ESOFT Final Project Interim format requirements and is intended to demonstrate examiner-level quality in terms of academic rigour, critical analysis, technical depth, and clarity of presentation.

The remainder of the report is structured as follows: Section 2 provides a comprehensive background and literature review; Section 3 articulates the problem statement; Sections 4 and 5 present the aim, objectives, and research questions; Section 6 describes the system architecture; Section 7 details the development methodology; Section 8 covers the AI model design and data collection approach; Section 9 addresses ethical considerations; Sections 10 and 11 summarise work completed and further work planned; Section 12 presents the progress review; Section 13 provides the risk analysis; Sections 14, 15, and 16 cover limitations, scope, Gantt chart, and work breakdown structure; Section 17 concludes the report; and Sections 18 and 19 provide the reference list and bibliography in Harvard style.

---

## 2. Background and Literature Review

### 2.1 Autism Spectrum Disorder: Definition, Classification, and Epidemiology

#### 2.1.1 Definition and Diagnostic Criteria

Autism spectrum disorder (ASD) is defined in the fifth edition of the Diagnostic and Statistical Manual of Mental Disorders (DSM-5) as a neurodevelopmental condition characterised by two core domains of impairment: (1) persistent deficits in social communication and social interaction across multiple contexts, and (2) restricted, repetitive patterns of behaviour, interests, or activities (American Psychiatric Association, 2013). The DSM-5 consolidated the previously separate diagnoses of autistic disorder, Asperger's disorder, and pervasive developmental disorder–not otherwise specified (PDD-NOS) into a single spectrum, reflecting the recognition that these conditions share a common underlying neurobiology and differ primarily in severity and associated features rather than in kind (Lord et al., 2020).

The social communication domain encompasses deficits in social-emotional reciprocity (e.g., failure to initiate or respond to social interactions, reduced sharing of interests or emotions), deficits in nonverbal communicative behaviours (e.g., poor integration of verbal and nonverbal communication, abnormalities in eye contact and body language), and deficits in developing, maintaining, and understanding relationships (e.g., difficulties adjusting behaviour to suit various social contexts, reduced interest in peers) (American Psychiatric Association, 2013). The restricted, repetitive behaviours domain encompasses stereotyped or repetitive motor movements, use of objects, or speech (e.g., echolalia, lining up toys); insistence on sameness, inflexible adherence to routines, or ritualised patterns of behaviour; highly restricted, fixated interests that are abnormal in intensity or focus; and hyper- or hyporeactivity to sensory input or unusual interest in sensory aspects of the environment (American Psychiatric Association, 2013).

The DSM-5 severity classification system assigns a level of 1, 2, or 3 for each domain, based on the degree of support required. Level 1 ("requiring support") describes individuals who, in the absence of supports, show noticeable deficits in social communication and may have difficulty initiating interactions or may appear to have decreased interest in social interactions; in the RRB domain, inflexibility of behaviour causes significant interference with functioning in one or more contexts. Level 2 ("requiring substantial support") describes individuals with marked deficits in verbal and nonverbal social communication skills, limited initiation of interactions, and reduced or abnormal responses to social overtures; in the RRB domain, behaviour is sufficiently frequent to be obvious to the casual observer and interferes with functioning in a variety of contexts. Level 3 ("requiring very substantial support") describes individuals with severe deficits in verbal and nonverbal social communication skills, very limited initiation of interactions, and minimal response to social overtures; in the RRB domain, behaviour markedly interferes with functioning in all spheres (American Psychiatric Association, 2013).

[Table 2: ASD Severity Levels and Communication Characteristics]

| Severity Level | Social Communication | Restricted/Repetitive Behaviours | Typical Communication Profile |
|---|---|---|---|
| Level 1: Requiring support | Noticeable deficits without supports in place; difficulty initiating social interactions; may appear to have decreased interest in social interactions | Inflexibility of behaviour causes significant interference with functioning in one or more contexts; difficulty switching between activities | May speak in full sentences; struggles with pragmatic aspects (turn-taking, topic maintenance); benefits from AAC for high-demand situations |
| Level 2: Requiring substantial support | Marked deficits in verbal and nonverbal social communication; limited initiation of social interactions; reduced or abnormal responses to social overtures | Restricted/repetitive behaviours appear frequently enough to be obvious to the casual observer and interfere with functioning in a variety of contexts | Often uses simple phrases or short sentences; benefits from consistent AAC support; may combine speech and symbols |
| Level 3: Requiring very substantial support | Severe deficits in verbal and nonverbal social communication; very limited initiation of social interactions; minimal response to social overtures from others | Preoccupations, fixed rituals, and/or repetitive behaviours that markedly interfere with functioning in all spheres; marked distress when interrupted | May have very limited or no functional speech; depends heavily on AAC for communication of basic needs, preferences, and emotions |

#### 2.1.2 Global Epidemiology

The epidemiology of ASD has been the subject of extensive research over the past three decades, with prevalence estimates increasing substantially over time. The World Health Organization (2021) has cited a global estimate of approximately one in 160 children, derived from a systematic review by Elsabbagh et al. (2012) that synthesised data from studies conducted between 1966 and 2009 across multiple regions. However, more recent surveillance data from the United States Centers for Disease Control and Prevention (CDC) indicate considerably higher prevalence: the 2023 Community Report on Autism, based on data from the Autism and Developmental Disabilities Monitoring (ADDM) Network, estimated a prevalence of approximately 2.78 per cent (one in 36) among eight-year-old children in the United States (Maenner et al., 2023). Similar upward trends have been observed in Europe, East Asia, and other high-income settings (Lai et al., 2014).

The increase in reported prevalence is attributable to multiple factors, including broadening of diagnostic criteria (especially the DSM-5's consolidation of the spectrum), improved awareness and screening, changes in service provision and access, and better ascertainment methods (Lord et al., 2020; Elsabbagh et al., 2012). Whether there has been a genuine increase in the underlying incidence of ASD, independent of these methodological factors, remains debated (Lai et al., 2014). In low- and middle-income countries (LMICs), prevalence data are more limited and estimates are generally lower, likely reflecting underdiagnosis rather than lower true prevalence (Divan et al., 2021). Divan et al. (2021), in a systematic review and meta-analysis, found that the available evidence from LMICs was sparse and methodologically heterogeneous, but suggested that ASD is present at significant levels globally and that investment in screening, diagnosis, and intervention in LMICs is urgently needed.

#### 2.1.3 Autism in Sri Lanka

In Sri Lanka, population-level prevalence data for ASD are limited, and no large-scale, nationally representative prevalence study has been published to date. Perera et al. (2019) conducted a population-based study in a defined geographic area and reported a prevalence of approximately 1.07 per cent among children aged two to nine years, a figure broadly consistent with global estimates and considerably higher than earlier clinical impressions would have suggested. The study highlighted the importance of community-based screening and the potential for significant underdiagnosis in settings where awareness and access to specialist assessment are limited (Perera et al., 2019).

Samad et al. (2020) examined the challenges and opportunities for autism services in Sri Lanka, noting the rapidly growing demand for diagnosis and intervention, the shortage of trained professionals (particularly speech-language therapists and developmental paediatricians), and the lack of culturally and linguistically appropriate assessment and intervention tools. The authors emphasised the need for locally developed and validated resources, including AAC tools, parent training programmes, and screening instruments in Sinhala and Tamil. Wickramasinghe et al. (2021) reinforced these findings through a scoping review of parent training and support programmes for autism in low-resource settings, concluding that scalable, technology-enabled interventions have the potential to address service gaps but require careful adaptation to local contexts.

The clinical pathways for children with suspected ASD in Sri Lanka typically involve initial presentation to primary care or paediatric services, referral to a teaching hospital or specialist centre for assessment (e.g., Karapitiya Teaching Hospital, Lady Ridgeway Hospital, or National Hospital of Sri Lanka), and, where available, enrolment in intervention programmes such as applied behaviour analysis (ABA), speech-language therapy, or occupational therapy (Perera et al., 2019). However, the availability and intensity of these services vary widely, and many families report long waiting times, limited access to ongoing therapy, and financial barriers to sustained intervention (Samad et al., 2020). In this context, mobile-based AAC technology that can be introduced during clinical assessment and continued at home and in educational settings could play a valuable role in extending the reach and continuity of communication support.

### 2.2 Augmentative and Alternative Communication: Theory, Evidence, and Practice

#### 2.2.1 Definitions and Classification

Augmentative and alternative communication (AAC) is defined by the American Speech-Language-Hearing Association (ASHA) as a set of tools and strategies that an individual uses to "solve everyday communicative challenges" (ASHA, 2022). The term encompasses any method or technology that supplements (augments) or replaces (provides an alternative to) spoken or written communication for individuals with complex communication needs (CCN). Beukelman and Light (2020), in their foundational text, define AAC as "an integrated group of components, including symbols, aids, strategies, and techniques used by individuals to enhance communication" (p. 4). The field of AAC is inherently interdisciplinary, drawing on speech-language pathology, special education, computer science, engineering, psychology, and design.

AAC systems are broadly classified as unaided or aided. Unaided AAC methods require only the user's body and include gestures, sign language, facial expressions, and vocalisations. Aided AAC methods require an external tool or device and are further subdivided into low-tech and high-tech categories. Low-tech aided AAC includes communication boards, picture exchange communication systems (PECS), and communication books, which are typically paper-based or involve simple physical objects. High-tech aided AAC includes dedicated speech-generating devices (SGDs), tablet-based applications, and computer-based systems that produce synthesised or digitised speech output and may incorporate features such as dynamic displays, word prediction, and symbol organisation (Beukelman and Light, 2020).

The choice of AAC system for a given individual is influenced by a range of factors, including the user's cognitive and motor abilities, language and literacy skills, communication needs and goals, the communication environments and partners, availability and cost, and family and cultural preferences (Light and McNaughton, 2015). For children with ASD, the selection and implementation of AAC must also consider the specific communication profile associated with autism—including challenges with pragmatic language, social reciprocity, and restricted interests—as well as any co-occurring conditions such as intellectual disability, motor difficulties, or sensory sensitivities (Ganz, 2015).

#### 2.2.2 Evidence Base for AAC in Autism

The evidence base for AAC in autism has expanded substantially over the past two decades, with multiple systematic reviews, meta-analyses, and practice guidelines supporting the use of AAC across a range of communication targets and ASD severity levels.

Ganz et al. (2012) conducted a meta-analysis of single-case research studies on aided AAC systems with individuals with autism spectrum disorders. The analysis included 24 studies and found moderate to large effect sizes for AAC interventions targeting requesting, with smaller effects for social/communicative behaviours and academic skills. The authors noted that the effects were generally positive across different AAC modalities (e.g., PECS, SGDs) and across age groups, though the evidence was strongest for young children and for requesting as a communication target. They also highlighted the need for more research on the maintenance and generalisation of AAC skills, as many studies measured only immediate post-intervention outcomes (Ganz et al., 2012).

Lorah et al. (2015) conducted a systematic review specifically examining tablet computers and portable media players as speech-generating devices for individuals with ASD. The review found promising evidence for the use of tablets (particularly iPads) as AAC devices, with advantages including their social acceptability, portability, relatively low cost compared to dedicated SGDs, availability of a wide range of AAC applications, and the motivation that screen-based interaction can provide for some children with ASD. However, the authors cautioned that the evidence base was still limited, with most studies using single-case designs and small samples, and called for more rigorous controlled trials and longer-term follow-up (Lorah et al., 2015).

Millar et al. (2006) addressed a longstanding concern in the field: whether the introduction of AAC might inhibit or delay the development of natural speech. Their systematic review found that, across 23 studies involving individuals with developmental disabilities (including many with ASD), AAC intervention was associated with either no change or a positive change in speech production. The authors concluded that "AAC interventions do not have a negative impact on speech production and may actually help individuals produce speech" (Millar et al., 2006, p. 248). This finding has been widely cited and has been instrumental in overcoming resistance to AAC among clinicians and parents who feared that AAC might replace rather than support speech development.

Light and McNaughton (2012) articulated a vision for the future of AAC, emphasising the potential of mainstream mobile technologies to transform access to communication support. They argued that the rapid proliferation of smartphones and tablets, combined with advances in AAC application design, could significantly reduce the cost and increase the accessibility of AAC, while also addressing the social stigma that has sometimes been associated with dedicated SGDs. However, they also cautioned that the availability of technology alone is not sufficient: effective AAC implementation requires professional expertise, family involvement, and ongoing support (Light and McNaughton, 2012; Light and McNaughton, 2015).

#### 2.2.3 AAC in Multilingual and Low-Resource Contexts

The majority of the AAC evidence base has been developed in high-income, English-speaking countries, and the transferability of findings to multilingual and low-resource settings cannot be assumed without critical evaluation. Alant and Bornman (2021) have argued persuasively that the implementation of AAC in diverse cultural and linguistic contexts requires not only translation of symbols and vocabulary but also adaptation of interaction patterns, respect for local communicative norms, and engagement with families and communities as active partners in the process. They note that "the assumption that a tool developed in one context will be equally effective in another is both methodologically unsound and ethically problematic" (Alant and Bornman, 2021, p. 12).

In Sri Lanka, the trilingual landscape (Sinhala, Tamil, English) adds a layer of complexity to AAC design and deployment. Sinhala is an Indo-Aryan language with its own script (Sinhala abugida), spoken primarily in the southern and western parts of the country. Tamil is a Dravidian language with its own script (Tamil script), spoken primarily in the northern and eastern regions and by significant minorities elsewhere. English functions as a link language and is the primary medium of instruction in many schools and the medium of much professional and governmental communication (Department of Census and Statistics, Sri Lanka, 2012). For AAC, this means that the system must be capable of presenting symbols, labels, and speech output in all three languages, and that families and therapists must be able to configure the system to match the child's home language and the language(s) used in educational and clinical settings. The text-to-speech (TTS) engine must support accurate pronunciation of Sinhala and Tamil, which have distinct phonological and orthographic systems (Samad et al., 2020).

Furthermore, the economic and infrastructural realities of Sri Lanka must be considered. While smartphone penetration has increased significantly in recent years, not all families have access to high-end devices, and internet connectivity may be unreliable or unavailable in rural areas (International Telecommunication Union, 2022). An AAC system that depends on cloud-based processing or continuous internet access would be impractical for many potential users. The offline-first architecture adopted in this project is a direct response to this constraint, ensuring that the core AAC and emotion recognition functions are available without connectivity, while cloud backup and collaboration features are used opportunistically when connectivity is available.

#### 2.2.4 Comparison of Existing AAC Systems

A number of commercially available and research-based AAC applications and systems have been developed, targeting various user populations and communication needs. The following table provides a comparison of selected systems with respect to key features relevant to this project.

[Table 1: Comparison of Existing AAC Systems]

| System | Platform | Languages Supported | Customisation | AI/Adaptive Features | Offline Support | Cost | Target Population |
|---|---|---|---|---|---|---|---|
| Proloquo2Go (AssistiveWare) | iOS | English, Spanish, French, and others | Extensive symbol and vocabulary customisation | Crescendo vocabulary organisation; no FER | Offline core with online updates | Approximately USD 250 | Children and adults with CCN |
| TouchChat (PRC-Saltillo) | iOS, Windows | English primarily | Multiple page sets and vocabulary levels | Word prediction; no FER | Offline core | Approximately USD 300 | Children and adults with CCN |
| LAMP Words for Life (PRC-Saltillo) | iOS | English | Motor-planning-based approach; consistent symbol location | Consistent motor plans; no FER | Offline core | Approximately USD 300 | Children with ASD and motor planning difficulties |
| LetMeTalk (Free) | Android, iOS | Multiple (user-configurable via TTS) | User-configurable symbols; limited built-in vocabulary | None | Partial offline support | Free | General CCN users |
| CoughDrop (Open-source) | Web, Android, iOS | English primarily | Configurable boards and symbols | Basic usage logging; no FER | Limited offline support | Subscription-based | Children and adults with CCN |
| Avaz AAC (Avaz) | iOS, Android | English, Hindi, Tamil, and others | Vocabulary and symbol customisation | Word prediction; no FER | Offline core | Approximately USD 100–200 | Children with ASD and CCN |
| Proposed System (This Project) | Android, iOS (Flutter) | Sinhala, Tamil, English | Extensive customisation (grid size, symbols, user-added content) | On-device FER with MobileNetV2/TFLite; emotion-adaptive AAC | Full offline-first architecture | To be determined (pilot phase) | Children with ASD in Sri Lanka (Levels 1–3+) |

The table illustrates several points. First, while a number of robust AAC applications exist, support for Sinhala and Tamil is extremely limited; Avaz AAC is notable for including Tamil, but Sinhala support is absent from any major system identified in the review. Second, none of the identified systems integrate on-device facial expression recognition for emotion-adaptive communication support. Third, the offline-first approach with full local functionality and optional cloud backup is a distinguishing feature of the proposed system, addressing the connectivity constraints common in Sri Lanka and similar LMICs.

### 2.3 Facial Expression Recognition and Affective Computing

#### 2.3.1 Theoretical Foundations

Facial expression recognition (FER) is a subfield of affective computing that concerns the automatic detection and classification of human emotional states from facial images or video. The field has its theoretical roots in the work of Charles Darwin, who proposed in *The Expression of the Emotions in Man and Animals* (1872) that certain emotional expressions are biologically innate and universal across cultures. This idea was developed further by Paul Ekman and Wallace Friesen, who identified a set of six "basic" emotions—happiness, sadness, anger, fear, surprise, and disgust—each associated with distinctive facial muscle configurations described through the Facial Action Coding System (FACS) (Ekman and Friesen, 1971; Ekman, 1992).

The universality thesis has been influential but is not without challenge. Barrett et al. (2019) published a comprehensive review in *Psychological Science in the Public Interest* arguing that the evidence for universal, discrete facial expressions of emotion is weaker than commonly assumed. They contend that facial movements are not reliable indicators of specific emotional states and that the mapping between facial configurations and emotions is mediated by context, culture, and individual differences. This critique has important implications for FER-based assistive technology: a model trained primarily on Western, adult facial expression datasets may not generalise well to children, to individuals with ASD (who may express emotions differently), or to non-Western cultural contexts (Barrett et al., 2019).

Despite these critiques, the basic-emotion framework remains the most widely used taxonomy in computational FER, partly because of the availability of large, labelled datasets (e.g., FER2013, AffectNet, CK+) annotated with these categories, and partly because the discrete-emotion approach lends itself to standard classification methods (Li and Deng, 2020). Alternative approaches, such as dimensional models (e.g., valence-arousal) and compound emotion categories, have been explored in the research literature but are less commonly implemented in commercial and assistive applications. For the present project, a pragmatic set of six emotion classes—happy, sad, angry, fear, neutral, and tired—has been adopted, balancing clinical relevance, feasibility of labelling, and coverage of the emotional states most relevant to communication support for children with ASD.

#### 2.3.2 Deep Learning for Facial Expression Recognition

Deep learning has transformed FER, with convolutional neural networks (CNNs) achieving state-of-the-art performance on benchmark datasets and enabling the development of real-time, on-device emotion recognition systems (Li and Deng, 2020; Goodfellow et al., 2015). The key advantage of CNNs over earlier approaches (e.g., hand-crafted features such as Local Binary Patterns, Histogram of Oriented Gradients) is their ability to learn hierarchical feature representations directly from raw pixel data, with early layers typically learning edges and textures and deeper layers learning more abstract, task-relevant features such as facial parts and configurations (LeCun et al., 2015).

The architecture of a typical CNN for FER consists of an input layer (accepting a fixed-size image, e.g., 224×224 pixels with three colour channels), multiple convolutional layers (each applying a set of learnable filters to produce feature maps), pooling layers (which reduce spatial dimensions and provide some degree of translation invariance), one or more fully connected (dense) layers (which integrate features from across the feature maps), and an output layer with one unit per class (e.g., six units for six emotion classes) followed by a softmax activation function to produce class probabilities (Goodfellow et al., 2015; LeCun et al., 2015).

Training is performed by iteratively presenting batches of labelled images to the network, computing the predicted class probabilities via a forward pass, calculating the loss (typically categorical cross-entropy), computing gradients of the loss with respect to all learnable parameters via backpropagation, and updating the parameters using an optimisation algorithm such as stochastic gradient descent (SGD), Adam (Kingma and Ba, 2015), or RMSprop. Regularisation techniques such as dropout (Srivastava et al., 2014), batch normalisation, weight decay, and data augmentation are employed to reduce overfitting and improve generalisation.

#### 2.3.3 Transfer Learning

Transfer learning refers to the practice of leveraging knowledge gained from training a model on one task (the source task) to improve performance on a different but related task (the target task) (Yosinski et al., 2014). In the context of FER, a common approach is to use a CNN pre-trained on a large, general-purpose image classification dataset (e.g., ImageNet, which contains over 14 million images across 1,000 classes) as a feature extractor. The pre-trained convolutional layers, which have learned rich and general visual features, are retained and optionally fine-tuned, while the top classification layers are replaced with new layers suited to the target task (e.g., six emotion classes instead of 1,000 ImageNet classes). Fine-tuning involves training the entire network (or selected layers) on the target dataset with a relatively low learning rate, allowing the pre-learned features to be adapted to the nuances of the new task (Yosinski et al., 2014; Goodfellow et al., 2015).

Transfer learning is particularly valuable when the target dataset is small—as is often the case in specialised applications such as FER for children with ASD—because the pre-trained features provide a strong initialisation that reduces the risk of overfitting and accelerates convergence. Yosinski et al. (2014) found that transferring features from ImageNet to a variety of target tasks consistently improved performance compared to training from scratch, with the magnitude of improvement largest for the most distant target tasks and smallest for those most similar to ImageNet classification. In the present project, the use of MobileNetV2 pre-trained on ImageNet as the backbone, with a custom classification head for six emotion classes, is motivated by these findings and by the practical constraints of developing a mobile-optimised model with a relatively modest dataset.

#### 2.3.4 MobileNetV2 Architecture

MobileNetV2, introduced by Sandler et al. (2018), is a lightweight deep neural network architecture designed for efficient inference on mobile and embedded devices. It builds upon the original MobileNet architecture (Howard et al., 2017), which introduced depthwise separable convolutions as a more computationally efficient alternative to standard convolutions. MobileNetV2 introduces two key innovations: inverted residual blocks and linear bottlenecks.

In a standard residual block (e.g., as used in ResNet), the input is first projected to a lower-dimensional space, processed through a convolutional layer, and then projected back to the original dimensionality, with a skip connection adding the input to the output. In an inverted residual block, the process is reversed: the input is first expanded to a higher-dimensional space (using a 1×1 convolution, termed the "expansion layer"), processed through a depthwise separable convolution, and then projected back to a lower-dimensional space (using another 1×1 convolution, termed the "projection layer" or "bottleneck layer"). The skip connection is applied between the bottleneck layers, not between the expanded layers. The linear bottleneck refers to the use of a linear (no activation) function after the final projection, which Sandler et al. (2018) argue helps preserve information in the low-dimensional bottleneck representation and prevents the destructive effects of non-linear activations on low-dimensional features.

The result is an architecture that achieves competitive accuracy on image classification benchmarks (e.g., 72.0% top-1 accuracy on ImageNet) with significantly fewer parameters and multiply-add operations than larger architectures such as VGG-16 or ResNet-50, making it well suited for deployment on resource-constrained devices. In combination with TensorFlow Lite (see Section 8.6), MobileNetV2 enables real-time inference on mid-range smartphones with acceptable latency, which is essential for the proposed AAC system's emotion recognition pipeline.

#### 2.3.5 FER Challenges and Limitations

Despite the advances in deep learning–based FER, several challenges remain that are particularly relevant to the present project.

**Dataset bias and generalisation.** The most widely used FER datasets (e.g., FER2013, CK+, AffectNet) are predominantly composed of adult faces, often from Western populations, and frequently include posed rather than spontaneous expressions (Li and Deng, 2020). Models trained on these datasets may not generalise well to children, to non-Western faces, or to the subtle and atypical expressions that may be observed in children with ASD. Barrett et al. (2019) have argued that the reliance on datasets with strong biases towards prototypical, posed expressions leads to inflated estimates of FER accuracy and poor real-world performance. Addressing this limitation in the present project requires the collection (post–ethics approval) of a purpose-built dataset that includes children of the target age group and cultural background, as well as the use of data augmentation and regularisation to improve robustness.

**Children with ASD and atypical expressiveness.** Research has documented that children with ASD may display atypical facial expressions, including reduced intensity, atypical timing, or unusual combinations of facial movements (Trevisan et al., 2018; Grossard et al., 2020). These differences may affect the accuracy of FER models trained on neurotypical populations. The project acknowledges this limitation and plans to document the model's performance on autism-specific data (where available and ethics-approved) and to provide mechanisms for caregiver override of model predictions.

**Lighting, pose, and occlusion.** Real-world conditions introduce variability in lighting, head pose, and facial occlusion (e.g., from hands, objects, or partial visibility), all of which can degrade FER accuracy. Data augmentation (e.g., random brightness and contrast changes, slight rotation) and face detection preprocessing can partially mitigate these effects, but achieving robust performance in uncontrolled settings remains a challenge (Li and Deng, 2020).

**Privacy and ethical concerns.** The use of FER in assistive technology raises significant privacy and ethical concerns, particularly when the target users are vulnerable children. These concerns are addressed in detail in Section 9 (Ethical Considerations).

### 2.4 Mobile and Edge Computing for Assistive Technology

#### 2.4.1 Flutter for Cross-Platform Mobile Development

Flutter is an open-source UI software development kit (SDK) created by Google, designed for building natively compiled applications for mobile (Android and iOS), web, and desktop from a single codebase (Flutter, 2023). Flutter uses the Dart programming language and provides a rich set of pre-built widgets and a high-performance rendering engine that draws directly to the screen canvas, avoiding the overhead of bridging to native UI components. Key advantages of Flutter for the present project include:

- **Single codebase:** Reduces development and maintenance effort by enabling a single set of source code to target both Android and iOS, which is important given the limited development resources of a final year project.
- **Fast development cycle:** Flutter's hot reload feature allows rapid iteration during development, enabling immediate visual feedback on UI changes without restarting the application.
- **Rich widget library:** Flutter provides a comprehensive library of Material Design and Cupertino widgets, as well as the ability to create custom widgets, supporting the design of accessible and visually appealing AAC interfaces.
- **Platform channel support:** Flutter supports platform-specific code via platform channels, which is used in this project to invoke the TensorFlow Lite interpreter on the native platform (Android or iOS) for on-device emotion recognition.
- **Community and ecosystem:** Flutter has a large and active developer community, extensive documentation, and a growing ecosystem of packages (available via pub.dev), including packages for camera access, local storage, Firebase integration, and text-to-speech.

#### 2.4.2 TensorFlow Lite for On-Device Inference

TensorFlow Lite is a lightweight, cross-platform framework designed for deploying machine learning models on mobile and embedded devices (TensorFlow, 2023). It is part of the broader TensorFlow ecosystem and provides tools for converting trained TensorFlow or Keras models into a compact, optimised format (.tflite) suitable for on-device inference. Key features of TensorFlow Lite relevant to this project include:

- **Model optimisation:** TensorFlow Lite supports various optimisation techniques, including post-training quantization (converting model weights and activations from 32-bit floating point to 8-bit integers or 16-bit floating point), pruning, and clustering, which reduce model size and accelerate inference with minimal accuracy loss.
- **Cross-platform support:** TensorFlow Lite runs on Android, iOS, Linux, and microcontrollers, ensuring broad device compatibility.
- **Hardware acceleration:** TensorFlow Lite can leverage hardware accelerators (e.g., GPU, DSP, or Neural Processing Units) where available, further improving inference speed.
- **Small footprint:** The TensorFlow Lite runtime is designed to have a small binary size and low memory footprint, suitable for resource-constrained devices.

In this project, the trained MobileNetV2 model is converted to TensorFlow Lite format using the TensorFlow Lite Converter, with post-training quantization applied to reduce model size while maintaining classification accuracy. The TFLite model is bundled with the Flutter application and invoked via platform channels for real-time emotion inference from camera input.

#### 2.4.3 Firebase for Backend Services

Firebase is a platform developed by Google for creating mobile and web applications, providing a suite of services including real-time databases, authentication, cloud storage, analytics, and hosting (Firebase, 2023). In this project, Firebase is used for:

- **Authentication:** Firebase Authentication provides secure sign-in mechanisms (e.g., email/password, OAuth) for therapists, parents, and administrators, with support for role-based access control.
- **Cloud Firestore or Realtime Database:** Used for storing structured data such as user profiles, vocabulary customisations, usage logs, and progress records. Data is synchronised across devices when connectivity is available.
- **Cloud Storage:** Used for backup of settings, exported data, and (where consented and ethics-approved) anonymised analytics.
- **Security rules:** Firebase security rules enforce access control, ensuring that users can only access data associated with their linked accounts and that sensitive data (e.g., facial images, if any are stored) is protected.

The offline-first architecture is implemented using local storage (e.g., SQLite or shared preferences) for core AAC data and TensorFlow Lite for on-device inference. Firebase synchronisation occurs opportunistically when connectivity is available, using Firebase's built-in offline persistence and conflict resolution mechanisms. This design ensures that the core functionality of the system—symbol-based communication, emotion recognition, and personalised vocabulary—remains fully operational without internet access, which is critical for deployment in areas of Sri Lanka with unreliable connectivity.

### 2.5 Critical Analysis of Existing Research and Identification of Research Gap

#### 2.5.1 Gaps in AAC Research

A critical reading of the AAC literature reveals several persistent gaps that are directly relevant to this project. First, the majority of high-quality AAC studies have been conducted in high-income, English-speaking countries, and the applicability of their findings to multilingual, low-resource settings such as Sri Lanka cannot be assumed without local adaptation and evaluation (Divan et al., 2021; Alant and Bornman, 2021). Second, while the evidence for AAC in autism is generally positive, many studies focus on acquisition of specific communicative functions (e.g., requesting) and provide limited evidence on generalisation to novel settings, maintenance over time, and impact on broader quality-of-life outcomes (Ganz et al., 2012). Third, the integration of affective computing into AAC for individuals with ASD is a relatively novel concept, and no published study or commercial product was identified that combines on-device FER with a multilingual AAC system specifically designed for children with autism in South Asia.

#### 2.5.2 Gaps in FER Research

In the FER literature, significant gaps include the underrepresentation of children, individuals with developmental disabilities, and non-Western populations in training and evaluation datasets (Barrett et al., 2019; Li and Deng, 2020). The validity of applying FER models—trained predominantly on adult, Western, posed expressions—to children with ASD, who may exhibit atypical expressiveness, is an open question. Furthermore, while FER performance on benchmark datasets has improved dramatically, real-world performance in uncontrolled environments remains a challenge, and the gap between "lab accuracy" and "field accuracy" is often substantial (Li and Deng, 2020).

#### 2.5.3 Synthesis and Research Gap

The literature supports the following synthesised conclusions: (1) ASD is associated with significant communication challenges that vary by severity level and require flexible, multimodal intervention; (2) AAC is an evidence-based support for individuals with ASD but requires cultural, linguistic, and contextual adaptation for effective deployment in settings such as Sri Lanka; (3) FER and affective computing offer potential for context-aware, emotion-adaptive AAC but must be applied with caution regarding dataset bias, model generalisation, and ethical implications; (4) Sri Lanka has specific and pressing needs for locally appropriate, multilingual, and scalable assistive technology solutions; and (5) no existing system combines all of these elements in an integrated, deployable product.

The present project aims to contribute to filling this gap by designing, developing, and preparing for pilot evaluation a dual-platform, AI-enhanced AAC system with on-device FER, trilingual support (Sinhala, Tamil, English), and an offline-first architecture suitable for deployment in the Sri Lankan healthcare and family context.

---
