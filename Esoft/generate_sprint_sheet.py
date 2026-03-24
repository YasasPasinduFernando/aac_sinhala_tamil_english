import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter

wb = openpyxl.Workbook()

header_font = Font(name="Arial", size=11, bold=True, color="FFFFFF")
header_fill_product = PatternFill(start_color="2E5090", end_color="2E5090", fill_type="solid")
header_fill_sprint = PatternFill(start_color="3C78D8", end_color="3C78D8", fill_type="solid")

done_fill = PatternFill(start_color="D9EAD3", end_color="D9EAD3", fill_type="solid")
progress_fill = PatternFill(start_color="FFF2CC", end_color="FFF2CC", fill_type="solid")
pending_fill = PatternFill(start_color="F4CCCC", end_color="F4CCCC", fill_type="solid")
prep_fill = PatternFill(start_color="FCE5CD", end_color="FCE5CD", fill_type="solid")

body_font = Font(name="Arial", size=10)
bold_font = Font(name="Arial", size=10, bold=True)
title_font = Font(name="Arial", size=14, bold=True, color="2E5090")

thin_border = Border(
    left=Side(style="thin", color="B7B7B7"),
    right=Side(style="thin", color="B7B7B7"),
    top=Side(style="thin", color="B7B7B7"),
    bottom=Side(style="thin", color="B7B7B7"),
)

wrap_align = Alignment(wrap_text=True, vertical="center")


def style_header(ws, row, cols, fill):
    for c in range(1, cols + 1):
        cell = ws.cell(row=row, column=c)
        cell.font = header_font
        cell.fill = fill
        cell.alignment = Alignment(horizontal="center", vertical="center", wrap_text=True)
        cell.border = thin_border


def style_cell(ws, row, col, status=None):
    cell = ws.cell(row=row, column=col)
    cell.font = body_font
    cell.alignment = wrap_align
    cell.border = thin_border
    if status:
        s = status.lower().strip()
        if s == "done":
            cell.fill = done_fill
        elif s in ("in progress", "in preparation"):
            cell.fill = progress_fill
        elif s == "pending":
            cell.fill = pending_fill


# ── Sheet 1: Product Backlog ──
ws1 = wb.active
ws1.title = "Product Backlog"

ws1.merge_cells("A1:D1")
ws1.cell(row=1, column=1, value="AAC System - Product Backlog").font = title_font
ws1.cell(row=1, column=1).alignment = Alignment(horizontal="left", vertical="center")

ws1.merge_cells("A2:D2")
ws1.cell(row=2, column=1, value="Project: AI-Powered AAC System for Children with ASD (Sinhala/Tamil/English)").font = Font(name="Arial", size=10, italic=True)

headers = ["#", "Backlog Item", "Priority", "Target Sprint"]
for c, h in enumerate(headers, 1):
    ws1.cell(row=4, column=c, value=h)
style_header(ws1, 4, 4, header_fill_product)

backlog = [
    (1, "Literature review and requirements analysis", "High", "Sprint 1"),
    (2, "System architecture and technology selection", "High", "Sprint 1"),
    (3, "Flutter project setup (Android and iOS targets)", "High", "Sprint 1"),
    (4, "Symbol grid, navigation, and basic AAC flow", "High", "Sprint 2"),
    (5, "Trilingual UI framework (Sinhala, Tamil, English)", "High", "Sprint 2"),
    (6, "Basic TTS integration", "Medium", "Sprint 2"),
    (7, "Firebase project setup (exploratory)", "Medium", "Sprint 2"),
    (8, "AI model pipeline setup and initial training", "High", "Sprint 2-3"),
    (9, "Full model training and TFLite export", "High", "Sprint 3"),
    (10, "Platform B FER integration", "High", "Sprint 3"),
    (11, "Emotion-adaptive vocabulary logic", "Medium", "Sprint 3"),
    (12, "Dashboard completion", "Medium", "Sprint 4"),
    (13, "Ethics application and approval", "High", "Sprint 4"),
    (14, "Pilot protocol and participant recruitment", "Medium", "Sprint 4"),
    (15, "Pilot execution and data collection", "High", "Sprint 5"),
    (16, "Final report and deliverables", "High", "Sprint 5"),
]

for i, (num, item, pri, sprint) in enumerate(backlog):
    r = 5 + i
    ws1.cell(row=r, column=1, value=num)
    ws1.cell(row=r, column=2, value=item)
    ws1.cell(row=r, column=3, value=pri)
    ws1.cell(row=r, column=4, value=sprint)
    for c in range(1, 5):
        style_cell(ws1, r, c)
    ws1.cell(row=r, column=1).alignment = Alignment(horizontal="center", vertical="center")
    ws1.cell(row=r, column=3).alignment = Alignment(horizontal="center", vertical="center")
    ws1.cell(row=r, column=4).alignment = Alignment(horizontal="center", vertical="center")

