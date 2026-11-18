# Script tự động biên dịch toàn bộ tài liệu LaTeX sang PDF
Write-Host "Building Report..." -ForegroundColor Cyan
Set-Location -Path "$PSScriptRoot/report"
xelatex -interaction=nonstopmode report.tex
xelatex -interaction=nonstopmode report.tex

Write-Host "Building Slides..." -ForegroundColor Cyan
Set-Location -Path "$PSScriptRoot/slides"
xelatex -interaction=nonstopmode slides.tex
xelatex -interaction=nonstopmode slides.tex

Set-Location -Path "$PSScriptRoot/.."
Write-Host "All PDFs successfully compiled!" -ForegroundColor Green
