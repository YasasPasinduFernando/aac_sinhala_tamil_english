# Read the assembled markdown file as UTF-8
$inputFile = 'C:\Users\HP\Desktop\aac_sinhala_tamil_english\Esoft\FC6P01ES_Interim_Report_FULL.md'
$outputFile = 'C:\Users\HP\Desktop\aac_sinhala_tamil_english\Esoft\FC6P01ES_Interim_Report_CLEAN.md'

$content = Get-Content -Path $inputFile -Encoding UTF8 -Raw

# ── Box-drawing characters (most common culprits in code blocks) ──────────
$content = $content -replace [char]0x251C, '+'    # ├  -> +
$content = $content -replace [char]0x2514, '+'    # └  -> +
$content = $content -replace [char]0x2502, '|'    # │  -> |
$content = $content -replace [char]0x2500, '-'    # ─  -> -
$content = $content -replace [char]0x2510, '+'    # ┐  -> +
$content = $content -replace [char]0x250C, '+'    # ┌  -> +
$content = $content -replace [char]0x2518, '+'    # ┘  -> +
$content = $content -replace [char]0x253C, '+'    # ┼  -> +
$content = $content -replace [char]0x252C, '+'    # ┬  -> +
$content = $content -replace [char]0x2524, '+'    # ┤  -> +
$content = $content -replace [char]0x2534, '+'    # ┴  -> +
$content = $content -replace [char]0x2550, '='    # ═  -> =
$content = $content -replace [char]0x2551, '|'    # ║  -> |

# ── Typography / punctuation ──────────────────────────────────────────────
$content = $content -replace [char]0x2014, '--'   # em dash  -> --
$content = $content -replace [char]0x2013, '-'    # en dash  -> -
$content = $content -replace [char]0x2018, "'"    # left single quote
$content = $content -replace [char]0x2019, "'"    # right single quote
$content = $content -replace [char]0x201C, '"'    # left double quote
$content = $content -replace [char]0x201D, '"'    # right double quote
$content = $content -replace [char]0x2026, '...'  # ellipsis
$content = $content -replace [char]0x00A0, ' '    # non-breaking space
$content = $content -replace [char]0x2022, '-'    # bullet
$content = $content -replace [char]0x00D7, 'x'    # multiplication sign

# ── Math / Greek letters ──────────────────────────────────────────────────
$content = $content -replace [char]0x00B1, '+/-'  # plus-minus
$content = $content -replace [char]0x03B1, 'alpha'
$content = $content -replace [char]0x03B2, 'beta'
$content = $content -replace [char]0x03BA, 'kappa'
$content = $content -replace [char]0x03C3, 'sigma'
$content = $content -replace [char]0x03C1, 'rho'
$content = $content -replace [char]0x2248, '~='
$content = $content -replace [char]0x2264, '<='
$content = $content -replace [char]0x2265, '>='

# ── Misc ──────────────────────────────────────────────────────────────────
$content = $content -replace [char]0x00A9, '(c)'
$content = $content -replace [char]0x00AE, '(R)'
$content = $content -replace [char]0x2122, '(TM)'
$content = $content -replace [char]0x00B0, ' degrees'

# Write as UTF-8 without BOM
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($outputFile, $content, $utf8NoBom)

Write-Host "Clean file written: $outputFile"
Write-Host "Lines: $((Get-Content $outputFile).Count)"
