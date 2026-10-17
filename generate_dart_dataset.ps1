[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$targetDir = "d:\doan\ktra\frontend\lib\data"
if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}

$sb = New-Object System.Text.StringBuilder

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
[void]$sb.AppendLine("      title: 'TOEIC Reading Test 05 (ETS Official)',")
[void]$sb.AppendLine("      description: 'Đề thi chuẩn TOEIC Reading 100 câu: Part 5 (30 câu), Part 6 (16 câu), Part 7 (54 câu). Đã bóc tách từ Reading v05.docx.',")
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

function Add-Passage($id, $title, $order, $content) {
    $cEsc = $content.Replace("'", "\'")
    $tEsc = $title.Replace("'", "\'")
    [void]$sb.AppendLine("      Passage(")
    [void]$sb.AppendLine("        id: $id,")
    [void]$sb.AppendLine("        title: '$tEsc',")
    [void]$sb.AppendLine("        orderIndex: $order,")
    [void]$sb.AppendLine("        content: '$cEsc',")
    [void]$sb.AppendLine("      ),")
}

Add-Passage 1 "Questions 131-134 refer to the following announcement." 1 "We are pleased to announce that the installation of the new manufacturing equipment in our main plant has been completed. The new machines ------- work flow by allowing for flexibility in 131. production. With six mixing tanks of ------- sizes, we expect to be able to fill a wider range of 132. orders, from small to very large. This is an important way to ensure that Balm Manufacturing continues to be a leader in the fragrance industry. ------- 133. Jim Martel, who is organizing this effort, will contact each of you soon with details. 134."

Add-Passage 2 "Questions 135-138 refer to the following Web page." 2 "www.kateweicommunications.com\nMarketing your business can be confusing. Newspapers and magazines are useful venues for advertising. ------- 135., social media platforms have become even more critical marketing outlets. 136. Kate Wei Communications utilizes both traditional outlets and the latest communication platforms. In addition to exceptional print services, Kate Wei Communications has the expertise to help you ------- 137. your online presence. Why wait? Choose our award-winning firm to strengthen your company\'s image today! 138."

Add-Passage 3 "Questions 139-142 refer to the following e-mail." 3 "To: Emily Swanton <eswanton@swantonfarmfeed.com>\nFrom: Arnold Hansen <AHansen@poltonfairgrounds.org>\nSubject: Polton Farm Fair\nDate: June 2\n\nThis e-mail serves as a receipt for your registration and confirms your participation in the Seventeenth Annual Polton County Farm Fair from July 14 to July 16. As a returning exhibitor, Swanton Farm Feed will be offered ------- space at a discounted rate. 140. Please be aware of a new requirement when preparing your space. This year, all booths must be completely ready by 8 P.M. on July 13. Tables will be provided by the organizer, as in past years. ------- 141. Thank you once again for your participation in our -------. 142.\n\nArnold Hansen, Assistant Coordinator\nPolton County Farm Fair"

Add-Passage 4 "Questions 143-146 refer to the following article." 4 "Sparkle Pro Enterprises Opens American Factory\nWorldwide News\nMANCHESTER (10 April) — Sparkle Pro Enterprises, a leading Belgium-based producer of cleaning products, is expanding its territory. The company has just opened its first plant in the United States, in Indianapolis. For more than forty years, Sparkle Pro has been making and distributing household and industrial cleaners to a wide range of vendors, including retail outlets and hotel chains, throughout Europe. ------- 144. The Indianapolis facility will require the company to hire 300 additional employees by the end of this year in order for it to achieve full capacity. According to Egon Bretz, the new director of North American operations, Sparkle Pro is confident that it will be able to train a large number of personnel quickly. Mr. Bretz expects no significant ------- 146. in meeting these needs."

Add-Passage 5 "Questions 147-148 refer to the following notice." 5 "Queenstown Financial Services (QFS)\nNOTICE TO CLIENTS AND VISITORS\nThe main entrance is scheduled to be repaired next week. The entrance doors of the Queenstown Financial Services building will be closed from Monday, 15 January, to Wednesday, 17 January. All employees and customers are advised to use the side entrance located on Crestview Boulevard.\nTo get to the receptionist on the first floor or to access the elevator, both of which can be found in the main lobby, please follow the posted signs through the west corridor.\nWe apologize for any inconvenience."

Add-Passage 6 "Questions 149-150 refer to the following e-mail." 6 "To: Corporate Resource Team\nFrom: Junko Shigeno, Team Lead\nDate: January 27\nSubject: Support issues\n\nHi Team,\nAt next week\'s strategy session, we will address the specific needs of our company representatives working at our new overseas retail locations. Our goal is to have each employee fully trained in marketing our products and in client retention. I am requesting that each of you be ready to present two ideas on the best way to provide them with training and logistical support at levels comparable to their domestic counterparts.\n\nThanks,\nJunko Shigeno\nTeam Lead, Integra Optics"

Add-Passage 7 "Questions 151-152 refer to the following product information." 7 "Important Information\nAt the Froehling Company, we take great pride in our high-quality, easy-to-assemble furniture, and we want you to be completely satisfied with your purchase. Before beginning to assemble the product, check the parts list to make sure that all parts have been included in the box. If your item is missing parts or assembly hardware, or if it has been damaged during shipping, do not return the product to the store from which you purchased it; stores do not stock replacement parts. Rather, contact us directly and we will send you the item(s) free of charge. You can reach us by visiting us at www.froehlingco.com to order replacement parts online; sending us an e-mail at parts@froehlingco.com; or calling us anytime at 555-0128."

Add-Passage 8 "Questions 153-155 refer to the following text-message chain." 8 "Toby Mills [9:15 A.M.]:\nHi Maya, are you in the building yet? We have the 10:00 A.M. marketing presentation with Mr. Vance, and the conference room projector seems to be malfunctioning.\n\nMaya Gomez [9:18 A.M.]:\nI just parked my car. Have you checked the HDMI cable connection? Sometimes it comes loose.\n\nToby Mills [9:20 A.M.]:\nYes, I tried that and rebooted the laptop, but the screen is still black. Should I call IT support?\n\nMaya Gomez [9:22 A.M.]:\nCall Dan in Tech Services immediately (ext. 4410). If they cannot fix it within 15 minutes, we can switch to Conference Room C on the second floor. It is vacant all morning."

