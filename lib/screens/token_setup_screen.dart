import 'package:flutter/material.dart';

import '../config/github_config.dart';
import '../core/theme/app_radii.dart';
import '../core/theme/app_spacing.dart';
import '../services/token_store.dart';
import '../shared/widgets/loading_button.dart';
import '../shared/widgets/responsive_content.dart';
import 'home_screen.dart';

/// Shown once, before the token exists on this device. Not a login screen -
/// there is no account, no server, no multi-user concept. It simply asks for
/// the personal access token the app needs to talk to GitHub directly.
class TokenSetupScreen extends StatefulWidget {
  /// True when reached from Home to replace an existing token, rather than
  /// the first-run flow.
  final bool isUpdate;

  const TokenSetupScreen({super.key, this.isUpdate = false});

  @override
  State<TokenSetupScreen> createState() => _TokenSetupScreenState();
}

class _TokenSetupScreenState extends State<TokenSetupScreen> {
  final _controller = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final token = _controller.text.trim();
    if (token.isEmpty) {
      setState(() => _error = 'Paste a token first.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    await TokenStore.instance.saveToken(token);
    if (!mounted) return;
    if (widget.isUpdate) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: widget.isUpdate ? AppBar(title: const Text('Update token')) : null,
      body: SafeArea(
        child: Center(
          child: ResponsiveContent(
            maxWidth: 480,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.xxl,
                AppSpacing.xl,
                AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!widget.isUpdate) ...[
                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadii.md),
                        ),
                        child: Image.asset(
                          'lib/assets/icon/taskbook_icon.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                  Text(
                    'Connect GitHub',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Paste a personal access token with Issues read/write '
                    'access to ${GithubConfig.owner}/${GithubConfig.repo}. '
                    "It's stored securely on this device only.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  TextField(
                    controller: _controller,
                    obscureText: true,
                    autocorrect: false,
                    onSubmitted: (_) => _saving ? null : _save(),
                    decoration: InputDecoration(
                      labelText: 'GitHub token',
                      errorText: _error,
                      prefixIcon: Icon(
                        Icons.vpn_key_outlined,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  LoadingButton(
                    onPressed: _save,
                    loading: _saving,
                    label: const Text('Save & continue'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
