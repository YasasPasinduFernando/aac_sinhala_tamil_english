$f = 'C:\Users\HP\Desktop\aac_sinhala_tamil_english\Esoft\FC6P01ES_Interim_Report_FINAL.md'
$content = Get-Content $f
$wc = ($content | Measure-Object -Word).Words
$lc = $content.Count
Write-Host "Words: $wc"
Write-Host "Lines: $lc"
