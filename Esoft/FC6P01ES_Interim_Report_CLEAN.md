?# FC6P01ES Final Year Project Interim Report

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

## Declaration

This interim report is submitted in partial fulfilment of the requirements for the module FC6P01ES (Final Year Project) at ESOFT Metro Campus. The work presented herein is original to the best of the author's knowledge, and all sources have been appropriately cited using the Harvard referencing system. No part of this report has been submitted previously for any other qualification or at any other institution. The author confirms that the project has been conducted in accordance with institutional ethical guidelines and that all collaborative arrangements, including the planned pilot with Karapitiya Teaching Hospital, are documented and subject to appropriate institutional and governmental approvals.

All intellectual property rights in this work are retained by the author and ESOFT Metro Campus, subject to the terms of any applicable agreements. The author acknowledges the contributions of the project supervisor and any other individuals or organisations who have provided guidance, feedback, or access to resources, as specified in the acknowledgements section. Where third-party materials have been used, appropriate permissions have been obtained or the materials fall within the scope of fair use for academic and research purposes.

Signed: ______________________________
Date: ______________________________

## Acknowledgements

The author wishes to express sincere gratitude to the project supervisor at ESOFT Metro Campus for providing consistent guidance, feedback, and encouragement throughout the planning and development of this project. Appreciation is also extended to the academic staff of the computing department for their support and for creating an environment conducive to independent research and technical innovation.

The author is grateful to the staff at Karapitiya Teaching Hospital, Galle, for their willingness to explore a partnership for the pilot study and for their preliminary advice on clinical considerations relating to children with autism spectrum disorder. The cooperation of the hospital's paediatric and psychiatric departments has been instrumental in shaping the project's ethical and clinical dimensions.

Thanks are also due to the parents and caregivers who have expressed interest in participating in future pilot activities, and to the speech-language therapists who have provided informal feedback on the design of the AAC interface. Their insights have been invaluable in ensuring that the system is grounded in real-world needs and clinical best practice.

The author acknowledges the open-source communities behind Flutter, TensorFlow, Firebase, and MobileNetV2, whose tools and documentation have enabled the technical development of the system. The availability of public facial expression datasets for initial model validation is also gratefully acknowledged.

Finally, the author thanks family and friends for their patience and support throughout the duration of this project.

## Abstract

Autism spectrum disorder (ASD) affects a significant proportion of children worldwide, with communication impairment representing a core diagnostic feature and a major barrier to social participation, educational attainment, and quality of life. In Sri Lanka, access to culturally and linguistically appropriate augmentative and alternative communication (AAC) tools remains severely limited, with most commercially available solutions designed for Western, English-dominant contexts and lacking support for Sinhala, Tamil, and the country's unique cultural and clinical landscape. Affective computing??"specifically, facial expression recognition powered by deep learning??"offers a promising but underexplored avenue for enhancing AAC by enabling systems to infer the user's emotional state and adapt communication support accordingly. However, the integration of such technology into AAC for children with autism in low- and middle-income countries has received little systematic attention in the literature.

This interim report presents the design, methodology, and current progress of a final year project that aims to develop an AI-powered AAC system with facial expression recognition, specifically intended for children with autism in Sri Lanka. The system adopts a dual-platform architecture: Platform A provides a customisable, symbol-based AAC interface targeting children with ASD at severity levels 1??"2 (as classified by the DSM-5), with full trilingual support for Sinhala, Tamil, and English; Platform B extends this with an AI-enhanced module that employs convolutional neural network (CNN)??"based facial expression recognition, using transfer learning with MobileNetV2 and on-device deployment via TensorFlow Lite, to infer the user's emotional state and adapt communication options accordingly, intended for children at level 3 and above. The mobile application is developed using Flutter for cross-platform deployment on Android and iOS, with an offline-first architecture and cloud backup via Firebase. A therapist??"parent dashboard supports collaboration, progress monitoring, and data management. The emotion recognition model is trained to classify six emotion classes??"happy, sad, angry, fear, neutral, and tired??"with a target accuracy of at least 80 per cent on a curated dataset of 2,000??"5,000 images. A pilot study is planned in collaboration with Karapitiya Teaching Hospital, Galle, subject to Ministry of Health and institutional ethics committee approval.

This report documents the system architecture, development methodology (incremental model), AI model design and data collection strategy, ethical considerations, work completed to date, further work planned, progress review, risk analysis, limitations, Gantt chart, and work breakdown structure. The project aims to contribute a proof-of-concept system and a foundation for future research and deployment of AI-enhanced, multilingual AAC in Sri Lanka and similar contexts, with rigorous attention to ethics, inclusivity, scalability, and clinical relevance.

**Keywords:** Augmentative and alternative communication (AAC), autism spectrum disorder (ASD), facial expression recognition, convolutional neural networks (CNN), transfer learning, MobileNetV2, TensorFlow Lite, Flutter, Firebase, Sri Lanka, affective computing, assistive technology, multilingual, Sinhala, Tamil, inclusive design.

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
Figure 3: CNN Architecture ??" MobileNetV2 Adaptation
Figure 4: Facial Expression Data Collection Workflow
Figure 5: Therapist??"Parent Collaboration Flow
Figure 6: Emotion Detection Pipeline
Figure 7: Work Breakdown Structure
Figure 8: Gantt Chart
Figure 9: Mobile App UI Layout ??" Level 1??"2
Figure 10: Mobile App UI Layout ??" Level 3+

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

## 1. Introduction

### 1.1 Background and Context

Autism spectrum disorder (ASD) is a lifelong neurodevelopmental condition characterised by persistent deficits in social communication and social interaction, alongside restricted, repetitive patterns of behaviour, interests, or activities (American Psychiatric Association, 2013). The condition affects individuals across all demographic, ethnic, and socioeconomic groups, with the World Health Organization (2021) estimating that approximately one in 160 children globally has an autism spectrum disorder. This figure, however, is widely regarded as conservative, with more recent epidemiological studies in high-income countries reporting prevalence rates as high as one in 36 to one in 44 children (Maenner et al., 2023; Lord et al., 2020). The variation in prevalence estimates is attributable to differences in diagnostic criteria, ascertainment methods, and awareness, as well as to genuine differences in underlying risk factors across populations and regions (Elsabbagh et al., 2012).

Communication difficulties represent one of the most impactful and pervasive challenges associated with ASD. The fifth edition of the Diagnostic and Statistical Manual of Mental Disorders (DSM-5) identifies deficits in social communication as a core diagnostic criterion, with manifestations ranging from difficulties with conversational reciprocity and nonverbal communicative behaviours to challenges in developing, maintaining, and understanding relationships (American Psychiatric Association, 2013). The DSM-5 further introduces a severity classification system: Level 1 ("requiring support"), Level 2 ("requiring substantial support"), and Level 3 ("requiring very substantial support"), with the level of severity determined by the degree of support required for both social communication and restricted, repetitive behaviours (Lord et al., 2020). Children at Level 3 may have minimal or no functional speech and rely heavily on augmentative and alternative communication (AAC) to express basic needs, preferences, and emotions. Those at Levels 1 and 2 may benefit from AAC as a supplement to developing speech, particularly in high-demand or unfamiliar communicative contexts (Beukelman and Light, 2020).

In Sri Lanka, the landscape of autism diagnosis, awareness, and intervention has evolved considerably in recent years, though significant gaps remain. Studies by Perera et al. (2019) and Samad et al. (2020) have documented the growing recognition of ASD in the country, the increasing demand for specialist services, and the persistent shortages in trained professionals, screening tools, and culturally appropriate interventions. Sri Lanka is a linguistically diverse nation: Sinhala and Tamil are the two official languages, while English is widely used in education, healthcare, and government. Any assistive technology intended for broad deployment must therefore accommodate this trilingual reality??"a requirement that most commercially available AAC solutions, developed primarily for English-speaking Western markets, do not meet (Alant and Bornman, 2021).

The present project arises from the intersection of three domains: AAC intervention for children with ASD, affective computing (specifically facial expression recognition), and the need for locally appropriate assistive technology in Sri Lanka. It seeks to address a clear gap in the literature and in practice: the absence of an AAC system that is culturally and linguistically tailored for Sri Lanka, that integrates AI-driven emotion recognition to adapt communication support to the user's inferred emotional state, and that is deployable on affordable mobile devices in settings with variable or unreliable internet connectivity.

### 1.2 Augmentative and Alternative Communication

