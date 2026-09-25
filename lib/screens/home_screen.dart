import 'package:flutter/material.dart';

import 'create_issue_screen.dart';
import 'issues_list_screen.dart';
import 'token_setup_screen.dart';

/// The entire home screen: a title and two buttons. No dashboard, no
/// statistics, no navigation drawer. The only extra affordance is a way to
/// replace the GitHub token if it's ever revoked or expires.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.vpn_key_outlined),
            tooltip: 'Update GitHub token',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const TokenSetupScreen(isUpdate: true),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'My Taskbook',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 48),
              SizedBox(
                height: 56,
                child: FilledButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Create New Issue'),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CreateIssueScreen(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 56,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.checklist),
                  label: const Text('View All Issues'),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const IssuesListScreen(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
