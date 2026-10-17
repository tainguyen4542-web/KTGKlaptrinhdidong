[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$lines = Get-Content "d:\doan\ktra\reading_v05_extracted.txt" -Encoding UTF8

Write-Output "Total lines: $($lines.Count)"
for ($i = 0; $i -lt 50; $i++) {
    Write-Output "[$i] $($lines[$i])"
}