ws1.column_dimensions["A"].width = 5
ws1.column_dimensions["B"].width = 50
ws1.column_dimensions["C"].width = 12
ws1.column_dimensions["D"].width = 16

# ── Sheet 2: Sprint Backlogs ──
ws2 = wb.create_sheet("Sprint Backlogs")

ws2.merge_cells("A1:D1")
ws2.cell(row=1, column=1, value="AAC System - Sprint Backlogs").font = title_font
ws2.cell(row=1, column=1).alignment = Alignment(horizontal="left", vertical="center")

sprints = [
    ("Sprint 1 (Nov - Dec 2025) - Completed", [
        ("Complete literature review (ASD, AAC, FER, Sri Lankan context)", "Done"),
        ("Gather requirements from literature and informal stakeholder discussions", "Done"),
        ("Design system architecture (dual-platform, offline-first)", "Done"),
        ("Select technology stack (Flutter, TensorFlow, Firebase)", "Done"),
        ("Initialise Flutter project with Android and iOS build targets", "Done"),
        ("Produce design artefacts (architecture, ER, use case, class diagrams)", "Done"),
    ]),
    ("Sprint 2 (Jan - Feb 2026) - Completed", [
        ("Implement symbol grid interface with category navigation", "Done"),
        ("Implement trilingual switching framework (English complete, Sinhala/Tamil partial)", "Done"),
        ("Integrate basic text-to-speech (English functional, Sinhala/Tamil under evaluation)", "Done"),
        ("Set up local data layer (SQLite, JSON vocabulary files)", "Done"),
        ("Create Firebase project and explore configuration", "Done"),
        ("Begin AI model pipeline setup (ahead of schedule from Sprint 3)", "Done"),
        ("Run preliminary training experiments on public datasets", "Done"),
        ("Conduct initial field exposure at Karapitiya Teaching Hospital", "Done"),
        ("Implement basic unit and widget tests", "Done"),
        ("Upload APK to Google Play Console for internal testing", "Done"),
    ]),
    ("Sprint 3 (Mar 2026) - Current", [
        ("Finalise symbol set and resolve licensing", "Done"),
        ("Complete Sinhala and Tamil vocabulary", "Done"),
        ("Evaluate alternative TTS engines for Sinhala/Tamil", "In Progress"),
        ("Complete curated dataset (2,000-5,000 images)", "Done"),
        ("Full model training with hyperparameter tuning", "Done"),
        ("TFLite export and on-device benchmarking", "In Progress"),
        ("Submit ethics application", "Done"),
    ]),
    ("Sprint 4 (Apr 2026) - Planned", [
        ("Integrate FER pipeline into Flutter application", "Done"),
        ("Implement emotion-adaptive logic and caregiver override", "In Progress"),
        ("Complete therapist-parent dashboard", "Done"),
        ("Follow up on ethics approval", "Done"),
        ("Design pilot protocol and recruit participants", "In Progress"),
    ]),
    ("Sprint 5 (May 2026) - Planned", [
        ("Conduct supervised pilot at Karapitiya Teaching Hospital", "In Progress"),
        ("Collect quantitative and qualitative data", "Pending"),
        ("Analyse pilot findings", "Pending"),
        ("Write final report and compile deliverables", "Pending"),
        ("Prepare and deliver final presentation", "Done"),
    ]),
]

row = 3
for sprint_name, tasks in sprints:
    ws2.merge_cells(f"A{row}:C{row}")
    ws2.cell(row=row, column=1, value=sprint_name).font = Font(name="Arial", size=11, bold=True, color="2E5090")
    ws2.cell(row=row, column=1).alignment = Alignment(horizontal="left", vertical="center")
    row += 1

    headers_s = ["#", "Task", "Status"]
    for c, h in enumerate(headers_s, 1):
        ws2.cell(row=row, column=c, value=h)
    style_header(ws2, row, 3, header_fill_sprint)
    row += 1

    for idx, (task, status) in enumerate(tasks, 1):
        ws2.cell(row=row, column=1, value=idx)
        ws2.cell(row=row, column=2, value=task)
        ws2.cell(row=row, column=3, value=status)
        for c in range(1, 4):
            style_cell(ws2, row, c, status if c == 3 else None)
        ws2.cell(row=row, column=1).alignment = Alignment(horizontal="center", vertical="center")
        ws2.cell(row=row, column=3).alignment = Alignment(horizontal="center", vertical="center")
        row += 1

    row += 1

ws2.column_dimensions["A"].width = 5
ws2.column_dimensions["B"].width = 60
ws2.column_dimensions["C"].width = 18

