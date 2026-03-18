$files = Get-ChildItem 'C:\Users\HP\Desktop\aac_sinhala_tamil_english\Esoft\*.md'
foreach ($f in $files) {
    $wc = (Get-Content $f.FullName | Measure-Object -Word).Words
    $lc = (Get-Content $f.FullName).Count
    Write-Host "$($f.Name): $wc words, $lc lines"
}
