$c = Get-Content "C:\Users\HP\Desktop\aac_sinhala_tamil_english\Esoft\FC6P01ES_Interim_Report_FINAL.md"
$w = ($c | Measure-Object -Word).Words
$l = $c.Count
Write-Host "Words: $w"
Write-Host "Lines: $l"
