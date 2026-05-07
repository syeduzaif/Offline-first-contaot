import 'package:flutter/material.dart';

import 'core/constants/app_constants.dart';
import 'core/themes/app_theme.dart';
import 'features/shell/main_shell.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.light(),
      debugShowCheckedModeBanner: false,
      home: const MainShell(),
    );
  }
}
