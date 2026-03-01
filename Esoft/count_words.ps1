$content = Get-Content 'C:\Users\HP\Desktop\aac_sinhala_tamil_english\Esoft\FC6P01ES_Interim_Report_FULL.md'
$lineCount = $content.Count
$raw = $content -join ' '
$wordCount = ($raw -split '\s+' | Where-Object { $_ -ne '' }).Count
$fileSize = (Get-Item 'C:\Users\HP\Desktop\aac_sinhala_tamil_english\Esoft\FC6P01ES_Interim_Report_FULL.md').Length
Write-Host "Lines: $lineCount"
Write-Host "Words: $wordCount"
Write-Host "Bytes: $fileSize"
