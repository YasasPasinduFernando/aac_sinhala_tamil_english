#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
reassemble.py  v2
Reads all report part files, extracts every section block by heading number,
sorts them numerically, and writes a clean, properly ordered document.
IMPORTANT: Skips '#' lines inside fenced code blocks (``` ... ```)
"""

import re, os

ESOFT = r'C:\Users\HP\Desktop\aac_sinhala_tamil_english\Esoft'

SOURCE_FILES = [
    'FC6P01ES_Interim_Report_AAC_Autism.md',
    'part2_sections3to6.md',
    'part3_sections7to8.md',
    'part4_sections9to19.md',
    'part5_expansion.md',
    'part6_expansion2.md',
    'part7_expansion3.md',
    'part8_expansion4.md',
    'part9_expansion5.md',
    'part10_expansion6.md',
    'part11_expansion7.md',
]

REPLACEMENTS = {
    '\u251c':'+', '\u2514':'+', '\u2502':'|', '\u2500':'-',
    '\u2510':'+', '\u250c':'+', '\u2518':'+', '\u253c':'+',
    '\u252c':'+', '\u2524':'+', '\u2534':'+', '\u2550':'=', '\u2551':'|',
    '\u2014':'-', '\u2013':'-', '\u2012':'-', '\u2015':'-',
    '\u2018':"'", '\u2019':"'", '\u201c':'"', '\u201d':'"',
    '\u201a':',', '\u201e':'"', '\u2026':'...', '\u00a0':' ',
    '\u2022':'-', '\u2023':'-', '\u25cf':'-',
    '\u00b1':'+/-', '\u00d7':'x', '\u00f7':'/',
    '\u2248':'~=', '\u2264':'<=', '\u2265':'>=',
    '\u221e':'infinity', '\u2260':'!=', '\u00b2':'^2', '\u00b3':'^3',
    '\u03b1':'alpha','\u03b2':'beta','\u03b3':'gamma','\u03ba':'kappa',
    '\u03c3':'sigma','\u03c1':'rho','\u03bc':'mu','\u03c0':'pi',
    '\u00a9':'(c)','\u00ae':'(R)','\u2122':'(TM)','\u00b0':' degrees',
    '\u2032':"'",'\u2033':'"','\u00bd':'1/2','\u00bc':'1/4','\u00be':'3/4',
}

def clean_text(text):
    for ch, rep in REPLACEMENTS.items():
        text = text.replace(ch, rep)
    text = re.sub(r'^\s*[-]{3,}\s*$', '', text, flags=re.MULTILINE)
    text = re.sub(r'^\s*[_]{3,}\s*$', '', text, flags=re.MULTILINE)
    text = re.sub(r'^\s*[\*]{3,}\s*$', '', text, flags=re.MULTILINE)
    text = text.encode('ascii', errors='replace').decode('ascii')
    text = re.sub(r'\n{4,}', '\n\n\n', text)
    return text

def parse_sort_key(heading_text):
    """
    '2.9 Extended ...' -> (2, 9, 0, 0)
    '10'  -> (10, 0, 0, 0)
    'Cover Page' -> (-1, 0, 0, 0)
    """
    m = re.match(r'^(\d+(?:\.\d+)*)', heading_text.strip())
    if m:
        parts = [int(x) for x in m.group(1).split('.')]
        while len(parts) < 4:
            parts.append(0)
        return tuple(parts[:4])
    fm = ['cover', 'declaration', 'acknowledgement', 'abstract',
          'table of contents', 'list of figures', 'list of tables']
    tl = heading_text.lower()
    for i, kw in enumerate(fm):
        if kw in tl:
            return (-1, i, 0, 0)
    return (999, 0, 0, 0)

# --------------------------------------------------------------------------
# Read all files
# --------------------------------------------------------------------------
full_text = ''
for fname in SOURCE_FILES:
    path = os.path.join(ESOFT, fname)
    if not os.path.exists(path):
        print(f'WARNING: missing {fname}')
        continue
    with open(path, encoding='utf-8', errors='replace') as f:
        content = f.read()
    full_text += '\n\n' + content

full_text = clean_text(full_text)

# --------------------------------------------------------------------------
# Find heading positions, SKIP lines inside fenced code blocks
# --------------------------------------------------------------------------
lines = full_text.split('\n')
heading_positions = []  # list of (line_index, hashes, title)
in_code_block = False

for line_idx, line in enumerate(lines):
    stripped = line.strip()
    
    # Toggle code fence state (``` or ~~~, possibly with language tag)
    if stripped.startswith('```') or stripped.startswith('~~~'):
        in_code_block = not in_code_block
        continue
    
    # Only match headings OUTSIDE code blocks
    if not in_code_block:
        m = re.match(r'^(#{1,6})\s+(.+)', line)
        if m:
            heading_positions.append((line_idx, m.group(1), m.group(2).strip()))

print(f"Found {len(heading_positions)} headings (code-fence aware)")

# --------------------------------------------------------------------------
# Extract blocks (heading + body until next heading)
# --------------------------------------------------------------------------
blocks = []

for i, (line_idx, hashes, title) in enumerate(heading_positions):
    start_line = line_idx
    if i + 1 < len(heading_positions):
        end_line = heading_positions[i + 1][0]
    else:
        end_line = len(lines)
    
    body = '\n'.join(lines[start_line:end_line])
    key = parse_sort_key(title)
    lvl = len(hashes)
    blocks.append((key, lvl, title, body))

# --------------------------------------------------------------------------
# De-duplicate: same heading text -> keep longest version
# --------------------------------------------------------------------------
seen = {}
for idx, (key, lvl, title, body) in enumerate(blocks):
    dedup_key = title.lower().strip()
    if dedup_key not in seen:
        seen[dedup_key] = idx
    else:
        prev_idx = seen[dedup_key]
        if len(body) > len(blocks[prev_idx][3]):
            seen[dedup_key] = idx

unique_indices = sorted(set(seen.values()))
unique_blocks = [blocks[idx] for idx in unique_indices]

# --------------------------------------------------------------------------
# Sort by section number
# --------------------------------------------------------------------------
unique_blocks.sort(key=lambda x: x[0])

# --------------------------------------------------------------------------
# Assemble
# --------------------------------------------------------------------------
front  = [b for b in unique_blocks if b[0][0] == -1]
main   = [b for b in unique_blocks if 0 <= b[0][0] <= 900]
tail   = [b for b in unique_blocks if b[0][0] >= 900]
ordered = front + main + tail

# Preamble = text before first heading
preamble = ''
if heading_positions:
    first_heading_line = heading_positions[0][0]
    preamble = '\n'.join(lines[:first_heading_line]).strip()

output_lines = []
if preamble:
    output_lines.append(preamble)
    output_lines.append('')

for (key, lvl, title, body) in ordered:
    output_lines.append(body.rstrip())
    output_lines.append('')

final_text = '\n'.join(output_lines)
final_text = re.sub(r'\n{4,}', '\n\n\n', final_text)

out_path = os.path.join(ESOFT, 'FC6P01ES_Interim_Report_STRUCTURED.md')
with open(out_path, 'w', encoding='utf-8', newline='\n') as f:
    f.write(final_text)

words = len(final_text.split())
lns = final_text.count('\n')
print(f"Done! Sections: {len(ordered)}  Lines: {lns}  Words: {words}")
print(f"Output: {out_path}")
