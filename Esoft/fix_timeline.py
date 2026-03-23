filepath = r"D:\aac_sinhala_tamil_english\Esoft\FC6P01ES_Interim_Report_FINAL.md"

with open(filepath, "r", encoding="utf-8") as f:
    content = f.read()

original = content

replacements = [
    # Section 2.6.2 Sprint Plan - intro sentence
    (
        "The project is organised into five sprints, each approximately two months in duration. The sprint boundaries align with the academic timeline and key project milestones.",
        "The project is organised into five sprints aligned with the academic timeline. The first two sprints are each approximately two months in duration, while the remaining three sprints are approximately one month each, reflecting the compressed schedule required to complete all deliverables within the academic year ending in May 2026."
    ),
    # Sprint 3
    (
        "**Sprint 3 (March to April 2026), AI Model Training and Platform B Integration.** This sprint covers dataset assembly, full model training and evaluation, TFLite export, integration of the FER pipeline into the Flutter application, and implementation of emotion-adaptive vocabulary logic. The deliverable is a working Platform B prototype.",
        "**Sprint 3 (March 2026), AI Model Training and Dataset Preparation.** This sprint covers dataset assembly, full model training and evaluation, TFLite export, symbol set finalisation, and ethics application submission. The deliverable is a trained and exported model ready for integration."
    ),
    # Sprint 4
    (
        "**Sprint 4 (May to June 2026), Dashboard Completion, Ethics Approval, and Pilot Preparation.** This sprint covers full dashboard development, ethics application and approval process, pilot protocol design, and participant recruitment. The deliverable is a complete system ready for pilot deployment.",
        "**Sprint 4 (April 2026), Platform B Integration, Dashboard, and Pilot Preparation.** This sprint covers integration of the FER pipeline into the Flutter application, emotion-adaptive vocabulary logic, dashboard completion, ethics follow-up, and pilot protocol design. The deliverable is a complete system ready for pilot deployment."
    ),
    # Sprint 5
    (
        "**Sprint 5 (July to August 2026), Pilot Execution and Final Report.** This sprint covers supervised pilot use, data collection and analysis, final report writing, and preparation of deliverables. The deliverable is the final report and all supporting documentation.",
        "**Sprint 5 (May 2026), Pilot Execution and Final Report.** This sprint covers supervised pilot use, data collection and analysis, final report writing, and preparation of deliverables. The deliverable is the final report and all supporting documentation."
    ),

    # Section 2.6.4 Sprint Backlog headers
    (
        "**Sprint 3 Backlog (March to April 2026) (Current)**",
        "**Sprint 3 Backlog (March 2026) (Current)**"
    ),
    (
        "**Sprint 4 Backlog (May to June 2026) (Planned)**",
        "**Sprint 4 Backlog (April 2026) (Planned)**"
    ),
    (
        "**Sprint 5 Backlog (July to August 2026) (Planned)**",
        "**Sprint 5 Backlog (May 2026) (Planned)**"
    ),

    # Sprint 4 backlog - restructure tasks
    (
        "| Integrate FER pipeline into Flutter application | Pending |\n| Implement emotion-adaptive logic and caregiver override | Pending |\n| Complete therapist-parent dashboard | Pending |\n| Obtain ethics approval | Pending |\n| Design pilot protocol and recruit participants | Pending |",
        "| Integrate FER pipeline into Flutter application | Pending |\n| Implement emotion-adaptive logic and caregiver override | Pending |\n| Complete therapist-parent dashboard | Pending |\n| Follow up on ethics approval | Pending |\n| Design pilot protocol and recruit participants | Pending |"
    ),

    # Sprint 5 backlog - add final report
    (
        "| Conduct supervised pilot at Karapitiya Teaching Hospital | Pending |\n| Collect quantitative and qualitative data | Pending |\n| Analyse pilot findings | Pending |\n| Write final report | Pending |\n| Prepare presentation and deliverables | Pending |",
        "| Conduct supervised pilot at Karapitiya Teaching Hospital | Pending |\n| Collect quantitative and qualitative data | Pending |\n| Analyse pilot findings | Pending |\n| Write final report and compile deliverables | Pending |\n| Prepare and deliver final presentation | Pending |"
    ),

    # Section 5.1 Original Project Plan - intro
    (
        "a Gantt chart was prepared as part of the project proposal to establish the planned schedule across the full academic year. This chart divided the work into five sprints spanning approximately ten months",
        "a Gantt chart was prepared as part of the project proposal to establish the planned schedule across the academic year. This chart divided the work into five sprints spanning approximately seven months"
    ),
    # Section 5.1 Sprint 3
    (
        "Sprint 3 (March to April 2026) covered dataset assembly, full model training and evaluation, TFLite export, and Platform B FER integration. The expected deliverable was a working Platform B prototype.",
        "Sprint 3 (March 2026) covered dataset assembly, full model training and evaluation, TFLite export, and symbol set finalisation. The expected deliverable was a trained model ready for integration."
    ),
    # Section 5.1 Sprint 4
    (
        "Sprint 4 (May to June 2026) covered dashboard completion, ethics approval, pilot design, consent form translation, and participant recruitment. The expected deliverable was a complete system ready for pilot deployment.",
        "Sprint 4 (April 2026) covered Platform B FER integration, dashboard completion, ethics approval, pilot design, and participant recruitment. The expected deliverable was a complete system ready for pilot deployment."
    ),
    # Section 5.1 Sprint 5
    (
        "Sprint 5 (July to August 2026) covered pilot execution, data collection and analysis, final report writing, and preparation of deliverables. The expected deliverable was the final report and all supporting documentation.",
        "Sprint 5 (May 2026) covered pilot execution, data collection and analysis, final report writing, and preparation of deliverables. The expected deliverable was the final report and all supporting documentation."
    ),

    # Section 5.4 Revised Plan - rewrite each period
    (
        "March to April 2026 (Revised Sprint 3). The focus during this period will be on finalising the symbol set, completing Platform A vocabulary and TTS integration, submitting the ethics application, continuing model training on public datasets, and beginning dataset curation.",
        "March 2026 (Revised Sprint 3). The focus during this period will be on finalising the symbol set, completing Platform A vocabulary and TTS integration, submitting the ethics application, continuing model training on public datasets, and beginning dataset curation."
    ),
    (
        "April to May 2026 (Overlap between Revised Sprints 3 and 4). This period will focus on full model training and evaluation once the dataset is ready, Platform B FER integration and testing, and dashboard completion.",
        "April 2026 (Revised Sprint 4). This period will focus on full model training completion, Platform B FER integration and testing, dashboard completion, and ethics follow-up. Pilot protocol design and participant recruitment will also begin during this sprint."
    ),
    (
        "May to June 2026 (Revised Sprint 4). Ethics approval is expected during this period. Tasks include pilot preparation, participant recruitment, and finalisation of backup and synchronisation flows.",
        "May 2026 (Revised Sprint 5 and Final Phase). This final sprint covers pilot execution at Karapitiya Teaching Hospital, data collection and analysis, final report writing, preparation of deliverables, and the project presentation."
    ),
    # Remove old Sprint 5 and Final phase paragraphs
    (
        "\nJune to July 2026 (Revised Sprint 5). This period covers pilot execution at Karapitiya Teaching Hospital, data collection, and preliminary analysis.\n\nJuly to August 2026 (Final phase). The final period is reserved for final report writing, preparation of deliverables, and the project presentation.\n",
        "\n"
    ),
    (
        "the parallel scheduling of previously sequential tasks during March to June 2026.",
        "the parallel scheduling of previously sequential tasks during March to May 2026 and the compression of Sprints 3 to 5 into one-month cycles."
    ),

    # Table 12 Remaining Work Plan
    (
        "| Complete Platform A (full trilingual AAC) | March to April 2026 |",
        "| Complete Platform A (full trilingual AAC) | March 2026 |"
    ),
    (
        "| Complete curated dataset | March to May 2026 |",
        "| Complete curated dataset | March to April 2026 |"
    ),
    (
        "| Full model training and evaluation | April to May 2026 | Dataset |",
        "| Full model training and evaluation | March to April 2026 | Dataset |"
    ),
    (
        "| Platform B integration (FER + adaptation) | April to May 2026 | Model |",
        "| Platform B integration (FER + adaptation) | April 2026 | Model |"
    ),
    (
        "| Full dashboard | April to May 2026 |",
        "| Full dashboard | April 2026 |"
    ),
    (
        "| Full offline-first sync | May 2026 | None |",
        "| Full offline-first sync | April 2026 | None |"
    ),
    (
        "| Ethics approval (hospital + MoH) | March to April 2026 |",
        "| Ethics approval (hospital + MoH) | March to April 2026 |"
    ),
    (
        "| Pilot recruitment | May 2026 | Ethics approval |",
        "| Pilot recruitment | April 2026 | Ethics approval |"
    ),
    (
        "| Pilot execution | June to July 2026 |",
        "| Pilot execution | May 2026 |"
    ),
    (
        "| Final report | July to August 2026 |",
        "| Final report | May 2026 |"
    ),

    # Product Backlog target sprints don't need changing (Sprint 1-5 names stay same)
]

for old, new in replacements:
    if old in content:
        content = content.replace(old, new)
    else:
        print(f"WARNING: Not found: {old[:60]}...")

with open(filepath, "w", encoding="utf-8") as f:
    f.write(content)

changes = sum(1 for o, n in zip(original.split('\n'), content.split('\n')) if o != n)
removed = len(original.split('\n')) - len(content.split('\n'))
print(f"Done! {changes} lines changed, {removed} lines removed.")