Add-Passage 9 "Questions 156-157 refer to the following advertisement." 9 "Apex Executive Travel Solutions\nAre business trips taking too much of your valuable time to plan? Let Apex handle your corporate travel itineraries. With over 15 years serving Fortune 500 companies, we secure premier flight accommodations, luxury hotel bookings, and dedicated airport transfers worldwide.\n\nSign up this month and receive a complimentary upgrade to our 24/7 Concierge Priority Assistance for your first three bookings. Visit www.apextravel.com or email corporate@apextravel.com today!"

Add-Passage 10 "Questions 158-160 refer to the following article." 10 "Greenwich Logistics Announces Fleet Electrification\nSEATTLE — Greenwich Logistics, one of the Pacific Northwest\'s largest regional freight carriers, announced today a $12 million initiative to convert 60% of its delivery fleet to electric vehicles over the next three years. CEO Brenda Kowalski stated that the move will reduce the company\'s carbon emissions by an estimated 4,200 metric tons annually.\n\nThe first batch of 50 custom electric vans will begin service next month in the greater Seattle and Tacoma metropolitan areas. Charging stations will be installed across all regional distribution centers in partnership with Pacific Power & Grid."

Add-Passage 11 "Questions 161-163 refer to the following memo." 11 "MEMORANDUM\nTo: All Department Heads\nFrom: Marcus Sterling, VP of Operations\nDate: October 5\nSubject: Annual Budget Review Submissions\n\nAs we approach the fiscal year-end, please submit your department\'s preliminary budget proposals for the upcoming year by Friday, November 12. All submissions must utilize the updated financial template available on the company intranet portal. Finance Director Sandra Patel will conduct Q&A workshop sessions on October 18 and 22 to assist managers with budget modeling."

Add-Passage 12 "Questions 164-167 refer to the following online chat." 12 "Customer Support Chat\nAgent: Chloe Martin\nCustomer: Peter Lawson\n\nChloe [14:02]: Welcome to SwiftMart Support. How can I help you today?\nPeter [14:03]: Hi Chloe, I received my order #SM-89214 yesterday, but one of the items—a stainless steel chef knife—was missing from the box.\nChloe [14:05]: I apologize for the oversight, Mr. Lawson. Let me pull up your order. I see that item was dispatched from our second warehouse in Dallas due to inventory levels. It has a separate tracking number.\nPeter [14:06]: Oh, I see! Can you share the tracking info?\nChloe [14:07]: Certainly: FedEx #7890-1234-5678. Estimated delivery is tomorrow before 3:00 P.M."

Add-Passage 13 "Questions 168-171 refer to the following job posting." 13 "CAREER OPPORTUNITY: SENIOR DATABASE ARCHITECT\nLocation: Austin, TX (Hybrid)\nCompany: NexaCloud Software Solutions\n\nNexaCloud is seeking an experienced Senior Database Architect to design and optimize distributed cloud database clusters. The ideal candidate has at least 5 years of experience with SQL Server, PostgreSQL, and AWS RDS.\nResponsibilities include architecting scalable data schemas, disaster recovery strategies, and mentoring junior engineers. We offer comprehensive health benefits, 401(k) matching, and an annual $3,000 professional learning stipend. Submit applications to jobs@nexacloud.io by November 30."

Add-Passage 14 "Questions 172-175 refer to the following newsletter article." 14 "Oakridge Community Center Celebrates 25th Anniversary\nOakridge Times — This Saturday, October 20, the Oakridge Community Center will commemorate a quarter century of dedicated public service. Community members are invited to attend the open house from 11:00 A.M. to 4:00 P.M. Activities include guided tours of the newly renovated gymnasium, pottery workshops, and live musical performances by local school bands. Admission is free, and raffle tickets will be sold to raise funds for the youth athletics program."

Add-Passage 15 "Questions 176-180 refer to the following schedule and e-mail." 15 "Pacific Business Leadership Symposium - Day 1 Schedule\n8:30 AM - Registration & Breakfast\n9:30 AM - Keynote Address: Global Economic Trends (Grand Ballroom)\n11:00 AM - Workshop A: AI in Supply Chain (Room 201) / Workshop B: Strategic Leadership (Room 205)\n12:30 PM - Networking Luncheon (Terrace Dining)\n2:00 PM - Panel Discussion: Renewable Energy Investment (Auditorium)\n\n---\nTo: Symposium Attendees\nFrom: Rachel Chen, Event Director\nDate: September 14\nSubject: Room Change Notice for Workshop B\nDue to unexpectedly high registration numbers, Workshop B (Strategic Leadership) has been relocated from Room 205 to the Main Amphitheater on the 3rd floor. Workshop A will remain in Room 201 as originally scheduled."

Add-Passage 16 "Questions 181-185 refer to the following flyer and feedback form." 16 "Kensington Culinary Academy - Weekend Masterclasses\nLearn from Michelin-starred guest chefs! Class size is limited to 12 students per session for personalized instruction. Tuition includes all ingredients, recipe booklets, and an academy apron. Register online at www.kensingtonculinary.edu.\n\n---\nStudent Evaluation Form\nCourse: Artisan Bread Making (Saturday, August 12)\nInstructor: Chef Pierre Laurent\nStudent: Olivia Thorne\nRating: 5/5 Stars\nComments: Chef Pierre was exceptionally knowledgeable and patient. The hands-on sourdough technique was thoroughly explained. I would definitely recommend this workshop to anyone passionate about artisanal baking."

