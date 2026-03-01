

### 2.12 Extended Discussion: Natural Language Processing for Sinhala and Tamil

#### 2.12.1 Challenges of NLP for Low-Resource Languages

Natural language processing (NLP) has made remarkable progress in recent years, driven by advances in deep learning, large language models, and the availability of massive text corpora for high-resource languages such as English, Chinese, and Spanish. However, the benefits of these advances have not been equally distributed across languages. Sinhala and Tamil are classified as low-resource languages, meaning that the availability of annotated datasets, pre-trained models, language-specific tools (tokenisers, morphological analysers, parsers), and text-to-speech systems is significantly more limited compared to high-resource languages (Joshi et al., 2020).

For Sinhala, specific NLP challenges include: (a) the complex morphology of the language, with extensive inflectional and derivational processes that increase the effective vocabulary size and complicate tokenisation; (b) the relatively small amount of digitised text available for training language models (compared to, for example, Hindi or Bengali); (c) the Sinhala script, which is an abugida (syllabic alphabet) with a large character set, presenting challenges for character-level NLP models; and (d) the limited availability of Sinhala-specific NLP tools and libraries, although efforts by the Language Technology Research Laboratory (LTRL) at the University of Colombo and other institutions have produced some foundational resources (Fernando et al., 2016).

For Tamil, while more NLP resources exist (Tamil being spoken by a larger global population and being an official language of both India and Sri Lanka), challenges remain in: (a) agglutinative morphology, with complex word formations that can encode multiple grammatical meanings in a single word; (b) dialect variation between Sri Lankan Tamil and Indian Tamil; (c) the availability and quality of TTS systems that produce natural-sounding speech in Tamil; and (d) the integration of Tamil NLP tools with modern mobile development frameworks.

These challenges directly impact the present project in two areas: text-to-speech quality and future NLP-based features (e.g., word prediction, sentence construction assistance). The project documents the current state of Sinhala and Tamil TTS quality (based on testing of Google's TTS engine and any available alternatives) and identifies areas where recorded audio may be needed as a fallback. Future NLP enhancements (e.g., predictive text input, grammatically correct sentence assembly from symbol sequences) are explicitly identified as areas for future research and development.

#### 2.12.2 Unicode Support and Script Rendering

Both Sinhala and Tamil scripts are fully supported in the Unicode standard, and modern mobile operating systems (Android 8.0+, iOS 14+) include system-level font support for both scripts. However, correct rendering of Sinhala and Tamil text—including complex conjunct characters, vowel signs, and ligatures—requires appropriate font selection and text rendering engine configuration.

Flutter, the project's UI framework, uses the Skia graphics engine for text rendering, which supports complex scripts including Sinhala and Tamil. However, edge cases in rendering (e.g., certain rare conjunct characters, mixed-script text with Sinhala, Tamil, and Latin characters in the same string) must be tested on the target devices to ensure correct display. The project includes a comprehensive text rendering test suite covering common vocabulary items in all three languages, with screenshots documented in the testing appendix.

### 3.7 Extended Problem Statement: The Digital Divide in Disability Services

The concept of the "digital divide"—the gap between those who have access to and can effectively use digital technologies and those who do not—is particularly acute in the context of disability services in LMICs. While digital technologies (including mobile apps, telehealth platforms, and AI-based tools) have the potential to dramatically expand access to disability services, realising this potential requires addressing multiple barriers: device availability, internet connectivity, digital literacy, content availability in local languages, and the design of technology that is usable by people with diverse abilities and in diverse cultural contexts (UN Broadband Commission, 2019).

In Sri Lanka, the digital divide in disability services manifests in several ways:

1. **Urban–rural divide:** Families in Colombo and other major cities have significantly better access to specialist services, including SLTs, developmental paediatricians, and assistive technology providers. Families in rural areas may have to travel long distances for specialist appointments and may have limited or no access to AAC assessment and intervention.

2. **Socioeconomic divide:** The cost of devices (smartphones, tablets), internet connectivity, and commercially available AAC apps places them beyond the reach of many low-income families. Even when free or low-cost apps are available, the cost of a suitable device may be a barrier.

3. **Language divide:** The predominance of English-language AAC tools means that families who are not proficient in English are effectively excluded from the digital AAC ecosystem. This English-language bias reflects a broader pattern in assistive technology development, which has historically prioritised the needs and languages of high-income, English-speaking markets.

4. **Knowledge divide:** Many families and even some professionals are unaware of the existence and potential benefits of AAC. Raising awareness about AAC, and about the specific system developed in this project, is an important component of the dissemination and implementation strategy.

The present project explicitly addresses these dimensions of the digital divide: it targets families across the socioeconomic spectrum by being free and running on affordable Android devices; it provides full trilingual support (Sinhala, Tamil, English); it is designed for use with minimal professional training; and it aims to raise awareness through its clinical partnership with Karapitiya Teaching Hospital and through dissemination activities (publications, presentations, community engagement).

---
