import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../data/database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets.dart';
import '../auth/auth_sheet.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final app = ref.watch(appControllerProvider);
    final plan = ref.watch(activePlanProvider).valueOrNull;
    final history =
        ref.watch(sessionHistoryProvider).valueOrNull ??
        const <FastingSession>[];
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          ScreenHeader(title: s.me),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 4, 22, 32),
              children: [
                _ProfileHeader(
                  app: app,
                  plan: plan,
                  fastCount: history
                      .where((e) => e.endedAtUtcMs != null)
                      .length,
                ),
                const SizedBox(height: 24),
                _sectionLabel(context, s.planAndPreferences),
                Card(
                  child: Column(
                    children: [
                      SettingsRow(
                        icon: CupertinoIcons.calendar,
                        label: s.currentPlan,
                        value:
                            '${(plan?.fastMinutes ?? 720) ~/ 60}:${(1440 - (plan?.fastMinutes ?? 720)) ~/ 60}',
                        onTap: () => _showPlan(context, ref, plan),
                      ),
                      const Divider(height: 1, indent: 62),
                      SettingsRow(
                        icon: CupertinoIcons.bell,
                        label: s.reminderSettings,
                        onTap: () => _showReminders(context, ref),
                      ),
                      const Divider(height: 1, indent: 62),
                      SettingsRow(
                        icon: CupertinoIcons.globe,
                        label: s.language,
                        value: _languageValue(context, app.language),
                        onTap: () => _showLanguage(context, ref),
                      ),
                      const Divider(height: 1, indent: 62),
                      SettingsRow(
                        icon: CupertinoIcons.compass,
                        label: s.units,
                        value: app.unitSystem == UnitSystem.metric
                            ? (Localizations.localeOf(context).languageCode ==
                                      'zh'
                                  ? '公制'
                                  : 'Metric')
                            : (Localizations.localeOf(context).languageCode ==
                                      'zh'
                                  ? '美制'
                                  : 'Imperial'),
                        onTap: () => _showUnits(context, ref),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                _sectionLabel(context, 'Lighter Plus'),
                LighterCard(
                  color: const Color(0xFFF1F2F8),
                  onTap: () =>
                      showMessage(context, 'Lighter Plus · ${s.comingSoon}'),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.sparkles,
                        color: AppColors.plus,
                        size: 24,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Localizations.localeOf(context).languageCode ==
                                      'zh'
                                  ? '解锁每周洞察与更多'
                                  : 'Unlock weekly insights and more',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              s.comingSoon,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        CupertinoIcons.chevron_right,
                        size: 18,
                        color: AppColors.faint,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                _sectionLabel(
                  context,
                  Localizations.localeOf(context).languageCode == 'zh'
                      ? '账号与安全'
                      : 'Account and safety',
                ),
                Card(
                  child: Column(
                    children: [
                      SettingsRow(
                        icon: CupertinoIcons.person,
                        label: s.accountAndSync,
                        value:
                            app.authSession?.email ??
                            (Localizations.localeOf(context).languageCode ==
                                    'zh'
                                ? '游客'
                                : 'Guest'),
                        onTap: () => _showAccount(context, ref),
                      ),
                      const Divider(height: 1, indent: 62),
                      SettingsRow(
                        icon: CupertinoIcons.shield,
                        label: s.learnAndSafety,
                        onTap: () => _showSafety(context),
                      ),
                      const Divider(height: 1, indent: 62),
                      SettingsRow(
                        icon: CupertinoIcons.lock,
                        label: s.privacy,
                        onTap: () => _showPrivacy(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                _sectionLabel(
                  context,
                  Localizations.localeOf(context).languageCode == 'zh'
                      ? '数据'
                      : 'Data',
                ),
                Card(
                  child: Column(
                    children: [
                      SettingsRow(
                        icon: CupertinoIcons.arrow_down_doc,
                        label: s.exportData,
                        onTap: () => _export(context, ref),
                      ),
                      const Divider(height: 1, indent: 62),
                      SettingsRow(
                        icon: CupertinoIcons.delete,
                        label: s.deleteData,
                        danger: true,
                        onTap: () => _confirmDelete(context, ref),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                LighterCard(
                  child: Column(
                    children: [
                      const Icon(
                        CupertinoIcons.pause_circle,
                        color: AppColors.muted,
                        size: 30,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        plan?.paused == true
                            ? (Localizations.localeOf(context).languageCode ==
                                      'zh'
                                  ? '计划已暂停'
                                  : 'Plan paused')
                            : (Localizations.localeOf(context).languageCode ==
                                      'zh'
                                  ? '随时可以暂停'
                                  : 'Pause anytime'),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        Localizations.localeOf(context).languageCode == 'zh'
                            ? '需要休息也没关系，回来后从原地继续。'
                            : 'Taking a break is okay. Return when you are ready.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 14),
                      OutlinedButton(
                        onPressed: () => ref
                            .read(repositoryProvider)
                            .updatePlan(
                              fastMinutes: plan?.fastMinutes ?? 720,
                              startMinuteOfDay: plan?.startMinuteOfDay ?? 1200,
                              paused: !(plan?.paused ?? false),
                            ),
                        child: Text(
                          plan?.paused == true
                              ? (Localizations.localeOf(context).languageCode ==
                                        'zh'
                                    ? '恢复计划'
                                    : 'Resume plan')
                              : s.pausePlan,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  s.notMedicalDevice,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11, color: AppColors.faint),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Lighter · v1.0.0',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: AppColors.faint),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
    child: Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.faint,
        letterSpacing: .8,
      ),
    ),
  );

  String _languageValue(BuildContext context, LanguagePreference value) =>
      switch (value) {
        LanguagePreference.system =>
          Localizations.localeOf(context).languageCode == 'zh'
              ? '跟随系统'
              : 'System',
        LanguagePreference.zh => '简体中文',
        LanguagePreference.en => 'English',
      };

  Future<void> _showPlan(
    BuildContext context,
    WidgetRef ref,
    FastingPlan? plan,
  ) async => showLighterSheet<void>(context, _PlanSettingsSheet(plan: plan));
  Future<void> _showReminders(BuildContext context, WidgetRef ref) async =>
      showLighterSheet<void>(context, const _ReminderSettingsSheet());
  Future<void> _showLanguage(BuildContext context, WidgetRef ref) async =>
      showLighterSheet<void>(context, const _LanguageSheet());
  Future<void> _showUnits(BuildContext context, WidgetRef ref) async =>
      showLighterSheet<void>(context, const _UnitSheet());

  Future<void> _showAccount(BuildContext context, WidgetRef ref) async {
    final app = ref.read(appControllerProvider);
    if (app.authSession == null) {
      await showLighterSheet<void>(context, const AuthSheet());
    } else {
      await showLighterSheet<void>(
        context,
        _SignedInSheet(email: app.authSession!.email),
      );
    }
  }

  Future<void> _showSafety(BuildContext context) => showLighterSheet<void>(
    context,
    _InfoSheet(
      title: Localizations.localeOf(context).languageCode == 'zh'
          ? '学习与安全'
          : 'Learn and safety',
      icon: CupertinoIcons.shield,
      body: Localizations.localeOf(context).languageCode == 'zh'
          ? '从温和计划开始。头晕、心慌、极度饥饿或其他不适时立即结束断食。未满 18 岁、孕期或哺乳期、1 型糖尿病、进食障碍史或相关用药者不应使用应用生成断食计划。'
          : 'Start gently. End your fast for dizziness, shakiness, severe hunger, or other symptoms. Lighter does not create plans for minors, pregnancy or breastfeeding, type 1 diabetes, eating-disorder history, or relevant medication and health conditions.',
    ),
  );

  Future<void> _showPrivacy(BuildContext context) => showLighterSheet<void>(
    context,
    _InfoSheet(
      title: AppLocalizations.of(context).privacy,
      icon: CupertinoIcons.lock_shield,
      body: Localizations.localeOf(context).languageCode == 'zh'
          ? '首版所有健康记录仅保存在这台设备中，不会发送到服务器。模拟登录也不连接网络。未来开启同步前会单独说明数据范围并征得同意。'
          : 'In this release, health records stay on this device and are not sent to a server. Mock sign-in is offline. Future sync will explain its data scope and ask for consent first.',
    ),
  );

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(appControllerProvider).shareExport(context);
    } catch (_) {
      if (context.mounted) {
        showMessage(
          context,
          Localizations.localeOf(context).languageCode == 'zh'
              ? '导出未完成'
              : 'Export was not completed',
        );
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(zh ? '删除本地数据？' : 'Delete local data?'),
        content: Text(
          zh
              ? '这会清除断食记录、体重、设置和模拟账号。操作不可撤销，但会保留同步删除标记。'
              : 'This clears fasts, weights, settings, and the mock account. It cannot be undone, but sync deletion markers are retained.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              zh ? '确认删除' : 'Delete',
              style: const TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) await ref.read(appControllerProvider).clearData();
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.app,
    required this.plan,
    required this.fastCount,
  });
  final AppController app;
  final FastingPlan? plan;
  final int fastCount;

  @override
  Widget build(BuildContext context) => LighterCard(
    child: Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 27,
              backgroundColor: AppColors.accentTint,
              child: Text(
                (app.authSession?.displayName ?? 'L').characters.first
                    .toUpperCase(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accent,
                ),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    app.authSession?.displayName ??
                        (Localizations.localeOf(context).languageCode == 'zh'
                            ? 'Lighter 用户'
                            : 'Lighter user'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    app.authSession == null
                        ? (Localizations.localeOf(context).languageCode == 'zh'
                              ? '游客模式'
                              : 'Guest mode')
                        : app.authSession!.email,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _stat(
                '$fastCount',
                Localizations.localeOf(context).languageCode == 'zh'
                    ? '断食次数'
                    : 'Fasts',
              ),
            ),
            Expanded(
              child: _stat(
                '${(plan?.fastMinutes ?? 720) ~/ 60}h',
                Localizations.localeOf(context).languageCode == 'zh'
                    ? '当前目标'
                    : 'Current goal',
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _stat(String value, String label) => Container(
    padding: const EdgeInsets.symmetric(vertical: 11),
    decoration: BoxDecoration(
      color: AppColors.surface2,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.faint),
        ),
      ],
    ),
  );
}

class _PlanSettingsSheet extends ConsumerStatefulWidget {
  const _PlanSettingsSheet({required this.plan});
  final FastingPlan? plan;
  @override
  ConsumerState<_PlanSettingsSheet> createState() => _PlanSettingsSheetState();
}

class _PlanSettingsSheetState extends ConsumerState<_PlanSettingsSheet> {
  late int duration = widget.plan?.fastMinutes ?? 720;
  late TimeOfDay start = TimeOfDay(
    hour: (widget.plan?.startMinuteOfDay ?? 1200) ~/ 60,
    minute: (widget.plan?.startMinuteOfDay ?? 1200) % 60,
  );

  @override
  Widget build(BuildContext context) {
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppLocalizations.of(context).currentPlan,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 18),
        SegmentedButton<int>(
          segments: const [
            ButtonSegment(value: 600, label: Text('10:14')),
            ButtonSegment(value: 720, label: Text('12:12')),
            ButtonSegment(value: 840, label: Text('14:10')),
            ButtonSegment(value: 960, label: Text('16:8')),
          ],
          selected: {duration},
          showSelectedIcon: false,
          onSelectionChanged: (v) => setState(() => duration = v.first),
        ),
        const SizedBox(height: 16),
        LighterCard(
          onTap: _pickTime,
          child: Row(
            children: [
              Expanded(child: Text(zh ? '计划开始时间' : 'Planned start time')),
              Text(
                start.format(context),
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        FilledButton(
          onPressed: _save,
          child: Text(AppLocalizations.of(context).save),
        ),
      ],
    );
  }

  Future<void> _pickTime() async {
    final value = await showTimePicker(context: context, initialTime: start);
    if (value != null) setState(() => start = value);
  }

  Future<void> _save() async {
    await ref
        .read(repositoryProvider)
        .updatePlan(
          fastMinutes: duration,
          startMinuteOfDay: start.hour * 60 + start.minute,
        );
    if (await ref.read(repositoryProvider).getPreference('reminderStart') ==
        'true') {
      await ref
          .read(notificationServiceProvider)
          .scheduleDailyStartReminder(start.hour * 60 + start.minute);
    }
    if (mounted) Navigator.pop(context);
  }
}

class _ReminderSettingsSheet extends ConsumerStatefulWidget {
  const _ReminderSettingsSheet();
  @override
  ConsumerState<_ReminderSettingsSheet> createState() =>
      _ReminderSettingsSheetState();
}

class _ReminderSettingsSheetState
    extends ConsumerState<_ReminderSettingsSheet> {
  bool start = true;
  bool window = true;
  bool water = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(repositoryProvider);
    final values = await Future.wait([
      repo.getPreference('reminderStart'),
      repo.getPreference('reminderWindow'),
      repo.getPreference('reminderWater'),
    ]);
    if (!mounted) return;
    setState(() {
      start = values[0] != 'false';
      window = values[1] != 'false';
      water = values[2] == 'true';
    });
  }

  @override
  Widget build(BuildContext context) {
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppLocalizations.of(context).reminderSettings,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          value: start,
          onChanged: (v) => setState(() => start = v),
          title: Text(zh ? '断食开始前提醒' : 'Before fast starts'),
          subtitle: Text(zh ? '提前 30 分钟' : '30 minutes before'),
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          value: window,
          onChanged: (v) => setState(() => window = v),
          title: Text(zh ? '进食窗口开启提醒' : 'Eating window opens'),
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          value: water,
          onChanged: (v) => setState(() => water = v),
          title: Text(zh ? '温和喝水提醒' : 'Gentle water reminders'),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _save,
          child: Text(AppLocalizations.of(context).save),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final repo = ref.read(repositoryProvider);
    await repo.setPreference('reminderStart', start.toString());
    await repo.setPreference('reminderWindow', window.toString());
    await repo.setPreference('reminderWater', water.toString());
    final notifications = ref.read(notificationServiceProvider);
    if (start || window || water) await notifications.requestPermission();
    if (start) {
      final plan = await repo.ensureDefaultPlan();
      await notifications.scheduleDailyStartReminder(plan.startMinuteOfDay);
    } else {
      await notifications.cancelDailyStartReminder();
    }
    if (mounted) Navigator.pop(context);
  }
}

class _LanguageSheet extends ConsumerWidget {
  const _LanguageSheet();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(appControllerProvider).language;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppLocalizations.of(context).language,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        RadioGroup<LanguagePreference>(
          groupValue: current,
          onChanged: (value) {
            if (value != null) {
              ref.read(appControllerProvider).setLanguage(value);
            }
          },
          child: const Column(
            children: [
              RadioListTile(
                value: LanguagePreference.system,
                title: Text('System / 跟随系统'),
              ),
              RadioListTile(value: LanguagePreference.zh, title: Text('简体中文')),
              RadioListTile(
                value: LanguagePreference.en,
                title: Text('English'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context).close),
        ),
      ],
    );
  }
}

class _UnitSheet extends ConsumerStatefulWidget {
  const _UnitSheet();
  @override
  ConsumerState<_UnitSheet> createState() => _UnitSheetState();
}

class _UnitSheetState extends ConsumerState<_UnitSheet> {
  late UnitSystem units = ref.read(appControllerProvider).unitSystem;
  late bool liquidMetric = ref.read(appControllerProvider).liquidMetric;
  @override
  Widget build(BuildContext context) {
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppLocalizations.of(context).units,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        SegmentedButton<UnitSystem>(
          segments: [
            ButtonSegment(
              value: UnitSystem.imperial,
              label: Text(zh ? '美制 · 磅' : 'Imperial · lb'),
            ),
            ButtonSegment(
              value: UnitSystem.metric,
              label: Text(zh ? '公制 · 千克' : 'Metric · kg'),
            ),
          ],
          selected: {units},
          onSelectionChanged: (v) => setState(() => units = v.first),
          showSelectedIcon: false,
        ),
        const SizedBox(height: 16),
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(value: false, label: Text(zh ? '液体盎司' : 'Fluid oz')),
            ButtonSegment(value: true, label: Text(zh ? '毫升' : 'Milliliters')),
          ],
          selected: {liquidMetric},
          onSelectionChanged: (v) => setState(() => liquidMetric = v.first),
          showSelectedIcon: false,
        ),
        const SizedBox(height: 22),
        FilledButton(
          onPressed: _save,
          child: Text(AppLocalizations.of(context).save),
        ),
      ],
    );
  }

  Future<void> _save() async {
    await ref
        .read(appControllerProvider)
        .setUnits(units, metricLiquid: liquidMetric);
    if (mounted) Navigator.pop(context);
  }
}

class _SignedInSheet extends ConsumerWidget {
  const _SignedInSheet({required this.email});
  final String email;
  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        AppLocalizations.of(context).accountAndSync,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5DF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          AppLocalizations.of(context).mockMode,
          style: const TextStyle(
            color: AppColors.warning,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      const SizedBox(height: 16),
      Text(email, style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 20),
      OutlinedButton(
        onPressed: () async {
          await ref.read(appControllerProvider).logout();
          if (context.mounted) Navigator.pop(context);
        },
        child: Text(AppLocalizations.of(context).signOut),
      ),
    ],
  );
}

class _InfoSheet extends StatelessWidget {
  const _InfoSheet({
    required this.title,
    required this.icon,
    required this.body,
  });
  final String title;
  final IconData icon;
  final String body;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Icon(icon, color: AppColors.accent, size: 34),
      const SizedBox(height: 12),
      Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 14),
      Text(body, style: Theme.of(context).textTheme.bodyLarge),
      const SizedBox(height: 22),
      FilledButton(
        onPressed: () => Navigator.pop(context),
        child: Text(AppLocalizations.of(context).close),
      ),
    ],
  );
}