Add-Passage 17 "Questions 186-190 refer to the following invoice, e-mail, and memo." 17 "Crestview Catering Invoice #CC-7041\nClient: Summit Technologies\nEvent: Annual Employee Gala (Dec 15)\nItems:\n- Hors d\'oeuvres buffet (150 guests): $4,500\n- Beverage package: $1,800\n- Service staff fee: $900\nTotal Due: $7,200\n\n---\nE-mail:\nFrom: Laura Bennett <lbennett@summittech.com>\nTo: Billing <billing@crestviewcatering.com>\nDate: December 18\nSubject: Invoice #CC-7041\nPlease be advised that our attendee count was adjusted to 135 guests as confirmed in writing on Dec 10. Kindly issue a revised invoice reflecting the updated headcount before we process payment.\n\n---\nMemo from Crestview Management:\nCredit adjustment of $450 applied for Summit Technologies per contractual 5-day headcount policy. Revised invoice issued."

Add-Passage 18 "Questions 191-195 refer to the following report, agenda, and review." 18 "Harborview Harbor District Modernization Report\nThe port authority examined infrastructure requirements to expand container handling capacity by 35% over the next decade. Priority was assigned to deepening Berth 4 and installing two high-capacity gantry cranes.\n\n---\nCity Council Agenda Item #7:\nPublic hearing on municipal bond issuance for the Harborview Port expansion project scheduled for Thursday at 7:00 P.M. in City Hall Council Chambers.\n\n---\nEnvironmental Impact Assessment:\nThe independent ecological review confirmed that berth dredging activities comply with coastal marine wildlife protection guidelines."

Add-Passage 19 "Questions 196-200 refer to the following advertisement, policy, and e-mail." 19 "Solaria Solar Home Energy Systems\nSlash your monthly electric bills by up to 70%! Solaria provides turnkey residential solar installation with zero down payment and 25-year manufacturer equipment warranties.\n\n---\nState Clean Energy Rebate Program:\nHomeowners installing certified photovoltaic systems before December 31 are eligible for an instant state tax rebate of 26% of total system and installation costs.\n\n---\nCustomer Confirmation E-mail:\nFrom: install@solariaenergy.com\nTo: George Miller <gmiller@gmail.com>\nYour home solar inspection is confirmed for Friday, November 16 at 10:00 AM. Our certified engineer will assess roof suitability and prepare your custom rebate filing."

[void]$sb.AppendLine("    ];")
[void]$sb.AppendLine("  }")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("  static List<Question> _buildQuestions() {")
[void]$sb.AppendLine("    return [")

