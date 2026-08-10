import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/authentication/presentation/screens/login_screen.dart';

class ApprovalManagementApp extends StatelessWidget {
  const ApprovalManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Approval Management',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
