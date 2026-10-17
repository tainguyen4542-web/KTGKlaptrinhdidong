[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Add-Type -AssemblyName System.IO.Compression.FileSystem

$path = "d:\doan\ktra\frontend\Reading v05.docx"
$zip = [System.IO.Compression.ZipFile]::OpenRead($path)
$entry = $zip.GetEntry("word/document.xml")
$stream = $entry.Open()
$reader = New-Object System.IO.StreamReader($stream, [System.Text.Encoding]::UTF8)
$xmlContent = $reader.ReadToEnd()
$reader.Close()
$stream.Close()
$zip.Dispose()

[xml]$xml = $xmlContent
$ns = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
$ns.AddNamespace("w", "http://schemas.openxmlformats.org/wordprocessingml/2006/main")

$tables = $xml.SelectNodes("//w:tbl", $ns)
Write-Output "Total tables in document: $($tables.Count)"

# Let's see how many cells are in each table
$tblIndex = 0
foreach ($tbl in $tables) {
    $tblIndex++
    $rows = $tbl.SelectNodes(".//w:tr", $ns)
    $cells = $tbl.SelectNodes(".//w:tc", $ns)
    Write-Output "Table $tblIndex : Rows = $($rows.Count), Cells = $($cells.Count)"
}
