import re

filepath = r"D:\aac_sinhala_tamil_english\Esoft\FC6P01ES_Interim_Report_FINAL.md"

with open(filepath, "r", encoding="utf-8") as f:
    content = f.read()

original = content

# Month number to actual month mapping (Month 1 = Nov 2025)
month_map = {
    1: "November 2025", 2: "December 2025",
    3: "January 2026", 4: "February 2026",
    5: "March 2026", 6: "April 2026",
    7: "May 2026", 8: "June 2026",
    9: "July 2026", 10: "August 2026",
}

month_map_short = {
    1: "Nov-Dec 2025", 2: "Dec 2025",
    3: "Jan-Feb 2026", 4: "Feb 2026",
    5: "Mar-Apr 2026", 6: "Apr 2026",
    7: "May-Jun 2026", 8: "Jun 2026",
    9: "Jul-Aug 2026", 10: "Aug 2026",
}

# Section 2.6.2 Sprint Plan
content = content.replace(
    "**Sprint 1 (Months 1-2), Requirements, Architecture, and Minimal AAC.**",
    "**Sprint 1 (November to December 2025), Requirements, Architecture, and Minimal AAC.**"
)
content = content.replace(
    "**Sprint 2 (Months 3-4), Platform A and Firebase Backend.**",
    "**Sprint 2 (January to February 2026), Platform A and Firebase Backend.**"
)
content = content.replace(
    "**Sprint 3 (Months 5-6), AI Model Training and Platform B Integration.**",
    "**Sprint 3 (March to April 2026), AI Model Training and Platform B Integration.**"
)
content = content.replace(
    "**Sprint 4 (Months 7-8), Dashboard Completion, Ethics Approval, and Pilot Preparation.**",
    "**Sprint 4 (May to June 2026), Dashboard Completion, Ethics Approval, and Pilot Preparation.**"
)
content = content.replace(
    "**Sprint 5 (Months 9-10), Pilot Execution and Final Report.**",
    "**Sprint 5 (July to August 2026), Pilot Execution and Final Report.**"
)

# Section 2.6.4 Sprint Backlog headers
content = content.replace(
    "**Sprint 1 Backlog (Months 1-2)**",
    "**Sprint 1 Backlog (November to December 2025)**"
)
content = content.replace(
    "**Sprint 2 Backlog (Months 3-4)**",
    "**Sprint 2 Backlog (January to February 2026)**"
)
content = content.replace(
    "**Sprint 3 Backlog (Months 5-6) (Planned)**",
    "**Sprint 3 Backlog (March to April 2026) (Current)**"
)
content = content.replace(
    "**Sprint 4 Backlog (Months 7-8) (Planned)**",
    "**Sprint 4 Backlog (May to June 2026) (Planned)**"
)
content = content.replace(
    "**Sprint 5 Backlog (Months 9-10) (Planned)**",
    "**Sprint 5 Backlog (July to August 2026) (Planned)**"
)

# Section 5.1 Original Project Plan
content = content.replace(
    "Sprint 1 (Months 1 to 2) covered requirements analysis",
    "Sprint 1 (November to December 2025) covered requirements analysis"
)
content = content.replace(
    "Sprint 2 (Months 3 to 4) covered Platform A core AAC features",
    "Sprint 2 (January to February 2026) covered Platform A core AAC features"
)
content = content.replace(
    "Sprint 3 (Months 5 to 6) covered dataset assembly",
    "Sprint 3 (March to April 2026) covered dataset assembly"
)
content = content.replace(
    "Sprint 4 (Months 7 to 8) covered dashboard completion",
    "Sprint 4 (May to June 2026) covered dashboard completion"
)
content = content.replace(
    "Sprint 5 (Months 9 to 10) covered pilot execution",
    "Sprint 5 (July to August 2026) covered pilot execution"
)
content = content.replace(
    "At the interim submission point, which falls at the end of Month 4,",
    "At the interim submission point, which falls at the end of February 2026,"
)

# Section 5.2 Progress Against Plan
content = content.replace(
    "Sprint 1 (Months 1 to 2) was completed on schedule.",
    "Sprint 1 (November to December 2025) was completed on schedule."
)
content = content.replace(
    "Sprint 2 (Months 3 to 4) is substantially complete",
    "Sprint 2 (January to February 2026) is substantially complete"
)

# Section 5.4 Revised Plan
content = content.replace(
    "Months 5 to 6 (Revised Sprint 3). The focus during this period",
    "March to April 2026 (Revised Sprint 3). The focus during this period"
)
content = content.replace(
    "Months 6 to 7 (Overlap between Revised Sprints 3 and 4). This period",
    "April to May 2026 (Overlap between Revised Sprints 3 and 4). This period"
)
content = content.replace(
    "Months 7 to 8 (Revised Sprint 4). Ethics approval",
    "May to June 2026 (Revised Sprint 4). Ethics approval"
)
content = content.replace(
    "Months 8 to 9 (Revised Sprint 5). This period covers",
    "June to July 2026 (Revised Sprint 5). This period covers"
)
content = content.replace(
    "Months 9 to 10 (Final phase). The final period",
    "July to August 2026 (Final phase). The final period"
)
content = content.replace(
    "the parallel scheduling of previously sequential tasks during Months 5 to 8.",
    "the parallel scheduling of previously sequential tasks during March to June 2026."
)

# Table 12: Remaining Work Plan - individual month references
content = content.replace(
    "| Finalise symbol set and licensing | Month 5 |",
    "| Finalise symbol set and licensing | March 2026 |"
)
content = content.replace(
    "| Complete Platform A (full trilingual AAC) | Months 5–6 |",
    "| Complete Platform A (full trilingual AAC) | March to April 2026 |"
)
content = content.replace(
    "| Complete curated dataset | Months 5–7 |",
    "| Complete curated dataset | March to May 2026 |"
)
content = content.replace(
    "| Full model training and evaluation | Months 6–7 |",
    "| Full model training and evaluation | April to May 2026 |"
)
content = content.replace(
    "| Platform B integration (FER + adaptation) | Months 6–7 |",
    "| Platform B integration (FER + adaptation) | April to May 2026 |"
)
content = content.replace(
    "| Full dashboard | Months 6–7 |",
    "| Full dashboard | April to May 2026 |"
)
content = content.replace(
    "| Full offline-first sync | Month 7 |",
    "| Full offline-first sync | May 2026 |"
)
content = content.replace(
    "| Ethics approval (hospital + MoH) | Months 5–6 |",
    "| Ethics approval (hospital + MoH) | March to April 2026 |"
)
content = content.replace(
    "| Pilot recruitment | Month 7 |",
    "| Pilot recruitment | May 2026 |"
)
content = content.replace(
    "| Pilot execution | Months 8–9 |",
    "| Pilot execution | June to July 2026 |"
)
content = content.replace(
    "| Final report | Months 9–10 |",
    "| Final report | July to August 2026 |"
)

with open(filepath, "w", encoding="utf-8") as f:
    f.write(content)

changes = 0
for i, (o, n) in enumerate(zip(original.split('\n'), content.split('\n'))):
    if o != n:
        changes += 1

print(f"Done! {changes} lines changed.")
