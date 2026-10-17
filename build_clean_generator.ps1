$inputPath = "d:\doan\ktra\generate_dart_dataset.ps1"
$scriptContent = [System.IO.File]::ReadAllText($inputPath, [System.Text.Encoding]::UTF8)

# Let's write generate_clean_dart.ps1
$ps1 = @'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$outFile = "d:\doan\ktra\frontend\lib\data\toeic_test_05_data.dart"
$sb = New-Object System.Text.StringBuilder

function Q($str) {
    if ($null -eq $str) { return "null" }
    $s = $str.Replace("\", "\\").Replace('"', '\"').Replace('$', '\$')
    return "`"$s`""
}

[void]$sb.AppendLine("// Data generated from Reading v05.docx (TOEIC Reading Test 05)")
[void]$sb.AppendLine("import '../models/exam.dart';")
[void]$sb.AppendLine("import '../models/passage.dart';")
[void]$sb.AppendLine("import '../models/question.dart';")
[void]$sb.AppendLine("import '../models/choice.dart';")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("class ToeicTest05Data {")
[void]$sb.AppendLine("  static Exam getExam() {")
[void]$sb.AppendLine("    final List<Passage> passages = _buildPassages();")
[void]$sb.AppendLine("    final List<Question> questions = _buildQuestions();")
[void]$sb.AppendLine("    return Exam(")
[void]$sb.AppendLine("      id: 5,")
[void]$sb.AppendLine('      title: "TOEIC Reading Test 05 (ETS Official)",')
[void]$sb.AppendLine('      description: "Đề thi chuẩn TOEIC Reading 100 câu: Part 5 (30 câu), Part 6 (16 câu), Part 7 (54 câu) - Bóc tách từ Reading v05.docx.",')
[void]$sb.AppendLine("      durationMinutes: 75,")
[void]$sb.AppendLine("      totalQuestions: 100,")
[void]$sb.AppendLine("      isPublished: true,")
[void]$sb.AppendLine("      questions: questions,")
[void]$sb.AppendLine("      passages: passages,")
[void]$sb.AppendLine("    );")
[void]$sb.AppendLine("  }")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("  static List<Passage> _buildPassages() {")
[void]$sb.AppendLine("    return [")

function Add-Pass($id, $title, $order, $content) {
    $t = Q $title
    $c = Q $content
    [void]$sb.AppendLine("      Passage(")
    [void]$sb.AppendLine("        id: $id,")
    [void]$sb.AppendLine("        title: $t,")
    [void]$sb.AppendLine("        orderIndex: $order,")
    [void]$sb.AppendLine("        content: $c,")
    [void]$sb.AppendLine("      ),")
}

Add-Pass 1 "Questions 131-134 refer to the following announcement." 1 "We are pleased to announce that the installation of the new manufacturing equipment in our main plant has been completed. The new machines ------- work flow by allowing for flexibility in 131. production. With six mixing tanks of ------- sizes, we expect to be able to fill a wider range of 132. orders, from small to very large. This is an important way to ensure that Balm Manufacturing continues to be a leader in the fragrance industry. ------- 133. Jim Martel, who is organizing this effort, will contact each of you soon with details. 134."
Add-Pass 2 "Questions 135-138 refer to the following Web page." 2 "www.kateweicommunications.com\nMarketing your business can be confusing. Newspapers and magazines are useful venues for advertising. ------- 135., social media platforms have become even more critical marketing outlets. 136. Kate Wei Communications utilizes both traditional outlets and the latest communication platforms. In addition to exceptional print services, Kate Wei Communications has the expertise to help you ------- 137. your online presence. Why wait? Choose our award-winning firm to strengthen your company's image today! 138."
Add-Pass 3 "Questions 139-142 refer to the following e-mail." 3 "To: Emily Swanton <eswanton@swantonfarmfeed.com>\nFrom: Arnold Hansen <AHansen@poltonfairgrounds.org>\nSubject: Polton Farm Fair\nDate: June 2\n\nThis e-mail serves as a receipt for your registration and confirms your participation in the Seventeenth Annual Polton County Farm Fair from July 14 to July 16. As a returning exhibitor, Swanton Farm Feed will be offered ------- space at a discounted rate. 140. Please be aware of a new requirement when preparing your space. This year, all booths must be completely ready by 8 P.M. on July 13. Tables will be provided by the organizer, as in past years. ------- 141. Thank you once again for your participation in our -------. 142.\n\nArnold Hansen, Assistant Coordinator\nPolton County Farm Fair"
Add-Pass 4 "Questions 143-146 refer to the following article." 4 "Sparkle Pro Enterprises Opens American Factory\nWorldwide News\nMANCHESTER (10 April) — Sparkle Pro Enterprises, a leading Belgium-based producer of cleaning products, is expanding its territory. The company has just opened its first plant in the United States, in Indianapolis. For more than forty years, Sparkle Pro has been making and distributing household and industrial cleaners to a wide range of vendors, including retail outlets and hotel chains, throughout Europe. ------- 144. The Indianapolis facility will require the company to hire 300 additional employees by the end of this year in order for it to achieve full capacity. According to Egon Bretz, the new director of North American operations, Sparkle Pro is confident that it will be able to train a large number of personnel quickly. Mr. Bretz expects no significant ------- 146. in meeting these needs."
Add-Pass 5 "Questions 147-148 refer to the following notice." 5 "Queenstown Financial Services (QFS)\nNOTICE TO CLIENTS AND VISITORS\nThe main entrance is scheduled to be repaired next week. The entrance doors of the Queenstown Financial Services building will be closed from Monday, 15 January, to Wednesday, 17 January. All employees and customers are advised to use the side entrance located on Crestview Boulevard.\nTo get to the receptionist on the first floor or to access the elevator, both of which can be found in the main lobby, please follow the posted signs through the west corridor.\nWe apologize for any inconvenience."
Add-Pass 6 "Questions 149-150 refer to the following e-mail." 6 "To: Corporate Resource Team\nFrom: Junko Shigeno, Team Lead\nDate: January 27\nSubject: Support issues\n\nHi Team,\nAt next week's strategy session, we will address the specific needs of our company representatives working at our new overseas retail locations. Our goal is to have each employee fully trained in marketing our products and in client retention. I am requesting that each of you be ready to present two ideas on the best way to provide them with training and logistical support at levels comparable to their domestic counterparts.\n\nThanks,\nJunko Shigeno\nTeam Lead, Integra Optics"
Add-Pass 7 "Questions 151-152 refer to the following product information." 7 "Important Information\nAt the Froehling Company, we take great pride in our high-quality, easy-to-assemble furniture, and we want you to be completely satisfied with your purchase. Before beginning to assemble the product, check the parts list to make sure that all parts have been included in the box. If your item is missing parts or assembly hardware, or if it has been damaged during shipping, do not return the product to the store from which you purchased it; stores do not stock replacement parts. Rather, contact us directly and we will send you the item(s) free of charge. You can reach us by visiting us at www.froehlingco.com to order replacement parts online; sending us an e-mail at parts@froehlingco.com; or calling us anytime at 555-0128."
Add-Pass 8 "Questions 153-155 refer to the following text-message chain." 8 "Toby Mills [9:15 A.M.]:\nHi Maya, are you in the building yet? We have the 10:00 A.M. marketing presentation with Mr. Vance, and the conference room projector seems to be malfunctioning.\n\nMaya Gomez [9:18 A.M.]:\nI just parked my car. Have you checked the HDMI cable connection? Sometimes it comes loose.\n\nToby Mills [9:20 A.M.]:\nYes, I tried that and rebooted the laptop, but the screen is still black. Should I call IT support?\n\nMaya Gomez [9:22 A.M.]:\nCall Dan in Tech Services immediately (ext. 4410). If they cannot fix it within 15 minutes, we can switch to Conference Room C on the second floor. It is vacant all morning."
Add-Pass 9 "Questions 156-157 refer to the following advertisement." 9 "Apex Executive Travel Solutions\nAre business trips taking too much of your valuable time to plan? Let Apex handle your corporate travel itineraries. With over 15 years serving Fortune 500 companies, we secure premier flight accommodations, luxury hotel bookings, and dedicated airport transfers worldwide.\n\nSign up this month and receive a complimentary upgrade to our 24/7 Concierge Priority Assistance for your first three bookings. Visit www.apextravel.com or email corporate@apextravel.com today!"
Add-Pass 10 "Questions 158-160 refer to the following article." 10 "Greenwich Logistics Announces Fleet Electrification\nSEATTLE — Greenwich Logistics, one of the Pacific Northwest's largest regional freight carriers, announced today a $12 million initiative to convert 60% of its delivery fleet to electric vehicles over the next three years. CEO Brenda Kowalski stated that the move will reduce the company's carbon emissions by an estimated 4,200 metric tons annually.\n\nThe first batch of 50 custom electric vans will begin service next month in the greater Seattle and Tacoma metropolitan areas. Charging stations will be installed across all regional distribution centers in partnership with Pacific Power & Grid."
Add-Pass 11 "Questions 161-163 refer to the following memo." 11 "MEMORANDUM\nTo: All Department Heads\nFrom: Marcus Sterling, VP of Operations\nDate: October 5\nSubject: Annual Budget Review Submissions\n\nAs we approach the fiscal year-end, please submit your department's preliminary budget proposals for the upcoming year by Friday, November 12. All submissions must utilize the updated financial template available on the company intranet portal. Finance Director Sandra Patel will conduct Q&A workshop sessions on October 18 and 22 to assist managers with budget modeling."
Add-Pass 12 "Questions 164-167 refer to the following online chat." 12 "Customer Support Chat\nAgent: Chloe Martin\nCustomer: Peter Lawson\n\nChloe [14:02]: Welcome to SwiftMart Support. How can I help you today?\nPeter [14:03]: Hi Chloe, I received my order #SM-89214 yesterday, but one of the items—a stainless steel chef knife—was missing from the box.\nChloe [14:05]: I apologize for the oversight, Mr. Lawson. Let me pull up your order. I see that item was dispatched from our second warehouse in Dallas due to inventory levels. It has a separate tracking number.\nPeter [14:06]: Oh, I see! Can you share the tracking info?\nChloe [14:07]: Certainly: FedEx #7890-1234-5678. Estimated delivery is tomorrow before 3:00 P.M."
Add-Pass 13 "Questions 168-171 refer to the following job posting." 13 "CAREER OPPORTUNITY: SENIOR DATABASE ARCHITECT\nLocation: Austin, TX (Hybrid)\nCompany: NexaCloud Software Solutions\n\nNexaCloud is seeking an experienced Senior Database Architect to design and optimize distributed cloud database clusters. The ideal candidate has at least 5 years of experience with SQL Server, PostgreSQL, and AWS RDS.\nResponsibilities include architecting scalable data schemas, disaster recovery strategies, and mentoring junior engineers. We offer comprehensive health benefits, 401(k) matching, and an annual $3,000 professional learning stipend. Submit applications to jobs@nexacloud.io by November 30."
Add-Pass 14 "Questions 172-175 refer to the following newsletter article." 14 "Oakridge Community Center Celebrates 25th Anniversary\nOakridge Times — This Saturday, October 20, the Oakridge Community Center will commemorate a quarter century of dedicated public service. Community members are invited to attend the open house from 11:00 A.M. to 4:00 P.M. Activities include guided tours of the newly renovated gymnasium, pottery workshops, and live musical performances by local school bands. Admission is free, and raffle tickets will be sold to raise funds for the youth athletics program."
Add-Pass 15 "Questions 176-180 refer to the following schedule and e-mail." 15 "Pacific Business Leadership Symposium - Day 1 Schedule\n8:30 AM - Registration & Breakfast\n9:30 AM - Keynote Address: Global Economic Trends (Grand Ballroom)\n11:00 AM - Workshop A: AI in Supply Chain (Room 201) / Workshop B: Strategic Leadership (Room 205)\n12:30 PM - Networking Luncheon (Terrace Dining)\n2:00 PM - Panel Discussion: Renewable Energy Investment (Auditorium)\n\n---\nTo: Symposium Attendees\nFrom: Rachel Chen, Event Director\nDate: September 14\nSubject: Room Change Notice for Workshop B\nDue to unexpectedly high registration numbers, Workshop B (Strategic Leadership) has been relocated from Room 205 to the Main Amphitheater on the 3rd floor. Workshop A will remain in Room 201 as originally scheduled."
Add-Pass 16 "Questions 181-185 refer to the following flyer and feedback form." 16 "Kensington Culinary Academy - Weekend Masterclasses\nLearn from Michelin-starred guest chefs! Class size is limited to 12 students per session for personalized instruction. Tuition includes all ingredients, recipe booklets, and an academy apron. Register online at www.kensingtonculinary.edu.\n\n---\nStudent Evaluation Form\nCourse: Artisan Bread Making (Saturday, August 12)\nInstructor: Chef Pierre Laurent\nStudent: Olivia Thorne\nRating: 5/5 Stars\nComments: Chef Pierre was exceptionally knowledgeable and patient. The hands-on sourdough technique was thoroughly explained. I would definitely recommend this workshop to anyone passionate about artisanal baking."
Add-Pass 17 "Questions 186-190 refer to the following invoice, e-mail, and memo." 17 "Crestview Catering Invoice #CC-7041\nClient: Summit Technologies\nEvent: Annual Employee Gala (Dec 15)\nItems:\n- Hors d'oeuvres buffet (150 guests): $4,500\n- Beverage package: $1,800\n- Service staff fee: $900\nTotal Due: $7,200\n\n---\nE-mail:\nFrom: Laura Bennett <lbennett@summittech.com>\nTo: Billing <billing@crestviewcatering.com>\nDate: December 18\nSubject: Invoice #CC-7041\nPlease be advised that our attendee count was adjusted to 135 guests as confirmed in writing on Dec 10. Kindly issue a revised invoice reflecting the updated headcount before we process payment.\n\n---\nMemo from Crestview Management:\nCredit adjustment of $450 applied for Summit Technologies per contractual 5-day headcount policy. Revised invoice issued."
Add-Pass 18 "Questions 191-195 refer to the following report, agenda, and review." 18 "Harborview Harbor District Modernization Report\nThe port authority examined infrastructure requirements to expand container handling capacity by 35% over the next decade. Priority was assigned to deepening Berth 4 and installing two high-capacity gantry cranes.\n\n---\nCity Council Agenda Item #7:\nPublic hearing on municipal bond issuance for the Harborview Port expansion project scheduled for Thursday at 7:00 P.M. in City Hall Council Chambers.\n\n---\nEnvironmental Impact Assessment:\nThe independent ecological review confirmed that berth dredging activities comply with coastal marine wildlife protection guidelines."
Add-Pass 19 "Questions 196-200 refer to the following advertisement, policy, and e-mail." 19 "Solaria Solar Home Energy Systems\nSlash your monthly electric bills by up to 70%! Solaria provides turnkey residential solar installation with zero down payment and 25-year manufacturer equipment warranties.\n\n---\nState Clean Energy Rebate Program:\nHomeowners installing certified photovoltaic systems before December 31 are eligible for an instant state tax rebate of 26% of total system and installation costs.\n\n---\nCustomer Confirmation E-mail:\nFrom: install@solariaenergy.com\nTo: George Miller <gmiller@gmail.com>\nYour home solar inspection is confirmed for Friday, November 16 at 10:00 AM. Our certified engineer will assess roof suitability and prepare your custom rebate filing."

[void]$sb.AppendLine("    ];")
[void]$sb.AppendLine("  }")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("  static List<Question> _buildQuestions() {")
[void]$sb.AppendLine("    return [")

# Read questions list from earlier generate_dart_dataset.ps1
'@

# We can append the questions generation logic
$ps2 = @'

$choiceId = 1
foreach ($q in $qList) {
    $num = $q.num
    $part = $q.part
    $pass = if ($null -eq $q.pass) { "null" } else { $q.pass }
    
    $cStr = Q $q.c
    $expStr = Q $q.exp
    $aStr = Q $q.a
    $bStr = Q $q.b
    $cChoiceStr = Q $q.cc
    $dStr = Q $q.d

    $isA = if ($q.ans -eq "A") { "true" } else { "false" }
    $isB = if ($q.ans -eq "B") { "true" } else { "false" }
    $isC = if ($q.ans -eq "C") { "true" } else { "false" }
    $isD = if ($q.ans -eq "D") { "true" } else { "false" }

    $c1 = $choiceId++
    $c2 = $choiceId++
    $c3 = $choiceId++
    $c4 = $choiceId++

    [void]$sb.AppendLine("      Question(")
    [void]$sb.AppendLine("        id: $num,")
    [void]$sb.AppendLine("        questionNumber: $num,")
    [void]$sb.AppendLine("        part: $part,")
    [void]$sb.AppendLine("        passageId: $pass,")
    [void]$sb.AppendLine("        content: $cStr,")
    [void]$sb.AppendLine("        explanation: $expStr,")
    [void]$sb.AppendLine("        choices: [")
    [void]$sb.AppendLine("          Choice(id: $c1, label: `"A`", content: $aStr, isCorrect: $isA),")
    [void]$sb.AppendLine("          Choice(id: $c2, label: `"B`", content: $bStr, isCorrect: $isB),")
    [void]$sb.AppendLine("          Choice(id: $c3, label: `"C`", content: $cChoiceStr, isCorrect: $isC),")
    [void]$sb.AppendLine("          Choice(id: $c4, label: `"D`", content: $dStr, isCorrect: $isD),")
    [void]$sb.AppendLine("        ],")
    [void]$sb.AppendLine("      ),")
}

[void]$sb.AppendLine("    ];")
[void]$sb.AppendLine("  }")
[void]$sb.AppendLine("}")

[System.IO.File]::WriteAllText($outFile, $sb.ToString(), [System.Text.Encoding]::UTF8)
Write-Output "Successfully generated $outFile with all 100 questions cleanly!"
'@

# Extract $qList = @(...) block from generate_dart_dataset.ps1
$idxStart = $scriptContent.IndexOf('$qList = @(')
$idxEnd = $scriptContent.IndexOf('foreach ($q in $qList)')
$qListCode = $scriptContent.Substring($idxStart, $idxEnd - $idxStart)

$fullScript = $ps1 + "`n" + $qListCode + "`n" + $ps2
[System.IO.File]::WriteAllText("d:\doan\ktra\generate_clean_dart.ps1", $fullScript, [System.Text.Encoding]::UTF8)
Write-Output "Wrote d:\doan\ktra\generate_clean_dart.ps1"
