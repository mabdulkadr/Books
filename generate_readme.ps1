$readmeHeader = @"
# Technical Digital Library
Automated Repository Catalog.

---
"@

$footer = @"
---
Last updated: $(Get-Date -Format "yyyy-MM-dd HH:mm")
"@

function Get-FileIcon {
    param($extension)
    switch ($extension) {
        ".pdf"  { return "https://cdn-icons-png.flaticon.com/512/337/337946.png" }
        ".docx" { return "https://cdn-icons-png.flaticon.com/512/337/337948.png" }
        ".doc"  { return "https://cdn-icons-png.flaticon.com/512/337/337948.png" }
        ".xlsx" { return "https://cdn-icons-png.flaticon.com/512/337/337958.png" }
        ".xls"  { return "https://cdn-icons-png.flaticon.com/512/337/337958.png" }
        Default { return "https://cdn-icons-png.flaticon.com/512/2991/2991108.png" }
    }
}

$content = "## Resource Gallery`n`n<table><tr>"
$counter = 0
$files = Get-ChildItem -Recurse -File | Where-Object { $_.Extension -in ".pdf", ".docx", ".doc", ".xlsx", ".xls" }

foreach ($file in $files) {
    if ($counter -eq 3) {
        $content += "</tr><tr>"
        $counter = 0
    }
    
    $relativePath = ($file.FullName.Replace((Get-Location).Path, "")).Replace("\", "/")
    $icon = Get-FileIcon $file.Extension
    
    $content += @"
    <td align="center" width="200">
      <a href=".$relativePath">
        <img src="$icon" width="100" /><br />
        <sub><b>$($file.Name)</b></sub>
      </a>
    </td>
"@
    $counter++
}

$content += "</tr></table>"

$finalReadme = $readmeHeader + $content + $footer
$finalReadme | Out-File -FilePath "README.md" -Encoding utf8