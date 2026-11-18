# Đặc tả Thiết kế: Báo cáo Kỹ thuật & Slide Thuyết trình Tái lập FlashAttention-1

- **Ngày tạo**: 2026-11-18
- **Tác giả**: Antigravity Assistant & Tien Manh
- **Chủ đề**: Nghiên cứu & Tái lập Thuật toán FlashAttention: Tối ưu hóa Attention nhận biết phần cứng (IO-Awareness)
- **Ngôn ngữ tài liệu**: Tiếng Việt (kèm thuật ngữ chuẩn quốc tế cho khoa học máy tính và AI)

---

## 1. Mục tiêu và Phạm vi (Scope & Objectives)

Dự án nhằm mục đích đóng gói toàn bộ cơ sở lý thuyết, phân tích kiến trúc phần cứng và kết quả thực nghiệm tái lập (reproduction) của thuật toán **FlashAttention-1** (NeurIPS 2022) thành 2 sản phẩm học thuật chất lượng cao:
1. **Báo cáo Kỹ thuật (`docs/report/report.tex`)**: Bài báo khoa học chuẩn 2 cột hoặc 1 cột học thuật dài 6–8 trang, đầy đủ công thức toán học, bảng số liệu, đồ thị thực nghiệm và phân tích chuyên sâu.
2. **Slide Thuyết trình (`docs/slides/slides.tex`)**: Bộ slide trình chiếu 14 trang viết bằng LaTeX Beamer, trực quan, có điểm nhấn về đồ họa, sơ đồ khối và biểu đồ kết quả đo đạc trên GPU thực tế.
3. **Biên dịch PDF tự động**: Sử dụng trình biên dịch `xelatex` / `pdflatex` có sẵn trên hệ thống để xuất bản file `report.pdf` và `slides.pdf`.

---

## 2. Đặc tả Báo cáo Kỹ thuật (`report.tex`)

### 2.1 Cấu hình & Định dạng
- **Engine**: `xelatex` (đảm bảo hiển thị hoàn hảo dấu tiếng Việt qua `fontspec` với font chuẩn Unicode như Arial/Times New Roman) hoặc `pdflatex` với `vntex`.
- **Gói hỗ trợ (Packages)**: `amsmath`, `amssymb`, `graphicx`, `booktabs`, `microtype`, `hyperref`, `algorithm`, `algorithmicx`, `algpseudocode`, `geometry`, `caption`, `subcaption`.
- **Hình ảnh & Dữ liệu nhúng**:
  - `figure3_reproduction.png`: Đồ thị 2 chiều (Runtime & Memory) tái hiện Figure 3 của paper.
  - Sơ đồ phân cấp bộ nhớ GPU (SRAM vs HBM) và luồng dữ liệu Tiling.
  - Bảng tổng hợp số liệu đo đạc 7 mốc sequence length ($N = 128 \to 8192$).

### 2.2 Cấu trúc Chi tiết các Chương mục
1. **Tiêu đề & Tóm tắt (Abstract)**:
   - Tóm tắt động lực, phương pháp tiling/online softmax, và kết quả thực nghiệm đạt tốc độ tăng tới **82.75×**, tiết kiệm VRAM **43.3×** trên GPU RTX 3050 Ti.
2. **1. Đặt vấn đề & Giới hạn của Standard Attention**:
   - Phân tích rào cản tính toán: Sự chênh lệch giữa tốc độ tính toán (FLOPs) và băng thông bộ nhớ (HBM).
   - Nút thắt $O(N^2)$ của ma trận attention trung gian $S, P$ dẫn đến tràn bộ nhớ (OOM) khi tăng sequence length.
3. **2. Cơ sở Lý thuyết & Kiến trúc FlashAttention-1**:
   - **Tiling & Online Softmax**: Chia khối $B_r \times B_c$ và cơ chế cập nhật running max $m$ và running sum $\ell$.
   - **Recomputation ở Backward Pass**: Tái tính toán attention block trực tiếp trong SRAM, loại bỏ việc lưu trữ ma trận $N \times N$.
   - **Kernel Fusion**: Gộp các bước tính vào 1 kernel duy nhất.
   - Phân tích độ phức tạp IO: Chứng minh số lượt truy cập HBM giảm từ $\Omega(Nd + N^2)$ xuống $O(N^2 d^2 M^{-1})$.
4. **3. Thiết lập Môi trường & Quy trình Tái lập (Methodology)**:
   - Phần cứng & phần mềm: NVIDIA RTX 3050 Ti Laptop GPU (4GB VRAM), WSL2 Ubuntu, PyTorch 2.10, FP16.
   - Kiểm chứng số học Algorithm 1 thuần PyTorch (`reproduce_fa1_algo1.py`).
   - Kịch bản đo đạc độ trễ và bộ nhớ cả 2 chiều Forward + Backward ($N = 128 \to 8192$).
