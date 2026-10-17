import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/exam_provider.dart';
import 'screens/exam_list_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ToeicExamApp());
}

class ToeicExamApp extends StatelessWidget {
  const ToeicExamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExamProvider()),
      ],
      child: MaterialApp(
        title: 'TOEIC Reading Exam App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const ExamListScreen(),
      ),
    );
  }
}
