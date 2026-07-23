import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets.dart';

class AuthSheet extends ConsumerStatefulWidget {
  const AuthSheet({super.key});

  @override
  ConsumerState<AuthSheet> createState() => _AuthSheetState();
}

class _AuthSheetState extends ConsumerState<AuthSheet> {
  bool register = false;
  bool busy = false;
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          register ? s.register : s.signIn,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF5DF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.science_outlined,
                size: 18,
                color: AppColors.warning,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  s.mockMode,
                  style: const TextStyle(
                    color: AppColors.warning,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (register) ...[
          TextField(
            controller: name,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: s.displayName),
          ),
          const SizedBox(height: 10),
        ],
        TextField(
          controller: email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          decoration: InputDecoration(labelText: s.email),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: password,
          obscureText: true,
          onSubmitted: (_) => _submit(),
          decoration: InputDecoration(labelText: s.password),
        ),
        const SizedBox(height: 18),
        FilledButton(
          onPressed: busy ? null : _submit,
          child: busy
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(register ? s.register : s.signIn),
        ),
        TextButton(
          onPressed: busy ? null : () => setState(() => register = !register),
          child: Text(register ? s.signIn : s.register),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    setState(() => busy = true);
    try {
      final service = ref.read(authServiceProvider);
      final session = register
          ? await service.register(
              email: email.text,
              displayName: name.text,
              password: password.text,
            )
          : await service.login(email: email.text, password: password.text);
      await ref.read(appControllerProvider).setAuthSession(session);
      if (mounted) Navigator.pop(context);
    } on FormatException catch (error) {
      if (mounted) showMessage(context, error.message);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }
}