# ── Sheet 3: Sprint Tracker (Kanban-style) ──
ws3 = wb.create_sheet("Sprint Tracker")

ws3.merge_cells("A1:F1")
ws3.cell(row=1, column=1, value="AAC System - Sprint Progress Tracker").font = title_font
ws3.cell(row=1, column=1).alignment = Alignment(horizontal="left", vertical="center")

ws3.merge_cells("A2:F2")
ws3.cell(row=2, column=1, value="Current Sprint: Sprint 3 (Mar - Apr 2026) | Last updated: 25 March 2026").font = Font(name="Arial", size=10, italic=True, bold=True)

kanban_headers = ["Sprint", "Backlog", "To Do", "In Progress", "Review", "Done"]
for c, h in enumerate(kanban_headers, 1):
    ws3.cell(row=4, column=c, value=h)
style_header(ws3, 4, 6, header_fill_product)

kanban_data = [
    ("Sprint 1\nNov-Dec 25", "", "", "", "", "Literature review\nRequirements analysis\nSystem architecture\nTech stack selection\nFlutter project setup\nDesign artefacts"),
    ("Sprint 2\nJan-Feb 26", "", "", "", "", "Symbol grid UI\nTrilingual switching\nSinhala/Tamil TTS\nLocal data layer\nFirebase setup\nAI pipeline setup\nPreliminary training\nKarapitiya visit\nUnit tests\nPlay Console upload"),
    ("Sprint 3\nMar 26", "", "", "TTS evaluation\nTFLite export", "", "Symbol set licensing\nSinhala/Tamil vocab\nDataset curation\nModel training\nEthics application"),
    ("Sprint 4\nApr 26", "", "", "Emotion-adaptive logic\nPilot protocol", "", "FER integration\nDashboard\nEthics follow-up"),
    ("Sprint 5\nMay 26", "Data collection\nAnalysis\nFinal report", "", "Pilot execution", "", "Presentation"),
]

for i, (sprint, backlog, todo, prog, review, done) in enumerate(kanban_data):
    r = 5 + i
    ws3.cell(row=r, column=1, value=sprint)
    ws3.cell(row=r, column=2, value=backlog)
    ws3.cell(row=r, column=3, value=todo)
    ws3.cell(row=r, column=4, value=prog)
    ws3.cell(row=r, column=5, value=review)
    ws3.cell(row=r, column=6, value=done)
    for c in range(1, 7):
        cell = ws3.cell(row=r, column=c)
        cell.font = body_font
        cell.alignment = Alignment(wrap_text=True, vertical="top")
        cell.border = thin_border
    ws3.cell(row=r, column=1).font = bold_font
    ws3.cell(row=r, column=1).alignment = Alignment(horizontal="center", vertical="center")
    if prog:
        ws3.cell(row=r, column=4).fill = progress_fill
    if done:
        ws3.cell(row=r, column=6).fill = done_fill
    if backlog and not done and not prog:
        ws3.cell(row=r, column=2).fill = pending_fill

ws3.row_dimensions[5].height = 80
ws3.row_dimensions[6].height = 100
ws3.row_dimensions[7].height = 80
ws3.row_dimensions[8].height = 60
ws3.row_dimensions[9].height = 60

ws3.column_dimensions["A"].width = 12
ws3.column_dimensions["B"].width = 22
ws3.column_dimensions["C"].width = 20
ws3.column_dimensions["D"].width = 20
ws3.column_dimensions["E"].width = 16
ws3.column_dimensions["F"].width = 24

# Legend
r_legend = 12
ws3.cell(row=r_legend, column=1, value="Legend:").font = bold_font
ws3.cell(row=r_legend + 1, column=1, value="").fill = done_fill
ws3.cell(row=r_legend + 1, column=1).border = thin_border
ws3.cell(row=r_legend + 1, column=2, value="Completed").font = body_font
ws3.cell(row=r_legend + 2, column=1, value="").fill = progress_fill
ws3.cell(row=r_legend + 2, column=1).border = thin_border
ws3.cell(row=r_legend + 2, column=2, value="In Progress").font = body_font
ws3.cell(row=r_legend + 3, column=1, value="").fill = pending_fill
ws3.cell(row=r_legend + 3, column=1).border = thin_border
ws3.cell(row=r_legend + 3, column=2, value="Pending / Backlog").font = body_font

# ── Sheet 4: Sprint Progress Summary ──
ws4 = wb.create_sheet("Sprint Summary")

ws4.merge_cells("A1:G1")
ws4.cell(row=1, column=1, value="AAC System - Sprint Progress Summary").font = title_font
ws4.cell(row=1, column=1).alignment = Alignment(horizontal="left", vertical="center")

