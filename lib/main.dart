import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/token_setup_screen.dart';
import 'services/token_store.dart';

void main() {
  runApp(const TaskbookApp());
}

class TaskbookApp extends StatelessWidget {
  const TaskbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskbook',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(Brightness.light),
      darkTheme: AppTheme.build(Brightness.dark),
      home: const _StartupGate(),
    );
  }
}

/// Decides, once, whether a GitHub token already exists on this device.
/// No login screen for the app itself - only this one-time token check.
class _StartupGate extends StatelessWidget {
  const _StartupGate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: TokenStore.instance.readToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final hasToken = (snapshot.data ?? '').isNotEmpty;
        return hasToken ? const HomeScreen() : const TokenSetupScreen();
      },
    );
  }
}
