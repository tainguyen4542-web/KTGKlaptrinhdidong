$path = "d:\doan\ktra\frontend\lib\data\toeic_test_05_data.dart"
$content = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)

# Replace broken backslashes
$content = $content.Replace("\\\'", "\'")
$content = $content.Replace("\$12", "\\$12")
$content = $content.Replace("\$3,000", "\\$3,000")
$content = $content.Replace("\$4,500", "\\$4,500")
$content = $content.Replace("\$1,800", "\\$1,800")
$content = $content.Replace("\$900", "\\$900")
$content = $content.Replace("\$7,200", "\\$7,200")
$content = $content.Replace("\$450", "\\$450")
$content = $content.Replace("\$5 ", "\\$5 ")
$content = $content.Replace("\$10 ", "\\$10 ")
$content = $content.Replace("\$6,300", "\\$6,300")
$content = $content.Replace("\$8,100", "\\$8,100")
$content = $content.Replace("\$300", "\\$300")
$content = $content.Replace("\$600", "\\$600")

# If there are any stray $ followed by number, escape them
$content = [System.Text.RegularExpressions.Regex]::Replace($content, '(?<!\\)\$([0-9])', '\$$1')

[System.IO.File]::WriteAllText($path, $content, [System.Text.Encoding]::UTF8)
Write-Output "Cleaned $path"
