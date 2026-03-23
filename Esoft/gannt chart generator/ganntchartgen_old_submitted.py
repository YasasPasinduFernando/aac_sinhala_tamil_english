import os
from datetime import timedelta

import matplotlib.dates as mdates
import matplotlib.pyplot as plt
import pandas as pd
from matplotlib.patches import FancyBboxPatch, Rectangle

output_dir = os.path.dirname(os.path.abspath(__file__))


def create_gantt(tasks_data, title, subtitle, output_name):
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
        ax.hlines(
            y,
            start_date - timedelta(days=5),
            end_date + timedelta(days=5),
            color="#EEF3F8",
            lw=1,
            zorder=0,
        )

    bar_height = 0.55
    for i, row in enumerate(df.itertuples(index=False)):
        y = len(df) - 1 - i
        x = mdates.date2num(row.Start)
        width = mdates.date2num(row.End) - mdates.date2num(row.Start)
        rounded_bar = FancyBboxPatch(
            (x, y - bar_height / 2),
            width,
            bar_height,
            boxstyle="round,pad=0.02,rounding_size=0.12",
            linewidth=0,
            facecolor=row.Color,
            alpha=0.92,
            transform=ax.transData,
            zorder=3,
        )
        ax.add_patch(rounded_bar)

    ax.set_yticks(range(len(df)))
    ax.set_yticklabels(df["Task"][::-1], fontsize=12, color="#333333")
    ax.tick_params(axis="y", length=0)

    fig.text(
        0.5,
        0.955,
        title,
        ha="center",
        va="center",
        fontsize=20,
        fontweight="bold",
        color="#1F3B64",
    )
    fig.text(0.5, 0.92, subtitle, ha="center", va="center", fontsize=14, color="#333333")

    header_y_month = len(df) + 1.0
    header_y_week = len(df) + 0.45
    current = start_date.replace(day=1)
    while current <= end_date:
        month_start = current
        next_month = (month_start + pd.offsets.MonthBegin(1)).to_pydatetime()
        visible_start = max(month_start, start_date)
        visible_end = min(next_month, end_date + timedelta(days=1))
        x0 = mdates.date2num(visible_start)
        x1 = mdates.date2num(visible_end)

        ax.text(
            mdates.num2date((x0 + x1) / 2),
            header_y_month,
            month_start.strftime("%b '%y"),
            ha="center",
            va="center",
            fontsize=13,
            color="#3A3A3A",
            fontweight="bold",
        )

        week_cursor = visible_start
        week_num = 1
        while week_cursor < visible_end:
            week_end = min(week_cursor + timedelta(days=7), visible_end)
            wx0 = mdates.date2num(week_cursor)
            wx1 = mdates.date2num(week_end)
            ax.text(
                mdates.num2date((wx0 + wx1) / 2),
                header_y_week,
                f"W{week_num}",
                ha="center",
                va="center",
                fontsize=11,
                color="#5C6B7A",
            )
            week_cursor += timedelta(days=7)
            week_num += 1

        current = next_month

    line_y = -0.7
    ax.annotate(
        "",
        xy=(mdates.date2num(end_date + timedelta(days=5)), line_y),
        xytext=(mdates.date2num(start_date), line_y),
        arrowprops=dict(arrowstyle="->", color="#4F81BD", lw=2),
    )
    ax.text(
        start_date,
        line_y - 0.35,
        f"Start Date: {start_date.strftime('%B')} {start_date.day}, {start_date.year}",
        ha="left",
        va="top",
        fontsize=14,
        color="#2F3E4E",
        fontweight="bold",
    )
    ax.text(
        end_date + timedelta(days=5),
        line_y - 0.35,
        f"End Date: {end_date.strftime('%B')} {end_date.day}, {end_date.year}",
        ha="right",
        va="top",
        fontsize=14,
        color="#2F3E4E",
        fontweight="bold",
    )

    legend_items = [Rectangle((0, 0), 1, 1, color=c) for c in df["Color"]]
    legend_labels = df["Task"].tolist()
    ax.legend(
        legend_items,
        legend_labels,
        loc="upper center",
        bbox_to_anchor=(0.5, -0.14),
        ncol=4,
        frameon=False,
        fontsize=11,
        handlelength=0.8,
        handletextpad=0.6,
    )

    plt.tight_layout(rect=[0.03, 0.08, 0.97, 0.9])
    out = os.path.join(output_dir, output_name)
    plt.savefig(out, dpi=300, bbox_inches="tight")
    print(f"Saved: {out}")
    plt.close()


old_submitted_tasks = [
    ("Literature Review", "2025-11-01", "2025-12-15", "#3F71AD"),
    ("Ethics Approval", "2025-11-01", "2026-01-15", "#3F71AD"),
    ("Dataset Acquisition", "2025-12-01", "2026-01-25", "#5B9EA0"),
    ("Clinical Consultations", "2025-12-01", "2026-02-25", "#5B9EA0"),
    ("AAC Development", "2025-12-20", "2026-02-10", "#E3B73F"),
    ("Facial Recognition Development", "2026-01-15", "2026-03-25", "#E3B73F"),
    ("Integration & Testing", "2026-01-25", "2026-04-10", "#E79643"),
    ("Validation & Documentation", "2026-02-15", "2026-05-31", "#7D61B5"),
]

create_gantt(
    old_submitted_tasks,
    "AI-Powered Facial Expression Analysis & AAC Platform Development",
    "Start Date: November 1, 2025 | End Date: May 31, 2026",
    "gantt_old_submitted.png",
)