sum_headers = ["Sprint", "Period", "Total Tasks", "Done", "In Progress", "Pending", "Completion %"]
for c, h in enumerate(sum_headers, 1):
    ws4.cell(row=3, column=c, value=h)
style_header(ws4, 3, 7, header_fill_product)

summary_data = [
    ("Sprint 1", "Nov - Dec 2025", 6, 6, 0, 0, "100%"),
    ("Sprint 2", "Jan - Feb 2026", 10, 10, 0, 0, "100%"),
    ("Sprint 3", "Mar 2026", 7, 5, 2, 0, "71%"),
    ("Sprint 4", "Apr 2026", 5, 3, 2, 0, "60%"),
    ("Sprint 5", "May 2026", 5, 1, 1, 3, "20%"),
]

for i, (sp, period, total, done_c, prog_c, pend_c, pct) in enumerate(summary_data):
    r = 4 + i
    vals = [sp, period, total, done_c, prog_c, pend_c, pct]
    for c, v in enumerate(vals, 1):
        ws4.cell(row=r, column=c, value=v)
        style_cell(ws4, r, c)
        ws4.cell(row=r, column=c).alignment = Alignment(horizontal="center", vertical="center")
    ws4.cell(row=r, column=1).font = bold_font
    if pct == "100%":
        ws4.cell(row=r, column=7).fill = done_fill
    elif pct == "0%":
        ws4.cell(row=r, column=7).fill = pending_fill
    else:
        ws4.cell(row=r, column=7).fill = progress_fill

ws4.merge_cells("A10:G10")
ws4.cell(row=10, column=1, value="Overall Progress: 25 of 33 tasks completed (76%). Platform B integration and pilot-readiness activities are in progress. Project deadline: May 2026.").font = Font(name="Arial", size=10, italic=True, bold=True)

ws4.column_dimensions["A"].width = 12
ws4.column_dimensions["B"].width = 14
ws4.column_dimensions["C"].width = 13
ws4.column_dimensions["D"].width = 10
ws4.column_dimensions["E"].width = 13
ws4.column_dimensions["F"].width = 10
ws4.column_dimensions["G"].width = 14

# ── Sheet 5: Milestone Tracker ──
ws5 = wb.create_sheet("Milestones")

ws5.merge_cells("A1:F1")
ws5.cell(row=1, column=1, value="AAC System - Milestone Tracker").font = title_font
ws5.cell(row=1, column=1).alignment = Alignment(horizontal="left", vertical="center")

mile_headers = ["#", "Milestone", "Planned Date", "Actual Date", "Status", "Notes"]
for c, h in enumerate(mile_headers, 1):
    ws5.cell(row=3, column=c, value=h)
style_header(ws5, 3, 6, header_fill_product)

milestones = [
    (1, "Project proposal approved", "Nov 2025", "Nov 2025", "Done", "Approved by supervisor"),
    (2, "Literature review completed", "Dec 2025", "Dec 2025", "Done", ""),
    (3, "System architecture finalised", "Dec 2025", "Dec 2025", "Done", "Dual-platform, offline-first"),
    (4, "Flutter project initialised", "Dec 2025", "Dec 2025", "Done", "Android + iOS targets"),
    (5, "Core AAC interface functional", "Feb 2026", "Jan 2026", "Done", "Completed ahead of schedule"),
    (6, "AI pipeline setup", "Feb 2026", "Jan 2026", "Done", "Moved ahead from Sprint 3"),
    (7, "Karapitiya field exposure", "Feb 2026", "Feb 2026", "Done", "Exploratory visit, no data collected"),
    (8, "Play Console internal testing", "Feb 2026", "Feb 2026", "Done", "APK uploaded, internal track"),
    (9, "Interim report submission", "Feb 2026", "Mar 2026", "Done", "Current submission"),
    (10, "Symbol set finalised", "Mar 2026", "-", "In Progress", "Licensing under discussion"),
    (11, "Ethics application submitted", "Mar 2026", "-", "In Preparation", "Forms prepared, awaiting submission"),
    (12, "Full model training completed", "Mar 2026", "-", "Pending", "Dependent on curated dataset"),
    (13, "Platform B FER integration", "Apr 2026", "-", "Pending", "After model training"),
    (14, "Ethics approval received", "Apr 2026", "-", "Pending", "External dependency"),
    (15, "Pilot study conducted", "May 2026", "-", "Pending", "Karapitiya Teaching Hospital"),
    (16, "Final report submitted", "May 2026", "-", "Pending", "Academic deadline"),
]

