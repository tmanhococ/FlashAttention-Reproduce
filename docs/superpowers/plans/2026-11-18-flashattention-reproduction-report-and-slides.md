# Kế hoạch Thực hiện: Báo cáo Kỹ thuật & Slide Thuyết trình Tái lập FlashAttention-1

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Xây dựng báo cáo nghiên cứu kỹ thuật chuẩn học thuật (`report.tex` $\to$ `report.pdf`) và bộ slide trình chiếu Beamer 14 trang (`slides.tex` $\to$ `slides.pdf`) bằng LaTeX (Tiếng Việt, chèn biểu đồ thực nghiệm và bảng số liệu), sau đó biên dịch ra PDF hoàn chỉnh.

**Architecture:** Sử dụng trình biên dịch `xelatex` (MiKTeX trên Windows) với `fontspec` để hiển thị tiếng Việt Unicode tự nhiên; tách biệt mã nguồn thành hai module độc lập `docs/report/` và `docs/slides/`; chia sẻ biểu đồ thực nghiệm `figure3_reproduction.png` được tái hiện từ paper.

**Tech Stack:** LaTeX, Beamer, XeLaTeX (MiKTeX 24.1), TikZ, Graphicx, Booktabs, PowerShell.

## Global Constraints
- Báo cáo và Slide viết bằng Tiếng Việt học thuật, giữ nguyên các thuật ngữ chuyên ngành chuẩn quốc tế (SRAM, HBM, Tiling, Online Softmax, Recomputation, IO-Awareness, Memory-bound, OOM, FLOPs).
- Sử dụng engine `xelatex` để hỗ trợ font Unicode tiếng Việt không bị lỗi font hoặc thiếu ký tự.
- Chèn trực tiếp biểu đồ thực nghiệm `figure3_reproduction.png` và bảng số liệu đo đạc thực tế từ GPU RTX 3050 Ti.
- Không để lại bất kỳ placeholder nào (như TODO, TBD, v.v.).

---

### Task 1: Thiết lập Cấu trúc Thư mục và Chuẩn bị Tài nguyên Đồ họa

**Files:**
- Create: `docs/report/`
- Create: `docs/slides/`
- Copy: `agent_space/figure3_reproduction.png` $\to$ `docs/report/figure3_reproduction.png`
- Copy: `agent_space/figure3_reproduction.png` $\to$ `docs/slides/figure3_reproduction.png`

**Interfaces:**
- Produces: Thư mục `docs/report/` và `docs/slides/` sẵn sàng chứa mã nguồn TeX và tệp ảnh biểu đồ.

- [ ] **Step 1: Khởi tạo thư mục và sao chép tệp ảnh đồ thị**

```powershell
New-Item -ItemType Directory -Force -Path docs/report
New-Item -ItemType Directory -Force -Path docs/slides
Copy-Item -Path agent_space/figure3_reproduction.png -Destination docs/report/figure3_reproduction.png
Copy-Item -Path agent_space/figure3_reproduction.png -Destination docs/slides/figure3_reproduction.png
```

- [ ] **Step 2: Kiểm tra sự tồn tại của tệp ảnh**

```powershell
Test-Path docs/report/figure3_reproduction.png
Test-Path docs/slides/figure3_reproduction.png
```
Expected: `True` cho cả hai đường dẫn.

- [ ] **Step 3: Commit**

```bash
git add docs/report docs/slides
git commit -m "chore: setup directories and assets for report and slides"
```

---

### Task 2: Viết và Biên dịch Báo cáo Kỹ thuật (`docs/report/report.tex`)

**Files:**
- Create: `docs/report/report.tex`
- Output: `docs/report/report.pdf`

**Interfaces:**
- Consumes: `docs/report/figure3_reproduction.png`, kết quả benchmark từ `agent_space/benchmark_reproduce_fa1.py` và thuật toán từ `agent_space/reproduce_fa1_algo1.py`.
- Produces: `docs/report/report.pdf` hoàn chỉnh (6–8 trang).

- [ ] **Step 1: Viết tệp mã nguồn `docs/report/report.tex`**
Viết tài liệu LaTeX hoàn chỉnh gồm:
- Khai báo documentclass `article`, cấu hình margin `geometry`, font tiếng Việt với `fontspec` (Times New Roman / Arial), `amsmath`, `graphicx`, `booktabs`, `hyperref`.
- Tiêu đề: *Nghiên cứu & Tái lập Thuật toán FlashAttention: Tối ưu hóa Attention nhận biết phần cứng (IO-Awareness)*.
- Abstract: Tóm tắt bài báo và kết quả đo trên RTX 3050 Ti.
- Phần 1: Động lực nghiên cứu & Giới hạn của Standard Attention ($O(N^2)$ memory wall, phân cấp HBM vs SRAM).
- Phần 2: Cơ chế thuật toán FlashAttention-1 (Tiling, Online Softmax, Recomputation, Kernel Fusion, phân tích độ phức tạp IO).
- Phần 3: Thiết lập Thực nghiệm & Phương pháp Tái lập (WSL2, RTX 3050 Ti, PyTorch 2.10, kiểm chứng Algorithm 1).
- Phần 4: Kết quả Thực nghiệm & Phân tích chuyên sâu (Bảng số liệu 7 mốc sequence length, biểu đồ Figure 3, phân tích Speedup 82.75× và OOM ở $N=8192$).
- Phần 5: Thảo luận & Tiến trình nâng cấp (FA1 $\to$ FA2 $\to$ FA3 $\to$ FA4).
- Phần 6: Kết luận & Tài liệu tham khảo.

