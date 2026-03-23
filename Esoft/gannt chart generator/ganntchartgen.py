import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from matplotlib.patches import FancyBboxPatch, Rectangle
from datetime import datetime, timedelta
import pandas as pd

# -----------------------------
# DATA
# -----------------------------
tasks = [
    ("Platform A Completion", "2026-02-01", "2026-03-15", "#2E7DB6"),
    ("Dataset & Ethics Prep", "2026-02-01", "2026-03-10", "#F28E1C"),
    ("Model Training", "2026-03-01", "2026-04-10", "#2CA02C"),
    ("FER Integration", "2026-03-15", "2026-04-20", "#D62728"),
    ("Dashboard Development", "2026-03-10", "2026-04-20", "#9467BD"),
    ("Pilot Preparation", "2026-04-15", "2026-05-01", "#8C564B"),
    ("Pilot Execution", "2026-05-01", "2026-05-20", "#E377C2"),
    ("Final Report", "2026-05-10", "2026-05-31", "#7F7F7F"),
]

df = pd.DataFrame(tasks, columns=["Task", "Start", "End", "Color"])
df["Start"] = pd.to_datetime(df["Start"])
df["End"] = pd.to_datetime(df["End"])

start_date = df["Start"].min()
end_date = df["End"].max()

# -----------------------------
# FIGURE
# -----------------------------
fig, ax = plt.subplots(figsize=(16, 8))
fig.patch.set_facecolor("white")
ax.set_facecolor("white")

# Extend space for headers and legend
ax.set_xlim(start_date - timedelta(days=10), end_date + timedelta(days=8))
ax.set_ylim(-1.2, len(df) + 2.2)

# Remove default spines/ticks
for spine in ax.spines.values():
    spine.set_visible(False)

ax.tick_params(left=False, bottom=False, labelbottom=False)

# -----------------------------
# GRID (weekly vertical lines)
# -----------------------------
current = start_date.replace(day=1)
while current <= end_date + timedelta(days=31):
    month_start = current
    next_month = (month_start + pd.offsets.MonthBegin(1)).to_pydatetime()

    # Month boundary line
    ax.axvline(month_start, color="#D9E2EF", lw=1.2, zorder=0)

    # Weekly divisions
    week_cursor = month_start
    while week_cursor < next_month and week_cursor <= end_date + timedelta(days=7):
        ax.axvline(week_cursor, color="#EEF3F8", lw=0.8, zorder=0)
        week_cursor += timedelta(days=7)

    current = next_month

# Horizontal row lines
for y in range(len(df) + 1):
    ax.hlines(y, start_date, end_date + timedelta(days=5), color="#EEF3F8", lw=1, zorder=0)

# -----------------------------
# TASK BARS
# -----------------------------
bar_height = 0.55
for i, row in enumerate(df.itertuples(index=False)):
    y = len(df) - 1 - i  # top to bottom
    x = mdates.date2num(row.Start)
    width = mdates.date2num(row.End) - mdates.date2num(row.Start)

    rounded_bar = FancyBboxPatch(
        (x, y - bar_height / 2),
        width,
        bar_height,
        boxstyle="round,pad=0.02,rounding_size=0.12",
        linewidth=0,
        facecolor=row.Color,
        alpha=0.95,
        transform=ax.transData,
        zorder=3
    )
    ax.add_patch(rounded_bar)

# -----------------------------
# Y LABELS
# -----------------------------
ax.set_yticks(range(len(df)))
ax.set_yticklabels(df["Task"][::-1], fontsize=12, color="#333333")
ax.tick_params(axis='y', length=0)

# -----------------------------
# TITLE + SUBTITLE
# -----------------------------
fig.text(
    0.5, 0.95,
    "AI-Powered Facial Expression Analysis & AAC Platform Development",
    ha="center", va="center",
    fontsize=20, fontweight="bold", color="#1F3B64"
)

fig.text(
    0.5, 0.915,
    f"Start Date: {start_date.strftime('%B %d, %Y')} | End Date: {end_date.strftime('%B %d, %Y')}",
    ha="center", va="center",
    fontsize=13, color="#333333"
)

# -----------------------------
# MONTH HEADER + WEEK HEADER
# -----------------------------
header_y_month = len(df) + 0.9
header_y_week = len(df) + 0.35

current = start_date.replace(day=1)
while current <= end_date:
    month_start = current
    next_month = (month_start + pd.offsets.MonthBegin(1)).to_pydatetime()

    # visible span within chart
    visible_start = max(month_start, start_date)
    visible_end = min(next_month, end_date + timedelta(days=1))

    x0 = mdates.date2num(visible_start)
    x1 = mdates.date2num(visible_end)

    # month label centered
    ax.text(
        mdates.num2date((x0 + x1) / 2),
        header_y_month,
        month_start.strftime("%b '%y"),
        ha="center", va="center",
        fontsize=12, color="#3A3A3A"
    )

    # week labels
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
            ha="center", va="center",
            fontsize=10, color="#5C6B7A"
        )
        week_cursor += timedelta(days=7)
        week_num += 1

    current = next_month

# -----------------------------
# BOTTOM START/END DATE ARROW
# -----------------------------
line_y = -0.7
ax.annotate(
    "",
    xy=(mdates.date2num(end_date + timedelta(days=5)), line_y),
    xytext=(mdates.date2num(start_date), line_y),
    arrowprops=dict(arrowstyle="->", color="#4F81BD", lw=2)
)

ax.text(
    start_date, line_y - 0.35,
    f"Start Date: {start_date.strftime('%B %d, %Y')}",
    ha="left", va="top",
    fontsize=12, color="#2F3E4E", fontweight="bold"
)

ax.text(
    end_date + timedelta(days=5), line_y - 0.35,
    f"End Date: {end_date.strftime('%B %d, %Y')}",
    ha="right", va="top",
    fontsize=12, color="#2F3E4E", fontweight="bold"
)

# -----------------------------
# LEGEND
# -----------------------------
legend_items = [Rectangle((0, 0), 1, 1, color=c) for c in df["Color"]]
legend_labels = df["Task"].tolist()

ax.legend(
    legend_items, legend_labels,
    loc="upper center",
    bbox_to_anchor=(0.5, -0.16),
    ncol=4,
    frameon=False,
    fontsize=11,
    handlelength=1,
    handletextpad=0.6
)

plt.tight_layout(rect=[0.03, 0.08, 0.97, 0.9])
output_path = "gantt_chart.png"
plt.savefig(output_path, dpi=300, bbox_inches="tight")
print(f"Saved: {output_path}")
plt.show()