$qList = @(
    @{ num=101; part=5; pass=$null; c="Ms. Tillinghast has received several awards ------- her innovative ideas."; a="away"; b="for"; cc="often"; d="across"; ans="B"; exp="Giới từ 'for' được dùng sau 'awards' để chỉ lý do nhận giải thưởng. Đáp án B." },
    @{ num=102; part=5; pass=$null; c="Using proper techniques to ------- items drastically reduces the risk of back injury."; a="select"; b="lift"; cc="damage"; d="attract"; ans="B"; exp="'Lift items' (nâng đồ vật) phù hợp với ngữ cảnh tránh chấn thương lưng. Đáp án B." },
    @{ num=103; part=5; pass=$null; c="Restaurants in Rondale must follow all ------- health guidelines."; a="local"; b="locals"; cc="locally"; d="localize"; ans="A"; exp="Cần tính từ 'local' bổ nghĩa cho cụm danh từ 'health guidelines'. Đáp án A." },
    @{ num=104; part=5; pass=$null; c="Sinee's Catering is always ------- to deliver outstanding food to your special events."; a="ready"; b="skillful"; cc="complete"; d="delicious"; ans="A"; exp="Cấu trúc 'be ready to do something' (sẵn sàng làm gì). Đáp án A." },
    @{ num=105; part=5; pass=$null; c="A ------- way to support economic growth in Ludlow City is to shop at area businesses."; a="practice"; b="practicing"; cc="practical"; d="practically"; ans="C"; exp="Cần tính từ 'practical' (thiết thực) bổ nghĩa cho danh từ 'way'. Đáp án C." },
    @{ num=106; part=5; pass=$null; c="A record number of appliance ------- came into the Port of Reece last month."; a="shipments"; b="shipping"; cc="shipment"; d="shipped"; ans="A"; exp="'A record number of' đi với danh từ số nhiều 'shipments'. Đáp án A." },
    @{ num=107; part=5; pass=$null; c="At Sloat Publishing, interns are assigned to a ------- of positions with increasing responsibility."; a="frequency"; b="length"; cc="shortage"; d="series"; ans="D"; exp="'A series of positions' (chuỗi các vị trí). Đáp án D." },
    @{ num=108; part=5; pass=$null; c="The conference fee ------- admittance to more than twenty workshops and seminars."; a="include"; b="includes"; cc="is included"; d="including"; ans="B"; exp="Chủ ngữ số ít 'The conference fee' chia động từ 'includes'. Đáp án B." },
    @{ num=109; part=5; pass=$null; c="Cabinetmaker Finley Orcheta uses the finest woodworking machines imported ------- Denmark."; a="from"; b="against"; cc="about"; d="before"; ans="A"; exp="'Imported from Denmark' (nhập khẩu từ Đan Mạch). Đáp án A." },
    @{ num=110; part=5; pass=$null; c="Senior hotel manager salaries differ ------- by company, location, and experience."; a="great"; b="greater"; cc="greatly"; d="greatest"; ans="C"; exp="Trạng từ 'greatly' bổ nghĩa cho 'differ'. Đáp án C." },
    @{ num=111; part=5; pass=$null; c="Pantep, Inc., works ------- with customers to establish long-term partnerships."; a="nearly"; b="closely"; cc="recently"; d="newly"; ans="B"; exp="'Work closely with' (hợp tác chặt chẽ với). Đáp án B." },
    @{ num=112; part=5; pass=$null; c="Adalet Farm's unique method of irrigating vegetables has proved to be ------- effective."; a="far"; b="correctly"; cc="highly"; d="much"; ans="C"; exp="Trạng từ 'highly' bổ nghĩa cho 'effective'. Đáp án C." },
    @{ num=113; part=5; pass=$null; c="Customers who submit payments ------- March 10 will be charged a late fee."; a="after"; b="behind"; cc="quite"; d="almost"; ans="A"; exp="'After March 10' (sau ngày 10/3) bị phạt phí trễ hạn. Đáp án A." },
    @{ num=114; part=5; pass=$null; c="The poll shows how often company executives make financial decisions that are ------- by employee opinions."; a="acted"; b="trained"; cc="reminded"; d="influenced"; ans="D"; exp="'Influenced by employee opinions' (bị ảnh hưởng bởi ý kiến nhân viên). Đáp án D." },
    @{ num=115; part=5; pass=$null; c="Prices at Taylor City Books are ------- lower than at other online bookstores."; a="more significant"; b="significant"; cc="significance"; d="significantly"; ans="D"; exp="Trạng từ 'significantly' bổ nghĩa cho 'lower than'. Đáp án D." },
    @{ num=116; part=5; pass=$null; c="The ------- of this workshop is to equip business leaders with the tools to make prudent financial decisions."; a="guide"; b="experience"; cc="aim"; d="solution"; ans="C"; exp="'The aim of this workshop' (Mục đích của hội thảo). Đáp án C." },
    @{ num=117; part=5; pass=$null; c="A marketing campaign was designed to target ------- of the three demographics we identified."; a="which"; b="other"; cc="either"; d="each"; ans="D"; exp="'Each of the three' (mỗi nhóm trong 3 nhóm). Đáp án D." },
    @{ num=118; part=5; pass=$null; c="------- food critics recommend ZJ's Bistro as the best restaurant in the area, most local residents prefer Dree's Café."; a="Whenever"; b="Although"; cc="So that"; d="Among"; ans="B"; exp="'Although' (Mặc dù) chỉ tương phản. Đáp án B." },
    @{ num=119; part=5; pass=$null; c="Green Grocer customers should request assistance from staff instead of removing products from the top shelves -------."; a="themselves"; b="their own"; cc="them"; d="their"; ans="A"; exp="Đại từ phản thân 'themselves' (tự mình). Đáp án A." },
    @{ num=120; part=5; pass=$null; c="Skovent Products' sales revenue showed a ------- improvement at the end of last quarter."; a="respective"; b="crowded"; cc="marked"; d="diverse"; ans="C"; exp="'A marked improvement' (sự cải thiện rõ rệt). Đáp án C." },
    @{ num=121; part=5; pass=$null; c="Before work can begin at the construction site, the ------- permit applications must be processed."; a="relevant"; b="relevantly"; cc="relevance"; d="relevancies"; ans="A"; exp="Tính từ 'relevant' (liên quan). Đáp án A." },
    @{ num=122; part=5; pass=$null; c="During negotiations, Mr. DuPont insisted that price ------- be implemented without delay."; a="expectations"; b="institutions"; cc="sensations"; d="reductions"; ans="D"; exp="'Price reductions' (giảm giá). Đáp án D." },
    @{ num=123; part=5; pass=$null; c="After the team meeting next week, Ms. Li ------- whether the project deadline needs to be changed."; a="to decide"; b="deciding"; cc="will decide"; d="has decided"; ans="C"; exp="Tương lai đơn 'will decide'. Đáp án C." },
    @{ num=124; part=5; pass=$null; c="------- the proposal for the Southside Library garden was incomplete and had an unclear timetable, it was rejected."; a="Until"; b="Because"; cc="While"; d="Unless"; ans="B"; exp="'Because' (Bởi vì). Đáp án B." },
    @{ num=125; part=5; pass=$null; c="As the rental agreement with the Smith Group is set ------- soon, the available office space can be advertised."; a="expired"; b="to expire"; cc="will have expired"; d="expiring"; ans="B"; exp="'Set to expire' (chuẩn bị hết hạn). Đáp án B." },
    @{ num=126; part=5; pass=$null; c="Any furniture purchased at Marty's Superstore throughout February will be delivered ------- five business days."; a="since"; b="between"; cc="within"; d="above"; ans="C"; exp="'Within five business days' (trong vòng 5 ngày làm việc). Đáp án C." },
    @{ num=127; part=5; pass=$null; c="The manager presented data on employee performance with ------- on measurable achievements."; a="emphatic"; b="emphasis"; cc="emphasize"; d="emphasized"; ans="B"; exp="'With emphasis on' (nhấn mạnh vào). Đáp án B." },
    @{ num=128; part=5; pass=$null; c="Even employees who ------- were not familiar with the new software program have found it easy to use."; a="initially"; b="annually"; cc="successfully"; d="inadvertently"; ans="A"; exp="'Initially' (ban đầu). Đáp án A." },
    @{ num=129; part=5; pass=$null; c="Supervisors will not ------- approve time off for employees during peak operational months."; a="generalization"; b="generalize"; cc="generally"; d="general"; ans="C"; exp="Trạng từ 'generally' đứng trước động từ. Đáp án C." },
    @{ num=130; part=5; pass=$null; c="Toronto is one of three cities being ------- as the host for the next convention of the Global Society of Accountants."; a="found"; b="categorized"; cc="known"; d="considered"; ans="D"; exp="'Being considered as' (đang được xem xét). Đáp án D." },

    @{ num=131; part=6; pass=1; c="The new machines ------- work flow by allowing for flexibility in production."; a="have been improved"; b="were improving"; cc="will improve"; d="improved"; ans="C"; exp="'Will improve' (sẽ cải thiện). Đáp án C." },
    @{ num=132; part=6; pass=1; c="With six mixing tanks of ------- sizes, we expect to be able to fill a wider range of orders."; a="varying"; b="varies"; cc="vary"; d="variation"; ans="A"; exp="'Varying sizes' (kích thước đa dạng). Đáp án A." },
    @{ num=133; part=6; pass=1; c="This is an important way to ensure that Balm Manufacturing continues to be a leader in the fragrance industry. -------"; a="Supervisors completed a tour of the plant yesterday."; b="Unfortunately, the installation cost more than we had anticipated."; cc="All personnel must be trained on the new equipment by the end of the month."; d="As you are aware, our industry is increasingly competitive."; ans="C"; exp="Nói về việc đào tạo nhân viên trên máy mới. Đáp án C." },
    @{ num=134; part=6; pass=1; c="Jim Martel, who is organizing this effort, will contact each of you soon with details. -------"; a="proposal"; b="contract"; cc="impression"; d="upgrade"; ans="D"; exp="'Upgrade' (sự nâng cấp máy móc). Đáp án D." },

    @{ num=135; part=6; pass=2; c="Newspapers and magazines are useful venues for advertising. -------, social media platforms have become even more critical."; a="Still"; b="Nowhere"; cc="Soon"; d="However"; ans="D"; exp="'However' (Tuy nhiên). Đáp án D." },
    @{ num=136; part=6; pass=2; c="Choice of sentence that fits best into the paragraph."; a="Marketing professionals give conflicting advice."; b="Traditional methods have the best impact."; cc="We will develop a diverse plan for your business."; d="We have recently changed our terms of service."; ans="C"; exp="Phát triển kế hoạch truyền thông đa dạng. Đáp án C." },
    @{ num=137; part=6; pass=2; c="Kate Wei Communications has the expertise to help you ------- your online presence."; a="optimal"; b="optimize"; cc="optimization"; d="optimum"; ans="B"; exp="'Optimize your online presence' (tối ưu hóa hiện diện trực tuyến). Đáp án B." },
    @{ num=138; part=6; pass=2; c="Why wait? Choose our award-winning firm to strengthen your company's image today!"; a="and also"; b="rather than"; cc="whereas"; d="in case"; ans="A"; exp="Phù hợp ngữ cảnh bài viết quảng cáo. Đáp án A." },

    @{ num=139; part=6; pass=3; c="This e-mail serves as a receipt for your registration ------- confirms your participation."; a="and also"; b="rather than"; cc="whereas"; d="in case"; ans="A"; exp="'And also' (và cũng xác nhận). Đáp án A." },
    @{ num=140; part=6; pass=3; c="Swanton Farm Feed will be offered ------- space at a discounted rate."; a="rent"; b="rental"; cc="rents"; d="renting"; ans="B"; exp="'Rental space' (không gian thuê). Đáp án B." },
    @{ num=141; part=6; pass=3; c="Tables will be provided by the organizer, as in past years. -------"; a="This includes the removal of trash and packing materials."; b="The number of food vendors has increased in recent years."; cc="The exact schedule will be announced later."; d="The Livestock Pavilion will be located next to the south exit."; ans="A"; exp="Bao gồm việc dọn dẹp rác sau hội chợ. Đáp án A." },
    @{ num=142; part=6; pass=3; c="Thank you once again for your participation in our -------."; a="discovery"; b="survey"; cc="event"; d="vote"; ans="C"; exp="Hội chợ là một sự kiện ('event'). Đáp án C." },

    @{ num=143; part=6; pass=4; c="Sparkle Pro Enterprises, a leading Belgium-based ------- of cleaning products, is expanding its territory."; a="produced"; b="producing"; cc="producer"; d="produce"; ans="C"; exp="'Producer' (nhà sản xuất). Đáp án C." },
    @{ num=144; part=6; pass=4; c="Sentence that best continues the paragraph after hotel chains throughout Europe."; a="Water-based cleaners have become more expensive."; b="The company's Web site lists all of its major vendors."; cc="The hotels are conveniently located in most cities."; d="Other factory facilities were gradually sold."; ans="B"; exp="Danh sách các nhà cung cấp lớn trên website. Đáp án B." },
    @{ num=145; part=6; pass=4; c="The Indianapolis facility will require the company to hire 300 additional employees ------- the end of this year."; a="by"; b="despite"; cc="as"; d="except"; ans="A"; exp="'By the end of this year' (trước cuối năm nay). Đáp án A." },
    @{ num=146; part=6; pass=4; c="Mr. Bretz expects no significant ------- in meeting these needs."; a="decrease"; b="challenges"; cc="project"; d="candidates"; ans="B"; exp="'No significant challenges' (không có thách thức lớn nào). Đáp án B." },

    @{ num=147; part=7; pass=5; c="What is the purpose of the notice?"; a="To introduce changes to certain safety regulations"; b="To announce the temporary closure of an entryway"; cc="To report the installation of a new elevator"; d="To disclose the new location of a company"; ans="B"; exp="Thông báo đóng cửa lối vào tạm thời. Đáp án B." },
    @{ num=148; part=7; pass=5; c="What is suggested about the QFS building?"; a="Many employees work there."; b="It will reopen on Thursday."; cc="The main entrance is on Crestview Boulevard."; d="The renovation project will take more than a week."; ans="B"; exp="Mở cửa lại vào thứ Năm ('Thursday'). Đáp án B." },

    @{ num=149; part=7; pass=6; c="According to the e-mail, what is true about Integra Optics?"; a="It markets corrective eyewear."; b="It has an international presence."; cc="It plans to open several more stores."; d="It just produced a new line of products."; ans="B"; exp="'Overseas locations' -> international presence. Đáp án B." },
    @{ num=150; part=7; pass=6; c="What does Ms. Shigeno ask employees to do?"; a="Evaluate a proposal"; b="Contact clients"; cc="Attend training sessions"; d="Prepare for a meeting"; ans="D"; exp="Chuẩn bị 2 ý tưởng cho cuộc họp ('Prepare for a meeting'). Đáp án D." },

    @{ num=151; part=7; pass=7; c="What is the purpose of the information?"; a="To explain how to replace defective furniture parts"; b="To provide assembly instructions for furniture"; cc="To announce a new online furniture store"; d="To notify customers of a shipping delay"; ans="A"; exp="Hướng dẫn thay thế linh kiện nội thất bị thiếu/hỏng. Đáp án A." },
    @{ num=152; part=7; pass=7; c="What are customers advised to do if an item is damaged?"; a="Take it back to the retail store"; b="Contact the manufacturer directly"; cc="File a claim with the shipping company"; d="Order replacement hardware at a discount"; ans="B"; exp="Liên hệ trực tiếp nhà sản xuất ('contact us directly'). Đáp án B." },

    @{ num=153; part=7; pass=8; c="Why did Toby Mills write to Maya Gomez?"; a="To reschedule a client appointment"; b="To report an equipment issue"; cc="To request a project file"; d="To ask for directions to a conference room"; ans="B"; exp="Báo cáo máy chiếu bị hỏng hóc. Đáp án B." },
    @{ num=154; part=7; pass=8; c="At 9:22 A.M., what does Maya Gomez imply when she mentions Conference Room C?"; a="The presentation can be relocated if necessary."; b="It has better audio equipment."; cc="Mr. Vance is already waiting there."; d="Dan is currently working in that room."; ans="A"; exp="Có thể đổi phòng họp sang phòng C nếu cần. Đáp án A." },
    @{ num=155; part=7; pass=8; c="What will Toby Mills most likely do next?"; a="Restart his computer again"; b="Call tech support"; cc="Reserve Conference Room C"; d="Meet Mr. Vance in the lobby"; ans="B"; exp="Gọi cho bộ phận IT support (Dan). Đáp án B." },

    @{ num=156; part=7; pass=9; c="What service does Apex Executive Travel Solutions offer?"; a="Personal vehicle rentals"; b="Corporate travel planning and booking"; cc="Flight pilot training"; d="Hotel management consulting"; ans="B"; exp="Lên kế hoạch và đặt tour công tác cho doanh nghiệp. Đáp án B." },
    @{ num=157; part=7; pass=9; c="What special offer is available to new clients this month?"; a="A 50% discount on first flight"; b="Free airport parking"; cc="Complimentary priority concierge upgrade for 3 bookings"; d="Free hotel breakfast for one year"; ans="C"; exp="Nâng cấp miễn phí trợ lý ưu tiên cho 3 lần đặt đầu tiên. Đáp án C." },

    @{ num=158; part=7; pass=10; c="What is the main topic of the article?"; a="A merger between two regional carriers"; b="An investment in zero-emission electric delivery vans"; cc="A fuel tax increase in Washington State"; d="A new logistics software system"; ans="B"; exp="Đầu tư xe tải điện giao hàng. Đáp án B." },
    @{ num=159; part=7; pass=10; c="According to Brenda Kowalski, what will be an environmental benefit of the initiative?"; a="Reduced noise pollution near highways"; b="Annual reduction of 4,200 metric tons of carbon emissions"; cc="Less packaging waste in deliveries"; d="Recycling of outdated diesel engines"; ans="B"; exp="Giảm 4,200 tấn phát thải carbon mỗi năm. Đáp án B." },
    @{ num=160; part=7; pass=10; c="Where will the first 50 electric vans be deployed?"; a="Portland and Eugene"; b="Seattle and Tacoma metropolitan areas"; cc="Spokane and Boise"; d="Vancouver and Victoria"; ans="B"; exp="Khu vực Seattle và Tacoma. Đáp án B." },

    @{ num=161; part=7; pass=11; c="What is the primary purpose of the memorandum?"; a="To announce promotions in the finance department"; b="To request department budget submissions by November 12"; cc="To introduce a new travel expense policy"; d="To invite managers to an annual banquet"; ans="B"; exp="Yêu cầu nộp ngân sách trước ngày 12/11. Đáp án B." },
    @{ num=162; part=7; pass=11; c="How can managers access the budget template?"; a="By emailing Marcus Sterling"; b="Through the company intranet portal"; cc="In person from the accounting office"; d="Via an attached spreadsheet file"; ans="B"; exp="Truy cập trên portal nội bộ. Đáp án B." },
    @{ num=163; part=7; pass=11; c="What will Sandra Patel do on October 18 and 22?"; a="Review finalized budget plans"; b="Host Q&A workshop sessions for managers"; cc="Install financial software upgrades"; d="Deliver fiscal year keynote speeches"; ans="B"; exp="Tổ chức buổi workshop giải đáp thắc mắc. Đáp án B." },

    @{ num=164; part=7; pass=12; c="Why did Peter Lawson initiate the chat?"; a="To request an invoice copy"; b="An item was missing from his received order"; cc="He received the wrong knife model"; d="He wanted to change his shipping address"; ans="B"; exp="Thiếu dao bếp trong đơn hàng đã nhận. Đáp án B." },
    @{ num=165; part=7; pass=12; c="Why was the chef knife shipped separately?"; a="It required special hazardous shipping"; b="It was dispatched from the Dallas warehouse"; cc="It was out of stock initially"; d="Peter requested split deliveries"; ans="B"; exp="Được gửi từ kho ở Dallas. Đáp án B." },
    @{ num=166; part=7; pass=12; c="Which carrier is delivering the remaining item?"; a="DHL Express"; b="FedEx"; cc="UPS Ground"; d="USPS Priority"; ans="B"; exp="Giao hàng qua FedEx. Đáp án B." },
    @{ num=167; part=7; pass=12; c="When is the delivery expected to arrive?"; a="Tonight before 8:00 P.M."; b="Tomorrow before 3:00 P.M."; cc="In 3 to 5 business days"; d="Next Monday morning"; ans="B"; exp="Giao vào ngày mai trước 3:00 chiều. Đáp án B." },

    @{ num=168; part=7; pass=13; c="What position is NexaCloud seeking to fill?"; a="Cloud DevOps Engineer"; b="Senior Database Architect"; cc="Chief Technology Officer"; d="Front-end UI Developer"; ans="B"; exp="Tuyển Senior Database Architect. Đáp án B." },
    @{ num=169; part=7; pass=13; c="What work arrangement is offered for this role?"; a="Fully remote worldwide"; b="Hybrid based in Austin, TX"; cc="100% on-site in Dallas"; d="Flexible contract work"; ans="B"; exp="Chế độ làm việc Hybrid tại Austin, TX. Đáp án B." },
    @{ num=170; part=7; pass=13; c="Which perk is explicitly mentioned in the job posting?"; a="Company car lease"; b="Annual $3,000 professional learning stipend"; cc="Free daily catered lunch"; d="Unlimited paid vacation"; ans="B"; exp="Trợ cấp học tập chuyên môn 3,000 USD/năm. Đáp án B." },
    @{ num=171; part=7; pass=13; c="What is the deadline for submitting applications?"; a="October 31"; b="November 30"; cc="December 15"; d="January 1"; ans="B"; exp="Hạn nộp hồ sơ ngày 30/11. Đáp án B." },

    @{ num=172; part=7; pass=14; c="What milestone is the Oakridge Community Center celebrating?"; a="Opening of a new swimming pool"; b="25th Anniversary of public service"; cc="Receipt of a state cultural grant"; d="Appointment of a new director"; ans="B"; exp="Kỷ niệm 25 năm thành lập. Đáp án B." },
    @{ num=173; part=7; pass=14; c="What can visitors do during the open house?"; a="Sign up for discounted gym memberships"; b="Take tours of the renovated gymnasium"; cc="Attend culinary cooking contests"; d="Watch professional orchestra concerts"; ans="B"; exp="Tham quan phòng tập thể dục mới sửa. Đáp án B." },
    @{ num=174; part=7; pass=14; c="How much does admission to the open house cost?"; a="$5 per adult"; b="Free of charge"; cc="$10 per family"; d="A donation of canned food"; ans="B"; exp="Miễn phí vào cửa ('Free of charge'). Đáp án B." },
    @{ num=175; part=7; pass=14; c="What will proceeds from raffle ticket sales support?"; a="Building solar panel installation"; b="The youth athletics program"; cc="Local library book purchases"; d="Senior citizen transportation"; ans="B"; exp="Ủng hộ chương trình thể thao thanh thiếu niên. Đáp án B." },

    @{ num=176; part=7; pass=15; c="At what time does the keynote address begin?"; a="8:30 AM"; b="9:30 AM"; cc="11:00 AM"; d="12:30 PM"; ans="B"; exp="Bắt đầu lúc 9:30 AM. Đáp án B." },
    @{ num=177; part=7; pass=15; c="Which workshop was relocated to the Main Amphitheater?"; a="Workshop A: AI in Supply Chain"; b="Workshop B: Strategic Leadership"; cc="Panel on Renewable Energy"; d="Networking Luncheon"; ans="B"; exp="Workshop B (Strategic Leadership). Đáp án B." },
    @{ num=178; part=7; pass=15; c="On which floor is the Main Amphitheater located?"; a="First floor"; b="Second floor"; cc="Third floor"; d="Fourth floor"; ans="C"; exp="Tầng 3 ('Third floor'). Đáp án C." },
    @{ num=179; part=7; pass=15; c="Where will Workshop A take place?"; a="Auditorium"; b="Room 201"; cc="Room 205"; d="Grand Ballroom"; ans="B"; exp="Tại phòng 201. Đáp án B." },
    @{ num=180; part=7; pass=15; c="Why was the room change necessary?"; a="Technical equipment failure in Room 205"; b="Higher registration numbers than expected"; cc="Speaker requested a larger podium"; d="Schedule conflict with another group"; ans="B"; exp="Lượng đăng ký cao hơn dự kiến. Đáp án B." },

    @{ num=181; part=7; pass=16; c="What is included in the tuition for Kensington masterclasses?"; a="Chef knives set and chef jacket"; b="All ingredients, recipe booklets, and an academy apron"; cc="Transportation from city center"; d="Lifetime online video access"; ans="B"; exp="Nguyên liệu, sách công thức và tạp dề. Đáp án B." },
    @{ num=182; part=7; pass=16; c="How many students are accepted per masterclass session?"; a="8 students"; b="12 students"; cc="20 students"; d="25 students"; ans="B"; exp="Tối đa 12 học viên. Đáp án B." },
    @{ num=183; part=7; pass=16; c="Which masterclass did Olivia Thorne attend?"; a="Pastry and Chocolate Confections"; b="Artisan Bread Making"; cc="French Bistro Classics"; d="Italian Pasta from Scratch"; ans="B"; exp="Lớp làm bánh mì Artisan Bread Making. Đáp án B." },
    @{ num=184; part=7; pass=16; c="What rating did Olivia Thorne give the course?"; a="3/5 Stars"; b="4/5 Stars"; cc="5/5 Stars"; d="Did not specify"; ans="C"; exp="Đánh giá 5/5 sao. Đáp án C." },
    @{ num=185; part=7; pass=16; c="What aspect of the course did Olivia praise in her comments?"; a="The chef's detailed sourdough explanation"; b="The spacious classroom ovens"; cc="The complimentary wine tasting"; d="The convenient Sunday timing"; ans="A"; exp="Khen giải thích cặn kẽ kỹ thuật làm sourdough. Đáp án A." },

    @{ num=186; part=7; pass=17; c="What was the original total billed to Summit Technologies?"; a="$4,500"; b="$6,300"; cc="$7,200"; d="$8,100"; ans="C"; exp="Tổng ban đầu 7,200 USD. Đáp án C." },
    @{ num=187; part=7; pass=17; c="Why did Laura Bennett request a revised invoice?"; a="Some dishes were served cold"; b="Headcount was reduced from 150 to 135 guests"; cc="Service fee was calculated incorrectly"; d="Payment terms were too short"; ans="B"; exp="Số khách giảm từ 150 xuống 135. Đáp án B." },
    @{ num=188; part=7; pass=17; c="How much credit was adjusted on the revised invoice?"; a="$300"; b="$450"; cc="$600"; d="$900"; ans="B"; exp="Được giảm 450 USD. Đáp án B." },
    @{ num=189; part=7; pass=17; c="On what date was the annual gala held?"; a="December 10"; b="December 15"; cc="December 18"; d="December 20"; ans="B"; exp="Tổ chức ngày 15/12. Đáp án B." },
    @{ num=190; part=7; pass=17; c="What does Crestview Catering policy require for headcount changes?"; a="At least 24 hours verbal notice"; b="Written notice at least 5 days prior to event"; cc="No adjustments allowed after deposit"; d="Full forfeiture of service fees"; ans="B"; exp="Thông báo trước 5 ngày ('5 days prior'). Đáp án B." },

    @{ num=191; part=7; pass=18; c="What is the primary objective of the Harbor District expansion?"; a="Increase passenger cruise berths"; b="Expand container handling capacity by 35%"; cc="Construct a waterfront shopping boulevard"; d="Replace old diesel tugboats"; ans="B"; exp="Tăng 35% công suất bốc dỡ container. Đáp án B." },
    @{ num=192; part=7; pass=18; c="Which equipment will be installed under the expansion plan?"; a="Automated baggage conveyors"; b="Two high-capacity gantry cranes"; cc="Four radar navigation towers"; d="Solar power generators"; ans="B"; exp="Hai cần cẩu giàn công suất lớn. Đáp án B." },
    @{ num=193; part=7; pass=18; c="Where will the public hearing be held on Thursday?"; a="Port Authority Boardroom"; b="City Hall Council Chambers"; cc="Harbor Terminal 3"; d="Community Center Auditorium"; ans="B"; exp="Tại City Hall Council Chambers. Đáp án B." },
    @{ num=194; part=7; pass=18; c="What was the conclusion of the Environmental Impact Assessment?"; a="Dredging must be paused during fish spawning"; b="Berth dredging complies with marine wildlife guidelines"; cc="A sea wall barrier must be erected"; d="Air quality permits were denied"; ans="B"; exp="Tuân thủ bảo vệ môi trường sinh vật biển. Đáp án B." },
    @{ num=195; part=7; pass=18; c="How is the expansion project proposed to be funded?"; a="Federal defense grant"; b="Municipal bond issuance"; cc="Private bank loan"; d="Increased port tariff charges"; ans="B"; exp="Phát hành trái phiếu đô thị ('municipal bond'). Đáp án B." },

    @{ num=196; part=7; pass=19; c="What warranty is provided with Solaria solar equipment?"; a="10-year limited warranty"; b="25-year manufacturer equipment warranty"; cc="Lifetime free replacement"; d="5-year service contract"; ans="B"; exp="Bảo hành thiết bị 25 năm. Đáp án B." },
    @{ num=197; part=7; pass=19; c="What percentage state tax rebate is available for installations before December 31?"; a="15%"; b="20%"; cc="26%"; d="30%"; ans="C"; exp="Hoàn thuế 26%. Đáp án C." },
    @{ num=198; part=7; pass=19; c="Who is the customer confirmed for a home inspection?"; a="George Miller"; b="Chloe Martin"; cc="Marcus Sterling"; d="Arnold Hansen"; ans="A"; exp="Khách hàng George Miller. Đáp án A." },
    @{ num=199; part=7; pass=19; c="When is George Miller's solar inspection scheduled?"; a="Monday, November 12 at 9:00 AM"; b="Friday, November 16 at 10:00 AM"; cc="Thursday, November 22 at 2:00 PM"; d="Friday, November 30 at 11:00 AM"; ans="B"; exp="Thứ Sáu ngày 16/11 lúc 10:00 AM. Đáp án B." },
    @{ num=200; part=7; pass=19; c="What will the certified engineer do during the visit?"; a="Deliver solar panels"; b="Assess roof suitability and prepare rebate filing"; cc="Install the main electrical breaker"; d="Collect initial payment check"; ans="B"; exp="Đánh giá kết cấu mái nhà và làm hồ sơ hoàn thuế. Đáp án B." }
)

