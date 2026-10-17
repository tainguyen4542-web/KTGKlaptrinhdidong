# TOEIC Reading Examination System (Hệ Thống Thi & Quản Lý Đề Thi TOEIC)

Dự án phát triển hệ thống thi thử và quản lý đề thi TOEIC Reading (100 câu: Part 5, Part 6, Part 7) bóc tách từ file Word chuẩn `Reading v05.docx`.

---

## 🏛️ Kiến Trúc Hệ Thống (Architecture)

1. **Giáo viên / Quản trị viên (Teacher/Admin - Web Portal):**
   * Thiết kế theo **Google Stitch** (`https://stitch.withgoogle.com/projects/1366692737283780152`).
   * Quản lý danh sách đề thi, 4 thẻ chỉ số thống kê (Total Exams, Active, Draft, Total Questions).
   * **Instant Access Control (Kích hoạt ca thi)**: Công tắc gạt thời gian thực (Switch Toggle) để Bật (`Active for Students`) hoặc Tắt (`Inactive/Draft`) ca thi cho sinh viên.
   * Chức năng Import đề thi từ file Word (.docx) và Chỉnh sửa nội dung câu hỏi.

2. **Sinh viên (Students - Mobile App):**
   * Ứng dụng di động (Android / iOS) với giao diện chuẩn Mobile-First.
   * Trên trình duyệt máy tính có tích hợp **Khung mô phỏng điện thoại thông minh (iPhone 15 Pro / Samsung Galaxy)** giúp trải nghiệm trực quan.
   * 4 Tab điều hướng dưới đáy (Bottom Navigation):
     * 📚 **Luyện đề**: Xem danh sách đề thi, lọc đề đang mở ca thi, làm bài thi 75 phút có bấm giờ.
     * 📊 **Kết quả**: Vòng tròn điểm số (395/495 PTS), phân loại trình độ (B2-C1), 4 chỉ số Đúng/Sai/Bỏ qua/Tốc độ và xem lại đáp án.
     * 💡 **Bí kíp**: Hướng dẫn phân bổ thời gian (Part 5: 12p, Part 6: 8p, Part 7: 55p) và chiến thuật giải đề.
     * 👤 **Tài khoản**: Thông tin sinh viên (MSSV: 2380600189), tình trạng đồng bộ máy chủ LMS.

3. **Cơ sở dữ liệu (SQL Server):**
   * [Toeic_Database_Schema.sql](Toeic_Database_Schema.sql): Định nghĩa 6 bảng quan hệ (`Exams`, `Passages`, `Questions`, `Choices`, `ExamResults`, `UserAnswers`).
   * [Insert_Toeic_Test05_Data.sql](Insert_Toeic_Test05_Data.sql): Kịch bản nạp dữ liệu trọn vẹn 100 câu hỏi và 19 bài đọc của Đề 05.

---

## 🚀 Hướng Dẫn Cài Đặt & Chạy Ứng Dụng

### Yêu cầu môi trường:
* Flutter SDK (3.x trở lên)
* Trình duyệt Google Chrome hoặc máy ảo Android/iOS
* SQL Server Management Studio (SSMS)

### Các bước chạy:
```bash
# 1. Di chuyển vào thư mục frontend
cd frontend

# 2. Cài đặt các thư viện phụ thuộc
flutter pub get

# 3. Chạy ứng dụng trên trình duyệt Chrome
flutter run -d chrome
```

---

## 📂 Cấu Trúc Thư Mục
* `frontend/`: Toàn bộ mã nguồn ứng dụng Flutter (Mobile App & Web Portal).
* `Toeic_Database_Schema.sql`: Script tạo bảng cơ sở dữ liệu SQL Server.
* `Insert_Toeic_Test05_Data.sql`: Script nạp 100 câu hỏi đề thi Test 05 vào DB.
* `figma_screenshots/`: Ảnh chụp màn hình chất lượng cao xuất từ Figma.
* `stitch_screen.html` & `stitch_screenshot.png`: Bản thiết kế Web Portal từ Google Stitch.