5. **4. Kết quả Thực nghiệm & Phân tích Chuyên sâu**:
   - Bảng tổng hợp số liệu đo đạc (Latency, Memory, Speedup).
   - Biểu đồ thực nghiệm Figure 3 (Left: Runtime log-scale, Right: Memory footprint $O(N)$ vs $O(N^2)$).
   - Phân tích hiện tượng OOM tại $N = 8192$ của Standard Attention và tính khả thi của FlashAttention tại các chuỗi siêu dài.
6. **5. Thảo luận & Hướng phát triển (FA2, FA3, FA4)**:
   - So sánh với FlashAttention-2 (đảo vòng lặp để tối ưu song song hóa), FlashAttention-3 (WGMMA/TMA trên Hopper) và FA4 (CuTeDSL).
7. **6. Kết luận & Tài liệu tham khảo (References)**.

---

## 3. Đặc tả Slide Thuyết trình Beamer (`slides.tex`)

### 3.1 Cấu hình Giao diện
- **Theme**: `metropolis` hoặc `Madrid` với bảng màu chuyên nghiệp (Navy Blue `#1B365D`, Slate Gray `#5C768D`, Accent Orange `#D9534F`).
- **Tỷ lệ khung hình**: `aspectratio=169` (Màn hình rộng 16:9 hiện đại).

### 3.2 Nội dung Từng Slide (14 Slides)
1. **Slide 1**: Tiêu đề, Tác giả, Ngày, Chủ đề.
2. **Slide 2**: Đặt vấn đề: Sự bùng nổ của Long-Context LLM và cuộc khủng hoảng Memory Bandwidth.
3. **Slide 3**: Cơ chế Standard Attention: Rào cản $O(N^2)$ và Memory Hierarchy (SRAM vs HBM).
4. **Slide 4**: Ý tưởng cốt lõi: Thuật toán nhận biết phần cứng (IO-Awareness) và kỹ thuật Tiling.
5. **Slide 5**: Trụ cột 1: Thuật toán Online Softmax (Công thức toán học & Cập nhật $m_i, \ell_i$).
6. **Slide 6**: Trụ cột 2: Recomputation trong Backward Pass (Đổi phép tính FLOPs lấy băng thông bộ nhớ).
7. **Slide 7**: Thiết lập Môi trường Thực nghiệm Tái lập (RTX 3050 Ti, WSL2, PyTorch).
8. **Slide 8**: Kiểm chứng Thuật toán (Algorithm 1 Verification: Sai số số học $< 10^{-6}$).
9. **Slide 9**: Bảng Số liệu Benchmark Toàn diện ($N=128 \to 8192$, Latency, VRAM, Speedup).
10. **Slide 10**: Phân tích Tốc độ (Đồ thị Runtime log-scale, Crossover point, Speedup tới 82.7×).
11. **Slide 11**: Phân tích Bộ nhớ (Đồ thị Memory Footprint $O(N)$ vs $O(N^2)$, rào cản OOM).
12. **Slide 12**: Bức tranh tiến hóa: Từ FlashAttention-1 đến FlashAttention-2, 3 và 4.
13. **Slide 13**: Kết luận & Đóng góp khoa học.
14. **Slide 14**: Q&A & Tài liệu tham khảo.

---

## 4. Kế hoạch Tổ chức Tệp tin (Directory Structure)

```
docs/
├── report/
│   ├── report.tex                 # Mã nguồn báo cáo LaTeX
│   ├── figure3_reproduction.png   # Biểu đồ thực nghiệm
│   └── report.pdf                 # File PDF đầu ra
└── slides/
    ├── slides.tex                 # Mã nguồn slide Beamer LaTeX
    ├── figure3_reproduction.png   # Biểu đồ thực nghiệm
    └── slides.pdf                 # File PDF đầu ra
```

---

## 5. Quy trình Kiểm thử & Tự động Biên dịch
1. Khởi tạo thư mục và sao chép các tệp hình ảnh vào thư mục tương ứng.
2. Viết mã nguồn `report.tex` và `slides.tex` đầy đủ, không để lại placeholder TODO.
3. Chạy lệnh biên dịch `xelatex` (2 lượt để giải quyết tham chiếu cross-references và số trang).
4. Kiểm tra sự tồn tại và tính hợp lệ của `report.pdf` và `slides.pdf`.
5. Cam kết (commit) các file vào git repository.