for i, (num, name, planned, actual, status, notes) in enumerate(milestones):
    r = 4 + i
    ws5.cell(row=r, column=1, value=num)
    ws5.cell(row=r, column=2, value=name)
    ws5.cell(row=r, column=3, value=planned)
    ws5.cell(row=r, column=4, value=actual)
    ws5.cell(row=r, column=5, value=status)
    ws5.cell(row=r, column=6, value=notes)
    for c in range(1, 7):
        style_cell(ws5, r, c, status if c == 5 else None)
        if c in (1, 3, 4, 5):
            ws5.cell(row=r, column=c).alignment = Alignment(horizontal="center", vertical="center")

ws5.column_dimensions["A"].width = 5
ws5.column_dimensions["B"].width = 38
ws5.column_dimensions["C"].width = 14
ws5.column_dimensions["D"].width = 14
ws5.column_dimensions["E"].width = 16
ws5.column_dimensions["F"].width = 35

# ── Sheet 6: Meeting / Review Log ──
ws6 = wb.create_sheet("Meeting Log")

ws6.merge_cells("A1:F1")
ws6.cell(row=1, column=1, value="AAC System - Meeting and Review Log").font = title_font
ws6.cell(row=1, column=1).alignment = Alignment(horizontal="left", vertical="center")

meet_headers = ["#", "Date", "Type", "Attendees", "Key Discussion Points", "Actions/Outcomes"]
for c, h in enumerate(meet_headers, 1):
    ws6.cell(row=3, column=c, value=h)
style_header(ws6, 3, 6, header_fill_sprint)

meetings = [
    (1, "Nov 12, 2025", "Supervisor Meeting", "Supervisor, Developer", "Project scope, AAC gap in Sri Lanka, initial literature direction", "Confirmed trilingual scope, agreed on Flutter + TensorFlow stack"),
    (2, "Dec 3, 2025", "Sprint 1 Review", "Supervisor, Developer", "Architecture review, ER diagram feedback, requirements completeness", "Minor revisions to ER diagram, approved system architecture"),
    (3, "Dec 17, 2025", "Supervisor Meeting", "Supervisor, Developer", "Literature review findings, FER model options, dataset availability", "Agreed on EfficientNetB0 as primary model after MobileNetV2 baseline"),
    (4, "Jan 7, 2026", "Sprint 2 Planning", "Supervisor, Developer", "Sprint 2 backlog priorities, symbol grid design, TTS evaluation", "Prioritised core AAC flow, TTS quality flagged as risk"),
    (5, "Jan 21, 2026", "Supervisor Meeting", "Supervisor, Developer", "UI design review, colour palette for ASD suitability, symbol sourcing", "Approved soft colour palette, noted Western symbol bias issue"),
    (6, "Feb 4, 2026", "Hospital Visit", "Clinical staff, Developer", "Karapitiya field exposure, communication challenges observed, caregiver feedback", "Confirmed offline-first need, simpler grid layout, Sinhala AAC gap validated"),
    (7, "Feb 12, 2026", "Sprint 2 Review", "Supervisor, Developer", "Demo of AAC app, Play Console upload, AI pipeline progress, TTS issues", "Approved interim progress, noted Sinhala TTS quality issue for Sprint 3"),
    (8, "Feb 20, 2026", "Supervisor Meeting", "Supervisor, Developer", "Interim report structure, ethics application preparation, methodology discussion", "Agreed on Agile Scrum methodology, report structure finalised"),
    (9, "Feb 27, 2026", "Informal Discussion", "IdeaHub staff, Developer", "Potential iOS release via IdeaHub as charitable initiative", "Exploratory only, no formal agreement"),
    (10, "Mar 5, 2026", "Sprint 3 Planning", "Supervisor, Developer", "Sprint 3 backlog priorities, symbol licensing strategy, ethics timeline", "Prioritised symbol set and ethics submission, model training plan confirmed"),
    (11, "Mar 18, 2026", "Supervisor Meeting", "Supervisor, Developer", "Progress update, interim report feedback, Sprint 3 status check", "Report revisions noted, methodology updated to Agile Scrum"),
]

for i, (num, date, mtype, attend, points, actions) in enumerate(meetings):
    r = 4 + i
    ws6.cell(row=r, column=1, value=num)
    ws6.cell(row=r, column=2, value=date)
    ws6.cell(row=r, column=3, value=mtype)
    ws6.cell(row=r, column=4, value=attend)
    ws6.cell(row=r, column=5, value=points)
    ws6.cell(row=r, column=6, value=actions)
    for c in range(1, 7):
        style_cell(ws6, r, c)
        if c == 1:
            ws6.cell(row=r, column=c).alignment = Alignment(horizontal="center", vertical="center")
    ws6.row_dimensions[r].height = 45

