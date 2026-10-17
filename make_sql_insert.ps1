[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$sqlFile = "d:\doan\ktra\Insert_Toeic_Test05_Data.sql"
$sb = New-Object System.Text.StringBuilder

[void]$sb.AppendLine("-- ========================================================")
[void]$sb.AppendLine("-- NẠP DỮ LIỆU ĐỀ THI READING TEST 05 TỪ FILE WORD")
[void]$sb.AppendLine("-- DATABASE: 2380600189Db")
[void]$sb.AppendLine("-- ========================================================")
[void]$sb.AppendLine("USE [2380600189Db];")
[void]$sb.AppendLine("GO")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("-- 1. Tạo bản ghi Đề thi Test 05")
[void]$sb.AppendLine("SET IDENTITY_INSERT dbo.Exams ON;")
[void]$sb.AppendLine("IF NOT EXISTS (SELECT 1 FROM dbo.Exams WHERE Id = 5)")
[void]$sb.AppendLine("BEGIN")
[void]$sb.AppendLine("    INSERT INTO dbo.Exams (Id, Title, Description, DurationMinutes, TotalQuestions, IsActive, CreatedAt)")
[void]$sb.AppendLine("    VALUES (5, N'TOEIC Reading Test 05 (ETS Official)', N'Đề thi TOEIC Reading chuẩn 100 câu bóc tách từ Reading v05.docx', 75, 100, 1, GETDATE());")
[void]$sb.AppendLine("END")
[void]$sb.AppendLine("SET IDENTITY_INSERT dbo.Exams OFF;")
[void]$sb.AppendLine("GO")
[void]$sb.AppendLine("")

# Read the generated dart file or data to insert passages and questions
# Let's inspect passages from clean dart generator
$passages = @(
    @{ id=1; title="Questions 131-134 refer to the following announcement."; part=6; order=1; content="We are pleased to announce that the installation of the new manufacturing equipment in our main plant has been completed. The new machines ------- work flow by allowing for flexibility in 131. production. With six mixing tanks of ------- sizes, we expect to be able to fill a wider range of 132. orders, from small to very large. This is an important way to ensure that Balm Manufacturing continues to be a leader in the fragrance industry. ------- 133. Jim Martel, who is organizing this effort, will contact each of you soon with details. 134." },
    @{ id=2; title="Questions 135-138 refer to the following Web page."; part=6; order=2; content="www.kateweicommunications.com\nMarketing your business can be confusing. Newspapers and magazines are useful venues for advertising. ------- 135., social media platforms have become even more critical marketing outlets. 136. Kate Wei Communications utilizes both traditional outlets and the latest communication platforms. In addition to exceptional print services, Kate Wei Communications has the expertise to help you ------- 137. your online presence. Why wait? Choose our award-winning firm to strengthen your company's image today! 138." },
    @{ id=3; title="Questions 139-142 refer to the following e-mail."; part=6; order=3; content="To: Emily Swanton <eswanton@swantonfarmfeed.com>\nFrom: Arnold Hansen <AHansen@poltonfairgrounds.org>\nSubject: Polton Farm Fair\nDate: June 2\n\nThis e-mail serves as a receipt for your registration and confirms your participation in the Seventeenth Annual Polton County Farm Fair from July 14 to July 16. As a returning exhibitor, Swanton Farm Feed will be offered ------- space at a discounted rate. 140. Please be aware of a new requirement when preparing your space. This year, all booths must be completely ready by 8 P.M. on July 13. Tables will be provided by the organizer, as in past years. ------- 141. Thank you once again for your participation in our -------. 142.\n\nArnold Hansen, Assistant Coordinator\nPolton County Farm Fair" },
    @{ id=4; title="Questions 143-146 refer to the following article."; part=6; order=4; content="Sparkle Pro Enterprises Opens American Factory\nWorldwide News\nMANCHESTER (10 April) — Sparkle Pro Enterprises, a leading Belgium-based producer of cleaning products, is expanding its territory. The company has just opened its first plant in the United States, in Indianapolis. For more than forty years, Sparkle Pro has been making and distributing household and industrial cleaners to a wide range of vendors, including retail outlets and hotel chains, throughout Europe. ------- 144. The Indianapolis facility will require the company to hire 300 additional employees by the end of this year in order for it to achieve full capacity. According to Egon Bretz, the new director of North American operations, Sparkle Pro is confident that it will be able to train a large number of personnel quickly. Mr. Bretz expects no significant ------- 146. in meeting these needs." },
    @{ id=5; title="Questions 147-148 refer to the following notice."; part=7; order=5; content="Queenstown Financial Services (QFS)\nNOTICE TO CLIENTS AND VISITORS\nThe main entrance is scheduled to be repaired next week. The entrance doors of the Queenstown Financial Services building will be closed from Monday, 15 January, to Wednesday, 17 January. All employees and customers are advised to use the side entrance located on Crestview Boulevard.\nTo get to the receptionist on the first floor or to access the elevator, both of which can be found in the main lobby, please follow the posted signs through the west corridor.\nWe apologize for any inconvenience." }
)

[void]$sb.AppendLine("-- 2. Nạp các đoạn văn đọc hiểu (Passages)")
[void]$sb.AppendLine("SET IDENTITY_INSERT dbo.Passages ON;")
foreach ($p in $passages) {
    $tEsc = $p.title.Replace("'", "''")
    $cEsc = $p.content.Replace("'", "''")
    $id = $p.id
    $part = $p.part
    $ord = $p.order
    [void]$sb.AppendLine("IF NOT EXISTS (SELECT 1 FROM dbo.Passages WHERE Id = $id)")
    [void]$sb.AppendLine("BEGIN")
    [void]$sb.AppendLine("    INSERT INTO dbo.Passages (Id, ExamId, PartNumber, Title, Content, OrderIndex)")
    [void]$sb.AppendLine("    VALUES ($id, 5, $part, N'$tEsc', N'$cEsc', $ord);")
    [void]$sb.AppendLine("END")
}
[void]$sb.AppendLine("SET IDENTITY_INSERT dbo.Passages OFF;")
[void]$sb.AppendLine("GO")
[void]$sb.AppendLine("")

[System.IO.File]::WriteAllText($sqlFile, $sb.ToString(), [System.Text.Encoding]::UTF8)
Write-Output "Generated $sqlFile"
