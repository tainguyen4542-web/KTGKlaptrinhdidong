-- ========================================================
-- HỆ THỐNG THI TRẮC NGHIỆM TOEIC READING
-- KỊCH BẢN TẠO CƠ SỞ DỮ LIỆU VÀ CÁC BẢNG TRONG SQL SERVER
-- ========================================================

-- 1. Sử dụng CSDL hiện tại của bài làm (2380600189Db)
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = '2380600189Db')
BEGIN
    CREATE DATABASE [2380600189Db];
END
GO

USE [2380600189Db];
GO

-- 2. Xóa các bảng cũ nếu đã tồn tại để tránh xung đột
IF OBJECT_ID('dbo.UserAnswers', 'U') IS NOT NULL DROP TABLE dbo.UserAnswers;
IF OBJECT_ID('dbo.ExamResults', 'U') IS NOT NULL DROP TABLE dbo.ExamResults;
IF OBJECT_ID('dbo.Choices', 'U') IS NOT NULL DROP TABLE dbo.Choices;
IF OBJECT_ID('dbo.Questions', 'U') IS NOT NULL DROP TABLE dbo.Questions;
IF OBJECT_ID('dbo.Passages', 'U') IS NOT NULL DROP TABLE dbo.Passages;
IF OBJECT_ID('dbo.Exams', 'U') IS NOT NULL DROP TABLE dbo.Exams;
GO

-- 3. Tạo bảng Bảng Exams (Quản lý Đề thi / Ca thi)
CREATE TABLE dbo.Exams (
    Id INT IDENTITY(1,1) NOT NULL,
    Title NVARCHAR(250) NOT NULL,                  -- Tên đề thi (VD: TOEIC Reading Test 05)
    Description NVARCHAR(MAX) NULL,                -- Mô tả đề thi
    DurationMinutes INT NOT NULL DEFAULT 75,       -- Thời gian thi (75 phút)
    TotalQuestions INT NOT NULL DEFAULT 100,       -- Tổng số câu hỏi (100 câu)
    IsActive BIT NOT NULL DEFAULT 1,               -- Trạng thái kích hoạt ca thi (1: Kích hoạt, 0: Đóng)
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(), -- Ngày tạo đề
    CONSTRAINT PK_Exams PRIMARY KEY CLUSTERED (Id)
);
GO

-- 4. Tạo bảng Passages (Đoạn văn đọc hiểu cho Part 6 và Part 7)
CREATE TABLE dbo.Passages (
    Id INT IDENTITY(1,1) NOT NULL,
    ExamId INT NOT NULL,                           -- Thuộc đề thi nào
    PartNumber INT NOT NULL,                       -- Part 6 hoặc Part 7
    Title NVARCHAR(250) NULL,                      -- Tiêu đề (VD: Questions 131-134 refer to the following email)
    Content NVARCHAR(MAX) NOT NULL,                -- Toàn bộ nội dung đoạn văn / bài đọc
    OrderIndex INT NOT NULL DEFAULT 1,             -- Thứ tự đoạn văn
    CONSTRAINT PK_Passages PRIMARY KEY CLUSTERED (Id),
    CONSTRAINT FK_Passages_Exams FOREIGN KEY (ExamId) REFERENCES dbo.Exams(Id) ON DELETE CASCADE
);
GO

-- 5. Tạo bảng Questions (Danh sách câu hỏi thi)
CREATE TABLE dbo.Questions (
    Id INT IDENTITY(1,1) NOT NULL,
    ExamId INT NOT NULL,                           -- Thuộc đề thi nào
    PassageId INT NULL,                            -- Thuộc đoạn văn nào (NULL với Part 5)
    QuestionNumber INT NOT NULL,                   -- Số thứ tự câu hỏi (101 -> 200)
    PartNumber INT NOT NULL,                       -- Thuộc Part 5, 6 hay 7
    Content NVARCHAR(MAX) NOT NULL,                -- Nội dung câu hỏi
    Explanation NVARCHAR(MAX) NULL,                -- Lời giải thích đáp án
    CONSTRAINT PK_Questions PRIMARY KEY CLUSTERED (Id),
    CONSTRAINT FK_Questions_Exams FOREIGN KEY (ExamId) REFERENCES dbo.Exams(Id),
    CONSTRAINT FK_Questions_Passages FOREIGN KEY (PassageId) REFERENCES dbo.Passages(Id) ON DELETE NO ACTION
);
GO