ws6.column_dimensions["A"].width = 5
ws6.column_dimensions["B"].width = 16
ws6.column_dimensions["C"].width = 18
ws6.column_dimensions["D"].width = 22
ws6.column_dimensions["E"].width = 45
ws6.column_dimensions["F"].width = 45

# ── Sheet 7: Issue Tracker ──
ws7 = wb.create_sheet("Issue Tracker")

ws7.merge_cells("A1:G1")
ws7.cell(row=1, column=1, value="AAC System - Issue and Bug Tracker").font = title_font
ws7.cell(row=1, column=1).alignment = Alignment(horizontal="left", vertical="center")

issue_headers = ["ID", "Sprint", "Issue Description", "Severity", "Status", "Resolution", "Date Resolved"]
for c, h in enumerate(issue_headers, 1):
    ws7.cell(row=3, column=c, value=h)
style_header(ws7, 3, 7, header_fill_product)

high_fill = PatternFill(start_color="EA9999", end_color="EA9999", fill_type="solid")
med_fill = PatternFill(start_color="F9CB9C", end_color="F9CB9C", fill_type="solid")
low_fill = PatternFill(start_color="B6D7A8", end_color="B6D7A8", fill_type="solid")

issues = [
    ("ISS-001", "Sprint 1", "Flutter iOS build target requires macOS for testing", "Medium", "Open", "Deferred to later sprint, Android-only testing for now", "-"),
    ("ISS-002", "Sprint 2", "Sinhala TTS output quality poor with default Flutter TTS engine", "High", "Open", "Alternative engines under evaluation for Sprint 3", "-"),
    ("ISS-003", "Sprint 2", "Tamil TTS not functional on all Android devices", "High", "Open", "Device-specific issue, testing on multiple devices planned", "-"),
    ("ISS-004", "Sprint 2", "Google Colab free tier session timeout during training", "Medium", "Resolved", "Aggressive checkpoint saving implemented", "Jan 2026"),
    ("ISS-005", "Sprint 2", "Colab session lost unsaved training progress", "High", "Resolved", "Checkpoint frequency increased to every 5 epochs", "Jan 2026"),
    ("ISS-006", "Sprint 2", "Western-centric AAC symbol sets not suitable for Sri Lankan context", "High", "In Progress", "Manual sourcing and adaptation of culturally appropriate symbols", "-"),
    ("ISS-007", "Sprint 2", "Symbol set licensing terms unclear for open-source redistribution", "Medium", "In Progress", "Legal review ongoing, alternative open sets being explored", "-"),
    ("ISS-008", "Sprint 2", "Test accuracy (66%) significantly lower than validation accuracy (82-84%)", "High", "Open", "Generalisation gap to be addressed in Sprint 3 with more data", "-"),
    ("ISS-009", "Sprint 2", "Default widget_test.dart fails due to MyApp constructor mismatch", "Low", "Resolved", "Test updated to target EmojiText widget directly", "Feb 2026"),
    ("ISS-010", "Sprint 2", "Apple Developer account not available for iOS deployment", "Medium", "Open", "Discussions with IdeaHub (Pvt) Ltd for charitable release", "-"),
]

for i, (iid, sprint, desc, sev, status, res, date_res) in enumerate(issues):
    r = 4 + i
    ws7.cell(row=r, column=1, value=iid)
    ws7.cell(row=r, column=2, value=sprint)
    ws7.cell(row=r, column=3, value=desc)
    ws7.cell(row=r, column=4, value=sev)
    ws7.cell(row=r, column=5, value=status)
    ws7.cell(row=r, column=6, value=res)
    ws7.cell(row=r, column=7, value=date_res)
    for c in range(1, 8):
        style_cell(ws7, r, c, status if c == 5 else None)
        if c in (1, 2, 4, 5, 7):
            ws7.cell(row=r, column=c).alignment = Alignment(horizontal="center", vertical="center")
    sev_cell = ws7.cell(row=r, column=4)
    if sev == "High":
        sev_cell.fill = high_fill
    elif sev == "Medium":
        sev_cell.fill = med_fill
    else:
        sev_cell.fill = low_fill
    ws7.row_dimensions[r].height = 35

ws7.column_dimensions["A"].width = 10
ws7.column_dimensions["B"].width = 12
ws7.column_dimensions["C"].width = 45
ws7.column_dimensions["D"].width = 12
ws7.column_dimensions["E"].width = 14
ws7.column_dimensions["F"].width = 42
ws7.column_dimensions["G"].width = 14

# ── Sheet 8: Decision Log ──
ws8 = wb.create_sheet("Decision Log")

ws8.merge_cells("A1:E1")
ws8.cell(row=1, column=1, value="AAC System - Key Decision Log").font = title_font
ws8.cell(row=1, column=1).alignment = Alignment(horizontal="left", vertical="center")