- [ ] **Step 2: Biên dịch tệp `report.tex` bằng `xelatex`**

```powershell
Set-Location -Path docs/report
xelatex -interaction=nonstopmode report.tex
xelatex -interaction=nonstopmode report.tex
Set-Location -Path ../..
```
Expected: Lệnh chạy thành công và sinh ra file `docs/report/report.pdf`.

- [ ] **Step 3: Kiểm tra tính hợp lệ của tệp `report.pdf`**

```powershell
Get-Item -Path docs/report/report.pdf | Select-Object Name, Length
```
Expected: File `report.pdf` tồn tại, dung lượng lớn hơn 100 KB.

- [ ] **Step 4: Commit**

```bash
git add docs/report/report.tex docs/report/report.pdf
git commit -m "feat: implement and compile FlashAttention research report"
```

---

### Task 3: Viết và Biên dịch Slide Thuyết trình Beamer (`docs/slides/slides.tex`)

**Files:**
- Create: `docs/slides/slides.tex`
- Output: `docs/slides/slides.pdf`

**Interfaces:**
- Consumes: `docs/slides/figure3_reproduction.png`, bảng dữ liệu benchmark, công thức Tiling/Online Softmax.
- Produces: `docs/slides/slides.pdf` hoàn chỉnh (14 slides, tỷ lệ 16:9).

- [ ] **Step 1: Viết tệp mã nguồn `docs/slides/slides.tex`**
Viết slide Beamer hoàn chỉnh:
- Documentclass `beamer` với `aspectratio=169`, theme `Madrid` hoặc `metropolis`, font tiếng Việt qua `fontspec`.
- Slide 1: Trang tiêu đề.
- Slide 2: Đặt vấn đề: Cuộc khủng hoảng Long Context & Băng thông bộ nhớ.
- Slide 3: Nút thắt Standard Attention & Phân cấp bộ nhớ GPU.
- Slide 4: Ý tưởng cốt lõi: IO-Awareness & Tiling.
- Slide 5: Trụ cột 1: Thuật toán Online Softmax.
- Slide 6: Trụ cột 2: Recomputation trong Backward Pass.
- Slide 7: Thiết lập Môi trường Thực nghiệm Tái lập (RTX 3050 Ti, WSL2).
- Slide 8: Kiểm chứng Thuật toán (Algorithm 1 Verification: sai số $< 10^{-6}$).
- Slide 9: Bảng Số liệu Benchmark Toàn diện ($N=128 \to 8192$).
- Slide 10: Phân tích Tốc độ Thực thi (Runtime log-scale & Speedup 82.75×).
- Slide 11: Phân tích Bộ nhớ Footprint ($O(N)$ vs $O(N^2)$ & OOM).
- Slide 12: Tiến hóa kiến trúc: FA1 $\to$ FA2 $\to$ FA3 $\to$ FA4.
- Slide 13: Kết luận & Đóng góp khoa học.
- Slide 14: Q&A & Tài liệu tham khảo.

- [ ] **Step 2: Biên dịch tệp `slides.tex` bằng `xelatex`**

```powershell
Set-Location -Path docs/slides
xelatex -interaction=nonstopmode slides.tex
xelatex -interaction=nonstopmode slides.tex
Set-Location -Path ../..
```
Expected: Lệnh chạy thành công và sinh ra file `docs/slides/slides.pdf`.

- [ ] **Step 3: Kiểm tra tính hợp lệ của tệp `slides.pdf`**

```powershell
Get-Item -Path docs/slides/slides.pdf | Select-Object Name, Length
```
Expected: File `slides.pdf` tồn tại, dung lượng lớn hơn 100 KB.

- [ ] **Step 4: Commit**

```bash
git add docs/slides/slides.tex docs/slides/slides.pdf
git commit -m "feat: implement and compile FlashAttention presentation slides"
```

---

### Task 4: Tạo Script Biên dịch Tự động & Đẩy lên GitHub

**Files:**
- Create: `docs/build.ps1`
- Modify: `.gitignore` (nếu cần dọn dẹp các tệp tạm của LaTeX: `.aux`, `.log`, `.nav`, `.out`, `.snm`, `.toc`)

**Interfaces:**
- Produces: Script một chạm biên dịch toàn bộ báo cáo và slide; repository GitHub được cập nhật đầy đủ sản phẩm.

- [ ] **Step 1: Viết script `docs/build.ps1`**

```powershell
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
```

- [ ] **Step 2: Cập nhật `.gitignore` để bỏ qua các tệp trung gian của LaTeX**
Thêm các đuôi tệp: `*.aux, *.log, *.nav, *.out, *.snm, *.toc, *.vrb, *.synctex.gz`.

- [ ] **Step 3: Chạy thử script `docs/build.ps1`**

```powershell
powershell -ExecutionPolicy Bypass -File docs/build.ps1
```
Expected: Hoàn thành không có lỗi biên dịch.

- [ ] **Step 4: Commit và Push lên GitHub**

```bash
git add docs/build.ps1 .gitignore
git commit -m "build: add automated LaTeX build script and update gitignore"
git push origin main
```
Expected: Đẩy thành công toàn bộ lên GitHub `https://github.com/tmanhococ/FlashAttention-Reproduce.git`.
