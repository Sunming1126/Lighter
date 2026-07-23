import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const [],
  });
  final String title;
  final String? subtitle;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(22, 12, 14, 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.faint,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
        ),
        ...actions,
      ],
    ),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.action});
  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        ...(action == null ? const <Widget>[] : <Widget>[action!]),
      ],
    ),
  );
}

class LighterCard extends StatelessWidget {
  const LighterCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.color,
    this.onTap,
  });
  final Widget child;
  final EdgeInsets padding;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Card(
    color: color,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(padding: padding, child: child),
    ),
  );
}

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.danger = false,
    this.onTap,
  });
  final IconData icon;
  final String label;
  final String? value;
  final bool danger;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 18,
              color: danger ? AppColors.danger : AppColors.foreground,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: danger ? AppColors.danger : AppColors.foreground,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (value != null)
            Text(
              value!,
              style: const TextStyle(fontSize: 13, color: AppColors.faint),
            ),
          const SizedBox(width: 5),
          const Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: AppColors.faint,
          ),
        ],
      ),
    ),
  );
}

Future<T?> showLighterSheet<T>(BuildContext context, Widget child) =>
    showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      barrierColor: AppColors.strong.withValues(alpha: .36),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (context) => SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            22,
            10,
            22,
            22 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.borderStrong,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 18),
              child,
            ],
          ),
        ),
      ),
    );

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.strong,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
        margin: const EdgeInsets.fromLTRB(70, 0, 70, 92),
        duration: const Duration(milliseconds: 1700),
      ),
    );
}
