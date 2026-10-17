$token = if ($env:FIGMA_TOKEN) { $env:FIGMA_TOKEN } else { "YOUR_FIGMA_TOKEN" }
$headers = @{ 'X-Figma-Token' = $token }

$res = Invoke-RestMethod -Uri 'https://api.figma.com/v1/files/7feYv545gNCYQKsR0lvglQ' -Headers $headers

$frames = @()
foreach ($page in $res.document.children) {
    foreach ($c in $page.children) {
        if ($c.type -eq "FRAME") {
            $frames += [PSCustomObject]@{
                Id = $c.id
                Name = $c.name
            }
        }
    }
}

Write-Output "Found $($frames.Count) frames:"
$ids = ($frames | ForEach-Object { $_.Id }) -join ","
Write-Output "IDs: $ids"

$imgRes = Invoke-RestMethod -Uri "https://api.figma.com/v1/images/7feYv545gNCYQKsR0lvglQ?ids=$ids&format=png&scale=2" -Headers $headers

$imgDir = "d:\doan\ktra\figma_screenshots"
if (-not (Test-Path $imgDir)) { New-Item -ItemType Directory -Path $imgDir -Force | Out-Null }

foreach ($f in $frames) {
    $url = $imgRes.images.($f.Id)
    if ($url) {
        $safeName = $f.Name -replace '[\\/:*?"<>|·]', '_' -replace '\s+', '_'
        $filePath = Join-Path $imgDir "$safeName.png"
        Invoke-WebRequest -Uri $url -OutFile $filePath
        Write-Output "Saved: $filePath"
    }
}
