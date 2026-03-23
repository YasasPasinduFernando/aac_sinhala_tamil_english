import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from matplotlib.patches import FancyBboxPatch, Rectangle
from datetime import datetime, timedelta
import pandas as pd
import os

output_dir = os.path.dirname(os.path.abspath(__file__))


def create_gantt(tasks_data, title, subtitle_extra, output_name, today_line=None):
    df = pd.DataFrame(tasks_data, columns=["Task", "Start", "End", "Color"])
    df["Start"] = pd.to_datetime(df["Start"])
    df["End"] = pd.to_datetime(df["End"])

    start_date = df["Start"].min()
    end_date = df["End"].max()

    fig, ax = plt.subplots(figsize=(18, 9))
    fig.patch.set_facecolor("white")
    ax.set_facecolor("white")

    ax.set_xlim(start_date - timedelta(days=12), end_date + timedelta(days=10))
    ax.set_ylim(-1.2, len(df) + 2.5)

    for spine in ax.spines.values():
        spine.set_visible(False)
    ax.tick_params(left=False, bottom=False, labelbottom=False)

    current = start_date.replace(day=1)
    while current <= end_date + timedelta(days=31):
        month_start = current
        next_month = (month_start + pd.offsets.MonthBegin(1)).to_pydatetime()
        ax.axvline(month_start, color="#D9E2EF", lw=1.2, zorder=0)
        week_cursor = month_start
        while week_cursor < next_month and week_cursor <= end_date + timedelta(days=7):
            ax.axvline(week_cursor, color="#EEF3F8", lw=0.8, zorder=0)
            week_cursor += timedelta(days=7)
        current = next_month

    for y in range(len(df) + 1):
        ax.hlines(y, start_date - timedelta(days=5), end_date + timedelta(days=5),
                  color="#EEF3F8", lw=1, zorder=0)

    bar_height = 0.55
    for i, row in enumerate(df.itertuples(index=False)):
        y = len(df) - 1 - i
        x = mdates.date2num(row.Start)
        width = mdates.date2num(row.End) - mdates.date2num(row.Start)
        rounded_bar = FancyBboxPatch(
            (x, y - bar_height / 2), width, bar_height,
            boxstyle="round,pad=0.02,rounding_size=0.12",
            linewidth=0, facecolor=row.Color, alpha=0.92,
            transform=ax.transData, zorder=3
        )
        ax.add_patch(rounded_bar)

    if today_line:
        today_dt = pd.to_datetime(today_line)
        if start_date <= today_dt <= end_date:
            ax.axvline(today_dt, color="#FF4444", lw=2, ls="--", zorder=5, alpha=0.8)
            ax.text(today_dt, len(df) + 1.6, "Today\n(25 Mar 2026)",
                    ha="center", va="center", fontsize=9, color="#FF4444", fontweight="bold")

    ax.set_yticks(range(len(df)))
    ax.set_yticklabels(df["Task"][::-1], fontsize=11, color="#333333")
    ax.tick_params(axis='y', length=0)

    fig.text(0.5, 0.955, title,
             ha="center", va="center", fontsize=18, fontweight="bold", color="#1F3B64")
    fig.text(0.5, 0.92,
             f"Start: {start_date.strftime('%B %Y')} | End: {end_date.strftime('%B %Y')} | {subtitle_extra}",
             ha="center", va="center", fontsize=12, color="#555555")

    header_y_month = len(df) + 1.0
    current = start_date.replace(day=1)
    while current <= end_date:
        month_start = current
        next_month = (month_start + pd.offsets.MonthBegin(1)).to_pydatetime()
        visible_start = max(month_start, start_date)
        visible_end = min(next_month, end_date + timedelta(days=1))
        x0 = mdates.date2num(visible_start)
        x1 = mdates.date2num(visible_end)
        ax.text(mdates.num2date((x0 + x1) / 2), header_y_month,
                month_start.strftime("%b '%y"),
                ha="center", va="center", fontsize=11, color="#3A3A3A", fontweight="bold")
        current = next_month

    line_y = -0.7
    ax.annotate("",
                xy=(mdates.date2num(end_date + timedelta(days=5)), line_y),
                xytext=(mdates.date2num(start_date), line_y),
                arrowprops=dict(arrowstyle="->", color="#4F81BD", lw=2))
    ax.text(start_date, line_y - 0.35,
            f"Start: {start_date.strftime('%B %Y')}",
            ha="left", va="top", fontsize=11, color="#2F3E4E", fontweight="bold")
    ax.text(end_date + timedelta(days=5), line_y - 0.35,
            f"End: {end_date.strftime('%B %Y')}",
            ha="right", va="top", fontsize=11, color="#2F3E4E", fontweight="bold")

    legend_items = [Rectangle((0, 0), 1, 1, color=c) for c in df["Color"]]
    legend_labels = df["Task"].tolist()
    ax.legend(legend_items, legend_labels,
              loc="upper center", bbox_to_anchor=(0.5, -0.14),
              ncol=4, frameon=False, fontsize=10,
              handlelength=1, handletextpad=0.6)

    plt.tight_layout(rect=[0.03, 0.08, 0.97, 0.9])
    out = os.path.join(output_dir, output_name)
    plt.savefig(out, dpi=300, bbox_inches="tight")
    print(f"Saved: {out}")
    plt.close()


