# Script tự động biên dịch toàn bộ tài liệu LaTeX sang PDF
$ErrorActionPreference = "Stop"

function Compile-Tex($folder, $filename) {
    Write-Host ">> Compiling $filename in $folder..." -ForegroundColor Cyan
    Push-Location -Path "$PSScriptRoot/$folder"
    try {
        xelatex -interaction=nonstopmode $filename | Out-Null
        if ($LASTEXITCODE -ne 0) { throw "Pass 1 failed for $filename" }
        xelatex -interaction=nonstopmode $filename | Out-Null
        if ($LASTEXITCODE -ne 0) { throw "Pass 2 failed for $filename" }
        Write-Host "   -> Successfully generated $folder/$($filename -replace '\.tex','.pdf')" -ForegroundColor Green
    }
    finally {
        Pop-Location
    }
}

Compile-Tex "report" "report.tex"
Compile-Tex "slides" "slides.tex"

Write-Host "`nAll PDFs successfully compiled and verified!" -ForegroundColor Green
