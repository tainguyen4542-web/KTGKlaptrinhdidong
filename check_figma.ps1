$token = if ($env:FIGMA_TOKEN) { $env:FIGMA_TOKEN } else { "YOUR_FIGMA_TOKEN" }
$headers = @{ 'X-Figma-Token' = $token }

try {
    $res = Invoke-RestMethod -Uri 'https://api.figma.com/v1/files/7feYv545gNCYQKsR0lvglQ' -Headers $headers
    Write-Output "Figma File Name: $($res.name)"
    Write-Output "Pages count: $($res.document.children.Count)"
    foreach ($page in $res.document.children) {
        Write-Output "Page: $($page.name)"
        foreach ($c in $page.children) {
            Write-Output "  - Node: $($c.name) | Type: $($c.type)"
        }
    }
} catch {
    Write-Output "Error calling Figma API: $_"
}