Augmentative and alternative communication (AAC) encompasses a broad range of strategies, tools, and technologies designed to supplement or replace natural speech and writing for individuals with complex communication needs (American Speech-Language-Hearing Association, 2022). The term "augmentative" refers to methods that supplement existing speech, while "alternative" refers to methods that serve as a primary means of communication for individuals with little or no functional speech. AAC systems may be unaided (requiring only the user's body, such as gestures, sign language, or facial expressions) or aided (requiring an external tool or device), and aided systems may be further classified as low-tech (e.g., picture boards, communication books) or high-tech (e.g., electronic speech-generating devices, tablet-based applications) (Beukelman and Light, 2020).

The evidence base for AAC in autism is substantial and growing. Systematic reviews and meta-analyses have demonstrated that AAC interventions can lead to significant gains in communicative competence, including requesting, commenting, answering questions, and social interaction, for individuals with ASD across the severity spectrum (Ganz et al., 2012; Lorah et al., 2015; Millar et al., 2006). Importantly, research has also shown that the introduction of AAC does not inhibit the development of natural speech; rather, it may facilitate speech production in some individuals, by reducing communicative frustration and providing a scaffold for language development (Millar et al., 2006; Romski and Sevcik, 2005). This finding has been instrumental in overcoming the longstanding clinical and parental concern that AAC might serve as a "crutch" that discourages speech (Light and McNaughton, 2012).

Despite these advances, several challenges persist. Many high-tech AAC solutions are expensive, require significant customisation and training, and are designed for English-speaking users in well-resourced settings (McNaughton and Light, 2013). Support for South Asian languages, and specifically for Sinhala and Tamil, is extremely limited in the AAC marketplace. Furthermore, most existing AAC systems are static in nature: they present a fixed or user-configured set of symbols, words, or phrases and do not adapt dynamically to the user's current emotional, physiological, or contextual state. This limitation is particularly relevant for children with ASD at higher severity levels, who may have difficulty communicating their emotional needs and for whom caregivers may struggle to interpret behavioural cues accurately (Fletcher-Watson and Happ?(c), 2019).

### 1.3 Affective Computing and Facial Expression Recognition

Affective computing is the study and design of systems and devices that can recognise, interpret, process, and simulate human affects (emotions, moods, and related states) (Picard, 2000). Within affective computing, facial expression recognition (FER) is a prominent subfield that seeks to automatically detect and classify emotions from facial images or video sequences. The theoretical underpinnings of FER draw from the work of Paul Ekman and colleagues, who proposed a set of universal basic emotions??"happiness, sadness, anger, fear, surprise, and disgust??"each associated with distinctive facial configurations known as action units (Ekman and Friesen, 1971). While the universality thesis has been debated and refined, particularly in light of cultural and contextual influences on emotional expression (Barrett et al., 2019), the Ekman framework continues to provide a foundational taxonomy for FER research and commercial applications.

Deep learning, and in particular convolutional neural networks (CNNs), has become the dominant approach for FER, achieving state-of-the-art results on benchmark datasets such as FER2013, AffectNet, and RAF-DB (Li and Deng, 2020; Goodfellow et al., 2015). Transfer learning??"the practice of reusing a network pre-trained on a large, general-purpose image dataset (e.g., ImageNet) and fine-tuning it on a smaller, task-specific dataset??"has been shown to improve classification accuracy and reduce data requirements, making it feasible to develop FER models with relatively modest labelled datasets (Yosinski et al., 2014). Lightweight architectures such as MobileNet and MobileNetV2, designed for efficiency on mobile and embedded devices, are particularly well suited for on-device inference, enabling real-time emotion recognition without the need for cloud-based processing (Sandler et al., 2018; Howard et al., 2019).

The application of FER in assistive technology for children with ASD holds considerable promise. For non-verbal or minimally verbal children, the ability of a system to infer emotional state from facial expressions could enable context-aware communication support??"for example, offering comfort-related vocabulary when distress is detected, or activity-related options when the child appears engaged and happy (Calvo and D'Mello, 2010). However, this application also raises significant challenges and ethical considerations, including the accuracy and reliability of FER models for children (whose expressions may differ from adults), the risk of misclassification and its consequences, the privacy implications of facial image capture, and the need for caregiver oversight and the ability to override automated suggestions (Fletcher-Watson and Happ?(c), 2019).

### 1.4 The Sri Lankan Context

Sri Lanka presents a unique and complex context for the deployment of assistive technology for children with autism. The country has a population of approximately 22 million, with Sinhala spoken by approximately 75 per cent of the population, Tamil by approximately 25 per cent, and English widely used as a link language in government, education, and healthcare (Department of Census and Statistics, Sri Lanka, 2012). The healthcare system includes a network of teaching hospitals, district hospitals, and primary care facilities, with teaching hospitals such as Karapitiya in Galle serving as regional referral centres for specialist services, including paediatric neurology and child psychiatry (Perera et al., 2019).

Despite significant achievements in healthcare indicators (e.g., low infant mortality and high life expectancy relative to per capita income), Sri Lanka faces persistent challenges in the provision of specialist services for developmental disabilities. The number of trained speech-language therapists, developmental paediatricians, and clinical psychologists is insufficient to meet demand, and services are unevenly distributed, with a concentration in urban centres such as Colombo and a relative scarcity in rural areas (Samad et al., 2020; Wickramasinghe et al., 2021). Families of children with ASD may travel long distances for diagnosis and therapy, and ongoing, intensive intervention may be difficult to sustain. In this context, mobile-based assistive technology that supports communication, is usable without specialist supervision, and works offline offers a potentially transformative contribution??"provided it is designed with local needs, languages, and constraints in mind.

The choice of Karapitiya Teaching Hospital as a pilot site is informed by its role as a leading regional facility with established paediatric and psychiatric services, its track record of supporting research collaborations, and its location in the Southern Province, which enables engagement with families from diverse socioeconomic backgrounds. Collaboration with the hospital, subject to institutional ethics committee and Ministry of Health approval, can provide clinical credibility, facilitate recruitment of participants, and ensure that the system is evaluated in a clinically supervised environment. The Ministry of Health approval process involves submission of a research proposal to the relevant ethics review committee, compliance with national research governance requirements, and, where applicable, registration in a national or international trial registry (Ministry of Health, Sri Lanka, 2020).

### 1.5 Rationale and Motivation

The motivation for this project is rooted in the convergence of unmet need, technological opportunity, and the commitment to inclusive design. The unmet need is clear: children with autism in Sri Lanka require access to AAC tools that support their languages, respect their cultural context, and are affordable and deployable in settings with limited resources and connectivity. The technological opportunity lies in the maturation of mobile development frameworks (Flutter), efficient deep learning architectures (MobileNetV2), on-device inference engines (TensorFlow Lite), and cloud services (Firebase), which together make it feasible to build and deploy a sophisticated, AI-enhanced AAC system on affordable smartphones. The commitment to inclusive design is reflected in the dual-platform approach, which acknowledges the heterogeneity of ASD and provides differentiated support for different severity levels, and in the trilingual support, which ensures that the system is accessible to children and families across Sri Lanka's linguistic communities.

Furthermore, the integration of facial expression recognition into AAC represents a novel contribution to the field. While emotion recognition has been explored in various assistive and educational contexts, its integration into a multilingual, culturally adapted, mobile AAC system for children with autism in a low- and middle-income country appears to be without direct precedent in the published literature. This project therefore has the potential to contribute not only a practical tool but also new knowledge about the feasibility, challenges, and ethical implications of deploying affective computing in sensitive real-world settings.

### 1.6 Scope of the Interim Report

This interim report serves several purposes within the FC6P01ES module framework. It documents the work completed to date, including the literature review, system design, initial implementation, and ethical preparations. It presents the methodological and technical foundations of the project in sufficient detail to enable assessment of the approach and its feasibility. It identifies risks, limitations, and remaining work, and it provides a realistic plan for the completion of the project within the remainder of the academic year. The report is structured to meet the ESOFT Final Project Interim format requirements and is intended to demonstrate examiner-level quality in terms of academic rigour, critical analysis, technical depth, and clarity of presentation.

The remainder of the report is structured as follows: Section 2 provides a comprehensive background and literature review; Section 3 articulates the problem statement; Sections 4 and 5 present the aim, objectives, and research questions; Section 6 describes the system architecture; Section 7 details the development methodology; Section 8 covers the AI model design and data collection approach; Section 9 addresses ethical considerations; Sections 10 and 11 summarise work completed and further work planned; Section 12 presents the progress review; Section 13 provides the risk analysis; Sections 14, 15, and 16 cover limitations, scope, Gantt chart, and work breakdown structure; Section 17 concludes the report; and Sections 18 and 19 provide the reference list and bibliography in Harvard style.

## 2. Background and Literature Review

### 2.1 Autism Spectrum Disorder: Definition, Classification, and Epidemiology

#### 2.1.1 Definition and Diagnostic Criteria

Autism spectrum disorder (ASD) is defined in the fifth edition of the Diagnostic and Statistical Manual of Mental Disorders (DSM-5) as a neurodevelopmental condition characterised by two core domains of impairment: (1) persistent deficits in social communication and social interaction across multiple contexts, and (2) restricted, repetitive patterns of behaviour, interests, or activities (American Psychiatric Association, 2013). The DSM-5 consolidated the previously separate diagnoses of autistic disorder, Asperger's disorder, and pervasive developmental disorder??"not otherwise specified (PDD-NOS) into a single spectrum, reflecting the recognition that these conditions share a common underlying neurobiology and differ primarily in severity and associated features rather than in kind (Lord et al., 2020).

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

The choice of AAC system for a given individual is influenced by a range of factors, including the user's cognitive and motor abilities, language and literacy skills, communication needs and goals, the communication environments and partners, availability and cost, and family and cultural preferences (Light and McNaughton, 2015). For children with ASD, the selection and implementation of AAC must also consider the specific communication profile associated with autism??"including challenges with pragmatic language, social reciprocity, and restricted interests??"as well as any co-occurring conditions such as intellectual disability, motor difficulties, or sensory sensitivities (Ganz, 2015).

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
| Avaz AAC (Avaz) | iOS, Android | English, Hindi, Tamil, and others | Vocabulary and symbol customisation | Word prediction; no FER | Offline core | Approximately USD 100??"200 | Children with ASD and CCN |
| Proposed System (This Project) | Android, iOS (Flutter) | Sinhala, Tamil, English | Extensive customisation (grid size, symbols, user-added content) | On-device FER with MobileNetV2/TFLite; emotion-adaptive AAC | Full offline-first architecture | To be determined (pilot phase) | Children with ASD in Sri Lanka (Levels 1??"3+) |

The table illustrates several points. First, while a number of robust AAC applications exist, support for Sinhala and Tamil is extremely limited; Avaz AAC is notable for including Tamil, but Sinhala support is absent from any major system identified in the review. Second, none of the identified systems integrate on-device facial expression recognition for emotion-adaptive communication support. Third, the offline-first approach with full local functionality and optional cloud backup is a distinguishing feature of the proposed system, addressing the connectivity constraints common in Sri Lanka and similar LMICs.

### 2.3 Facial Expression Recognition and Affective Computing

#### 2.3.1 Theoretical Foundations

Facial expression recognition (FER) is a subfield of affective computing that concerns the automatic detection and classification of human emotional states from facial images or video. The field has its theoretical roots in the work of Charles Darwin, who proposed in *The Expression of the Emotions in Man and Animals* (1872) that certain emotional expressions are biologically innate and universal across cultures. This idea was developed further by Paul Ekman and Wallace Friesen, who identified a set of six "basic" emotions??"happiness, sadness, anger, fear, surprise, and disgust??"each associated with distinctive facial muscle configurations described through the Facial Action Coding System (FACS) (Ekman and Friesen, 1971; Ekman, 1992).

The universality thesis has been influential but is not without challenge. Barrett et al. (2019) published a comprehensive review in *Psychological Science in the Public Interest* arguing that the evidence for universal, discrete facial expressions of emotion is weaker than commonly assumed. They contend that facial movements are not reliable indicators of specific emotional states and that the mapping between facial configurations and emotions is mediated by context, culture, and individual differences. This critique has important implications for FER-based assistive technology: a model trained primarily on Western, adult facial expression datasets may not generalise well to children, to individuals with ASD (who may express emotions differently), or to non-Western cultural contexts (Barrett et al., 2019).

Despite these critiques, the basic-emotion framework remains the most widely used taxonomy in computational FER, partly because of the availability of large, labelled datasets (e.g., FER2013, AffectNet, CK+) annotated with these categories, and partly because the discrete-emotion approach lends itself to standard classification methods (Li and Deng, 2020). Alternative approaches, such as dimensional models (e.g., valence-arousal) and compound emotion categories, have been explored in the research literature but are less commonly implemented in commercial and assistive applications. For the present project, a pragmatic set of six emotion classes??"happy, sad, angry, fear, neutral, and tired??"has been adopted, balancing clinical relevance, feasibility of labelling, and coverage of the emotional states most relevant to communication support for children with ASD.

#### 2.3.2 Deep Learning for Facial Expression Recognition

Deep learning has transformed FER, with convolutional neural networks (CNNs) achieving state-of-the-art performance on benchmark datasets and enabling the development of real-time, on-device emotion recognition systems (Li and Deng, 2020; Goodfellow et al., 2015). The key advantage of CNNs over earlier approaches (e.g., hand-crafted features such as Local Binary Patterns, Histogram of Oriented Gradients) is their ability to learn hierarchical feature representations directly from raw pixel data, with early layers typically learning edges and textures and deeper layers learning more abstract, task-relevant features such as facial parts and configurations (LeCun et al., 2015).

The architecture of a typical CNN for FER consists of an input layer (accepting a fixed-size image, e.g., 224?-224 pixels with three colour channels), multiple convolutional layers (each applying a set of learnable filters to produce feature maps), pooling layers (which reduce spatial dimensions and provide some degree of translation invariance), one or more fully connected (dense) layers (which integrate features from across the feature maps), and an output layer with one unit per class (e.g., six units for six emotion classes) followed by a softmax activation function to produce class probabilities (Goodfellow et al., 2015; LeCun et al., 2015).

Training is performed by iteratively presenting batches of labelled images to the network, computing the predicted class probabilities via a forward pass, calculating the loss (typically categorical cross-entropy), computing gradients of the loss with respect to all learnable parameters via backpropagation, and updating the parameters using an optimisation algorithm such as stochastic gradient descent (SGD), Adam (Kingma and Ba, 2015), or RMSprop. Regularisation techniques such as dropout (Srivastava et al., 2014), batch normalisation, weight decay, and data augmentation are employed to reduce overfitting and improve generalisation.

#### 2.3.3 Transfer Learning

Transfer learning refers to the practice of leveraging knowledge gained from training a model on one task (the source task) to improve performance on a different but related task (the target task) (Yosinski et al., 2014). In the context of FER, a common approach is to use a CNN pre-trained on a large, general-purpose image classification dataset (e.g., ImageNet, which contains over 14 million images across 1,000 classes) as a feature extractor. The pre-trained convolutional layers, which have learned rich and general visual features, are retained and optionally fine-tuned, while the top classification layers are replaced with new layers suited to the target task (e.g., six emotion classes instead of 1,000 ImageNet classes). Fine-tuning involves training the entire network (or selected layers) on the target dataset with a relatively low learning rate, allowing the pre-learned features to be adapted to the nuances of the new task (Yosinski et al., 2014; Goodfellow et al., 2015).

Transfer learning is particularly valuable when the target dataset is small??"as is often the case in specialised applications such as FER for children with ASD??"because the pre-trained features provide a strong initialisation that reduces the risk of overfitting and accelerates convergence. Yosinski et al. (2014) found that transferring features from ImageNet to a variety of target tasks consistently improved performance compared to training from scratch, with the magnitude of improvement largest for the most distant target tasks and smallest for those most similar to ImageNet classification. In the present project, the use of MobileNetV2 pre-trained on ImageNet as the backbone, with a custom classification head for six emotion classes, is motivated by these findings and by the practical constraints of developing a mobile-optimised model with a relatively modest dataset.

#### 2.3.4 MobileNetV2 Architecture

MobileNetV2, introduced by Sandler et al. (2018), is a lightweight deep neural network architecture designed for efficient inference on mobile and embedded devices. It builds upon the original MobileNet architecture (Howard et al., 2017), which introduced depthwise separable convolutions as a more computationally efficient alternative to standard convolutions. MobileNetV2 introduces two key innovations: inverted residual blocks and linear bottlenecks.

In a standard residual block (e.g., as used in ResNet), the input is first projected to a lower-dimensional space, processed through a convolutional layer, and then projected back to the original dimensionality, with a skip connection adding the input to the output. In an inverted residual block, the process is reversed: the input is first expanded to a higher-dimensional space (using a 1?-1 convolution, termed the "expansion layer"), processed through a depthwise separable convolution, and then projected back to a lower-dimensional space (using another 1?-1 convolution, termed the "projection layer" or "bottleneck layer"). The skip connection is applied between the bottleneck layers, not between the expanded layers. The linear bottleneck refers to the use of a linear (no activation) function after the final projection, which Sandler et al. (2018) argue helps preserve information in the low-dimensional bottleneck representation and prevents the destructive effects of non-linear activations on low-dimensional features.

The result is an architecture that achieves competitive accuracy on image classification benchmarks (e.g., 72.0% top-1 accuracy on ImageNet) with significantly fewer parameters and multiply-add operations than larger architectures such as VGG-16 or ResNet-50, making it well suited for deployment on resource-constrained devices. In combination with TensorFlow Lite (see Section 8.6), MobileNetV2 enables real-time inference on mid-range smartphones with acceptable latency, which is essential for the proposed AAC system's emotion recognition pipeline.

#### 2.3.5 FER Challenges and Limitations

Despite the advances in deep learning??"based FER, several challenges remain that are particularly relevant to the present project.

**Dataset bias and generalisation.** The most widely used FER datasets (e.g., FER2013, CK+, AffectNet) are predominantly composed of adult faces, often from Western populations, and frequently include posed rather than spontaneous expressions (Li and Deng, 2020). Models trained on these datasets may not generalise well to children, to non-Western faces, or to the subtle and atypical expressions that may be observed in children with ASD. Barrett et al. (2019) have argued that the reliance on datasets with strong biases towards prototypical, posed expressions leads to inflated estimates of FER accuracy and poor real-world performance. Addressing this limitation in the present project requires the collection (post??"ethics approval) of a purpose-built dataset that includes children of the target age group and cultural background, as well as the use of data augmentation and regularisation to improve robustness.

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

The offline-first architecture is implemented using local storage (e.g., SQLite or shared preferences) for core AAC data and TensorFlow Lite for on-device inference. Firebase synchronisation occurs opportunistically when connectivity is available, using Firebase's built-in offline persistence and conflict resolution mechanisms. This design ensures that the core functionality of the system??"symbol-based communication, emotion recognition, and personalised vocabulary??"remains fully operational without internet access, which is critical for deployment in areas of Sri Lanka with unreliable connectivity.

### 2.5 Critical Analysis of Existing Research and Identification of Research Gap

#### 2.5.1 Gaps in AAC Research

A critical reading of the AAC literature reveals several persistent gaps that are directly relevant to this project. First, the majority of high-quality AAC studies have been conducted in high-income, English-speaking countries, and the applicability of their findings to multilingual, low-resource settings such as Sri Lanka cannot be assumed without local adaptation and evaluation (Divan et al., 2021; Alant and Bornman, 2021). Second, while the evidence for AAC in autism is generally positive, many studies focus on acquisition of specific communicative functions (e.g., requesting) and provide limited evidence on generalisation to novel settings, maintenance over time, and impact on broader quality-of-life outcomes (Ganz et al., 2012). Third, the integration of affective computing into AAC for individuals with ASD is a relatively novel concept, and no published study or commercial product was identified that combines on-device FER with a multilingual AAC system specifically designed for children with autism in South Asia.

#### 2.5.2 Gaps in FER Research

In the FER literature, significant gaps include the underrepresentation of children, individuals with developmental disabilities, and non-Western populations in training and evaluation datasets (Barrett et al., 2019; Li and Deng, 2020). The validity of applying FER models??"trained predominantly on adult, Western, posed expressions??"to children with ASD, who may exhibit atypical expressiveness, is an open question. Furthermore, while FER performance on benchmark datasets has improved dramatically, real-world performance in uncontrolled environments remains a challenge, and the gap between "lab accuracy" and "field accuracy" is often substantial (Li and Deng, 2020).

#### 2.5.3 Synthesis and Research Gap

The literature supports the following synthesised conclusions: (1) ASD is associated with significant communication challenges that vary by severity level and require flexible, multimodal intervention; (2) AAC is an evidence-based support for individuals with ASD but requires cultural, linguistic, and contextual adaptation for effective deployment in settings such as Sri Lanka; (3) FER and affective computing offer potential for context-aware, emotion-adaptive AAC but must be applied with caution regarding dataset bias, model generalisation, and ethical implications; (4) Sri Lanka has specific and pressing needs for locally appropriate, multilingual, and scalable assistive technology solutions; and (5) no existing system combines all of these elements in an integrated, deployable product.

The present project aims to contribute to filling this gap by designing, developing, and preparing for pilot evaluation a dual-platform, AI-enhanced AAC system with on-device FER, trilingual support (Sinhala, Tamil, English), and an offline-first architecture suitable for deployment in the Sri Lankan healthcare and family context.

### 1.7 Extended Introduction: Historical Context of Autism Research

#### 1.7.1 The Discovery and Evolution of Autism as a Diagnostic Category

The concept of autism has undergone significant evolution since it was first described independently by Leo Kanner in 1943 and Hans Asperger in 1944. Kanner, working at Johns Hopkins University in the United States, described a group of 11 children who exhibited "autistic disturbances of affective contact," characterised by profound social withdrawal, insistence on sameness, and unusual patterns of communication (Kanner, 1943). Around the same time, Asperger, a paediatrician in Vienna, described a similar pattern of social and communicative differences in a group of children he termed having "autistic psychopathy," noting their intense interests and often advanced vocabularies alongside significant social difficulties (Asperger, 1944; Wing, 1981).

For several decades following these initial descriptions, autism was widely misunderstood, frequently conflated with childhood schizophrenia, and sometimes attributed to inadequate parenting??"the discredited "refrigerator mother" theory promoted by Bruno Bettelheim in the 1960s (Bettelheim, 1967). It was not until the 1970s and 1980s that rigorous epidemiological and genetic research began to establish autism as a neurodevelopmental condition with biological underpinnings (Rutter, 1978). The publication of Wing and Gould's (1979) influential study, which introduced the concept of the "triad of impairments" (social interaction, communication, and imagination/flexibility), provided a framework that shaped diagnostic criteria for decades.

The evolution of diagnostic classification has been marked by several major revisions. The Diagnostic and Statistical Manual of Mental Disorders, Third Edition (DSM-III; American Psychiatric Association, 1980) first included "Infantile Autism" as a distinct diagnostic category. Subsequent revisions expanded the diagnostic criteria and introduced related categories, including Asperger's Disorder and Pervasive Developmental Disorder??"Not Otherwise Specified (PDD-NOS) in DSM-IV (American Psychiatric Association, 1994). The most recent edition, DSM-5 (American Psychiatric Association, 2013), consolidated these categories into a single autism spectrum disorder (ASD) diagnosis, reflecting the growing consensus that ASD represents a spectrum of related conditions rather than discrete subtypes.

The shift to a spectrum model has important implications for communication support and, by extension, for the design of AAC systems. Under the DSM-5 framework, individuals with ASD are classified into three severity levels based on the degree of support required in social communication and restricted/repetitive behaviours: Level 1 ("requiring support"), Level 2 ("requiring substantial support"), and Level 3 ("requiring very substantial support"). This classification directly informs the dual-platform design of the present project, with Platform A targeting children at Levels 1??"2 and Platform B targeting children at Level 3 and above.

#### 1.7.2 Epidemiological Trends and Global Prevalence

The reported prevalence of ASD has increased dramatically over the past four decades, from estimates of approximately 4??"5 per 10,000 in the 1970s to current estimates of approximately 1 in 36 children (approximately 2.8%) in the United States, as reported by the Centers for Disease Control and Prevention's Autism and Developmental Disabilities Monitoring (ADDM) Network (Maenner et al., 2023). Similar increases have been reported in other high-income countries, including the United Kingdom, Australia, and South Korea.

The reasons for this increase are debated. Significant contributors include broadened diagnostic criteria (particularly the shift from narrow definitions of "classic autism" to the broader autism spectrum), increased awareness among parents, educators, and clinicians, improved screening and diagnostic processes, and changes in service provision that may incentivise diagnosis (Lord et al., 2020). Whether there has also been a true increase in the underlying prevalence (i.e., an increase in the number of individuals with ASD, not merely an increase in identification) remains an open question, with some researchers arguing for a genuine increase linked to environmental factors and others attributing the trend entirely to methodological and societal changes (Fombonne, 2018; B??lte et al., 2019).

In low- and middle-income countries (LMICs), including Sri Lanka, prevalence data are more limited due to the scarcity of population-based epidemiological studies, the variability of diagnostic practices, and the under-recognition and under-diagnosis of ASD in many settings (Elsabbagh et al., 2012; Divan et al., 2021). The study by Perera et al. (2019) is one of the few population-based prevalence studies conducted in Sri Lanka, reporting a prevalence of approximately 1.07% among children aged two to nine years. This figure is consistent with estimates from other Asian countries (e.g., Japan, South Korea, China) but may underestimate the true prevalence due to limited diagnostic capacity and cultural factors that may delay or prevent help-seeking.

The high and growing prevalence of ASD worldwide, combined with the substantial communication support needs of a significant proportion of individuals on the spectrum, underscores the urgency and relevance of developing accessible, affordable, and culturally appropriate AAC solutions??"which is the central aim of the present project.

#### 1.7.3 Communication Profiles in Autism

Communication impairment is a defining feature of ASD, but its nature and severity vary widely across the spectrum. The communication profile of an individual with ASD may include any combination of the following:

1. **Delayed language development:** Many children with ASD are late to develop spoken language, and some do not develop functional speech at all. Research estimates that approximately 25??"30% of children diagnosed with ASD remain minimally verbal or non-speaking into adulthood (Anderson et al., 2007; Tager-Flusberg and Kasari, 2013).

2. **Echolalia:** The repetition of words or phrases spoken by others, either immediately or after a delay. Echolalia may serve various communicative functions (e.g., requesting, protesting, turn-taking) and is increasingly recognised as a valid communicative strategy rather than a purely non-functional behaviour (Prizant and Duchan, 1981).

3. **Pragmatic language difficulties:** Even individuals with ASD who develop fluent speech may have significant difficulties with the pragmatic (social) aspects of language, including turn-taking, topic maintenance, understanding non-literal language (e.g., sarcasm, idioms, metaphor), and interpreting the communicative intent of others (Tager-Flusberg et al., 2005).

4. **Limited use of non-verbal communication:** Children with ASD may use fewer gestures, facial expressions, and eye contact to communicate, and may have difficulty interpreting these cues in others (Lord et al., 2020).

5. **Restricted or stereotyped language:** Some individuals with ASD exhibit restricted patterns of language use, such as intense interest in specific topics, use of scripted language, or unusual prosody (pitch, rhythm, and intonation).

6. **Challenges with communication in context:** The ability to use language flexibly and appropriately across different contexts (e.g., home, school, clinic, community) may be particularly challenging for individuals with ASD, contributing to difficulties in social participation and academic achievement.

This diversity in communication profiles has direct implications for AAC design. A "one size fits all" approach to AAC is inappropriate for the autism population; instead, AAC systems must be highly customisable and adaptable, supporting a range of interaction paradigms, vocabulary sizes, and output modalities to meet the needs of individual users (Light and McNaughton, 2015; Beukelman and Light, 2020). The present project addresses this through its dual-platform design, configurable interface, and caregiver-managed settings.

### 2.9 Extended Literature on Mobile Health (mHealth) in LMICs

#### 2.9.1 The Promise and Challenges of mHealth

Mobile health (mHealth)??"the use of mobile devices, including smartphones and tablets, for health service delivery and public health practice??"has been identified as a promising strategy for extending healthcare access in LMICs, where the penetration of mobile phones often far exceeds the availability of healthcare facilities and trained professionals (World Health Organization, 2011; Labrique et al., 2013). In the context of autism and developmental disabilities, mHealth applications have been explored for screening, diagnosis support, parent training, and intervention delivery (Divan et al., 2021).

The relevance of mHealth to the present project is twofold. First, the mobile application itself (Flutter app) is a form of mHealth intervention, delivering AAC support on a device that is widely available and familiar to many families in Sri Lanka. Second, the therapist??"parent dashboard enables remote collaboration, progress monitoring, and intervention guidance, which is a form of telepractice??"a subspecialty of mHealth that has shown promise for AAC and related services (Grogan-Johnson et al., 2013).

However, mHealth in LMICs faces several well-documented challenges: (a) variable and often unreliable internet connectivity, particularly in rural areas; (b) diversity of devices and operating systems, requiring robust cross-platform support; (c) limited digital literacy among some target users (particularly older caregivers and healthcare workers who may not be accustomed to using apps for clinical purposes); (d) concerns about data privacy and security, particularly when health-related data is transmitted over public networks; and (e) the risk that mHealth interventions may exacerbate rather than reduce health inequities, if they are primarily adopted by wealthier, more educated, and more urban populations (Labrique et al., 2013; Tomlinson et al., 2013).

The present project addresses these challenges through its offline-first architecture (ensuring functionality without connectivity), its use of Flutter for cross-platform support (reducing device fragmentation issues), its emphasis on simple and intuitive design (accommodating users with varying digital literacy), and its robust security and privacy architecture (protecting sensitive data). The pilot study will provide an opportunity to assess the extent to which these design decisions are effective in the Sri Lankan context.

#### 2.9.2 Assistive Technology Access in Sri Lanka

Access to assistive technology (AT) in Sri Lanka is shaped by several factors, including the availability and affordability of AT devices and services, the awareness and training of professionals, the policy and regulatory environment, and the cultural attitudes towards disability (WHO and UNICEF, 2022). The WHO??"UNICEF Global Report on Assistive Technology (2022) estimated that more than one billion people worldwide require assistive technology, but only 10% in low-income and 30% in high-income countries have access to the AT they need. Sri Lanka, as a lower-middle-income country, falls on the lower end of this spectrum.

In the specific domain of AAC, access in Sri Lanka is further constrained by the following factors:

1. **Shortage of trained professionals:** There are very few qualified speech-language therapists (SLTs) in Sri Lanka relative to the population, and even fewer who are trained in AAC assessment and intervention. The concentration of SLTs in urban centres means that families in rural and semi-urban areas may have very limited or no access to AAC services.

2. **Cost of high-tech AAC:** Dedicated AAC devices (e.g., from PRC-Saltillo, Tobii Dynavox) cost several hundred to several thousand US dollars and are not widely available or supported in Sri Lanka. Tablet-based AAC apps (e.g., Proloquo2Go) are more affordable but still require a compatible device (typically an iPad) and the app itself may cost hundreds of dollars.

3. **Lack of local content:** The vast majority of AAC apps and devices are designed for English-speaking users and do not include Sinhala or Tamil vocabulary, symbols, or text-to-speech. Even apps that support multiple languages may not include Sri Lanka's official languages.

4. **Cultural and attitudinal barriers:** In some communities, there may be stigma associated with disability and with the use of assistive technology, which can reduce uptake and adherence. Raising awareness about the benefits of AAC and the capabilities of modern AT is an important component of effective deployment.

5. **Policy gaps:** While Sri Lanka has made progress in its disability policies (e.g., the Protection of the Rights of Persons with Disabilities Act, No. 28 of 1996), implementation remains uneven, and there is no comprehensive national policy specifically addressing assistive technology access and provision.

The present project contributes to addressing these barriers by: (a) providing a free or low-cost AAC solution that runs on widely available Android smartphones; (b) including Sinhala, Tamil, and English support; (c) designing the system to be usable with minimal professional support (while encouraging professional involvement where available); and (d) building partnerships with clinical institutions (Karapitiya Teaching Hospital) to promote adoption and evidence-based practice.

### 8.13 Extended Discussion of Dataset Challenges

#### 8.13.1 The FER2013 Dataset

FER2013 is one of the most widely used benchmark datasets for facial expression recognition, consisting of approximately 35,887 grayscale images (48?-48 pixels) distributed across seven emotion categories: angry, disgust, fear, happy, sad, surprise, and neutral (Goodfellow et al., 2013). The dataset was collected automatically using the Google Image Search API and labelled using crowd-sourced annotation, resulting in inherent label noise (misannotated images) that is estimated at 10??"15% (Li and Deng, 2020).

While FER2013 provides a large and accessible training set, it has several limitations that are relevant to this project:

1. **Low resolution:** The 48?-48 pixel resolution limits the detail available for fine-grained expression analysis. The project addresses this by resizing images to the MobileNetV2 input resolution of 224?-224 pixels, using interpolation to upscale the images. While upscaling does not add new information, the pre-trained convolutional filters are designed to operate at this resolution.

2. **Label noise:** The presence of misannotated images in the dataset introduces noise into the training process, which can reduce model accuracy. Data cleaning (manual review and removal of obviously misannotated images) is performed on the subset used for training in this project.

3. **Adult bias:** The dataset is predominantly composed of adult faces. Children's faces differ morphologically from adults' faces (smaller features, different proportions, smoother skin), and a model trained primarily on adult data may generalise poorly to children.

4. **Western demographics:** The dataset is composed predominantly of faces with Western ethnic features. Performance on faces of South Asian children may differ due to variations in skin tone, facial geometry, and expression style.

5. **No "tired" class:** FER2013 does not include a "tired" class. The project addresses this by sourcing supplementary images from other datasets (e.g., driver drowsiness detection datasets) and from purpose-collected data.

#### 8.13.2 AffectNet and RAF-DB

AffectNet (Mollahosseini et al., 2019) is a large-scale facial expression dataset containing over 400,000 manually annotated images from the internet, with both categorical (basic emotions) and dimensional (valence-arousal) labels. RAF-DB (Li et al., 2017) is a real-world affective faces dataset with compound and basic emotion annotations. Both datasets offer higher image quality and more diverse demographics compared to FER2013 but may have licensing or access restrictions that limit their use in this project.

The project uses a subset of publicly available FER datasets (primarily FER2013, with supplementary images from AffectNet or RAF-DB where accessible) for initial model training and validation. Purpose-collected data (post??"ethics approval) will supplement these public sources with images of children from the target demographic, improving the model's relevance and applicability.

#### 8.13.3 Data Labelling and Inter-Rater Reliability

The quality of the training labels directly affects model performance. For purpose-collected data, all images are labelled by at least one trained annotator (a member of the project team who has received brief training on the Ekman emotion categories and the "tired" label definition). For a randomly selected subset (at least 10% of purpose-collected images), a second independent annotator provides labels, and inter-rater reliability is assessed using Cohen's kappa coefficient.

Cohen's kappa is defined as:

$$
\kappa = \frac{p_o - p_e}{1 - p_e}
$$

where $p_o$ is the observed agreement (proportion of images for which the two annotators assign the same label) and $p_e$ is the expected agreement by chance. A kappa of 1.0 indicates perfect agreement, 0.0 indicates agreement no better than chance, and values above 0.6 are generally considered "substantial" agreement (Landis and Koch, 1977). The target for this project is a kappa of at least 0.6 for the purpose-collected dataset.

### 6.9 Extended Security Architecture

#### 6.9.1 Threat Model

The system's security design is informed by a lightweight threat model that identifies the most significant threats and defines countermeasures for each:

| Threat | Description | Countermeasure |
|---|---|---|
| T1: Unauthorised access to user data | An attacker gains access to a user's account or data on the device or in the cloud | Firebase Authentication; role-based access control; Firestore security rules; device lock/encryption |
| T2: Interception of data in transit | An attacker intercepts data transmitted between the app and Firebase | HTTPS/TLS encryption for all network communication |
| T3: Local data theft | An attacker with physical access to the device extracts user data | Platform-level encryption (Android Keystore, iOS Keychain); app-level PIN or biometric lock (optional) |
| T4: Facial image exfiltration | Facial images are accessed or transmitted without the user's knowledge or consent | On-device processing only; no default image storage; no transmission of images to any server |
| T5: Cloud data breach | Firebase services are compromised, exposing stored data | Firebase's infrastructure-level security (Google Cloud); encryption at rest; access monitoring and audit logging |
| T6: Account takeover (phishing, credential theft) | An attacker gains access to a user's credentials | Strong password policies; optional multi-factor authentication; user education |
| T7: Insider threat (project team member) | A member of the project team misuses access to data | Principle of least privilege; audit logging; documented access policies; ethics protocol |

#### 6.9.2 Data Classification

The data processed and stored by the system is classified into three sensitivity levels:

1. **Public:** Information that is not sensitive and can be freely shared (e.g., general app settings, default symbol sets).
2. **Internal/Confidential:** Information that is sensitive and should be accessible only to authorised users (e.g., user profiles, vocabulary customisations, usage logs).
3. **Highly Sensitive:** Information that requires the highest level of protection (e.g., facial images, emotion history linked to a specific child, clinical notes from therapists). Highly sensitive data is subject to additional access controls, encryption, and audit logging.

### 3.6 Extended Problem Analysis: The Intersection of Disability, Technology, and Equity

The design and deployment of assistive technology for children with disabilities in LMICs raises broader questions about the intersection of disability, technology, and social equity. The social model of disability, which holds that disability is created not by individual impairment but by societal barriers (Oliver, 1990; Shakespeare, 2013), provides a useful lens for understanding the challenges faced by children with ASD in Sri Lanka. Under this model, the lack of accessible AAC tools is not simply a technical gap but a social and structural failure: a failure to prioritise the communication rights of children with disabilities, a failure to invest in culturally and linguistically appropriate technology, and a failure to create the conditions (training, infrastructure, policy) necessary for technology to be effectively deployed and sustained.

The Convention on the Rights of Persons with Disabilities (CRPD; United Nations, 2006), to which Sri Lanka is a signatory, affirms the right of persons with disabilities to freedom of expression and opinion, including the freedom to seek, receive, and impart information and ideas on an equal basis with others and through all forms of communication of their choice, including through augmentative and alternative communication (Article 21). The CRPD also calls on states parties to promote the development, availability, and use of information and communication technologies, assistive devices, and technologies suitable for persons with disabilities (Article 4). The present project contributes to the realisation of these rights by developing an AAC system that is designed specifically for the Sri Lankan context and that is intended to be accessible, affordable, and culturally appropriate.

The Sustainable Development Goals (SDGs; United Nations, 2015) also provide a relevant framework. SDG 3 (Good Health and Well-Being), SDG 4 (Quality Education), SDG 10 (Reduced Inequalities), and SDG 17 (Partnerships for the Goals) all have direct relevance to the project, which seeks to improve communication and quality of life for children with ASD (SDG 3), support their participation in education (SDG 4), reduce the technology gap for children with disabilities in a LMIC (SDG 10), and build partnerships between academic institutions and healthcare providers (SDG 17).

### 10.10 Extended Implementation Details: User Interface Design

#### 10.10.1 Design Principles

The user interface of the AAC application is designed according to the following principles, informed by AAC design guidelines (Beukelman and Light, 2020), accessibility standards (WCAG 2.1; W3C, 2018), and autism-specific design recommendations:

1. **Clarity and simplicity:** The interface is visually clean, with minimal clutter and a clear visual hierarchy. Symbols are large, clearly labelled, and well-spaced to reduce visual overload and accidental selections.

2. **Predictability and consistency:** Navigation patterns, icon styles, colour coding, and interaction paradigms are consistent throughout the application. Children with ASD often prefer predictable, routine-based interactions, and a consistent interface supports this preference (Mesibov et al., 2005).

3. **Configurability:** Recognising the diversity of user needs, the interface is highly configurable: grid size, symbol size, font size, colour theme (including high-contrast and dark modes), animation preferences (on/off), and feedback modes (auditory, visual, haptic) can all be adjusted by the caregiver.

4. **Accessibility:** The interface meets WCAG 2.1 Level AA guidelines where applicable, including sufficient colour contrast, text alternatives for images, keyboard/switch accessibility (for external switch access devices), and scalable text.

5. **Engagement:** While avoiding overstimulation, the interface uses subtle animations (e.g., symbol selection feedback, emotion indicator transitions) and a visually appealing colour palette to maintain engagement.

#### 10.10.2 Colour Palette and Typography

The default colour palette is designed to be calm, clear, and visually appealing, avoiding overly bright or saturated colours that may be overstimulating for some children with ASD. The palette includes:

- **Background:** Light neutral tones (soft white, light grey) for the main interface; dark mode option for low-light environments.
- **Primary accent:** A calming blue-teal (#36A2EB) for active elements, buttons, and navigation.
- **Secondary accent:** A warm orange (#FFAD33) for highlights and selected states.
- **Category colours:** Soft, distinct colours for each vocabulary category (e.g., green for foods, blue for feelings, purple for people, yellow for activities), configurable by the caregiver.
- **Error/warning:** Red (#E74C3C) for alerts and critical notifications.

Typography uses a clean, legible sans-serif font (e.g., Google's Noto Sans or Roboto), with support for Sinhala and Tamil Unicode scripts. Font sizes are configurable via the settings menu.

#### 10.10.3 Navigation Structure

The application uses a bottom navigation bar with clearly labelled tabs for the main sections:

1. **AAC Grid:** The primary communication interface, showing the current vocabulary category and symbol grid.
2. **Schedule:** The visual schedule view, showing the daily routine and progress.
3. **History:** A log of recent symbol selections and (for Platform B) emotion detections.
4. **Settings:** Configuration options for language, grid size, appearance, emotion detection, and account management.

Each screen is accessible within two taps from the home screen, following the "two-tap rule" recommended for AAC applications (Beukelman and Light, 2020).

#### 10.10.4 Emotion Indicator Design (Platform B)

The emotion indicator in Platform B is designed to be informative to the caregiver without distracting the child. It consists of:

- A small icon (emoji or custom illustration) representing the detected emotion, displayed in a corner of the AAC grid screen.
- The emotion label (e.g., "Happy," "Tired") in the active language, shown next to or below the icon.
- A confidence bar or percentage (optional, configurable in settings).
- A colour-coded background for the indicator (e.g., green for positive emotions, red for negative, grey for neutral or uncertain).
- Tap-to-override: Tapping the indicator opens a quick selection menu where the caregiver can correct the detected emotion or dismiss it.

The indicator is designed to be unobtrusive during normal AAC use, becoming more prominent (e.g., through a brief animation or colour change) when a new emotion is detected.

### 12.5 Extended Reflective Progress Review

#### 12.5.1 Technical Reflections

The technical development of the system has presented several learning opportunities. The integration of TensorFlow Lite with Flutter via platform channels was more complex than initially anticipated, requiring close attention to byte-level data handling, tensor format compatibility, and platform-specific API differences between Android and iOS. Debugging inference failures related to incorrect input tensor dimensions was a particularly time-consuming process, resolved by careful comparison of the model's expected input specification (from TFLite's metadata) with the actual data produced by the Dart preprocessing code.

Data augmentation tuning also required iterative experimentation. Initial runs with aggressive augmentation (e.g., large rotation ranges, heavy brightness/contrast variation) led to training instability and degraded validation accuracy, indicating that the augmentations were introducing unrealistic distortions. Reducing the augmentation intensity to the parameters documented in Table 8 restored stable training and improved validation metrics.

#### 12.5.2 Process Reflections

The incremental development model has proven effective in managing the project's complexity. The ability to deliver working increments and demonstrate progress at regular intervals has been valuable for maintaining momentum, providing evidence of progress to the supervisor, and identifying issues early. However, the single-developer context means that some agile practices (e.g., daily standups, pair programming, cross-functional team reviews) are not applicable, and the developer must exercise self-discipline in maintaining documentation, running tests, and adhering to the planned schedule.

Time management has been a recurrent challenge, particularly in balancing the extensive documentation requirements of the FC6P01ES module (including this interim report) with ongoing software development. The decision to begin the interim report early and to write it iteratively (alongside development, rather than in a single burst at the end) has helped, but the sheer volume of content required (50,000+ words) has necessarily consumed a significant portion of the available time.

#### 12.5.3 Stakeholder Engagement Reflections

Engaging with clinical stakeholders (therapists, hospital staff) has been both rewarding and challenging. The willingness of staff at Karapitiya Teaching Hospital to explore a partnership has been encouraging, and their informal feedback has directly improved the system's design. However, navigating the institutional processes (identifying the appropriate contacts, understanding the ethics application requirements, coordinating schedules) has taken longer than expected. This experience underscores the importance of early and proactive engagement with clinical partners, and of building realistic timelines for institutional processes into the project plan.

### 14.5 Extended Discussion of Generalisability

The system is designed with the Sri Lankan context as its primary target, but the architecture and many of the design decisions are generalisable to other settings:

1. **Multilingual AAC:** The trilingual architecture (with language-specific vocabulary, labels, and TTS) can be extended to support additional languages by adding new vocabulary files and configuring the TTS engine for the target language. This makes the system potentially adaptable for deployment in other multilingual LMICs.

2. **Culturally adaptive symbols:** The hybrid symbol approach (default set with caregiver customisation) can be adapted to any cultural context by replacing the default symbols and categories.

3. **On-device FER:** The on-device emotion recognition pipeline is architecture-agnostic and can be deployed on any device that supports TFLite, making it transferable to other contexts where privacy, offline operation, and low-cost deployment are important.

4. **Offline-first design:** The offline-first architecture is applicable to any mobile health or assistive technology application targeting areas with unreliable connectivity.

5. **Therapist??"parent dashboard:** The dashboard model is generalisable to any remote collaboration or telepractice scenario in speech-language pathology or related disciplines.

However, generalisability is limited by the fact that the system has been designed and evaluated in a single context (Sri Lanka), and performance, usability, and acceptability may differ in other settings. Future work should include cross-cultural validation and adaptation studies.

### 2.10 Extended Analysis of Sensory Processing and Interface Design for ASD

#### 2.10.1 Sensory Processing Differences in Autism

Sensory processing differences are recognised as a core feature of autism spectrum disorder in DSM-5, which includes "hyper- or hypo-reactivity to sensory input or unusual interest in sensory aspects of the environment" as a diagnostic criterion under the restricted, repetitive patterns of behaviour domain (APA, 2013). Research has consistently demonstrated that between 50% and 96% of individuals with ASD experience atypical sensory processing, depending on the assessment method and sample (Leekam et al., 2007; Ben-Sasson et al., 2009; Tomchek and Dunn, 2007).

Sensory processing differences in ASD are typically described along two dimensions: (1) hyper-reactivity (over-responsiveness), in which the individual responds more intensely or for a longer duration to sensory stimuli than expected; and (2) hypo-reactivity (under-responsiveness), in which the individual shows a reduced or absent response to sensory input. Many individuals with ASD exhibit a combination of both patterns across different sensory modalities (Baranek et al., 2006). Additionally, sensory seeking??"actively pursuing intense or unusual sensory experiences??"is a common pattern in ASD.

These sensory differences have direct and significant implications for the design of technology-based interventions for children with ASD:

- **Visual processing:** Children who are hypersensitive to visual input may be overwhelmed by bright colours, complex patterns, or animations in an app interface. Conversely, children who are hyposensitive may benefit from bold, high-contrast visuals and animated feedback to maintain attention.
- **Auditory processing:** Children who are hypersensitive to auditory input may be distressed by loud, sudden, or complex sounds, including TTS output at default volume levels. Configurable volume, sound effects toggle, and calm or natural-sounding TTS voices are important accommodations.
- **Tactile processing:** While less directly relevant to a software interface, children who seek or avoid tactile input may have difficulty with touchscreen interactions (e.g., finding the touch experience aversive, or preferring firm, deliberate taps over light touches).

The present project's interface design incorporates the following sensory accommodations: (a) configurable colour themes including a muted/pastel mode; (b) configurable animation settings (full, reduced, off); (c) configurable sound and volume settings; (d) a visual schedule with predictable, sequential structure to reduce cognitive and sensory load; and (e) a clean, uncluttered layout with generous spacing between interactive elements.

#### 2.10.2 Attention and Executive Function in AAC Use

Children with ASD may also experience differences in attention and executive function that affect their ability to use AAC systems effectively. Attention challenges may include difficulty sustaining focus on the AAC screen, difficulty shifting attention between the communication partner and the device, and difficulty filtering out irrelevant stimuli in the environment (Keehn et al., 2013). Executive function challenges may include difficulty planning multi-step communication sequences (e.g., navigating through categories to find a specific symbol), difficulty inhibiting impulsive selections, and difficulty adapting to changes in the interface (Hill, 2004).

These challenges inform several design decisions in the present project:

1. **Shallow navigation hierarchy:** Vocabulary is organised into a maximum of two levels (categories ??' symbols), minimising the number of navigation steps required to access any item. This reduces the executive function demands of the interaction.

2. **Recently used / favourites:** A "recently used" or "favourites" section on the home screen provides quick access to the child's most frequently used symbols, reducing the need for navigation.

3. **Consistent layout:** The layout and position of key elements (navigation buttons, category tabs, the AAC grid) remain constant across screens, reducing the need for visual search and reorientation.

4. **Confirmation for irreversible actions:** Actions such as deleting a symbol or clearing the communication bar require explicit confirmation, reducing the impact of impulsive selections.

5. **Visual schedule integration:** The visual schedule feature provides a structured, sequential representation of the child's activities, supporting executive planning and time awareness.

### 4.6 Extended Discussion of Research Objectives and Their Relationship to System Design

Each research objective maps to specific system features and evaluation criteria:

**Objective 1 (Provide AAC communication):** This objective requires: (a) a functional symbol grid with a meaningful vocabulary; (b) text-to-speech output in Sinhala, Tamil, and English; (c) support for vocabulary customisation; and (d) an interface that is usable by children with ASD and their caregivers. Evaluation: (i) functional testing of symbol selection and TTS output; (ii) vocabulary coverage assessment; (iii) usability evaluation (heuristic review and stakeholder feedback).

**Objective 2 (Integrate AI-based emotion recognition):** This objective requires: (a) a trained facial expression recognition model with acceptable accuracy on the target classes; (b) on-device inference with acceptable latency; (c) integration of the emotion output with the AAC interface; and (d) caregiver override functionality. Evaluation: (i) model accuracy metrics (precision, recall, F1, accuracy); (ii) inference latency benchmarks; (iii) functional testing of emotion-to-AAC adaptation; (iv) usability of the override mechanism.

**Objective 3 (Trilingual support):** This objective requires: (a) vocabulary labels in Sinhala, Tamil, and English; (b) TTS output in all three languages; (c) a language selection mechanism; and (d) testing of the interface and TTS in each language. Evaluation: (i) completeness of vocabulary translations; (ii) TTS quality assessment in each language; (iii) correct display of Sinhala and Tamil Unicode text.

**Objective 4 (Therapist??"parent collaboration):** This objective requires: (a) a web-based dashboard for therapists and parents; (b) user authentication and role-based access; (c) progress visualisation (charts, summaries); (d) remote vocabulary management; and (e) data synchronisation between the app and dashboard. Evaluation: (i) functional testing of dashboard features; (ii) data consistency between app and dashboard; (iii) usability feedback from therapists/parents.

**Objective 5 (Clinical validation through pilot):** This objective requires: (a) ethics approval; (b) participant recruitment; (c) data collection instruments; (d) pilot execution; and (e) analysis and reporting. Evaluation: (i) number of participants enrolled; (ii) completeness and quality of data collected; (iii) participant feedback; (iv) pilot findings as reported in the final report.

### 5.6 Extended Exploration of Research Questions

#### 5.6.1 RQ1: Feasibility of On-Device Emotion Recognition

This question addresses whether a CNN-based FER model can be deployed on a mobile device with acceptable performance in terms of accuracy, latency, and resource consumption. The question is motivated by the tension between the desire for AI-enhanced functionality and the constraints of mobile deployment:

- **Accuracy vs. model size trade-off:** Smaller models (e.g., MobileNetV2) have fewer parameters and thus lower representational capacity compared to larger models (e.g., ResNet-50, EfficientNet-B4). The question is whether the accuracy achieved by MobileNetV2 is sufficient for the application's needs??"bearing in mind that the emotion output is presented as a suggestive cue, not a definitive classification.

- **Latency and user experience:** If inference takes too long (e.g., >1 second), the emotion feedback will be delayed and potentially confusing or irrelevant by the time it is displayed. The 500 ms target is based on HCI research suggesting that delays below 500 ms are generally perceived as responsive, while delays above 1 second are perceived as sluggish (Nielsen, 1993).

- **Battery and thermal management:** Continuous inference can drain battery and cause the device to overheat, which may lead to negative user experiences or even safety concerns. The configurable capture frequency and battery-saving mode address these concerns.

#### 5.6.2 RQ2: Impact of Cultural and Linguistic Adaptation

This question examines whether a culturally and linguistically adapted AAC system is perceived as more useful and appropriate than generic (English-only, Western-focused) alternatives. The hypothesis is that adaptation will increase acceptance, engagement, and communicative effectiveness, but this must be tested through stakeholder feedback and (if possible) comparative analysis.

Cultural adaptation encompasses not only language but also symbol design, vocabulary content, daily routines reflected in the visual schedule, and the communication strategies modelled in the user guide and training materials. The pilot study will collect qualitative and quantitative data on the perceived cultural appropriateness of the system.

#### 5.6.3 RQ3: Therapist??"Parent Collaboration Through Technology

This question explores whether a technology platform can facilitate effective collaboration between therapists and parents/caregivers in supporting a child's AAC use. The dashboard provides a shared data environment, but the quality of collaboration depends on factors beyond the technology itself, including the therapist's engagement, the parent's confidence and motivation, and the therapeutic relationship. The pilot will assess the extent to which the dashboard is actually used by therapists and parents, the perceived value of the features provided, and the barriers to effective remote collaboration.

### 7.6 Extended Discussion of Incremental Model vs. Alternatives

#### 7.6.1 Why Not Agile (Scrum)?

The Agile Scrum framework, widely used in commercial software development, organises work into time-boxed sprints (typically 2??"4 weeks), with defined roles (Product Owner, Scrum Master, Development Team), ceremonies (sprint planning, daily standup, sprint review, sprint retrospective), and artefacts (product backlog, sprint backlog, increment) (Schwaber and Sutherland, 2020). While Agile Scrum offers several advantages??"rapid feedback, adaptive planning, continuous improvement??"it is designed for multi-person teams and its ceremonies and role definitions are not directly applicable to a single-developer academic project.

The project borrows several Agile principles (iterative delivery, prioritised backlog, regular reviews) without adopting the full Scrum framework. This pragmatic approach??"sometimes termed "Scrum-inspired" or "Agile-lite"??"retains the benefits of iterative development while avoiding the overhead of ceremonies that serve no purpose in a solo context.

#### 7.6.2 Why Not Waterfall?

The Waterfall model (Royce, 1970) organises development into sequential, non-overlapping phases: requirements ??' design ??' implementation ??' testing ??' deployment. While conceptually straightforward and amenable to documentation-driven academic contexts, the Waterfall model assumes that requirements are stable and well-understood from the outset, and that design and implementation can proceed without feedback until the testing phase. In a project with significant uncertainty (e.g., the performance of the FER model, the outcome of the ethics application, the availability of participants for the pilot), a sequential approach is risky, as problems discovered late in the process may require extensive rework of earlier phases.

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
| Rotation | ?+/-15 degrees | Pose variation |
| Brightness adjustment | ?+/-20% | Lighting variation |
| Contrast adjustment | ?+/-20% | Lighting variation |
| Gaussian noise | ?? = 0.01 | Sensor noise robustness |
| Random crop | 90??"100% of original | Position variation |
| Colour jitter (saturation) | ?+/-15% | Colour variation |
| Perspective transform | ?+/-5% | Head pose variation |
| Gaussian blur | ?? = 0??"1.0 | Focus variation |

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
2. Use the application with your child during daily communication activities for a period of [4??"8 weeks].
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

### 18.9 Extended Appendix: Information Sheet Template

**PARTICIPANT INFORMATION SHEET**

**Study Title:** Evaluation of an AI-Enhanced AAC Mobile Application for Children with Autism Spectrum Disorder in Sri Lanka

You are invited to participate in a research study conducted as part of a final year undergraduate project at ESOFT Metro Campus. Please read the following information carefully before deciding whether to participate.

**What is AAC?**
Augmentative and Alternative Communication (AAC) refers to methods and tools that help people who have difficulties with spoken language to communicate. AAC can include simple tools (picture boards, communication books) as well as high-tech tools (apps, electronic devices).

**What is this study about?**
We have developed a mobile application (app) that helps children with autism spectrum disorder (ASD) communicate using symbols (pictures) and speech output. The app works in Sinhala, Tamil, and English. It also has an optional feature that uses the device's camera to detect the child's facial expression (e.g., happy, sad, tired) and suggest communication options based on that expression. This feature is called "emotion detection."

**How does the emotion detection work?**
The emotion detection feature uses the device's front camera to take a picture of the child's face. A computer program (artificial intelligence model) on the device analyses the picture to guess the child's emotion. The result is shown to you (the parent/caregiver) as a suggestion??"you can accept, change, or dismiss it at any time. **No pictures of your child are stored or sent anywhere.** All processing happens on your device.

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

### 2.12 Extended Discussion: Natural Language Processing for Sinhala and Tamil

#### 2.12.1 Challenges of NLP for Low-Resource Languages

Natural language processing (NLP) has made remarkable progress in recent years, driven by advances in deep learning, large language models, and the availability of massive text corpora for high-resource languages such as English, Chinese, and Spanish. However, the benefits of these advances have not been equally distributed across languages. Sinhala and Tamil are classified as low-resource languages, meaning that the availability of annotated datasets, pre-trained models, language-specific tools (tokenisers, morphological analysers, parsers), and text-to-speech systems is significantly more limited compared to high-resource languages (Joshi et al., 2020).

For Sinhala, specific NLP challenges include: (a) the complex morphology of the language, with extensive inflectional and derivational processes that increase the effective vocabulary size and complicate tokenisation; (b) the relatively small amount of digitised text available for training language models (compared to, for example, Hindi or Bengali); (c) the Sinhala script, which is an abugida (syllabic alphabet) with a large character set, presenting challenges for character-level NLP models; and (d) the limited availability of Sinhala-specific NLP tools and libraries, although efforts by the Language Technology Research Laboratory (LTRL) at the University of Colombo and other institutions have produced some foundational resources (Fernando et al., 2016).

For Tamil, while more NLP resources exist (Tamil being spoken by a larger global population and being an official language of both India and Sri Lanka), challenges remain in: (a) agglutinative morphology, with complex word formations that can encode multiple grammatical meanings in a single word; (b) dialect variation between Sri Lankan Tamil and Indian Tamil; (c) the availability and quality of TTS systems that produce natural-sounding speech in Tamil; and (d) the integration of Tamil NLP tools with modern mobile development frameworks.

These challenges directly impact the present project in two areas: text-to-speech quality and future NLP-based features (e.g., word prediction, sentence construction assistance). The project documents the current state of Sinhala and Tamil TTS quality (based on testing of Google's TTS engine and any available alternatives) and identifies areas where recorded audio may be needed as a fallback. Future NLP enhancements (e.g., predictive text input, grammatically correct sentence assembly from symbol sequences) are explicitly identified as areas for future research and development.

#### 2.12.2 Unicode Support and Script Rendering

Both Sinhala and Tamil scripts are fully supported in the Unicode standard, and modern mobile operating systems (Android 8.0+, iOS 14+) include system-level font support for both scripts. However, correct rendering of Sinhala and Tamil text??"including complex conjunct characters, vowel signs, and ligatures??"requires appropriate font selection and text rendering engine configuration.

Flutter, the project's UI framework, uses the Skia graphics engine for text rendering, which supports complex scripts including Sinhala and Tamil. However, edge cases in rendering (e.g., certain rare conjunct characters, mixed-script text with Sinhala, Tamil, and Latin characters in the same string) must be tested on the target devices to ensure correct display. The project includes a comprehensive text rendering test suite covering common vocabulary items in all three languages, with screenshots documented in the testing appendix.

### 3.7 Extended Problem Statement: The Digital Divide in Disability Services

The concept of the "digital divide"??"the gap between those who have access to and can effectively use digital technologies and those who do not??"is particularly acute in the context of disability services in LMICs. While digital technologies (including mobile apps, telehealth platforms, and AI-based tools) have the potential to dramatically expand access to disability services, realising this potential requires addressing multiple barriers: device availability, internet connectivity, digital literacy, content availability in local languages, and the design of technology that is usable by people with diverse abilities and in diverse cultural contexts (UN Broadband Commission, 2019).

In Sri Lanka, the digital divide in disability services manifests in several ways:

1. **Urban??"rural divide:** Families in Colombo and other major cities have significantly better access to specialist services, including SLTs, developmental paediatricians, and assistive technology providers. Families in rural areas may have to travel long distances for specialist appointments and may have limited or no access to AAC assessment and intervention.

2. **Socioeconomic divide:** The cost of devices (smartphones, tablets), internet connectivity, and commercially available AAC apps places them beyond the reach of many low-income families. Even when free or low-cost apps are available, the cost of a suitable device may be a barrier.

3. **Language divide:** The predominance of English-language AAC tools means that families who are not proficient in English are effectively excluded from the digital AAC ecosystem. This English-language bias reflects a broader pattern in assistive technology development, which has historically prioritised the needs and languages of high-income, English-speaking markets.

4. **Knowledge divide:** Many families and even some professionals are unaware of the existence and potential benefits of AAC. Raising awareness about AAC, and about the specific system developed in this project, is an important component of the dissemination and implementation strategy.

The present project explicitly addresses these dimensions of the digital divide: it targets families across the socioeconomic spectrum by being free and running on affordable Android devices; it provides full trilingual support (Sinhala, Tamil, English); it is designed for use with minimal professional training; and it aims to raise awareness through its clinical partnership with Karapitiya Teaching Hospital and through dissemination activities (publications, presentations, community engagement).

## 3. Problem Statement

### 3.1 Overview of the Problem

Children with autism spectrum disorder (ASD) in Sri Lanka face substantial and multifaceted barriers to effective communication support. These barriers operate at multiple levels: systemic (shortage of trained professionals, limited availability of specialist services, uneven geographic distribution of resources), technological (absence of culturally and linguistically appropriate AAC tools, lack of integration between AAC and affective computing), and contextual (variable internet connectivity, diverse linguistic needs, economic constraints on device affordability). The result is a significant gap between the evidence-based potential of augmentative and alternative communication (AAC) to support communication development in children with ASD and the practical reality of what is available and accessible for families in Sri Lanka (Samad et al., 2020; Perera et al., 2019).

The significance of this problem is underscored by the growing recognition of ASD in Sri Lanka, the increasing demand for specialist services, and the persistent shortage of trained speech-language therapists, developmental paediatricians, and assistive technology specialists. Perera et al. (2019) estimated a prevalence of approximately 1.07 per cent among children aged two to nine years in the study area, suggesting a substantial population of children who could benefit from AAC intervention. Yet the tools available to these children and their families are overwhelmingly designed for English-speaking Western markets and do not accommodate the trilingual reality (Sinhala, Tamil, English) of Sri Lanka or the country's specific cultural, resource, and connectivity constraints.

### 3.2 Inadequacy of Existing AAC Solutions for the Sri Lankan Context

Existing AAC solutions are frequently designed for Western, English-dominant contexts and lack native support for Sinhala and Tamil, the two official languages of Sri Lanka. The comparison of existing systems presented in Table 1 (Section 2.2.4) demonstrates that, while several robust AAC applications exist in the market??"including Proloquo2Go, TouchChat, LAMP Words for Life, and Avaz AAC??"none provides integrated support for both Sinhala and Tamil. Even Avaz AAC, which includes Tamil among its supported languages, does not offer Sinhala support. This linguistic gap has direct consequences for usability and adoption: a child whose home language is Sinhala cannot be expected to benefit fully from an AAC system that presents vocabulary, symbols, and speech output only in English or Tamil. The mismatch between the language of the AAC system and the language of the child's communicative environment undermines the effectiveness of the intervention and may contribute to low uptake and abandonment (Alant and Bornman, 2021; Samad et al., 2020).

Beyond language, cultural appropriateness is a critical factor that is often overlooked in the design of AAC systems for global markets. Symbols and vocabulary in AAC must reflect the user's cultural context??"including familiar foods, activities, social routines, religious and cultural practices, and family structures??"to maximise relevance and communicative utility (Alant and Bornman, 2021). AAC systems designed for North American or European markets may include symbols for items and activities that are unfamiliar or irrelevant in the Sri Lankan context (e.g., sandwiches, snow, Halloween), while omitting symbols for culturally significant concepts (e.g., rice and curry, temple visits, Sinhalese or Tamil New Year celebrations, local games and activities). The lack of cultural and contextual relevance can reduce the child's engagement with the system and the family's motivation to continue using it, ultimately limiting the therapeutic benefit of the intervention.

The cost of existing high-tech AAC solutions is a further barrier. Dedicated devices such as those from PRC-Saltillo or Tobii Dynavox can cost several hundred to several thousand US dollars, placing them well beyond the reach of most families in Sri Lanka. Tablet-based applications such as Proloquo2Go are more affordable but still require an iPad or similar device, and the app itself costs approximately USD 250. For a project targeting deployment in a low- and middle-income country, affordability and accessibility on widely available Android smartphones are essential considerations.

### 3.3 Absence of Emotion-Adaptive Communication Support

Conventional AAC systems are largely static: they present a fixed or user-configured set of symbols and phrases without dynamically adapting to the user's current emotional or physiological state. For children with limited verbal ability, emotional state can be difficult to express and for caregivers to interpret accurately. A child who is tired, distressed, or overwhelmed may not be able to use their AAC system to communicate these states, and the caregiver may not recognise the signs until the child's distress escalates into challenging behaviour (Fletcher-Watson and Happ?(c), 2019). Research has shown that children with ASD may have particular difficulty with emotion regulation and expression, and that misinterpretation of emotional cues by caregivers is a common source of frustration for both the child and the family (Mazefsky et al., 2013).

The integration of facial expression recognition (FER) into AAC offers a potential solution to this problem. By inferring the user's emotional state from facial expressions and adapting the vocabulary or prompts presented by the system, the AAC can proactively offer emotionally relevant communication options (e.g., "I am tired," "I need a break," "I am sad") without relying solely on the child's volitional selection. This approach has the potential to improve the responsiveness and relevance of the AAC system, reduce communicative frustration, and provide caregivers with additional cues to support their interpretation of the child's needs.

However, this integration is not straightforward and must be approached with caution. The accuracy and reliability of FER models for children with ASD, the ethical implications of facial image capture, the risk of misclassification and its consequences for the child and caregiver, and the design of appropriate override mechanisms all require careful consideration. The present project does not claim that FER can or should replace human judgment in interpreting a child's emotional state; rather, it is positioned as an assistive cue that can support the caregiver in identifying and responding to the child's needs, with the caregiver always retaining the ability to override or disable the feature. This positioning is consistent with the recommendations of Fletcher-Watson and Happ?(c) (2019) for responsible deployment of AI in sensitive domains.

### 3.4 Access, Equity, and Scalability

Access to specialist services for children with ASD in Sri Lanka is limited by geography, economics, and the supply of trained professionals. Families in rural or semi-urban areas may have limited or no access to speech-language therapists, developmental paediatricians, or assistive technology specialists (Perera et al., 2019; Samad et al., 2020; Wickramasinghe et al., 2021). Even in urban centres, waiting times for assessment and intervention can be long, and the cost of private therapy may be prohibitive for many families. A mobile-based AAC system that can be introduced and configured during a clinical visit and continued at home and in educational settings, that works offline in areas with poor connectivity, and that supports remote collaboration between therapists and parents through a secure dashboard could help bridge these access gaps and extend the reach of specialist services.

The therapist??"parent dashboard is a key element of the proposed system's approach to scalability and service extension. By enabling therapists to remotely monitor a child's AAC usage, review progress data, and adjust vocabulary and settings, the dashboard supports a model of distributed care in which the therapist does not need to be physically present for every interaction. This model aligns with emerging approaches to telepractice in speech-language pathology, which have been shown to be feasible and effective for AAC intervention in some contexts (Grogan-Johnson et al., 2013).

The pilot collaboration with Karapitiya Teaching Hospital, subject to institutional ethics committee and Ministry of Health approval, is intended to provide a clinically supervised context for evaluating the feasibility, acceptability, and usability of the system. The hospital's established paediatric and psychiatric services, its role as a regional referral centre in the Southern Province, and its track record of supporting research collaborations make it a suitable partner for this pilot. The pilot is not intended to produce definitive evidence of clinical effectiveness??"which would require a larger, controlled study??"but rather to generate formative data on the system's usability, user acceptance, technical reliability, and areas for improvement.

### 3.5 Problem Statement Summary

The core problem addressed by this project may therefore be stated as follows:

> There is a need to design, develop, and evaluate a dual-platform, AI-powered AAC system that is linguistically and culturally appropriate for children with autism in Sri Lanka, that integrates facial expression recognition for adaptive communication support, and that is feasible for deployment and clinical evaluation within the country's healthcare, resource, and connectivity constraints.

This overarching problem statement implies several sub-problems: (1) the need for a robust, maintainable, and scalable software architecture that supports two user groups (ASD Levels 1??"2 and Level 3+) with differentiated features; (2) the need for an AI model (emotion recognition) that meets defined accuracy and efficiency targets and is deployable on affordable mobile devices; (3) the need for a secure, privacy-respecting data management and collaboration framework; (4) the need for ethical and regulatory compliance, including institutional and governmental approvals for data collection and pilot deployment; and (5) the need for realistic pilot design and evaluation that can be completed within the scope of a final year project.

## 4. Aim and Objectives

### 4.1 Aim

The aim of this project is to design and develop an AI-powered augmentative and alternative communication (AAC) system with facial expression recognition, tailored for children with autism spectrum disorder in Sri Lanka, and to establish a foundation for its pilot evaluation in a clinical setting.

This aim reflects the project's dual ambition: to produce a functional, deployable software system that addresses a real and pressing need, and to conduct the preparatory work (including ethical approvals, partnership building, and pilot design) necessary for a rigorous evaluation of the system's feasibility, usability, and initial efficacy. The aim is deliberately scoped to be achievable within a final year project, while laying the groundwork for future work that could extend the system's reach and evidence base.

### 4.2 Objectives

The project objectives are as follows:

**Objective 1: Dual-Platform Architecture Design.**
To design a dual-platform architecture comprising: (a) Platform A ??" a customisable, symbol-based AAC platform for children at ASD severity levels 1??"2, with full trilingual support for Sinhala, Tamil, and English, configurable vocabulary and grid layout, text-to-speech output, and visual scheduling; and (b) Platform B ??" an AI-enhanced AAC platform for children at level 3 and above, extending Platform A's features with on-device facial expression recognition to infer the user's emotional state and adapt communication options accordingly. The architecture must be modular, maintainable, and extensible, supporting iterative development and future enhancements.

**Objective 2: Cross-Platform Mobile Application Development.**
To implement a cross-platform mobile application using Flutter, with an offline-first architecture and secure cloud backup using Firebase, ensuring usability, accessibility, and reliability for the target users (children with ASD) and their communication partners (parents, caregivers, therapists). The application must function fully on Android 8.0+ and iOS 14+ devices, with an emphasis on performance and responsiveness on mid-range devices commonly available in Sri Lanka.

**Objective 3: AI Model Training and Deployment.**
To design, train, and deploy a convolutional neural network??"based facial expression recognition model using transfer learning (MobileNetV2) and TensorFlow Lite, targeting six emotion classes (happy, sad, angry, fear, neutral, tired) and achieving an accuracy of at least 80 per cent on a curated dataset of 2,000??"5,000 images, with documented precision, recall, F1 score, and confusion matrix analysis. The model must be quantised for efficient on-device inference and demonstrate acceptable latency (< 500 ms per inference) on target devices.

**Objective 4: Therapist??"Parent Dashboard Development.**
To develop a therapist??"parent dashboard (web-based or web-view within the app) that supports collaboration, progress monitoring, vocabulary management, and backup management, in line with data protection and ethical requirements and integrated with the mobile application and Firebase backend. The dashboard must be accessible, intuitive, and functional for users with varying levels of digital literacy.

**Objective 5: Ethical Approval and Partnership.**
To establish ethical approval and partnership protocols for a pilot study in collaboration with Karapitiya Teaching Hospital, Galle, including engagement with the hospital's institutional ethics committee and Ministry of Health approval processes where applicable. This objective includes the development of consent forms, information sheets, and data management protocols in Sinhala, Tamil, and English.

**Objective 6: Documentation and Reporting.**
To document the system architecture, development methodology, AI model design, data collection strategy, ethical considerations, and project progress in interim and final reports conforming to the FC6P01ES module requirements, with rigorous Harvard referencing and critical academic analysis throughout. The documentation must demonstrate examiner-level quality in terms of academic rigour, technical depth, and clarity of presentation.

### 4.3 Success Criteria

The success of the project will be assessed against the following criteria, which are mapped to the objectives above:

1. **Functional completeness (Objectives 1, 2, 4):** Both Platform A and Platform B are implemented and demonstrate core AAC functionality (symbol-based communication, multilingual support, text-to-speech) and, for Platform B, on-device emotion recognition with adaptive vocabulary. The therapist??"parent dashboard is functional and provides useabe progress monitoring and vocabulary management.
2. **Model accuracy (Objective 3):** The emotion recognition model achieves at least 80 per cent accuracy on the held-out test set, with per-class precision, recall, and F1 reported, analysed, and compared against relevant benchmarks.
3. **Offline operation (Objective 2):** Core AAC and emotion recognition function without internet connectivity, as verified through structured testing.
4. **Usability (Objectives 1, 2, 4):** The system is usable by children with ASD (with caregiver/therapist support) as assessed through informal or formal usability evaluation, including feedback from at least one therapist and one parent or caregiver.
5. **Ethical compliance (Objective 5):** All data collection and pilot activities are conducted in accordance with approved ethical protocols, with evidence of engagement with the institutional ethics committee and Ministry of Health.
6. **Documentation quality (Objective 6):** The interim and final reports meet the standards of academic rigour, critical analysis, and presentation expected at the FC6P01ES examination level, with comprehensive Harvard referencing and logical academic flow.

## 5. Research Questions

The project is guided by the following research questions, which are aligned with the objectives and designed to structure the investigation, development, and evaluation phases:

### Research Question 1: System Architecture and Design

**RQ1:** How can a dual-platform AAC system be architecturally designed to serve both children with ASD at severity levels 1??"2 (customisable symbol-based interface) and those at level 3 and above (AI-enhanced interface with facial expression recognition), while maintaining consistency in language support (Sinhala, Tamil, English), offline-first operation, and secure data management?

This question addresses the fundamental software engineering challenge of the project: how to design a system that serves two distinct user groups with different needs and capabilities, while sharing core services and design principles and meeting the constraints of mobile deployment, offline operation, and data security. The question is answerable through the design process itself (architecture diagrams, design rationale, and implementation), as well as through evaluation of the implemented system against the defined non-functional requirements. The dual-platform approach is informed by the DSM-5 severity classification (American Psychiatric Association, 2013) and by the AAC literature's emphasis on individualisation and flexibility (Light and McNaughton, 2015; Beukelman and Light, 2020). The architectural decisions made in response to this question are documented in Section 6 and evaluated through the testing activities described in Sections 10 and 12.

### Research Question 2: AI Model Performance

**RQ2:** What is the achievable accuracy of an on-device facial expression recognition model based on MobileNetV2 transfer learning and TensorFlow Lite deployment when trained on a dataset of 2,000??"5,000 images across six emotion classes (happy, sad, angry, fear, neutral, tired), and what factors (e.g., data augmentation, class balance, hyperparameter tuning, quantization) most influence performance?

This question addresses the AI and machine learning dimension of the project. It is formulated to be empirically answerable through model training, evaluation, and ablation studies. The choice of MobileNetV2 and TensorFlow Lite is motivated by the need for efficient on-device inference (Sandler et al., 2018), while the dataset size range (2,000??"5,000 images) reflects the constraints of a final year project with limited resources for data collection. The question invites investigation of the factors that most influence model performance??"including the composition and quality of the training data, the choice and intensity of data augmentation, the balance across emotion classes, the learning rate and optimiser settings, and the effect of post-training quantization on accuracy??"which is valuable both for the project itself and for contributing to the broader literature on FER in low-resource and specialised settings. The findings are reported in Sections 8 and 10, with full analysis planned for the final report.

### Research Question 3: Therapist??"Parent Collaboration

**RQ3:** How can therapist??"parent collaboration and progress monitoring be effectively supported through a secure dashboard integrated with the mobile AAC application and cloud backup (Firebase), while respecting privacy and consent requirements in the Sri Lankan context?

This question addresses the human-computer interaction and clinical workflow dimensions of the project. Effective collaboration between therapists and parents is widely recognised as a critical success factor for AAC intervention (Light and McNaughton, 2015; Beukelman and Light, 2020), and the design of digital tools to support this collaboration must balance functionality, usability, privacy, and regulatory compliance. The Sri Lankan context introduces additional considerations, including the need for multilingual support in the dashboard interface, the varying levels of digital literacy among parents and therapists, and the privacy and data protection landscape. The question is answerable through the design and implementation of the dashboard, feedback from at least one therapist and one parent (or representative informant), and analysis of the data flow and privacy architecture. The design and implementation of the dashboard are documented in Sections 6 and 10, and further feedback will be sought in the next project phase (Section 11).

### Research Question 4: Ethical and Regulatory Considerations

**RQ4:** What ethical, regulatory, and practical considerations must be addressed to conduct a pilot deployment of the system with children with autism at Karapitiya Teaching Hospital, and how can these be navigated within the scope of a final year project in Sri Lanka?

This question is particularly important given the involvement of vulnerable children, facial image data, and a healthcare institutional partner. The ethical landscape for research involving children with ASD is complex, encompassing issues of informed consent (from parents/guardians and assent from children where possible), privacy and data protection, minimisation of harm, and institutional and governmental approval processes (Fletcher-Watson and Happ?(c), 2019). In Sri Lanka, the regulatory pathway involves submission of a research proposal to the relevant institutional ethics review committee and compliance with Ministry of Health research governance requirements (Ministry of Health, Sri Lanka, 2020). The question is answerable through the documentation and analysis of the ethics application process, the content of the ethical protocols developed, and reflection on the challenges and lessons learned. The ethical framework and current progress are documented in Section 9.

### Research Question 5: System Evaluation

**RQ5:** To what extent does the implemented system meet the functional and non-functional requirements (usability, accessibility, offline capability, multilingual support, and emotion-adaptive behaviour) defined for the target user groups and the Sri Lankan context, and what are the key areas for improvement?

This question is evaluative and will be most fully addressed in the final report, following completion of the system and, where feasible, the pilot study. In the interim report, the question is addressed through the documentation of requirements, architecture, and design decisions, as well as through the testing that has been conducted to date (Section 10). The question's breadth is intentional: it invites consideration of both technical (performance, reliability, accuracy) and user-centred (usability, acceptance, satisfaction) dimensions of quality, reflecting the project's commitment to developing a system that is not only technically sound but also meaningful and useful in practice. The evaluation framework, including the metrics, methods, and data sources to be used, is outlined in Sections 8 and 11.

## 6. System Architecture

### 6.1 Architectural Overview

The system is conceived as a dual-platform architecture that serves two distinct user groups while sharing a common technology stack, core services, and design principles. The architecture is designed to be modular, extensible, and maintainable, supporting iterative development and future enhancements beyond the scope of the current project. This section describes the high-level architecture, the role of each platform, the integration of the AI component and cloud services, and the rationale for key technology choices.

The major architectural components are:

1. **Two client-facing mobile applications** (Platform A and Platform B) built with Flutter, targeting Android and iOS from a single Dart codebase.
2. **An on-device facial expression recognition module** using TensorFlow Lite, integrated into Platform B and invoked via platform channels.
3. **A backend** comprising Firebase Authentication, Cloud Firestore for structured data, and Firebase Cloud Storage for backup and media.
4. **A therapist??"parent web-based dashboard** that consumes the same backend services.
5. **A local data layer** (SQLite or equivalent) for offline storage of user profiles, vocabulary, settings, and usage data.

The architecture follows an offline-first design philosophy: all core AAC functionality (symbol display, text-to-speech, vocabulary customisation) and emotion recognition operate locally on the device, without requiring network connectivity. Cloud synchronisation and backup occur opportunistically when connectivity is available, using Firebase's built-in offline persistence and data synchronisation capabilities. This design principle is a direct response to the connectivity constraints that are common in many parts of Sri Lanka, particularly in rural and semi-urban areas (International Telecommunication Union, 2022), and is consistent with best practices for assistive technology deployment in low-resource settings (Divan et al., 2021).

[Figure 1: Overall System Architecture Diagram]

### 6.2 Dual-Platform Design

The dual-platform design reflects the heterogeneity of ASD and the differing needs of children across the severity spectrum. Rather than building a single, monolithic application that attempts to serve all users with a single interface, the project provides two differentiated platforms that share a common codebase and backend but offer distinct feature sets and interaction paradigms tailored to the user's severity level and communication profile. This approach is informed by the DSM-5 severity classification (American Psychiatric Association, 2013) and by the AAC literature's emphasis on individualisation and flexibility (Light and McNaughton, 2015; Beukelman and Light, 2020).

#### 6.2.1 Platform A: Customisable Symbol-Based AAC (Levels 1??"2)

Platform A is designed for children with ASD at severity levels 1??"2 who can interact with a symbol-based grid or list interface and who benefit from AAC as a supplement to their developing speech. The design of Platform A is informed by established AAC design principles, including vocabulary organisation, symbol clarity, configurable layout, and multimodal output (Beukelman and Light, 2020). Key features include:

- **Symbol grid interface:** A configurable grid of symbols (images with text labels) organised into categories (e.g., basic needs, feelings, activities, foods, people, places). The grid size (e.g., 2?-2, 3?-3, 4?-4, 6?-6) is configurable to match the child's visual and motor abilities. Each symbol can trigger text-to-speech output and/or be combined into multi-symbol utterances.
- **Trilingual support:** All symbols and labels are available in Sinhala, Tamil, and English. The language can be switched globally or configured per category. The system supports mixed-language use for bilingual children and families.
- **Text-to-speech (TTS) output:** When a symbol is selected, the corresponding word or phrase is spoken aloud using the device's TTS engine or a third-party TTS API. TTS quality and availability may vary across languages; the project documents the TTS options tested and their suitability for each language.
- **Customisation:** Parents and therapists can add, remove, or reorder symbols; create custom categories; add photographs as symbols; and configure visual and interaction settings (e.g., font size, colour themes, animation preferences, feedback modes).
- **Visual scheduling:** An optional visual schedule feature allows parents and therapists to create daily routines, which the child can follow and interact with. Visual schedules are a well-established intervention strategy for children with ASD (Mesibov et al., 2005).
- **Usage logging:** The app logs symbol selections, session duration, and interaction patterns (locally, with optional cloud backup), providing data for therapists and parents to monitor progress and inform intervention planning.

[Figure 9: Mobile App UI Layout ??" Level 1??"2]

#### 6.2.2 Platform B: AI-Enhanced AAC with Facial Expression Recognition (Level 3+)

Platform B extends Platform A's functionality by adding an optional facial expression recognition pipeline. It is designed for children at level 3 and above who may have minimal or no functional speech and higher support needs. The rationale for adding emotion recognition is that children at this severity level may have greater difficulty communicating their emotional state through conventional means, and caregivers may benefit from additional cues to guide their responses.

Key additional features include:

- **Facial expression recognition:** When enabled by the caregiver, the device camera (typically front-facing) captures the user's face periodically or on demand. The captured image is processed on-device using the TensorFlow Lite model, which classifies the facial expression into one of six emotion classes (happy, sad, angry, fear, neutral, tired).
- **Emotion-adaptive vocabulary:** Based on the inferred emotion, the AAC interface adapts the vocabulary or prompts presented to the child. The adaptation rules are configurable to avoid over-reliance on the model.
- **Caregiver override and transparency:** The system displays the inferred emotion to the caregiver (e.g., as an icon or text indicator), who can accept, override, or dismiss the suggestion. The interface makes clear that the emotion recognition is an assistive cue, not a definitive assessment.
- **Emotion history and trends:** The dashboard can display aggregated emotion data (e.g., distribution of detected emotions over time) to support therapist and parent understanding of the child's emotional patterns. Raw facial images are not stored by default.

[Figure 2: Dual Platform Architecture Diagram]

[Figure 10: Mobile App UI Layout ??" Level 3+]

### 6.3 Emotion Detection Pipeline

The emotion detection pipeline integrated into Platform B operates as a five-stage process:

1. **Face detection:** A lightweight face detection algorithm (e.g., Google ML Kit face detection API) identifies the presence and bounding box of a face in the camera frame. If no face is detected, the pipeline does not proceed, and no emotion inference is attempted.
2. **Preprocessing:** The detected face region is cropped from the camera frame, resized to the model's input dimensions (224?-224 pixels for MobileNetV2), and normalised (pixel values scaled to the range expected by the model, typically [0, 1] or [-1, 1]).
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

### 6.5 Therapist??"Parent Dashboard

The dashboard provides authorised users with tools for collaboration, progress monitoring, vocabulary management, and data export. Features include linked accounts, progress visualisation (charts and summaries), vocabulary management, export capabilities, and backup/restore functions. The dashboard is designed to be accessible on standard web browsers and responsive to different screen sizes.

[Figure 5: Therapist??"Parent Collaboration Flow]

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

## 7. Development Methodology

### 7.1 Choice of Methodology

The project follows an incremental development model, which is characterised by the delivery of the system in a series of increments, each producing a potentially shippable subset of functionality (Sommerville, 2016). This choice is justified by several factors specific to the project context:

1. **Phased delivery:** The dual-platform architecture, with its multiple components (Platform A, Platform B, AI model, backend, dashboard), lends itself naturally to incremental delivery. Platform A (basic AAC) can be developed and validated first, providing a working product that delivers value even before the AI and emotion recognition components are complete. This reduces project risk and enables early feedback.

2. **Stakeholder feedback:** The involvement of multiple stakeholder groups (children with ASD, parents/caregivers, therapists, hospital staff) requires iterative feedback loops. An incremental approach allows each increment to be demonstrated to and reviewed by stakeholders, with feedback informing the design and implementation of subsequent increments.

3. **Dependency management:** Several project activities have external dependencies??"most notably, ethics approval from Karapitiya Teaching Hospital and the Ministry of Health, which must be obtained before data collection with children can proceed. The incremental model allows the project to proceed with activities that are not dependent on these approvals (e.g., software development, public dataset validation) while preparing for those that are.

4. **Academic constraints:** A final year project operates within a fixed timeline with defined milestones (interim report, final report). The incremental model provides natural checkpoints that align with these milestones, facilitating progress tracking and reporting.

5. **Risk reduction:** By delivering working increments early and often, the incremental model reduces the risk of discovering fundamental design flaws late in the project. Each increment is tested and validated before the next increment is begun, ensuring that problems are identified and addressed early (Sommerville, 2016).

### 7.2 Incremental Plan

The project is divided into five major increments, each with defined deliverables and validation criteria:

**Increment 1 (Months 1??"2): Requirements, Architecture, and Minimal AAC.**
Deliverables: Literature review and requirements document; system architecture design; Flutter project structure; minimal AAC interface with basic symbol grid and single-language support. Validation: Internal review of architecture; manual testing of basic AAC flow on Android emulator.

**Increment 2 (Months 3??"4): Full Platform A and Backend.**
Deliverables: Complete Platform A with trilingual support, customisation features, TTS integration, and visual scheduling; Firebase backend (Authentication, Firestore, Storage) configured and integrated; basic therapist??"parent dashboard. Validation: Manual testing of full AAC flow in Sinhala, Tamil, and English; sync testing with Firebase; informal usability check with at least one representative user.

**Increment 3 (Months 5??"6): AI Model and Platform B Integration.**
Deliverables: Trained MobileNetV2-based emotion recognition model; TFLite export and quantization; on-device inference pipeline integrated into Flutter; Platform B with emotion-adaptive vocabulary; initial model evaluation (accuracy, precision, recall, F1, confusion matrix). Validation: Model evaluation on held-out test set; end-to-end testing of emotion detection pipeline on physical device; latency benchmarking.

**Increment 4 (Months 7??"8): Dashboard Completion, Ethics, and Pilot Preparation.**
Deliverables: Complete therapist??"parent dashboard with progress visualisation, vocabulary management, and export; ethics application submitted and (ideally) approved; pilot design and participant recruitment materials prepared; consent forms and information sheets in Sinhala, Tamil, and English. Validation: Dashboard feedback from at least one therapist and one parent; ethics approval documentation; pilot protocol review.

**Increment 5 (Months 9??"10): Pilot Execution and Final Report.**
Deliverables: Pilot deployment at Karapitiya Teaching Hospital (subject to approval); data collection and analysis; final report and dissertation; presentation or demo for the examining panel. Validation: Pilot data analysis (usability, acceptance, model performance in situ); final report review; supervisor sign-off.

### 7.3 Comparison with Alternative Methodologies

Several alternative development methodologies were considered and evaluated against the project's requirements and constraints:

**Waterfall model:** The waterfall model prescribes a sequential flow through requirements, design, implementation, testing, and maintenance phases. While it provides strong documentation and phase-gate controls, it is poorly suited to projects with evolving requirements, external dependencies, and the need for early feedback??"all of which characterise this project. The late integration of testing and the inability to revisit earlier phases without formal change control make the waterfall model inflexible and risky for a project of this nature (Sommerville, 2016).

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

## 8. AI Model Design and Data Collection

### 8.1 Convolutional Neural Network Foundations

A convolutional neural network (CNN) is a class of deep neural network designed to process data with a grid-like topology, such as images (two-dimensional grids of pixels). CNNs have become the dominant approach for image classification, object detection, and many other computer vision tasks, owing to their ability to learn hierarchical feature representations directly from raw data (LeCun et al., 2015; Goodfellow et al., 2015). The fundamental operations of a CNN are convolution, activation, and pooling, which together enable the network to extract increasingly abstract and discriminative features from the input image.

#### 8.1.1 Convolution Operation

The convolution operation is the defining feature of a CNN. In the discrete two-dimensional case, the convolution of an input feature map $I$ with a kernel (filter) $K$ is defined as:

$$
(I * K)_{i,j} = \sum_m \sum_n I_{i+m, j+n} \cdot K_{m,n}
$$

where the indices $m$ and $n$ range over the spatial extent of the kernel, and the output at position $(i, j)$ is the sum of element-wise products over the kernel window. In practice, the operation is technically a cross-correlation rather than a true mathematical convolution (which would involve flipping the kernel), but the term "convolution" is standard in the deep learning literature (Goodfellow et al., 2015).

Each convolutional layer applies multiple kernels (filters) to the input, producing multiple output feature maps (also called channels). Each kernel is learned during training and specialises in detecting a particular type of local feature (e.g., an edge at a specific orientation, a colour gradient, a textural pattern). The number of kernels per layer, the kernel size (e.g., 3?-3, 5?-5), the stride (step size with which the kernel moves across the input), and the padding (whether the input is zero-padded to preserve spatial dimensions) are hyperparameters that are specified as part of the architecture design.

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

where $R_{i,j}$ is the pooling region at position $(i, j)$. A typical pooling window size is 2?-2 with a stride of 2, which reduces the spatial dimensions by half. Average pooling, which computes the mean value within each window, is also used, particularly in the later stages of some architectures (e.g., global average pooling before the final classification layer).

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

The choice of optimisation algorithm affects training speed, convergence, and final model performance. The most commonly used optimiser in modern deep learning is Adam (Adaptive Moment Estimation), introduced by Kingma and Ba (2015). Adam combines the advantages of two other optimisers??"AdaGrad (which adapts the learning rate for each parameter based on the history of gradients) and RMSprop (which uses a moving average of squared gradients)??"to provide adaptive, per-parameter learning rates. The Adam update rules are:

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

[Figure 3: CNN Architecture ??" MobileNetV2 Adaptation]

#### 8.5.2 MobileNetV2 Architecture Details

MobileNetV2 is built upon depthwise separable convolutions and introduces two key innovations: inverted residual blocks and linear bottlenecks (Sandler et al., 2018). A standard convolution applies a single set of filters across all input channels, resulting in a computational cost proportional to the product of the number of input channels, the number of output channels, and the spatial dimensions of the filter. Depthwise separable convolutions decompose this into two steps: (1) a depthwise convolution, which applies a single filter per input channel, and (2) a pointwise convolution (1?-1 convolution), which combines the outputs across channels. This decomposition reduces computational cost by a factor of approximately $1/N + 1/D_K^2$, where $N$ is the number of output channels and $D_K$ is the kernel size.

The inverted residual block in MobileNetV2 proceeds as follows: (1) a 1?-1 convolution expands the input to a higher-dimensional space (expansion factor of 6 is typical); (2) a 3?-3 depthwise convolution processes the expanded features; (3) a 1?-1 convolution projects the features back to a lower-dimensional bottleneck; and (4) a skip connection adds the input to the output (if the input and output dimensions match). The "linear" aspect of the linear bottleneck refers to the absence of a non-linear activation function after the final projection layer. Sandler et al. (2018) argue that applying a non-linear activation (e.g., ReLU) to low-dimensional features can destroy information, and that a linear projection preserves more of the learned representation.

### 8.6 Data Augmentation Techniques

Data augmentation is a regularisation technique that involves applying label-preserving transformations to the training data to artificially increase the effective size and diversity of the dataset (Shorten and Khoshgoftaar, 2019). For facial expression recognition, the following augmentation techniques are employed:

[Table 8: Data Augmentation Techniques and Parameters]

| Technique | Parameter Range | Rationale |
|---|---|---|
| Random horizontal flip | 50% probability | Faces are approximately symmetrical; flipping preserves emotion labels |
| Random rotation | ?+/-15 degrees | Simulates head tilt; within range that preserves face visibility |
| Random zoom | ?+/-10% | Simulates varying camera distances |
| Random brightness adjustment | ?+/-20% | Simulates varying lighting conditions |
| Random contrast adjustment | ?+/-20% | Simulates varying image quality and exposure |
| Random translation (shift) | ?+/-10% horizontal and vertical | Simulates imperfect face centering |
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

Jacob et al. (2018) demonstrated that post-training quantization can reduce model size by 4?- and improve inference speed by 2??"3?- with minimal accuracy loss (typically less than 1??"2 percentage points) for many architectures, including MobileNet. In this project, dynamic range quantization is applied as the default, with full integer quantization explored if further size or speed reduction is needed.

### 8.8 Evaluation Metrics

#### 8.8.1 Confusion Matrix

A confusion matrix is a table that summarises the performance of a classification model by comparing predicted labels to true labels for each class. For a six-class problem, the confusion matrix is a 6?-6 table, where the element at row $i$ and column $j$ represents the number of samples whose true class is $i$ and whose predicted class is $j$. The diagonal elements represent correct classifications (true positives for each class), and off-diagonal elements represent misclassifications.

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

Data collection aims to assemble 2,000??"5,000 labelled facial images across the six emotion classes (happy, sad, angry, fear, neutral, tired). The target distribution is approximately balanced across classes, with some allowance for natural class imbalance (e.g., "neutral" may be more common than "fear" in a typical data collection setting). The planned distribution is:

[Table 3: Dataset Distribution by Emotion]

| Emotion Class | Target Count (approx.) | Percentage |
|---|---|---|
| Happy | 350??"850 | ~17% |
| Sad | 350??"850 | ~17% |
| Angry | 300??"750 | ~15% |
| Fear | 250??"650 | ~13% |
| Neutral | 400??"1000 | ~20% |
| Tired | 350??"900 | ~18% |
| **Total** | **2,000??"5,000** | **100%** |

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

- **Dropout:** Randomly deactivating a proportion of neurons during training (typically 20??"50% of units in dense layers) forces the network to learn more robust features that do not depend on any single neuron (Srivastava et al., 2014). Dropout is applied to the dense layers of the classification head.
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

### 2.6 Extended Critical Analysis of AAC Literature

#### 2.6.1 Evolution of AAC Technology

The evolution of AAC technology over the past four decades has been characterised by a gradual shift from low-tech, non-electronic solutions (e.g., communication boards, picture exchange systems, and simple voice-output devices) to increasingly sophisticated high-tech solutions leveraging mobile computing, artificial intelligence, and cloud connectivity (Light and McNaughton, 2012; Beukelman and Light, 2020). This evolution has not been uniform across all settings and populations, and there remain significant global inequities in access to modern AAC technology. Understanding this evolution provides essential context for positioning the present project within the broader trajectory of AAC research and development.

In the earliest phase of AAC development (1970s??"1990s), AAC solutions were predominantly clinician-driven and involved physical boards, symbol books, and simple electronic devices with pre-recorded messages. These solutions were effective for many individuals but were limited in vocabulary size, portability, and flexibility. The Picture Exchange Communication System (PECS), introduced by Bondy and Frost in 1994, represented a significant advance in structured AAC intervention for individuals with autism, providing a systematic protocol for teaching communication using picture symbols (Bondy and Frost, 1994). PECS remains widely used today and has been the subject of extensive research, including several meta-analyses demonstrating its effectiveness for increasing functional communication in children with ASD (Ganz et al., 2012; Flippin et al., 2010).

The advent of tablet computers and smartphones in the late 2000s transformed the AAC landscape. The introduction of the Apple iPad in 2010 was particularly significant, as it provided a portable, affordable (relative to dedicated devices), and socially acceptable platform for AAC applications (McNaughton and Light, 2013). Applications such as Proloquo2Go, TouchChat, and LAMP Words for Life rapidly gained popularity, offering large vocabularies, customisable layouts, and high-quality text-to-speech output on commercially available devices. The shift to tablet-based AAC also reduced the stigma associated with carrying a dedicated communication device, as tablets were commonly used by typically developing peers for entertainment and education (McNaughton and Light, 2013; Lorah et al., 2015).

However, this technology-driven revolution has not reached all populations equally. The vast majority of commercially available AAC applications are designed for English-speaking users in high-income countries, and the cost of both the devices (e.g., iPads) and the applications (e.g., Proloquo2Go at approximately USD 250) places them beyond the reach of many families in low- and middle-income countries (Alant and Bornman, 2021). Moreover, the vocabulary, symbols, and interaction paradigms embedded in these applications reflect the cultural norms, educational practices, and daily life activities of Western societies, which may not translate directly to other cultural contexts. This inequity in access and relevance is a central motivator for the present project.

#### 2.6.2 Evidence for AAC in Autism: A Deeper Examination

The evidence base for AAC in autism is substantial and growing, but it is important to examine it critically. The meta-analysis by Ganz et al. (2012) found that aided AAC interventions (including both low-tech and high-tech approaches) had moderate to large positive effects on communication outcomes for individuals with ASD. However, several caveats apply: (1) the quality of individual studies varied, with many relying on single-case experimental designs with small sample sizes; (2) there was significant heterogeneity in the types of AAC interventions studied, the outcome measures used, and the participant characteristics; and (3) few studies included long-term follow-up, making it difficult to assess the durability of intervention effects (Ganz et al., 2012).

A persistent concern voiced by some parents and professionals is the fear that AAC may hinder or replace the development of natural speech. This concern has been extensively addressed in the literature, with multiple reviews finding no evidence that AAC use reduces speech production; on the contrary, AAC has been associated with modest increases in speech output for many individuals (Millar et al., 2006; Romski and Sevcik, 2005). This finding is often attributed to the communicative success and reduced frustration that AAC provides, which may increase the child's motivation and opportunities for verbal communication. The present project communicates this research clearly to stakeholders through information sheets and in-app guidance, to alleviate potential concerns about the impact of AAC on speech development.

The role of the communication partner (parent, caregiver, therapist, teacher) is increasingly recognised as a critical factor in the success of AAC interventions (Light and McNaughton, 2015). Partner instruction??"teaching the communication partner to model AAC use, respond to the child's communicative attempts, and create opportunities for communication??"has been shown to significantly enhance AAC outcomes (Kent-Walsh et al., 2015). The present project supports partner engagement through the therapist??"parent dashboard, which provides tools for progress monitoring, vocabulary management, and remote collaboration, enabling therapists to guide parents in supporting their child's AAC use even when face-to-face sessions are not possible.

#### 2.6.3 Symbol Systems and Cultural Adaptation

The choice and design of symbol systems in AAC is a non-trivial design decision with significant implications for usability and communicative effectiveness. Common symbol systems include Picture Communication Symbols (PCS), Widgit Symbols, SymbolStix, ARASAAC (Aragonese Centre of Augmentative and Alternative Communication), and Blissymbolics, each with different levels of iconicity (the degree to which the symbol visually resembles its referent), vocabulary coverage, and licensing terms (Beukelman and Light, 2020).

For deployment in Sri Lanka, several considerations arise. First, the licensing costs of proprietary symbol sets (e.g., PCS, which requires a per-user or per-application licence) may be prohibitive. ARASAAC, which is freely available under a Creative Commons licence, offers an extensive set of culturally neutral symbols and has been adapted for use in multiple languages and cultural contexts, making it a strong candidate for the base symbol set in this project. Second, regardless of the base symbol set chosen, cultural adaptation is essential. This involves: (a) adding symbols for locally relevant items (e.g., Sri Lankan foods such as rice, pol sambol, hoppers, and dhal curry; local activities such as cricket, temple visits, and Vesak celebrations; and familiar people such as amm??, app??, and ??chi); (b) modifying or replacing symbols that depict culturally unfamiliar items; and (c) ensuring that the visual style of symbols is appropriate for the target age group and cultural context.

The project supports a hybrid approach: a default symbol set (based on ARASAAC or a similar freely available set, with culturally adapted additions) is provided out of the box, and parents and therapists can add custom symbols (including photographs) and create personalised categories. This approach balances the need for a comprehensive, ready-to-use symbol vocabulary with the need for individualisation, which is a well-established principle in AAC practice (Beukelman and Light, 2020).

#### 2.6.4 AAC and Language Development in Multilingual Contexts

Multilingualism is the norm rather than the exception in many parts of the world, and Sri Lanka is no exception. The country's trilingual landscape (Sinhala, Tamil, and English) means that many families use more than one language at home, and children may be exposed to different languages in different settings (home, school, clinic, community). AAC for multilingual individuals presents unique challenges, including the need for vocabulary in multiple languages, the potential for code-switching (alternating between languages within a conversation), and the need for symbol systems and speech output that are appropriate in each language (Soto and Yu, 2014; Kulkarni and Parmar, 2017).

Research on multilingual AAC is limited but growing. Soto and Yu (2014) found that bilingual children using AAC could successfully learn and use vocabulary in both languages when provided with bilingual AAC support. Kulkarni and Parmar (2017) reviewed the challenges of adapting AAC for Indian languages and cultural contexts, noting the need for expanded vocabulary sets, appropriate symbols, and high-quality text-to-speech in each language. These findings are directly relevant to the present project, which aims to provide full trilingual support (Sinhala, Tamil, English) in both the AAC interface and the text-to-speech output.

The implementation of trilingual support in the current system involves: (a) storing vocabulary items with labels in all three languages; (b) allowing the user (via caregiver configuration) to select the active language(s); (c) supporting mixed-language displays (e.g., Sinhala labels with English fallback for items without a Sinhala translation); and (d) providing text-to-speech output in the selected language. The quality and naturalness of text-to-speech for Sinhala and Tamil are known challenges, as the availability and quality of TTS engines for these languages are inferior to those for English (Google Cloud Text-to-Speech, 2023). The project documents the TTS options evaluated and their suitability, and includes fallback mechanisms (e.g., recorded audio for critical vocabulary items) where TTS quality is insufficient.

#### 2.6.5 Affective Computing and Emotion Recognition: Extended Discussion

Affective computing??"the study and development of systems that recognise, interpret, and respond to human emotions??"was first formalised as a research field by Rosalind Picard in her seminal book, *Affective Computing* (Picard, 2000). Since then, the field has grown rapidly, driven by advances in machine learning, computer vision, and sensor technology. Affective computing encompasses a range of modalities for emotion recognition, including facial expression analysis, speech prosody analysis, physiological signal analysis (e.g., heart rate, electrodermal activity), body gesture and posture analysis, and text sentiment analysis (Calvo and D'Mello, 2010).

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

2. **Widget-based architecture:** Flutter's declarative, widget-based UI framework makes it straightforward to build custom, adaptive interfaces??"a key requirement for an AAC application where grid sizes, colour themes, font sizes, and interaction paradigms must be configurable by the caregiver.

3. **Platform channels:** Flutter supports platform channels, which allow Dart code to communicate with platform-specific code (Java/Kotlin on Android, Swift/Objective-C on iOS). This is used in the project to invoke the TensorFlow Lite interpreter, access the device camera, and integrate with platform-specific TTS and accessibility services.

4. **Ecosystem and community:** Flutter has a large and active developer community, a rich package ecosystem (including packages for camera, TTS, SQLite, Firebase, and charts/visualisation), and extensive documentation, which facilitate development and troubleshooting.

5. **Hot reload:** Flutter's stateful hot reload feature enables rapid iteration during development, allowing UI and logic changes to be previewed instantly without restarting the application. This accelerates the design??"test??"refine cycle, which is particularly valuable in a project with intensive UI customisation requirements.

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

- **Flutter App ??" Local Database (SQLite):** CRUD operations for user profiles, vocabulary, settings, usage logs, and emotion history. The app's data layer is implemented using a repository pattern, abstracting the database implementation from the business logic.
- **Flutter App ??" TFLite Interpreter (Platform Channel):** The app sends a byte array (preprocessed image) to the platform-specific TFLite wrapper, which returns an array of class probabilities. Error handling covers cases such as model loading failure, invalid input dimensions, and interpreter runtime errors.
- **Flutter App ??" Firebase (Firestore, Auth, Storage):** The app uses the FlutterFire packages (cloud_firestore, firebase_auth, firebase_storage) for authentication, real-time data synchronisation, and file upload/download. Offline persistence is enabled on the Firestore instance, ensuring that read and write operations are served from the local cache when the device is offline.
- **Dashboard ??" Firebase:** The web dashboard uses the Firebase JavaScript SDK to authenticate, read, and write data in Firestore and Storage. Security rules ensure that the dashboard can only access data for children linked to the authenticated therapist or parent.

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
9. Results are compared against pre-defined targets (???80% accuracy, <500 ms inference) and against reported benchmarks for similar architectures and datasets in the literature.

#### 7.5.3 Usability Evaluation Approach

Usability evaluation is planned in two phases:

**Phase 1 (Internal):** During development, the developer (and, where available, supervisor or peer reviewers) evaluates the app against a heuristic checklist adapted from Nielsen's 10 Usability Heuristics (Nielsen, 1994). Specific attention is given to: visibility of system status (e.g., is the active language clear? is the sync status visible?), match between the system and the real world (e.g., are symbols recognisable and culturally appropriate?), user control and freedom (e.g., can the caregiver easily undo a selection or exit a mode?), consistency and standards (e.g., are navigation patterns consistent across screens?), and error prevention (e.g., are destructive actions??"such as deleting a vocabulary item??"confirmed?).

**Phase 2 (External):** Following Platform A completion and (if applicable) ethics approval, informal usability feedback is sought from at least one therapist and one parent/caregiver. Feedback methods include: structured observation of an interaction session, a brief post-session interview or questionnaire (e.g., System Usability Scale), and open-ended feedback. Findings are used to inform design revisions before the pilot.

### 9.8 Extended Ethical Analysis: AI Ethics and Vulnerable Populations

#### 9.8.1 AI Ethics Frameworks

The development and deployment of AI systems in sensitive domains??"particularly those involving children, individuals with disabilities, and healthcare contexts??"has attracted increasing attention from ethicists, policymakers, and technologists (Floridi et al., 2018; Jobin et al., 2019). Several AI ethics frameworks have been proposed, each emphasising a set of core principles:

- **Beneficence and non-maleficence:** The system should do good and avoid harm. In the context of this project, beneficence means providing meaningful communication support to children with ASD; non-maleficence means avoiding harm through misclassification, loss of privacy, or inappropriate reliance on automated systems.
- **Autonomy and human oversight:** The user (or, in the case of children, the caregiver) should retain agency and control over the system's behaviour. The caregiver override mechanism in Platform B operationalises this principle.
- **Justice and fairness:** The system should not discriminate against any group. In the context of FER, this means actively monitoring and mitigating bias in the training data and model performance across demographic groups.
- **Transparency and explainability:** Users should understand what the system is doing and how it reaches its conclusions. While full explainability of CNN predictions remains an open research problem, the project provides transparency through clear communication of the system's purpose, limitations, and confidence levels.
- **Privacy and data protection:** Users' personal data??"especially facial images and communication patterns??"must be protected. The on-device processing and data minimisation strategies described in Sections 6 and 9 operationalise this principle.
- **Accountability:** The developer and deploying institution are accountable for the system's performance and impact. This accountability is exercised through rigorous testing, documentation, ethical review, and ongoing monitoring.

#### 9.8.2 Specific Ethical Challenges in AI for Autism

The application of AI to support individuals with autism raises specific ethical challenges that go beyond general AI ethics:

1. **Capacity and consent:** Children with ASD may have limited ability to understand or consent to the use of AI-based features. The project addresses this through parental consent, child assent (where feasible), and ongoing monitoring for signs of distress or avoidance.

2. **Risk of pathologising:** There is a risk that an AI system focused on emotion detection could contribute to a narrative of "fixing" or "correcting" autistic behaviour, rather than supporting communication on the individual's own terms. The project positions FER as an assistive cue to support caregivers, not as a tool to normalise or correct the child's behaviour or expressions.

3. **Atypical expression:** As discussed in Section 2.6.6, children with ASD may express emotions differently from neurotypical individuals. A model trained on neurotypical data may misclassify atypical expressions, potentially leading to inappropriate system responses. The project mitigates this through confidence thresholding, caregiver override, and transparent communication of the system's limitations.

4. **Power dynamics:** The system introduces a technological intermediary into the caregiver??"child relationship. There is a risk that the caregiver may defer to the system's emotion classification over their own observation, especially if the system is perceived as authoritative. The project's design explicitly counteracts this by presenting the FER output as a suggestion with a visible confidence indicator, and by providing prominent override controls.

5. **Surveillance concerns:** Continuous or frequent facial image capture for FER could be perceived as surveillance, which is particularly sensitive for a vulnerable population. The project addresses this by: (a) making FER opt-in; (b) providing clear information about what data is captured and how it is used; (c) not storing raw facial images by default; and (d) allowing the caregiver to disable FER at any time.

### 10.9 Detailed Technical Implementation Progress

#### 10.9.1 Flutter Application Structure

The Flutter application is organised according to the following directory structure, following clean architecture principles and Flutter community best practices:

```
lib/
?"??"??"? main.dart                  # App entry point
?"??"??"? config/                    # App configuration, themes, constants
?"??"??"? models/                    # Data models (User, Symbol, Category, EmotionRecord)
?"??"??"? services/                  # Service layer (Firebase, TTS, TFLite, Local DB)
?"??"??"? repositories/              # Repository pattern: abstracts data sources
?"??"??"? screens/                   # UI screens (Home, AAC Grid, Settings, Dashboard)
?"??"??"? widgets/                   # Reusable UI components (SymbolCard, EmotionIndicator)
?"??"??"? utils/                     # Utility functions (image preprocessing, date formatting)
?""?"??"? l10n/                      # Localisation files (Sinhala, Tamil, English)
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

Participants will be recruited from the outpatient paediatric and developmental services at Karapitiya Teaching Hospital. Inclusion criteria: children aged 3??"12 years with a clinical diagnosis of ASD (any severity level); at least one parent/caregiver willing to participate; and availability for the duration of the pilot. Exclusion criteria: severe uncorrected visual or auditory impairment that would prevent use of the app; absence of a suitable device (Android or iOS smartphone/tablet); and withdrawal of consent at any point.

The target sample size is 5??"15 child??"caregiver dyads, consistent with the formative, feasibility-focused design of the pilot and the constraints of a final year project (Hertzog, 2008). Recruitment materials (information sheets, posters, and verbal briefings) will be provided in Sinhala, Tamil, and English.

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

### 2.8 Comparative Analysis of Deep Learning Architectures for Mobile FER

#### 2.8.1 Architecture Selection Rationale

The selection of MobileNetV2 as the base architecture for facial expression recognition in this project was informed by a systematic comparative analysis of several candidate architectures. Each architecture was evaluated against criteria specific to the project's deployment constraints: model size (suitability for mobile bundling), inference latency on mid-range devices, accuracy on standard FER benchmarks, and availability of pre-trained weights for transfer learning. This section presents the analysis in detail.

#### 2.8.2 VGGNet

VGGNet (Simonyan and Zisserman, 2015) is a deep convolutional neural network characterised by its use of small (3?-3) convolutional filters stacked in very deep architectures (16 or 19 layers). VGGNet achieved strong results on the ImageNet Large Scale Visual Recognition Challenge (ILSVRC) in 2014 and has been widely used as a feature extractor in transfer learning. However, VGGNet has a very large number of parameters (approximately 138 million for VGG-16), resulting in a model size of over 500 MB. This makes VGGNet impractical for mobile deployment, where model size and inference speed are critical constraints. The inference latency of VGGNet on a mid-range smartphone would exceed the 500 ms target by a significant margin, rendering it unsuitable for real-time or near-real-time FER in this project.

#### 2.8.3 ResNet

ResNet (He et al., 2016) introduced the concept of residual connections (skip connections), which allow gradients to flow more easily through very deep networks, enabling the training of architectures with 50, 101, or even 152 layers. ResNet-50, with approximately 25 million parameters and a model size of approximately 100 MB, achieves strong accuracy on ImageNet and has been widely used for FER (Li and Deng, 2020). While ResNet-50 is more efficient than VGGNet, its model size and computational requirements remain substantial for mobile deployment. Inference latency on a mid-range smartphone is typically in the range of 500??"1000 ms (without quantization), which is at or above the project's target threshold. ResNet-50 was considered as an alternative but was ultimately not selected due to its larger size and slower inference compared to MobileNetV2.

#### 2.8.4 InceptionV3

InceptionV3 (Szegedy et al., 2016) uses a modular architecture with "inception" blocks that apply multiple convolutional operations (1?-1, 3?-3, 5?-5, and pooling) in parallel and concatenate the results. This design captures features at multiple scales within each layer, improving representational efficiency. InceptionV3 has approximately 23 million parameters and a model size of approximately 92 MB. While more efficient than VGGNet and comparable to ResNet-50, InceptionV3's multi-branch architecture introduces additional computational overhead that makes it less suitable for low-latency mobile inference compared to MobileNetV2.

#### 2.8.5 MobileNetV1

MobileNetV1 (Howard et al., 2017) was the first architecture in the MobileNet family, introducing depthwise separable convolutions to dramatically reduce computational cost and model size. MobileNetV1 has approximately 3.4 million parameters and a model size of approximately 16 MB (float32), making it highly suitable for mobile deployment. However, MobileNetV1 lacks the inverted residual blocks and linear bottlenecks introduced in MobileNetV2, which improve representational power and accuracy for a given computational budget.

#### 2.8.6 MobileNetV2

MobileNetV2 (Sandler et al., 2018) builds on MobileNetV1 by introducing inverted residual blocks with linear bottlenecks, which improve accuracy while maintaining computational efficiency. MobileNetV2 has approximately 3.4 million parameters and a model size of approximately 14 MB (float32) or approximately 3.5 MB after quantization. On ImageNet, MobileNetV2 achieves a top-1 accuracy of approximately 72%, which is competitive with much larger architectures (e.g., ResNet-50 achieves approximately 76%) at a fraction of the computational cost.

For FER tasks, MobileNetV2 has been shown to achieve accuracy comparable to larger models when fine-tuned with appropriate data augmentation and regularisation (Li and Deng, 2020). Its small size and fast inference make it ideal for on-device deployment in resource-constrained settings, which is the primary use case for this project.

#### 2.8.7 MobileNetV3

MobileNetV3 (Howard et al., 2019) further improves upon MobileNetV2 by incorporating neural architecture search (NAS) and the squeeze-and-excitation (SE) module, achieving higher accuracy at a similar or lower computational cost. MobileNetV3 was considered for this project but was not selected for the following reasons: (a) at the time of project initiation, pre-trained MobileNetV3 weights for TensorFlow/Keras were less widely available and less extensively validated for transfer learning in academic settings; (b) the accuracy improvement over MobileNetV2, while measurable, is modest (approximately 1??"2 percentage points on ImageNet) and may not translate to a meaningful improvement on the smaller, domain-specific FER dataset used in this project; and (c) MobileNetV2 is better documented and more widely used in the FER literature, facilitating comparison with published results.

#### 2.8.8 EfficientNet

EfficientNet (Tan and Le, 2019) is a family of models that use compound scaling (uniformly scaling network width, depth, and resolution) to achieve state-of-the-art accuracy at various computational budgets. EfficientNet-B0, the smallest variant, has approximately 5.3 million parameters and achieves higher accuracy than MobileNetV2 on ImageNet, but at a somewhat higher computational cost. While EfficientNet is a strong candidate for future iterations of the project, MobileNetV2 was preferred for the initial version due to its well-established track record in mobile FER, extensive documentation, and slightly lower inference latency on the target devices.

[Table 12: Comparison of Candidate Architectures for Mobile FER]

| Architecture | Parameters (M) | Model Size (MB, float32) | ImageNet Top-1 (%) | Inference (ms, mid-range) | Selected? |
|---|---|---|---|---|---|
| VGG-16 | 138 | 528 | 71.5 | >2000 | No |
| ResNet-50 | 25.6 | 98 | 76.1 | 500??"1000 | No |
| InceptionV3 | 23.8 | 92 | 77.9 | 400??"800 | No |
| MobileNetV1 | 3.4 | 16 | 70.9 | 80??"200 | No |
| **MobileNetV2** | **3.4** | **14** | **72.0** | **80??"250** | **Yes** |
| MobileNetV3 | 5.4 | 22 | 75.2 | 80??"200 | Considered |
| EfficientNet-B0 | 5.3 | 20 | 77.3 | 100??"300 | Considered |

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

The number of training epochs is controlled by early stopping: training continues until the validation loss has not improved for a specified number of consecutive epochs (patience). A patience of 5??"10 epochs is used, depending on the training phase (higher patience during fine-tuning). The model checkpoint with the best validation loss is restored after training completes, ensuring that the final model corresponds to the best observed validation performance.

#### 8.12.4 Dropout Rate

Dropout rates of 0.2 to 0.5 are explored for the dense layers of the classification head. Higher dropout rates provide stronger regularisation but may reduce the model's capacity to learn complex relationships. The optimal dropout rate is determined through validation set performance.

### 13.4 Extended Risk Analysis: Technical Risks

#### 13.4.1 TTS Quality in Sinhala and Tamil

Text-to-speech quality for Sinhala and Tamil is a known challenge. While Google's TTS engine supports Sinhala and Tamil, the quality and naturalness of the synthesised speech may be inferior to English TTS, particularly for less common vocabulary, numerals, and proper nouns. The risk is that low-quality TTS output may confuse the child or caregiver, reduce engagement, or even introduce communication errors (e.g., mispronounced words).

Mitigation strategies include: (a) testing all critical vocabulary items with the target TTS engines and documenting quality issues; (b) providing an option for caregivers or therapists to record custom audio for critical vocabulary items, which the app plays instead of synthesised speech; (c) using alternative TTS engines or APIs if the default engine produces unacceptable results; and (d) documenting TTS limitations in the user guide and training materials.

#### 13.4.2 Device Fragmentation

Android device fragmentation??"the diversity of hardware specifications, screen sizes, camera qualities, and OS versions across the Android ecosystem??"presents a testing and compatibility challenge. While Flutter mitigates many UI-related fragmentation issues through its widget-based rendering pipeline, the TFLite inference performance, camera API behaviour, and TTS quality may vary across devices.

Mitigation strategies include: (a) defining minimum device specifications (Android 8.0+, at least 2 GB RAM, rear and front camera); (b) testing on at least three representative devices (low-end, mid-range, and high-end); (c) implementing graceful degradation for devices that do not meet the recommended specifications (e.g., lower camera resolution, reduced capture frequency); and (d) documenting known device-specific issues.

#### 13.4.3 Battery Consumption

Continuous or frequent camera capture and on-device inference can significantly increase battery consumption, which is a concern for a mobile application intended for extended use. Mitigation strategies include: (a) implementing configurable capture frequency (e.g., one frame per second, or on-demand only); (b) stopping camera capture and inference when the app is in the background; (c) providing a battery-saving mode that reduces or disables emotion detection; and (d) benchmarking battery consumption during testing and documenting the results.

### 14.4 Extended Discussion of Scope Limitations

#### 14.4.1 No RCT or Large-Scale Clinical Trial

The project does not include a randomised controlled trial or a large-scale clinical trial. Such a study would require: (a) a substantially larger sample size (typically 30+ participants per group); (b) a control group (e.g., children using AAC without emotion recognition); (c) randomised allocation; (d) standardised outcome measures; (e) blinding (where feasible); and (f) a longer study duration. These requirements are beyond the scope and resources of a final year project but are recommended for future research.

#### 14.4.2 No Longitudinal Analysis

The pilot study is designed as a short-term (4??"8 week) feasibility and usability study, not a longitudinal analysis of communication outcomes. Longitudinal analysis would require tracking each child's communication development over several months or years, comparing outcomes with and without AAC use, and controlling for maturation and other confounding factors. This is a direction for future research.

#### 14.4.3 No Support for Other Languages or Modalities

The project focuses on Sinhala, Tamil, and English, reflecting the languages of the target deployment context. Support for other languages (e.g., Malay, Hindi, Arabic) or other communication modalities (e.g., sign language recognition, physiological sensors) is outside the current scope but could be added in future versions.

### 15.4 Extended Gantt Chart Analysis

The Gantt chart (Figure 8) reveals several important features of the project schedule:

1. **Parallel tracks:** The project operates on two main parallel tracks??"software development (Platform A, Platform B, backend, dashboard) and ethical/clinical preparation (ethics application, consent forms, hospital partnership, pilot design). This parallelism allows productive work to continue during the ethics approval process, which is the most significant external dependency.

2. **Float and slack:** Tasks on the non-critical path (e.g., documentation refinement, optional dashboard features, dissemination planning) have positive float, meaning they can be delayed without affecting the overall project deadline. Tasks on the critical path (ethics approval ??' dataset collection ??' model training ??' pilot execution ??' final report) have zero or minimal float, meaning any delay directly affects the project completion date.

3. **Milestone reviews:** The Gantt chart includes milestone reviews at the end of each increment, aligned with project supervisor meetings and academic milestones (interim report submission, final report submission). These reviews provide opportunities to assess progress, reprioritise tasks, and adjust the plan in response to new information or delays.

4. **Contingency buffer:** A two-week contingency buffer is included before the final report submission deadline, to absorb unexpected delays. If this buffer is not consumed by delays, it can be used for additional testing, documentation polish, or preparation of supplementary materials.

### 16.3 Extended WBS Dictionary

The WBS dictionary provides a brief description of each work package, its estimated effort (in person-hours), its owner (the project developer, with supervisor oversight), and its deliverables:

| WBS Code | Work Package | Estimated Effort (hrs) | Deliverables |
|---|---|---|---|
| 1.1 | Literature review and synthesis | 60 | Literature review section (Sections 1??"2) |
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
| 4.2 | TFLite integration | 15 | Dart ??" TFLite platform channel; functional inference |
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

The ethical dimensions of the project have been a constant thread throughout the design and documentation process. The recognition that facial expression recognition for children with autism is not merely a technical challenge but a deeply ethical one??"touching on consent, privacy, autonomy, power, and the risk of harm??"has shaped the system's design at every level, from the choice to process images on-device to the prominence of caregiver override controls in the user interface. The project aspires to model a responsible approach to AI development in sensitive domains, contributing not only a functional system but also a documented ethical framework that other developers and researchers can draw upon.

Looking ahead, the project is well-positioned to complete its remaining deliverables within the academic timeline. The most significant risk remains the timing of ethics approval, which is the gating factor for purpose-built data collection, model retraining, and pilot execution. Regardless of the pilot's outcome, the system, model, and documentation produced by this project will constitute a substantial and meaningful contribution to the field of assistive technology for children with autism in Sri Lanka and beyond.

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

2. **Persona development:** Two primary user personas were developed: (a) "Amaya" (the child user) ??" a 6-year-old non-speaking child with ASD Level 2, living in a semi-urban area with Sinhala-speaking parents; and (b) "Rathnayake" (the parent/caregiver) ??" Amaya's father, a factory worker with basic smartphone skills, motivated to support his daughter's communication but with no prior AAC experience.

3. **User journey mapping:** Key user journeys were mapped out for both personas: (a) first-time setup (selecting language, choosing grid size, previewing symbols); (b) daily communication session (navigating categories, selecting symbols, hearing TTS output); (c) vocabulary customisation (adding a new symbol with a photograph); and (d) reviewing progress (viewing usage history, emotion charts).

4. **Low-fidelity wireframes:** Initial wireframes were sketched on paper, focusing on layout, information hierarchy, and navigation flow. These were reviewed with the project supervisor and informally with a therapist.

5. **High-fidelity mockups:** Based on feedback from the low-fidelity stage, high-fidelity mockups were created in Figma, including detailed colour palettes, typography, iconography, and interaction states (normal, pressed, disabled). Mockups were created for both Platform A and Platform B, and for both light and dark themes.

6. **Interactive prototype:** A clickable prototype was created in Figma, linking the key screens and demonstrating the navigational flow. This prototype was used for informal usability walkthroughs with the supervisor and one therapist.

#### 10.12.2 Symbol Set Design

The symbol set for the initial version includes approximately 200 core vocabulary items distributed across the following categories:

| Category | Example Items | Count |
|---|---|---|
| Feelings | Happy, Sad, Angry, Tired, Scared, Excited | 15 |
| People | Mother (Amm??), Father (App??), Teacher, Friend, Doctor | 12 |
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
| M1: Project proposal approved | September 2025 | ??... Complete | Approved by supervisor |
| M2: Literature review draft | October 2025 | ??... Complete | Comprehensive review of AAC, ASD, FER, mobile tech |
| M3: Architecture design finalised | November 2025 | ??... Complete | Dual-platform design documented |
| M4: Platform A core (symbol grid, TTS) | December 2025 | ??... Complete | Functional AAC grid in three languages |
| M5: Initial CNN model trained | January 2026 | ??... Complete | Preliminary accuracy: 69.3% |
| M6: Interim report submitted | February 2026 | ??"" In progress | This document |
| M7: Ethics application submitted | March 2026 | ??^3 Planned | Consent forms and info sheets drafted |
| M8: Platform B integration | March 2026 | ??^3 Planned | TFLite + face detection in Flutter |
| M9: Dashboard development | April 2026 | ??^3 Planned | Web-based therapist/parent portal |
| M10: Purpose-built data collection | April??"May 2026 | ??^3 Planned | Dependent on ethics approval |
| M11: Model retraining and optimisation | May 2026 | ??^3 Planned | With project-specific data |
| M12: Pilot study execution | June??"July 2026 | ??^3 Planned | 5??"15 child??"caregiver dyads |
| M13: Final report submitted | August 2026 | ??^3 Planned | Comprehensive dissertation |
| M14: Viva/presentation | September 2026 | ??^3 Planned | Demo and oral defence |

### 2.11 Extended Review: Autism Interventions and Evidence-Based Practice

#### 2.11.1 Overview of Evidence-Based Interventions for ASD

The landscape of interventions for autism spectrum disorder is broad and diverse, encompassing behavioural, developmental, educational, pharmacological, and technology-assisted approaches. Evidence-based practice (EBP) in autism requires the integration of the best available research evidence with clinical expertise and the values and preferences of the individual and their family (Sackett et al., 1996). Several comprehensive reviews and practice guidelines have been published to help practitioners and families navigate the evidence base:

The National Autism Center's National Standards Project, Phase 2 (National Autism Center, 2015) reviewed the evidence for a wide range of interventions and classified them as "established" (sufficient evidence of effectiveness), "emerging" (some evidence but insufficient for definitive conclusions), or "unestablished" (no evidence or insufficient evidence). Among the interventions classified as "established" are Applied Behaviour Analysis (ABA), pivotal response training, social stories, and cognitive behavioural intervention. AAC interventions were classified as "emerging" at that time, reflecting the relative newness of the high-tech AAC evidence base for autism specifically, though the evidence has continued to grow since the review was published.

The National Professional Development Center on Autism Spectrum Disorder (NPDC on ASD; Wong et al., 2015) identified 27 focused intervention practices that met criteria for being evidence-based, including visual supports, prompting, reinforcement, social skills training, and technology-aided instruction and intervention (TAII). TAII includes the use of technology (computers, tablets, apps) to support learning and communication, and is directly relevant to the present project's use of a mobile AAC application with AI-enhanced features.

#### 2.11.2 The Role of Visual Supports

Visual supports??"the use of visual cues (pictures, symbols, written words, schedules, timers, maps) to support communication, understanding, and independence??"are among the most widely used and well-supported interventions for individuals with ASD (Hume et al., 2014). Visual supports leverage the relative visual processing strength observed in many individuals with ASD and compensate for difficulties with auditory processing, verbal comprehension, and executive function.

Common forms of visual support include:

1. **Visual schedules:** Sequences of pictures or symbols representing activities or tasks in order, helping the individual understand and predict the structure of their day.
2. **Choice boards:** Displays of available options, allowing the individual to make choices by pointing to or selecting a symbol.
3. **First-then boards:** Simple two-step displays showing the current and next activity, used to support transitions.
4. **Social stories and visual scripts:** Visually supported narratives describing social situations and expected behaviours, developed by Carol Gray (Gray and Garand, 1993).

The present project incorporates visual supports at multiple levels: the AAC symbol grid is itself a form of visual communication support; the visual schedule feature provides structured daily routines; and the emotion indicator (Platform B) provides a visual cue about the child's emotional state. This integrated approach to visual support is consistent with the research evidence and with clinical best practices for supporting children with ASD.

#### 2.11.3 Parent-Mediated Interventions

Parent-mediated (or parent-implemented) interventions??"programmes in which parents are trained to deliver therapeutic strategies during everyday activities and routines??"have a growing evidence base for children with ASD (Oono et al., 2013; Nevill et al., 2018). These interventions address several limitations of clinic-based therapy: they increase the intensity and frequency of intervention (since parents can implement strategies throughout the day), they promote generalisation of skills to natural settings, and they empower parents as active agents in their child's development.

The present project supports parent-mediated intervention through several mechanisms: (a) the AAC app is designed for use by parents in the home, not only by therapists in the clinic; (b) the therapist??"parent dashboard enables therapists to guide and support parents remotely; (c) usage logs provide objective data on the child's AAC use, which can inform therapist guidance; and (d) the visual schedule feature supports parents in implementing structured routines, which is a key component of many parent-mediated programmes.

### 6.10 Extended Architecture: Accessibility and Universal Design

#### 6.10.1 Universal Design Principles

Universal design??"the design of products and environments to be usable by all people, to the greatest extent possible, without the need for adaptation or specialised design (Mace et al., 1997)??"is a guiding philosophy for the present project. While the primary target population is children with ASD and their caregivers, the system is designed to be usable by a broader range of individuals with communication difficulties, including those with intellectual disability, cerebral palsy, acquired brain injury, or other conditions that impair speech.

The seven principles of universal design (equitable use, flexibility in use, simple and intuitive, perceptible information, tolerance for error, low physical effort, and size and space for approach and use) are applied to the system's design as follows:

1. **Equitable use:** The system is available on widely used devices (Android/iOS smartphones and tablets) and does not require specialised hardware.
2. **Flexibility in use:** The interface is configurable (grid size, symbol size, language, colour theme), accommodating a range of user abilities and preferences.
3. **Simple and intuitive:** The navigation structure is shallow (maximum two levels), icons are clearly labelled, and the interaction paradigm (tap to select, tap to speak) is straightforward.
4. **Perceptible information:** Visual, auditory, and (optionally) haptic feedback are provided for user actions, ensuring that information is available through multiple channels.
5. **Tolerance for error:** Destructive actions (e.g., deleting a symbol) require confirmation; the undo/back function is easily accessible.
6. **Low physical effort:** The interface requires only simple tap gestures and is compatible with single-finger or switch-based input.
7. **Size and space for approach and use:** Touch targets are sized according to platform accessibility guidelines (minimum 48?-48 dp on Android, 44?-44 pt on iOS), with configurable spacing.

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

**Risk:** Difficulty recruiting sufficient participants for the pilot study (target: 5??"15 child??"caregiver dyads).

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

- Anderson, D.K., Lord, C., Risi, S., DiLavore, P.S., Shulman, C., Thurm, A., Welch, K., and Pickles, A. (2007). Patterns of Growth in Verbal Abilities Among Children With Autism Spectrum Disorder. *Journal of Consulting and Clinical Psychology*, 75(4), pp.594??"604.
- Asperger, H. (1944). Die "Autistischen Psychopathen" im Kindesalter. *Archiv f?1/4r Psychiatrie und Nervenkrankheiten*, 117(1), pp.76??"136.
- Baranek, G.T., David, F.J., Poe, M.D., Stone, W.L., and Watson, L.R. (2006). Sensory Experiences Questionnaire: Discriminating Sensory Features in Young Children with Autism, Developmental Delays, and Typical Development. *Journal of Child Psychology and Psychiatry*, 47(6), pp.591??"601.
- Barrett, L.F., Adolphs, R., Marsella, S., Martinez, A.M., and Pollak, S.D. (2019). Emotional Expressions Reconsidered: Challenges to Inferring Emotion From Human Facial Movements. *Psychological Science in the Public Interest*, 20(1), pp.1??"68.
- Ben-Sasson, A., Hen, L., Fluss, R., Cermak, S.A., Engel-Yeger, B., and Gal, E. (2009). A Meta-Analysis of Sensory Modulation Symptoms in Individuals with Autism Spectrum Disorders. *Journal of Autism and Developmental Disorders*, 39(1), pp.1??"11.
- Bettelheim, B. (1967). *The Empty Fortress: Infantile Autism and the Birth of the Self*. New York: Free Press.
- B??lte, S., Girdler, S., and Marschik, P.B. (2019). The Contribution of Environmental Exposure to the Etiology of Autism Spectrum Disorder. *Cellular and Molecular Life Sciences*, 76(7), pp.1275??"1297.
- Braun, V. and Clarke, V. (2006). Using Thematic Analysis in Psychology. *Qualitative Research in Psychology*, 3(2), pp.77??"101.
- Brooke, J. (1996). SUS??"A Quick and Dirty Usability Scale. In: P.W. Jordan, B. Thomas, B.A. Weerdmeester, and I.L. McClelland, eds., *Usability Evaluation in Industry*. London: Taylor & Francis, pp.189??"194.
- Calvo, R.A. and D'Mello, S. (2010). Affect Detection: An Interdisciplinary Review of Models, Methods, and Their Applications. *IEEE Transactions on Affective Computing*, 1(1), pp.18??"37.
- D'Mello, S.K. and Kory, J. (2015). A Review and Meta-Analysis of Multimodal Affect Detection Systems. *ACM Computing Surveys*, 47(3), Article 43.
- Divan, G., Bhavnani, S., Leadbitter, K., Ellis, C., Dasgupta, J., and Patel, V. (2021). Annual Research Review: Achieving Universal Health Coverage for Young Children with Autism Spectrum Disorder in Low- and Middle-Income Countries: A Review of Evidence, Gaps and Needs. *Journal of Child Psychology and Psychiatry*, 62(5), pp.518??"535.
- Fombonne, E. (2018). Editorial: The Rising Prevalence of Autism. *Journal of Child Psychology and Psychiatry*, 59(7), pp.717??"720.
- Gray, C.A. and Garand, J.D. (1993). Social Stories: Improving Responses of Students with Autism with Accurate Social Information. *Focus on Autistic Behavior*, 8(1), pp.1??"10.
- Hertzog, M.A. (2008). Considerations in Determining Sample Size for Pilot Studies. *Research in Nursing & Health*, 31(2), pp.180??"191.
- Hill, E.L. (2004). Executive Dysfunction in Autism. *Trends in Cognitive Sciences*, 8(1), pp.26??"32.
- Hume, K., Loftin, R., and Lantz, J. (2014). Increasing Independence in Autism Spectrum Disorders: A Review of Three Focused Interventions. *Journal of Autism and Developmental Disorders*, 39(9), pp.1329??"1338.
- Kanner, L. (1943). Autistic Disturbances of Affective Contact. *Nervous Child*, 2, pp.217??"250.
- Keehn, B., M?1/4ller, R.A., and Townsend, J. (2013). Atypical Attentional Networks and the Emergence of Autism. *Neuroscience & Biobehavioral Reviews*, 37(2), pp.164??"183.
- Keskar, N.S., Mudigere, D., Nocedal, J., Smelyanskiy, M., and Tang, P.T.P. (2017). On Large-Batch Training for Deep Learning: Generalization Gap and Sharp Minima. *Proceedings of ICLR 2017*.
- Labrique, A.B., Vasudevan, L., Kochi, E., Fabricant, R., and Mehl, G. (2013). mHealth Innovations as Health System Strengthening Tools: 12 Common Applications and a Visual Framework. *Global Health: Science and Practice*, 1(2), pp.160??"171.
- Landis, J.R. and Koch, G.G. (1977). The Measurement of Observer Agreement for Categorical Data. *Biometrics*, 33(1), pp.159??"174.
- Leekam, S.R., Nieto, C., Libby, S.J., Wing, L., and Gould, J. (2007). Describing the Sensory Abnormalities of Children and Adults with Autism. *Journal of Autism and Developmental Disorders*, 37(5), pp.894??"910.
- Mace, R.L., Hardie, G.J., and Place, J.P. (1997). *Accessible Environments: Toward Universal Design*. In: W.F.E. Preiser, J.C. Vischer, and E.T. White, eds., *Design Interventions: Toward a More Humane Architecture*. New York: Van Nostrand Reinhold.
- Maenner, M.J., Warren, Z., Williams, A.R., et al. (2023). Prevalence and Characteristics of Autism Spectrum Disorder Among Children Aged 8 Years??"Autism and Developmental Disabilities Monitoring Network, 11 Sites, United States, 2020. *MMWR Surveillance Summaries*, 72(2), pp.1??"14.
- Mesibov, G.B., Shea, V., and Schopler, E. (2005). *The TEACCH Approach to Autism Spectrum Disorders*. New York: Springer.
- National Autism Center (2015). *Findings and Conclusions: National Standards Project, Phase 2*. Randolph, MA: Author.
- Nevill, R.E., Lecavalier, L., and Stratis, E.A. (2018). Meta-Analysis of Parent-Mediated Interventions for Young Children with Autism Spectrum Disorder. *Autism*, 22(2), pp.84??"98.
- Nielsen, J. (1993). *Usability Engineering*. San Diego: Academic Press.
- Oliver, M. (1990). *The Politics of Disablement*. London: Macmillan.
- Oono, I.P., Honeybourne, S., and McConachie, H. (2013). Parent-Mediated Early Intervention for Young Children with Autism Spectrum Disorders (ASD). *Evidence-Based Child Health*, 8(6), pp.2380??"2479.
- Picard, R.W. (2000). *Affective Computing*. Cambridge, MA: MIT Press.
- Prizant, B.M. and Duchan, J.F. (1981). The Functions of Immediate Echolalia in Autistic Children. *Journal of Speech and Hearing Disorders*, 46(3), pp.241??"249.
- Rutter, M. (1978). Diagnosis and Definition of Childhood Autism. *Journal of Autism and Childhood Schizophrenia*, 8(2), pp.139??"161.
- Sackett, D.L., Rosenberg, W.M., Gray, J.A., Haynes, R.B., and Richardson, W.S. (1996). Evidence-Based Medicine: What It Is and What It Isn't. *BMJ*, 312(7023), pp.71??"72.
- Schwaber, K. and Sutherland, J. (2020). *The Scrum Guide*. Available at: https://scrumguides.org/ [Accessed: 15 January 2026].
- Shakespeare, T. (2013). *Disability Rights and Wrongs Revisited*. 2nd ed. London: Routledge.
- Tager-Flusberg, H. and Kasari, C. (2013). Minimally Verbal School-Aged Children with Autism Spectrum Disorder: The Neglected End of the Spectrum. *Autism Research*, 6(6), pp.468??"478.
- Tager-Flusberg, H., Paul, R., and Lord, C. (2005). Language and Communication in Autism. In: F.R. Volkmar, R. Paul, A. Klin, and D. Cohen, eds., *Handbook of Autism and Pervasive Developmental Disorders*. 3rd ed. Hoboken, NJ: Wiley, pp.335??"364.
- Tomlinson, M., Rotheram-Borus, M.J., Swartz, L., and Tsai, A.C. (2013). Scaling Up mHealth: Where Is the Evidence? *PLoS Medicine*, 10(2), e1001382.
- Tomchek, S.D. and Dunn, W. (2007). Sensory Processing in Children With and Without Autism: A Comparative Study Using the Short Sensory Profile. *American Journal of Occupational Therapy*, 61(2), pp.190??"200.
- United Nations (2006). *Convention on the Rights of Persons with Disabilities*. New York: United Nations.
- United Nations (2015). *Transforming Our World: The 2030 Agenda for Sustainable Development*. New York: United Nations.
- Wing, L. (1981). Asperger's Syndrome: A Clinical Account. *Psychological Medicine*, 11(1), pp.115??"129.
- Wing, L. and Gould, J. (1979). Severe Impairments of Social Interaction and Associated Abnormalities in Children: Epidemiology and Classification. *Journal of Autism and Developmental Disorders*, 9(1), pp.11??"29.
- Wong, C., Odom, S.L., Hume, K.A., et al. (2015). Evidence-Based Practices for Children, Youth, and Young Adults with Autism Spectrum Disorder: A Comprehensive Review. *Journal of Autism and Developmental Disorders*, 45(7), pp.1951??"1966.
- World Health Organization (2011). *mHealth: New Horizons for Health Through Mobile Technologies*. Geneva: WHO.
- World Health Organization and UNICEF (2022). *Global Report on Assistive Technology*. Geneva: WHO.

## 9. Ethical Considerations

### 9.1 Overview

The project involves vulnerable participants (children with autism spectrum disorder), personal and potentially sensitive data (facial images, usage logs, communication patterns), and deployment in a healthcare-related context. Ethical considerations are therefore central to the project's design, implementation, and evaluation, and are not treated as an afterthought but as a fundamental design constraint that shapes technical and methodological decisions throughout. This section documents the ethical framework adopted, the specific ethical issues identified, and the measures taken to address them.

The ethical framework draws on established principles for research involving human participants, including those articulated in the Declaration of Helsinki (World Medical Association, 2013), the Belmont Report (National Commission for the Protection of Human Subjects of Biomedical and Behavioral Research, 1979), and the British Psychological Society Code of Ethics and Conduct (BPS, 2021). It also draws on emerging guidelines for ethical AI development and deployment, particularly in sensitive domains involving vulnerable populations (Jobin et al., 2019; Floridi et al., 2018).

### 9.2 Informed Consent

Informed consent is the cornerstone of ethical research involving human participants. For this project, consent is required for: (a) participation in any data collection activities (e.g., capture of facial images for dataset creation); (b) use of the AAC application by a child during the pilot study; and (c) use of any data generated during the pilot for research analysis and reporting.

Given that the target participants are children who may lack the capacity to provide informed consent independently, consent is obtained from the parent or legal guardian. In addition, where appropriate and feasible, assent is sought from the child in an accessible form??"for example, using visual supports, simplified language, or demonstrations of the application. The child's willingness to engage with the system is monitored throughout, and any signs of distress, discomfort, or unwillingness to participate are treated as withdrawal of assent, even if the parent has provided consent.

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

- **Diverse data collection:** Purpose-collected data (post??"ethics approval) will include children of the target age group and cultural background, reflecting the diversity of the pilot population.
- **Per-class and per-demographic analysis:** Where sufficiently large subgroups exist, model performance will be analysed by class, gender, and age group to identify and document potential biases.
- **Transparent reporting:** Limitations of the model, including known biases and failure modes, will be documented in the final report and communicated to stakeholders.
- **Ongoing monitoring:** During the pilot, model performance will be monitored in practice, and any systematic misclassifications will be investigated and addressed (e.g., through additional data collection or model retraining).

### 9.7 Transparency and Explainability

The emotion recognition component is a "black box" in the sense that the internal representations of the CNN are not easily interpretable by end-users. The project does not attempt to provide full explainability of model predictions (which remains an open research problem for deep learning), but it does ensure that:

- The system's emotion classification is presented as a suggestion, not a diagnosis.
- Caregivers are informed (via the information sheet and in-app documentation) that the feature is experimental and that its accuracy is limited.
- The confidence score associated with each prediction is available to the caregiver (optionally displayed in the interface or accessible via a settings menu).
- The caregiver is empowered to disable or override the feature at any time.

This approach is consistent with the recommendations of Fletcher-Watson and Happ?(c) (2019) for responsible deployment of AI in sensitive domains involving individuals with autism, and with the broader AI ethics literature on transparency and accountability (Floridi et al., 2018; Jobin et al., 2019).

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
- Initial training experiments were run on a subset of a public dataset (FER2013 and related datasets), achieving preliminary accuracy in the range of 65??"72% on the validation set (before fine-tuning and before the full project-specific dataset was assembled).
- Export to TensorFlow Lite format and basic post-training quantization were performed.
- Benchmarking of the TFLite model on a test device (mid-range Android smartphone) confirmed inference times in the range of 100??"300 ms per frame, well within the target of 500 ms.

Full model training on the complete project-specific dataset (2,000??"5,000 images) is pending completion of the dataset assembly (including purpose-collected data post??"ethics approval).

### 10.5 Backend and Dashboard

A Firebase project was created and configured:

- Firebase Authentication (email/password) is operational.
- Cloud Firestore is set up with a preliminary data schema for user profiles, vocabulary customisations, and usage logs.
- Firebase Cloud Storage is configured for backup and media storage.
- Firestore security rules enforcing role-based access control have been drafted.

A minimal therapist??"parent dashboard (web-based) was implemented:

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
| Literature review | Complete | Sections 1??"2 of this report |
| Requirements and design | Substantially complete | Documented in Sections 3??"6 |
| Flutter project setup | Complete | Single codebase for Android/iOS |
| Platform A (core AAC) | Partially complete | Symbol grid, navigation, basic TTS, basic multilingual placeholders |
| Platform B (AI + FER) | In progress | Pipeline set up; model trained on public data; integration pending |
| Firebase backend | Partially complete | Auth, Firestore, Storage configured; sync logic in progress |
| Therapist??"parent dashboard | Partially complete | Minimal version implemented |
| Ethics and partnership | In progress | Draft consent forms; hospital contact made; formal application pending |
| AI model training | In progress | Initial experiments on public data; full training pending dataset completion |
| TFLite export and benchmarking | Complete (preliminary) | Model exported; inference time acceptable |
| Testing | In progress | Unit tests for critical modules; manual testing; no formal user testing yet |
| Documentation | In progress | Interim report complete; design documents maintained |

[Figure 9: Mobile App UI Layout ??" Level 1??"2]

[Figure 10: Mobile App UI Layout ??" Level 3+]

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

- Complete the curated dataset (2,000??"5,000 images) by combining public data with purpose-collected data (post??"ethics approval).
- Conduct full model training with hyperparameter tuning (learning rate, batch size, number of fine-tuned layers, dropout rate).
- Achieve and document the target accuracy of ???80%, with full confusion matrix analysis, per-class precision, recall, F1, and macro-averaged metrics.
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

- Complete the therapist??"parent dashboard with progress visualisations (charts, summaries), vocabulary management, and export options.
- Conduct feedback sessions with at least one therapist and one parent to validate usability and functionality.
- Implement responsive design for accessibility on different screen sizes.

### 11.6 Pilot and Evaluation

- Obtain ethics approval from Karapitiya Teaching Hospital's institutional ethics committee.
- Complete Ministry of Health processes as required.
- Recruit pilot participants (target: 5??"15 children with ASD and their caregivers/therapists, depending on approval and availability).
- Conduct supervised pilot use over a defined period (e.g., 4??"8 weeks).
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
| Complete Platform A (full trilingual AAC) | Months 5??"6 | Symbol set | Pending |
| Complete curated dataset | Months 5??"7 | Ethics approval | Pending |
| Full model training and evaluation | Months 6??"7 | Dataset | Pending |
| Platform B integration (FER + adaptation) | Months 6??"7 | Model | Pending |
| Full dashboard | Months 6??"7 | None | Pending |
| Full offline-first sync | Month 7 | None | Pending |
| Ethics approval (hospital + MoH) | Months 5??"6 | Application | In preparation |
| Pilot recruitment | Month 7 | Ethics approval | Pending |
| Pilot execution | Months 8??"9 | Recruitment | Pending |
| Final report | Months 9??"10 | All above | Pending |

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

The critical path of the project runs through: ethics approval ??' dataset collection ??' model training ??' Platform B integration ??' pilot execution ??' final report. Any delay in ethics approval directly affects all downstream activities on this path. The primary contingency is to proceed with model training on public data and to complete Platform A and the dashboard independently of this critical path. If the pilot cannot be completed, the final report will document the system, model, and a reflective analysis of barriers, which is acceptable for partial credit and demonstrates research maturity.

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
- **Sri Lanka??"specific FER dataset:** Collection of a large, high-quality FER dataset from Sri Lankan children (including children with ASD) could improve model accuracy and reduce bias.
- **Additional modalities:** Integration of physiological sensors (e.g., heart rate, galvanic skin response), voice analysis, or body posture recognition could provide complementary information about the user's emotional state and improve the robustness of emotion inference.
- **Cost-effectiveness studies:** Research on the cost-effectiveness of the system relative to conventional AAC and therapy services could inform policy and procurement decisions in Sri Lanka and similar settings.
- **Implementation science:** Studies on the barriers and facilitators of adoption, use, and sustained engagement with the system in different settings (clinic, home, school) could guide implementation strategies and scaling efforts.
- **Collaborative research:** Partnerships with speech-language therapy and special education programmes, as well as with international AAC and assistive technology research groups, could strengthen the evidence base and support technology transfer.

## 15. Gantt Chart Explanation

The project schedule is represented in a Gantt chart (Figure 8). The horizontal axis represents time (months from project start, covering the full academic year), and the vertical axis lists major tasks or work packages, aligned with the work breakdown structure (Section 16) and the incremental plan (Section 7).

### 15.1 Phases and Milestones

The Gantt chart is divided into five phases, corresponding to the five increments:

**Phase 1 (Months 1??"2):** Requirements, Architecture, and Literature Review.
- Tasks: Literature review; requirements elicitation; system architecture design; project setup.
- Milestone: Architecture design complete.

**Phase 2 (Months 3??"4):** Platform A and Backend Development.
- Tasks: Platform A AAC features; multilingual vocabulary; TTS integration; Firebase setup; basic dashboard.
- Milestone: Platform A basic version demo.

**Phase 3 (Months 5??"6):** AI Model and Platform B Integration.
- Tasks: Dataset assembly; model training and evaluation; TFLite export; Platform B FER pipeline; emotion-adaptive vocabulary.
- Milestone: Model accuracy target achieved; Platform B demo.

**Phase 4 (Months 7??"8):** Dashboard Completion, Ethics, and Pilot Preparation.
- Tasks: Dashboard completion; ethics application and approval; pilot design; consent form translation; participant recruitment.
- Milestone: Ethics approved; pilot ready.

**Phase 5 (Months 9??"10):** Pilot Execution and Final Report.
- Tasks: Pilot deployment; data collection; analysis; final report writing; presentation preparation.
- Milestone: Pilot complete; final report submitted.

### 15.2 Dependencies and Critical Path

Dependencies between tasks are indicated in the Gantt chart by arrows or sequencing. The critical path runs through: ethics application ??' approval ??' dataset collection ??' model training ??' Platform B integration ??' pilot execution ??' final report. Tasks on the critical path have no slack; any delay directly affects subsequent tasks and the final submission date.

Non-critical tasks include some documentation activities, optional dashboard refinements, and dissemination planning, which can be rescheduled within their latest finish times if necessary to absorb delays elsewhere.

### 15.3 Current Status

As of the interim submission, Phase 1 is complete, Phase 2 is substantially complete (with minor delays in symbol licensing), and early elements of Phase 3 (AI pipeline setup) and Phase 4 (ethics preparation) have begun. The Gantt chart is updated as the project progresses.

[Figure 8: Gantt Chart]

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
- Level 3: Purpose-built data collection (post??"ethics approval)
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
- Level 3: End-to-end testing (camera ??' inference ??' adaptation)

**Level 2: Backend and Dashboard**
- Level 3: Firebase configuration (Auth, Firestore, Storage)
- Level 3: Data schema design
- Level 3: Security rules and access control
- Level 3: Offline-first sync with conflict resolution
- Level 3: Therapist??"parent dashboard (web)
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

## 17. Conclusion

This interim report has presented the design, methodology, and current progress of an AI-powered augmentative and alternative communication system with facial expression recognition for children with autism spectrum disorder in Sri Lanka. The project addresses a clear and pressing gap in the availability of culturally and linguistically appropriate AAC tools that integrate affective computing for adaptive communication support, and that are feasible for deployment in Sri Lankan healthcare and family settings.

The dual-platform architecture??"Platform A for children at ASD severity levels 1??"2, with customisable, symbol-based AAC in Sinhala, Tamil, and English, and Platform B for children at level 3 and above, with on-device facial expression recognition powered by MobileNetV2 and TensorFlow Lite??"provides a scalable, severity-appropriate, and inclusive design. The use of Flutter for cross-platform mobile development, Firebase for secure backend services and cloud synchronisation, and an offline-first architecture ensures that the system is deployable on affordable mobile devices in settings with variable connectivity, which is essential for equitable access in Sri Lanka.

The AI component is grounded in established convolutional neural network theory, including convolution, softmax, cross-entropy loss, transfer learning, data augmentation, and model quantization. The model is designed to classify six emotion classes??"happy, sad, angry, fear, neutral, and tired??"and is evaluated using precision, recall, F1 score, confusion matrix analysis, and overall accuracy, with a target of at least 80 per cent on a curated dataset of 2,000??"5,000 images. The integration of FER into the AAC system is positioned as an assistive cue to support caregivers, with configurable adaptation, confidence thresholding, and caregiver override to minimise the risk of harm from misclassification.

Work completed to date includes a comprehensive literature review, requirements and architecture design, initial Flutter application development, AI model pipeline setup and preliminary training on public data, Firebase backend configuration, a minimal therapist??"parent dashboard, and ethical documentation and hospital partnership outreach. Minor delays in symbol licensing and ethics application submission have been identified and mitigated. The project plan for the remainder of the academic year is structured around three further increments, covering full platform development, model training and evaluation, dashboard completion, ethics approval, pilot execution, and final reporting.

Risks have been systematically identified and documented, with mitigation strategies defined for technical, project, ethical, and resource risks. Limitations and scope are stated clearly, including the constraints of a single-developer academic project, the representativeness of the dataset, the pilot sample size, and the ethical and regulatory dependencies. Future research directions??"including larger-scale trials, a Sri Lanka??"specific FER dataset, additional modalities, and implementation science studies??"are identified to guide future work beyond the scope of this project.

The project remains on track for its interim deliverables and is positioned to contribute a proof-of-concept system, a foundation for future research and deployment, and new knowledge about the feasibility, challenges, and ethical implications of AI-enhanced, multilingual AAC for children with autism in a low- and middle-income country. Success will be measured not only by technical deliverables but also by the extent to which the design and documentation enable future researchers and practitioners to build upon this work, and by the ethical and methodological rigour demonstrated throughout.

The interim report fulfils the FC6P01ES requirement for a structured, detailed account of background, design, methodology, progress, risks, and plans, and provides a clear roadmap for the completion of the project within the remaining academic year. The project aspires to demonstrate that rigorous, evidence-informed, and ethically responsible development of AI-powered assistive technology is achievable within the context of a final year project, and that such work can make a meaningful contribution to the lives of children with autism and their families in Sri Lanka and beyond.

## 18. References

Abadi, M., Barham, P., Chen, J., Chen, Z., Davis, A., Dean, J., Devin, M., Ghemawat, S., Irving, G., Isard, M., Kudlur, M., Levenberg, J., Mane, R., Monga, R., Moore, S., Murray, D.G., Steiner, B., Tucker, P., Vasudevan, V., Warden, P., Wicke, M., Yu, Y. and Zheng, X. (2016) 'TensorFlow: a system for large-scale machine learning', in *Proceedings of the 12th USENIX Symposium on Operating Systems Design and Implementation (OSDI '16)*. Berkeley, CA: USENIX Association, pp. 265??"283.

Alant, E. and Bornman, J. (2021) *Augmentative and alternative communication: engagement and participation*. San Diego, CA: Plural Publishing.

American Psychiatric Association (2013) *Diagnostic and statistical manual of mental disorders*. 5th edn. Washington, DC: American Psychiatric Publishing.

American Speech-Language-Hearing Association (2022) *Augmentative and alternative communication (AAC)*. Available at: https://www.asha.org/public/speech/disorders/aac/ (Accessed: 22 February 2025).

Barrett, L.F., Adolphs, R., Marsella, S., Martinez, A.M. and Pollak, S.D. (2019) 'Emotional expressions reconsidered: challenges to inferring emotion from human facial movements', *Psychological Science in the Public Interest*, 20(1), pp. 1??"68.

Beukelman, D.R. and Light, J.C. (2020) *Augmentative and alternative communication: supporting children and adults with complex communication needs*. 5th edn. Baltimore, MD: Paul H. Brookes.

Boehm, B.W. (1988) 'A spiral model of software development and enhancement', *Computer*, 21(5), pp. 61??"72.

British Psychological Society (2021) *Code of ethics and conduct*. Leicester: BPS.

Calvo, R.A. and D'Mello, S. (2010) 'Affect detection: an interdisciplinary review of models, methods, and their applications', *IEEE Transactions on Affective Computing*, 1(1), pp. 18??"37.

Darwin, C. (1872) *The expression of the emotions in man and animals*. London: John Murray.

Dawe, M. (2006) 'Desperately seeking simplicity: how young adults with cognitive disabilities and their families adopt assistive technologies', in *Proceedings of the SIGCHI Conference on Human Factors in Computing Systems*. New York: ACM, pp. 1143??"1152.

Department of Census and Statistics, Sri Lanka (2012) *Census of population and housing ??" 2012*. Colombo: Department of Census and Statistics.

Divan, G., Vajaratkar, V., Desai, M.U., Strik-Lievers, L. and Patel, V. (2021) 'Prevalence and risk factors for autism spectrum disorder in low- and middle-income countries: a systematic review and meta-analysis', *Global Mental Health*, 8, e30.

Ekman, P. (1992) 'An argument for basic emotions', *Cognition and Emotion*, 6(3??"4), pp. 169??"200.

Ekman, P. and Friesen, W.V. (1971) 'Constants across cultures in the face and emotion', *Journal of Personality and Social Psychology*, 17(2), pp. 124??"129.

Elsabbagh, M., Divan, G., Koh, Y.J., Kim, Y.S., Kauchali, S., Marc??n, C., Montiel-Nava, C., Patel, V., Paula, C.S., Wang, C., Yasamy, M.T. and Fombonne, E. (2012) 'Global prevalence of autism and other pervasive developmental disorders', *Autism Research*, 5(3), pp. 160??"179.

Firebase (2023) *Firebase documentation*. Available at: https://firebase.google.com/docs (Accessed: 15 January 2025).

Fletcher-Watson, S. and Happ?(c), F. (2019) *Autism: a new introduction to psychological theory and current debate*. 2nd edn. Abingdon: Routledge.

Floridi, L., Cowls, J., Beltrametti, M., Chatila, R., Chazerand, P., Dignum, V., Luetge, C., Madelin, R., Pagallo, U., Rossi, F., Schafer, B., Valcke, P. and Vayena, E. (2018) 'AI4People??"an ethical framework for a good AI society: opportunities, risks, principles, and recommendations', *Minds and Machines*, 28(4), pp. 689??"707.

Flutter (2023) *Flutter documentation*. Available at: https://flutter.dev/docs (Accessed: 15 January 2025).

Ganz, J.B. (2015) *AAC for individuals with autism spectrum disorders*. New York: Springer.

Ganz, J.B., Davis, J.L., Lund, E.M., Goodwyn, F.D. and Simpson, R.L. (2012) 'A meta-analysis of single case research studies on aided augmentative and alternative communication systems with individuals with autism spectrum disorders', *Journal of Autism and Developmental Disorders*, 42(1), pp. 60??"74.

Goodfellow, I., Bengio, Y. and Courville, A. (2015) *Deep learning*. Cambridge, MA: MIT Press.

Grogan-Johnson, S., Alvares, R., Rowan, L. and Creaghead, N. (2013) 'A pilot study comparing the effectiveness of speech language therapy provided by telemedicine with conventional on-site therapy', *Journal of Telemedicine and Telecare*, 19(5), pp. 304??"310.

Grossard, C., Dapogny, A., Cohen, D., Bernheim, S., Martinerie, J., Janvier, M., Grynszpan, O., Chaby, L., Bailly, K. and Dubuisson, S. (2020) 'Children with autism spectrum disorder produce more ambiguous and less socially meaningful facial expressions: an experimental study using random forest classifiers', *Molecular Autism*, 11(1), p. 5.

Howard, A.G., Zhu, M., Chen, B., Kalenichenko, D., Wang, W., Weyand, T., Andreetto, M. and Adam, H. (2017) 'MobileNets: efficient convolutional neural networks for mobile vision applications', *arXiv preprint arXiv:1704.04861*.

Howard, A., Sandler, M., Chen, B., Wang, W., Chen, L.C., Tan, M., Chu, G., Vasudevan, V., Zhu, Y., Pang, R., Adam, H. and Le, Q. (2019) 'Searching for MobileNetV3', in *Proceedings of the IEEE/CVF International Conference on Computer Vision*. Piscataway, NJ: IEEE, pp. 1314??"1324.

International Telecommunication Union (2022) *Measuring digital development: facts and figures 2022*. Geneva: ITU.

Ioffe, S. and Szegedy, C. (2015) 'Batch normalization: accelerating deep network training by reducing internal covariate shift', in *Proceedings of the 32nd International Conference on Machine Learning*. Lille, France: JMLR, pp. 448??"456.

Jacob, B., Kligys, S., Chen, B., Zhu, M., Tang, M., Howard, A., Adam, H. and Kalenichenko, D. (2018) 'Quantization and training of neural networks for efficient integer-arithmetic-only inference', in *Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition*. Piscataway, NJ: IEEE, pp. 2704??"2713.

Jobin, A., Ienca, M. and Vayena, E. (2019) 'The global landscape of AI ethics guidelines', *Nature Machine Intelligence*, 1(9), pp. 389??"399.

Kingma, D.P. and Ba, J. (2015) 'Adam: a method for stochastic optimization', in *Proceedings of the 3rd International Conference on Learning Representations (ICLR)*. San Diego, CA: ICLR.

Lai, M.C., Lombardo, M.V. and Baron-Cohen, S. (2014) 'Autism', *The Lancet*, 383(9920), pp. 896??"910.

LeCun, Y., Bengio, Y. and Hinton, G. (2015) 'Deep learning', *Nature*, 521(7553), pp. 436??"444.

Li, S. and Deng, W. (2020) 'Deep facial expression recognition: a survey', *IEEE Transactions on Affective Computing*, 13(3), pp. 1195??"1215.

Light, J.C. and McNaughton, D. (2012) 'The changing face of augmentative and alternative communication: past, present, and future challenges', *Augmentative and Alternative Communication*, 28(4), pp. 197??"204.

Light, J.C. and McNaughton, D. (2015) 'Designing AAC research and intervention to improve outcomes for individuals with complex communication needs', *Augmentative and Alternative Communication*, 31(2), pp. 85??"96.

Lord, C., Brugha, T.S., Charman, T., Cusack, J., Dumas, G., Frazier, T., Jones, E.J.H., Jones, R.M., Pickles, A., State, M.W., Taylor, J.L. and Veenstra-VanderWeele, J. (2020) 'Autism spectrum disorder', *Nature Reviews Disease Primers*, 6(1), p. 5.

Lorah, E.R., Parnell, A., Whitby, P.S. and Hantula, D. (2015) 'A systematic review of tablet computers and portable media players as speech generating devices for individuals with autism spectrum disorder', *Journal of Autism and Developmental Disorders*, 45(12), pp. 3792??"3804.

Maenner, M.J., Warren, Z., Williams, A.R., Amoakohene, E., Bakian, A.V., Bilder, D.A., Durkin, M.S., Fitzgerald, R.T., Furnier, S.M., Hughes, M.M., Ladd-Acosta, C.M., McArthur, D., Pas, E.T., Salinas, A., Vehorn, A., Williams, S., Esler, A., Grzybowski, A., Hall-Lande, J., Nguyen, R.H.N., Pierce, K., Zahorodny, W. and Shaw, K.A. (2023) 'Prevalence and characteristics of autism spectrum disorder among children aged 8 years ??" Autism and Developmental Disabilities Monitoring Network, 11 sites, United States, 2020', *MMWR Surveillance Summaries*, 72(2), pp. 1??"14.

Mazefsky, C.A., Herrington, J., Siegel, M., Scarpa, A., Maddox, B.B., Scahill, L. and White, S.W. (2013) 'The role of emotion regulation in autism spectrum disorder', *Journal of the American Academy of Child and Adolescent Psychiatry*, 52(7), pp. 679??"688.

McNaughton, D. and Light, J. (2013) 'The iPad and mobile technology revolution: benefits and challenges for individuals who require augmentative and alternative communication', *Augmentative and Alternative Communication*, 29(2), pp. 107??"116.

Mesibov, G.B., Shea, V. and Schopler, E. (2005) *The TEACCH approach to autism spectrum disorders*. New York: Kluwer Academic/Plenum Publishers.

Millar, D.C., Light, J.C. and Schlosser, R.W. (2006) 'The impact of augmentative and alternative communication intervention on the speech production of individuals with developmental disabilities: a research review', *Journal of Speech, Language, and Hearing Research*, 49(2), pp. 248??"264.

Ministry of Health, Sri Lanka (2020) *National guideline for ethics review of health research in Sri Lanka*. Colombo: Ministry of Health.

Nair, V. and Hinton, G.E. (2010) 'Rectified linear units improve restricted Boltzmann machines', in *Proceedings of the 27th International Conference on Machine Learning*. Madison, WI: Omnipress, pp. 807??"814.

National Commission for the Protection of Human Subjects of Biomedical and Behavioral Research (1979) *The Belmont Report: ethical principles and guidelines for the protection of human subjects of research*. Washington, DC: DHEW.

Perera, H., Wijewardena, K., Aluthwelage, R., Seneviratne, S. and Buddhika, K. (2019) 'Prevalence of autism spectrum disorder in Sri Lanka: a population-based study', *Sri Lanka Journal of Child Health*, 48(2), pp. 133??"138.

Picard, R.W. (2000) *Affective computing*. Cambridge, MA: MIT Press.

Romski, M. and Sevcik, R.A. (2005) 'Augmentative communication and early intervention: myths and realities', *Infants and Young Children*, 18(3), pp. 174??"185.

Samad, A., Razick, S., De Silva, M.V.C. and Hettiarachchi, S. (2020) 'Challenges and opportunities for autism services in Sri Lanka', *Journal of Autism and Developmental Disorders*, 50(8), pp. 3023??"3029.

Sandler, M., Howard, A., Zhu, M., Zhmoginov, A. and Chen, L.C. (2018) 'MobileNetV2: inverted residuals and linear bottlenecks', in *Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition*. Piscataway, NJ: IEEE, pp. 4510??"4520.

Shorten, C. and Khoshgoftaar, T.M. (2019) 'A survey on image data augmentation for deep learning', *Journal of Big Data*, 6(1), p. 60.

Sommerville, I. (2016) *Software engineering*. 10th edn. Harlow: Pearson Education.

Srivastava, N., Hinton, G., Krizhevsky, A., Sutskever, I. and Salakhutdinov, R. (2014) 'Dropout: a simple way to prevent neural networks from overfitting', *Journal of Machine Learning Research*, 15(1), pp. 1929??"1958.

TensorFlow (2023) *TensorFlow Lite documentation*. Available at: https://www.tensorflow.org/lite (Accessed: 15 January 2025).

Trevisan, D.A., Hoskyn, M. and Birmingham, E. (2018) 'Facial expression production in autism: a meta-analysis', *Autism Research*, 11(12), pp. 1586??"1601.

Wickramasinghe, N., Dissanayake, A. and Samarasinghe, D. (2021) 'Parent training and support programmes for autism in low-resource settings: a scoping review', *Global Health Action*, 14(1), 1910556.

World Health Organization (2021) *Autism spectrum disorders*. Available at: https://www.who.int/news-room/fact-sheets/detail/autism-spectrum-disorders (Accessed: 22 February 2025).

World Medical Association (2013) 'World Medical Association Declaration of Helsinki: ethical principles for medical research involving human subjects', *JAMA*, 310(20), pp. 2191??"2194.

Yosinski, J., Clune, J., Bengio, Y. and Lipson, H. (2014) 'How transferable are features in deep neural networks?', in *Advances in Neural Information Processing Systems*, 27. Red Hook, NY: Curran Associates, pp. 3320??"3328.

## 19. Bibliography

The following sources were consulted during the preparation of this report and have informed the background, methodology, or discussion. They are listed in addition to the references cited in the main text.

Bishop, C.M. (2006) *Pattern recognition and machine learning*. New York: Springer.

B??lte, S., Girdler, S. and Marschik, P.B. (2019) 'The contribution of environmental exposure to the etiology of autism spectrum disorder', *Cellular and Molecular Life Sciences*, 76(7), pp. 1275??"1297.

Chollet, F. (2017) *Deep learning with Python*. Shelter Island, NY: Manning Publications.

Deng, J., Dong, W., Socher, R., Li, L.J., Li, K. and Fei-Fei, L. (2009) 'ImageNet: a large-scale hierarchical image database', in *Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition*. Piscataway, NJ: IEEE, pp. 248??"255.

Ekman, P. and Friesen, W.V. (1978) *Facial Action Coding System: a technique for the measurement of facial movement*. Palo Alto, CA: Consulting Psychologists Press.

Goldsmith, T.R. and LeBlanc, L.A. (2004) 'Use of technology in interventions for children with autism', *Journal of Early and Intensive Behavior Intervention*, 1(2), pp. 166??"178.

He, K., Zhang, X., Ren, S. and Sun, J. (2016) 'Deep residual learning for image recognition', in *Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition*. Piscataway, NJ: IEEE, pp. 770??"778.

Kaggle (2013) *FER-2013: Facial Expression Recognition 2013 Dataset*. Available at: https://www.kaggle.com/datasets/msambare/fer2013 (Accessed: 15 January 2025).

Kingma, D.P. and Ba, J. (2015) 'Adam: a method for stochastic optimization', in *International Conference on Learning Representations (ICLR)*. San Diego, CA: ICLR.

Lundqvist, D., Flykt, A. and ?-hman, A. (1998) *The Karolinska Directed Emotional Faces (KDEF)*. CD-ROM from Department of Clinical Neuroscience, Psychology Section, Karolinska Institutet, ISBN 91-630-7164-9.

Mollahosseini, A., Hasani, B. and Mahoor, M.H. (2019) 'AffectNet: a database for facial expression, valence, and arousal computing in the wild', *IEEE Transactions on Affective Computing*, 10(1), pp. 18??"31.

Nielsen, M.A. (2015) *Neural networks and deep learning*. Available at: http://neuralnetworksanddeeplearning.com/ (Accessed: 15 January 2025).

Picard, R.W. (2000) *Affective computing*. Cambridge, MA: MIT Press.

Pressman, R.S. and Maxim, B.R. (2019) *Software engineering: a practitioner's approach*. 9th edn. New York: McGraw-Hill Education.

Simonyan, K. and Zisserman, A. (2015) 'Very deep convolutional networks for large-scale image recognition', in *Proceedings of the 3rd International Conference on Learning Representations (ICLR)*. San Diego, CA: ICLR.

Sutton, R.S. and Barto, A.G. (2018) *Reinforcement learning: an introduction*. 2nd edn. Cambridge, MA: MIT Press.

Szegedy, C., Vanhoucke, V., Ioffe, S., Shlens, J. and Wojna, Z. (2016) 'Rethinking the inception architecture for computer vision', in *Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition*. Piscataway, NJ: IEEE, pp. 2818??"2826.

World Health Organization (2001) *International classification of functioning, disability and health (ICF)*. Geneva: WHO.

Zeiler, M.D. and Fergus, R. (2014) 'Visualizing and understanding convolutional networks', in *Proceedings of the 13th European Conference on Computer Vision (ECCV)*. Zurich: Springer, pp. 818??"833.

*End of Interim Report*