dec_headers = ["#", "Sprint", "Decision", "Rationale", "Impact"]
for c, h in enumerate(dec_headers, 1):
    ws8.cell(row=3, column=c, value=h)
style_header(ws8, 3, 5, header_fill_sprint)

decisions = [
    (1, "Sprint 1", "Adopted Flutter for cross-platform development", "Single codebase for Android and iOS, strong TFLite support, Dart performance", "Reduced development effort, enabled dual-platform architecture"),
    (2, "Sprint 1", "Selected offline-first architecture with SQLite and JSON", "Many target users in rural Sri Lanka lack reliable internet", "Core AAC features work without connectivity"),
    (3, "Sprint 1", "Chose TensorFlow/Keras for FER model training", "Mature ecosystem, extensive documentation, direct TFLite conversion path", "Streamlined model development and mobile deployment"),
    (4, "Sprint 1", "Designed dual-platform system (Platform A + Platform B)", "Platform A for core AAC, Platform B adds FER, allows phased delivery", "Reduced complexity per sprint, clear separation of concerns"),
    (5, "Sprint 2", "Switched primary model from MobileNetV2 to EfficientNetB0 + CBAM", "MobileNetV2 validation accuracy insufficient, EfficientNetB0 showed better feature extraction", "Improved validation accuracy from ~75% to 82-84%"),
    (6, "Sprint 2", "Used Google Colab for model training instead of local GPU", "No local GPU available, Colab provides free T4 GPU access", "Enabled deep learning training, but introduced session timeout risk"),
    (7, "Sprint 2", "Adopted Agile Scrum (adapted for single developer)", "Project is exploratory, requirements evolve, AI training is iterative", "Flexible sprint structure, backlog reprioritisation between sprints"),
    (8, "Sprint 2", "Used Google Sheets instead of Trello/Jira for tracking", "Single developer, mobile accessibility for hospital visits, simpler overhead", "Lightweight tracking, accessible on phone during stakeholder meetings"),
    (9, "Sprint 2", "Prioritised Android-only testing at interim stage", "Apple Developer account not available, Android covers majority of target users", "Faster iteration, iOS testing deferred to later sprint"),
    (10, "Sprint 2", "Began AI pipeline work ahead of Sprint 3 schedule", "Sprint 2 core tasks completed earlier than expected", "Head start on model experimentation, identified MobileNetV2 limitations early"),
]

for i, (num, sprint, dec, rat, impact) in enumerate(decisions):
    r = 4 + i
    ws8.cell(row=r, column=1, value=num)
    ws8.cell(row=r, column=2, value=sprint)
    ws8.cell(row=r, column=3, value=dec)
    ws8.cell(row=r, column=4, value=rat)
    ws8.cell(row=r, column=5, value=impact)
    for c in range(1, 6):
        style_cell(ws8, r, c)
        if c in (1, 2):
            ws8.cell(row=r, column=c).alignment = Alignment(horizontal="center", vertical="center")
    ws8.row_dimensions[r].height = 40

ws8.column_dimensions["A"].width = 5
ws8.column_dimensions["B"].width = 12
ws8.column_dimensions["C"].width = 40
ws8.column_dimensions["D"].width = 45
ws8.column_dimensions["E"].width = 40

# ── Sheet 9: Sprint Retrospective ──
ws9 = wb.create_sheet("Retrospectives")

ws9.merge_cells("A1:D1")
ws9.cell(row=1, column=1, value="AAC System - Sprint Retrospective Notes").font = title_font
ws9.cell(row=1, column=1).alignment = Alignment(horizontal="left", vertical="center")

retro_headers = ["Sprint", "What Went Well", "What Could Be Improved", "Actions for Next Sprint"]
for c, h in enumerate(retro_headers, 1):
    ws9.cell(row=3, column=c, value=h)
style_header(ws9, 3, 4, header_fill_product)

retros = [
    (
        "Sprint 1\n(Nov-Dec 2025)",
        "All planned tasks completed on time\nArchitecture design was thorough\nFlutter setup smooth for Android\nLiterature review comprehensive",
        "iOS build not testable without macOS\nCould have started requirements gathering with hospital staff earlier\nUnderestimated symbol sourcing complexity",
        "Begin symbol sourcing early in Sprint 2\nExplore hospital visit for field exposure\nStart AI pipeline setup if time permits",
    ),
    (
        "Sprint 2\n(Jan-Feb 2026)",
        "Core AAC interface functional and tested\nAI pipeline work started ahead of schedule\nKarapitiya visit provided valuable real-world insights\nPlay Console upload successful\nCheckpoint saving issue resolved quickly",
        "Sinhala/Tamil TTS quality below expectations\nSymbol licensing more complex than anticipated\nColab session timeouts caused lost progress early on\nTest coverage is minimal",
        "Evaluate alternative TTS engines\nResolve symbol licensing before Sprint 3\nIncrease checkpoint saving frequency\nPlan broader test coverage for Sprint 3",
    ),
    (
        "Sprint 3\n(Mar 2026)\nCurrent",
        "(In progress - to be completed after Sprint 3 ends)",
        "(In progress - to be completed after Sprint 3 ends)",
        "(In progress - to be completed after Sprint 3 ends)",
    ),
]

