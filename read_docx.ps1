[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Add-Type -AssemblyName System.IO.Compression.FileSystem

function Read-DocxText($path, $outTxt) {
    Write-Output "Extracting $path to $outTxt..."
    $zip = [System.IO.Compression.ZipFile]::OpenRead($path)
    $entry = $zip.GetEntry("word/document.xml")
    if ($null -eq $entry) {
        Write-Output "No word/document.xml found"
        $zip.Dispose()
        return
    }
    $stream = $entry.Open()
    $reader = New-Object System.IO.StreamReader($stream, [System.Text.Encoding]::UTF8)
    $xmlContent = $reader.ReadToEnd()
    $reader.Close()
    $stream.Close()
    $zip.Dispose()

    [xml]$xml = $xmlContent
    $ns = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
    $ns.AddNamespace("w", "http://schemas.openxmlformats.org/wordprocessingml/2006/main")
    
    $sb = New-Object System.Text.StringBuilder
    $paras = $xml.SelectNodes("//w:p", $ns)
    foreach ($p in $paras) {
        $texts = $p.SelectNodes(".//w:t", $ns)
        $line = ($texts | ForEach-Object { $_.InnerText }) -join ""
        if (-not [string]::IsNullOrWhiteSpace($line)) {
            [void]$sb.AppendLine($line)
        }
    }
    [System.IO.File]::WriteAllText($outTxt, $sb.ToString(), [System.Text.Encoding]::UTF8)
    Write-Output "Done. Output lines: $($paras.Count)"
}

Read-DocxText "d:\doan\ktra\frontend\Reading v05.docx" "d:\doan\ktra\reading_v05_extracted.txt"
