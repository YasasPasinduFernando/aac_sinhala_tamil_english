#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Clean markdown file for Word conversion:
  1. Replace ALL non-ASCII characters with safe ASCII equivalents
  2. Remove --- horizontal rules (AI-style dividers)
  3. Clean up excessive blank lines
"""

import re

INPUT  = r'C:\Users\HP\Desktop\aac_sinhala_tamil_english\Esoft\FC6P01ES_Interim_Report_FULL.md'
OUTPUT = r'C:\Users\HP\Desktop\aac_sinhala_tamil_english\Esoft\FC6P01ES_Interim_Report_CLEAN.md'

with open(INPUT, encoding='utf-8', errors='replace') as f:
    text = f.read()

# ── Box-drawing / tree characters ────────────────────────────────────────
replacements = {
    '\u251c': '+',   # ├
    '\u2514': '+',   # └
    '\u2502': '|',   # │
    '\u2500': '-',   # ─
    '\u2510': '+',   # ┐
    '\u250c': '+',   # ┌
    '\u2518': '+',   # ┘
    '\u253c': '+',   # ┼
    '\u252c': '+',   # ┬
    '\u2524': '+',   # ┤
    '\u2534': '+',   # ┴
    '\u2550': '=',   # ═
    '\u2551': '|',   # ║

    # Dashes
    '\u2014': '-',   # em dash — (was --)
    '\u2013': '-',   # en dash –
    '\u2012': '-',   # figure dash
    '\u2015': '-',   # horizontal bar

    # Quotes
    '\u2018': "'",   # left single '
    '\u2019': "'",   # right single '
    '\u201c': '"',   # left double "
    '\u201d': '"',   # right double "
    '\u201a': ',',   # single low-9 quotation
    '\u201e': '"',   # double low-9 quotation

    # Ellipsis / other punct
    '\u2026': '...',  # ellipsis
    '\u00a0': ' ',    # non-breaking space
    '\u2022': '-',    # bullet
    '\u2023': '-',    # triangular bullet
    '\u25cf': '-',    # black circle

    # Math
    '\u00b1': '+/-',
    '\u00d7': 'x',
    '\u00f7': '/',
    '\u2248': '~=',
    '\u2264': '<=',
    '\u2265': '>=',
    '\u221e': 'infinity',
    '\u2260': '!=',
    '\u00b2': '^2',
    '\u00b3': '^3',

    # Greek
    '\u03b1': 'alpha',
    '\u03b2': 'beta',
    '\u03b3': 'gamma',
    '\u03ba': 'kappa',
    '\u03c3': 'sigma',
    '\u03c1': 'rho',
    '\u03bc': 'mu',
    '\u03c0': 'pi',

    # Misc
    '\u00a9': '(c)',
    '\u00ae': '(R)',
    '\u2122': '(TM)',
    '\u00b0': ' degrees',
    '\u2032': "'",   # prime
    '\u2033': '"',   # double prime
    '\u00bd': '1/2',
    '\u00bc': '1/4',
    '\u00be': '3/4',
}

for char, replacement in replacements.items():
    text = text.replace(char, replacement)

# ── Remove --- horizontal rule lines (look AI-generated) ────────────────
# Match lines that are only dashes (---, ----, etc.) possibly with whitespace
text = re.sub(r'^\s*-{3,}\s*$', '', text, flags=re.MULTILINE)

# ── Remove lines that are only underscores (___) ────────────────────────
text = re.sub(r'^\s*_{3,}\s*$', '', text, flags=re.MULTILINE)

# ── Remove lines that are only asterisks (***) ───────────────────────────
text = re.sub(r'^\s*\*{3,}\s*$', '', text, flags=re.MULTILINE)

# ── Collapse 3+ consecutive blank lines to 2 ────────────────────────────
text = re.sub(r'\n{4,}', '\n\n\n', text)

# ── Final pass: replace any remaining non-ASCII with ? ──────────────────
text = text.encode('ascii', errors='replace').decode('ascii')

with open(OUTPUT, 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

lines = text.count('\n')
words = len(text.split())
print(f"Done! Lines: {lines}  Words: {words}")
print(f"Output: {OUTPUT}")