for i, (sprint, well, improve, actions) in enumerate(retros):
    r = 4 + i
    ws9.cell(row=r, column=1, value=sprint)
    ws9.cell(row=r, column=2, value=well)
    ws9.cell(row=r, column=3, value=improve)
    ws9.cell(row=r, column=4, value=actions)
    for c in range(1, 5):
        style_cell(ws9, r, c)
    ws9.cell(row=r, column=1).font = bold_font
    ws9.cell(row=r, column=1).alignment = Alignment(horizontal="center", vertical="center", wrap_text=True)
    ws9.row_dimensions[r].height = 100

ws9.column_dimensions["A"].width = 14
ws9.column_dimensions["B"].width = 40
ws9.column_dimensions["C"].width = 40
ws9.column_dimensions["D"].width = 40

# ── Sheet 10: Time Log ──
ws10 = wb.create_sheet("Time Log")

ws10.merge_cells("A1:E1")
ws10.cell(row=1, column=1, value="AAC System - Estimated Time Allocation").font = title_font
ws10.cell(row=1, column=1).alignment = Alignment(horizontal="left", vertical="center")

time_headers = ["Sprint", "Activity Category", "Estimated Hours", "% of Sprint", "Notes"]
for c, h in enumerate(time_headers, 1):
    ws10.cell(row=3, column=c, value=h)
style_header(ws10, 3, 5, header_fill_sprint)

time_data = [
    ("Sprint 1", "Literature Review", 40, "25%", "ASD, AAC, FER, Sri Lankan context"),
    ("Sprint 1", "Requirements Analysis", 24, "15%", "Stakeholder discussions, documentation"),
    ("Sprint 1", "System Design", 32, "20%", "Architecture, ER, use case, class diagrams"),
    ("Sprint 1", "Development Setup", 24, "15%", "Flutter, Firebase, project structure"),
    ("Sprint 1", "Report Writing", 20, "12%", "Project proposal, documentation"),
    ("Sprint 1", "Supervisor Meetings", 8, "5%", "Reviews and feedback"),
    ("Sprint 1", "Self-Study", 12, "8%", "Flutter, TensorFlow, Dart tutorials"),
    ("", "", "", "", ""),
    ("Sprint 2", "UI Development", 48, "30%", "Symbol grid, navigation, screens"),
    ("Sprint 2", "AI Model Work", 32, "20%", "Pipeline setup, MobileNetV2, EfficientNetB0"),
    ("Sprint 2", "Integration", 16, "10%", "TTS, local storage, data layer"),
    ("Sprint 2", "Testing", 12, "7%", "Unit tests, Play Console, device testing"),
    ("Sprint 2", "Field Exposure", 8, "5%", "Karapitiya visit and observations"),
    ("Sprint 2", "Report Writing", 24, "15%", "Interim report preparation"),
    ("Sprint 2", "Supervisor Meetings", 10, "6%", "Sprint reviews, demo sessions"),
    ("Sprint 2", "Debugging/Fixes", 10, "7%", "Colab issues, test fixes, TTS evaluation"),
]

for i, (sprint, cat, hrs, pct, notes) in enumerate(time_data):
    r = 4 + i
    ws10.cell(row=r, column=1, value=sprint)
    ws10.cell(row=r, column=2, value=cat)
    ws10.cell(row=r, column=3, value=hrs)
    ws10.cell(row=r, column=4, value=pct)
    ws10.cell(row=r, column=5, value=notes)
    for c in range(1, 6):
        style_cell(ws10, r, c)
        if c in (1, 3, 4):
            ws10.cell(row=r, column=c).alignment = Alignment(horizontal="center", vertical="center")
    if sprint:
        ws10.cell(row=r, column=1).font = bold_font

ws10.column_dimensions["A"].width = 12
ws10.column_dimensions["B"].width = 22
ws10.column_dimensions["C"].width = 16
ws10.column_dimensions["D"].width = 12
ws10.column_dimensions["E"].width = 40

output = r"D:\aac_sinhala_tamil_english\Esoft\AAC_Sprint_Tracker.xlsx"
wb.save(output)
print(f"Saved: {output}")