-- 6. Tạo bảng Choices (Các đáp án lựa chọn A, B, C, D)
CREATE TABLE dbo.Choices (
    Id INT IDENTITY(1,1) NOT NULL,
    QuestionId INT NOT NULL,                       -- Thuộc câu hỏi nào
    Label VARCHAR(5) NOT NULL,                     -- Nhãn đáp án: 'A', 'B', 'C', 'D'
    Content NVARCHAR(MAX) NOT NULL,                -- Nội dung của lựa chọn
    IsCorrect BIT NOT NULL DEFAULT 0,              -- 1: Đáp án đúng, 0: Đáp án sai
    CONSTRAINT PK_Choices PRIMARY KEY CLUSTERED (Id),
    CONSTRAINT FK_Choices_Questions FOREIGN KEY (QuestionId) REFERENCES dbo.Questions(Id) ON DELETE CASCADE
);
GO

-- 7. Tạo bảng ExamResults (Kết quả bài thi của thí sinh)
CREATE TABLE dbo.ExamResults (
    Id INT IDENTITY(1,1) NOT NULL,
    ExamId INT NOT NULL,                           -- Đề thi đã làm
    StudentId NVARCHAR(50) NULL,                   -- Mã số sinh viên (VD: 2380600189)
    StudentName NVARCHAR(150) NULL,                -- Họ và tên sinh viên
    Score INT NOT NULL DEFAULT 0,                  -- Điểm số TOEIC (Quy đổi trên thang 495)
    CorrectCount INT NOT NULL DEFAULT 0,           -- Số câu trả lời đúng
    TotalQuestions INT NOT NULL DEFAULT 100,       -- Tổng số câu của bài thi
    TimeSpentSeconds INT NOT NULL DEFAULT 0,       -- Thời gian thực tế đã làm bài (tính bằng giây)
    CompletedAt DATETIME NOT NULL DEFAULT GETDATE(),-- Thời điểm nộp bài
    CONSTRAINT PK_ExamResults PRIMARY KEY CLUSTERED (Id),
    CONSTRAINT FK_ExamResults_Exams FOREIGN KEY (ExamId) REFERENCES dbo.Exams(Id)
);
GO

-- 8. Tạo bảng UserAnswers (Chi tiết câu trả lời từng câu của thí sinh)
CREATE TABLE dbo.UserAnswers (
    Id INT IDENTITY(1,1) NOT NULL,
    ExamResultId INT NOT NULL,                     -- Thuộc bài thi nào
    QuestionId INT NOT NULL,                       -- Câu hỏi nào
    SelectedChoiceId INT NULL,                     -- Lựa chọn mà thí sinh đã chọn
    IsCorrect BIT NOT NULL DEFAULT 0,              -- Đúng hay sai
    CONSTRAINT PK_UserAnswers PRIMARY KEY CLUSTERED (Id),
    CONSTRAINT FK_UserAnswers_ExamResults FOREIGN KEY (ExamResultId) REFERENCES dbo.ExamResults(Id) ON DELETE CASCADE,
    CONSTRAINT FK_UserAnswers_Questions FOREIGN KEY (QuestionId) REFERENCES dbo.Questions(Id),
    CONSTRAINT FK_UserAnswers_Choices FOREIGN KEY (SelectedChoiceId) REFERENCES dbo.Choices(Id)
);
GO