# ═══════════════════════════════════════════
# FIGURE 17: Initial Project Gantt Chart
# (Original plan from project proposal)
# ═══════════════════════════════════════════
initial_tasks = [
    ("Literature Review",                "2025-11-01", "2025-12-15", "#2E7DB6"),
    ("Requirements Analysis",            "2025-11-15", "2025-12-20", "#4A90D9"),
    ("System Architecture Design",       "2025-12-01", "2025-12-31", "#1B5E8A"),
    ("Flutter Project Setup",            "2025-12-10", "2025-12-31", "#6BAED6"),
    ("Symbol Grid & AAC Interface",      "2026-01-01", "2026-02-15", "#F28E1C"),
    ("Trilingual Framework",             "2026-01-10", "2026-02-20", "#F5A623"),
    ("TTS Integration",                  "2026-01-15", "2026-02-28", "#E8751A"),
    ("Local Data Layer (SQLite/JSON)",   "2026-01-05", "2026-01-31", "#FFB84D"),
    ("AI Model Pipeline Setup",          "2026-02-01", "2026-03-15", "#2CA02C"),
    ("Full Model Training & TFLite",     "2026-03-01", "2026-03-31", "#3DBF3D"),
    ("Ethics Application & Approval",    "2026-03-01", "2026-04-15", "#98DF8A"),
    ("FER Integration (Platform B)",     "2026-04-01", "2026-04-25", "#D62728"),
    ("Dashboard Development",            "2026-04-01", "2026-04-20", "#FF6B6B"),
    ("Pilot Preparation",                "2026-04-10", "2026-04-30", "#9467BD"),
    ("Pilot Execution & Data Collection","2026-05-01", "2026-05-20", "#E377C2"),
    ("Final Report & Deliverables",      "2026-05-05", "2026-05-31", "#7F7F7F"),
]

create_gantt(
    initial_tasks,
    "AAC System - Initial Project Plan (Gantt Chart)",
    "5 Sprints | Nov 2025 - May 2026",
    "gantt_initial.png"
)


# ═══════════════════════════════════════════
# FIGURE 18: Updated Project Gantt Chart
# (Revised plan with parallel scheduling)
# ═══════════════════════════════════════════
updated_tasks = [
    ("Literature Review [Done]",              "2025-11-01", "2025-12-15", "#93C5E6"),
    ("Requirements & Architecture [Done]",    "2025-11-15", "2025-12-31", "#93C5E6"),
    ("Flutter Setup & Design Artefacts [Done]","2025-12-10", "2025-12-31", "#93C5E6"),
    ("Symbol Grid & AAC Interface [Done]",    "2026-01-01", "2026-02-10", "#FFD699"),
    ("TTS & Trilingual Framework [In Prog]",  "2026-01-10", "2026-03-31", "#FFF2CC"),
    ("Local Data Layer [Done]",               "2026-01-05", "2026-01-25", "#FFD699"),
    ("AI Pipeline & Preliminary Training [Done]","2026-01-15", "2026-02-28", "#B8E6B8"),
    ("Karapitiya Field Exposure [Done]",      "2026-02-01", "2026-02-10", "#FFD699"),
    ("Symbol Set Finalisation [In Prog]",     "2026-03-01", "2026-03-31", "#F28E1C"),
    ("Full Model Training & TFLite Export",   "2026-03-10", "2026-04-10", "#2CA02C"),
    ("Ethics Application & Approval",         "2026-03-01", "2026-04-15", "#9467BD"),
    ("FER Integration (Platform B)",          "2026-04-01", "2026-04-20", "#D62728"),
    ("Dashboard Development",                 "2026-04-01", "2026-04-20", "#FF6B6B"),
    ("Pilot Preparation & Recruitment",       "2026-04-10", "2026-04-30", "#8C564B"),
    ("Pilot Execution & Data Collection",     "2026-05-01", "2026-05-15", "#E377C2"),
    ("Final Report & Deliverables",           "2026-05-05", "2026-05-31", "#7F7F7F"),
]

create_gantt(
    updated_tasks,
    "AAC System - Updated Project Plan (Gantt Chart)",
    "Revised Sprint 3-5 with parallel scheduling | As of March 2026",
    "gantt_updated.png",
    today_line="2026-03-25"
)

print("\nBoth Gantt charts generated successfully!")