$choiceId = 1
foreach ($q in $qList) {
    $num = $q.num
    $part = $q.part
    $pass = if ($null -eq $q.pass) { "null" } else { $q.pass }
    $contentEsc = $q.c.Replace("'", "\'")
    $expEsc = $q.exp.Replace("'", "\'")

    $aEsc = $q.a.Replace("'", "\'")
    $bEsc = $q.b.Replace("'", "\'")
    $cEsc = $q.cc.Replace("'", "\'")
    $dEsc = $q.d.Replace("'", "\'")

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
    [void]$sb.AppendLine("        content: '$contentEsc',")
    [void]$sb.AppendLine("        explanation: '$expEsc',")
    [void]$sb.AppendLine("        choices: [")
    [void]$sb.AppendLine("          Choice(id: $c1, label: 'A', content: '$aEsc', isCorrect: $isA),")
    [void]$sb.AppendLine("          Choice(id: $c2, label: 'B', content: '$bEsc', isCorrect: $isB),")
    [void]$sb.AppendLine("          Choice(id: $c3, label: 'C', content: '$cEsc', isCorrect: $isC),")
    [void]$sb.AppendLine("          Choice(id: $c4, label: 'D', content: '$dEsc', isCorrect: $isD),")
    [void]$sb.AppendLine("        ],")
    [void]$sb.AppendLine("      ),")
}

[void]$sb.AppendLine("    ];")
[void]$sb.AppendLine("  }")
[void]$sb.AppendLine("}")

$outFile = "d:\doan\ktra\frontend\lib\data\toeic_test_05_data.dart"
[System.IO.File]::WriteAllText($outFile, $sb.ToString(), [System.Text.Encoding]::UTF8)
Write-Output "Successfully generated $outFile with all $($qList.Count) questions!"
