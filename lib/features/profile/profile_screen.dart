import 'dart:math' as math;

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
    final accent = LighterAccentPalette.of(context);
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                22,
                20,
                22,
                kFloatingNavigationClearance,
              ),
              children: [
                _ProfileHeader(
                  app: app,
                  plan: plan,
                  sessions: history,
                  onAccountTap: () => _showAccount(context, ref),
                ),
                const SizedBox(height: 24),
                _sectionLabel(context, s.planAndPreferences),
                Card(
                  child: Column(
                    children: [
                      SettingsRow(
                        icon: CupertinoIcons.calendar,
                        iconColor: accent.primary,
                        iconBackground: accent.tint,
                        label: s.currentPlan,
                        value:
                            '${(plan?.fastMinutes ?? 720) ~/ 60}:${(1440 - (plan?.fastMinutes ?? 720)) ~/ 60}',
                        onTap: () => _showPlan(context, ref, plan),
                      ),
                      const Divider(height: 1, indent: 62),
                      SettingsRow(
                        icon: CupertinoIcons.paintbrush,
                        iconColor: accent.primary,
                        iconBackground: accent.tint,
                        label:
                            Localizations.localeOf(context).languageCode == 'zh'
                            ? '系统风格'
                            : 'App theme',
                        value: _themeValue(context, app.accentTheme),
                        onTap: () => _showTheme(context),
                      ),
                      const Divider(height: 1, indent: 62),
                      SettingsRow(
                        icon: CupertinoIcons.bell,
                        iconColor: AppColors.steps,
                        iconBackground: AppColors.stepsTint,
                        label: s.reminderSettings,
                        onTap: () => _showReminders(context, ref),
                      ),
                      const Divider(height: 1, indent: 62),
                      SettingsRow(
                        icon: CupertinoIcons.globe,
                        iconColor: AppColors.water,
                        iconBackground: AppColors.waterTint,
                        label: s.language,
                        value: _languageValue(context, app.language),
                        onTap: () => _showLanguage(context, ref),
                      ),
                      const Divider(height: 1, indent: 62),
                      SettingsRow(
                        icon: CupertinoIcons.compass,
                        iconColor: AppColors.purple,
                        iconBackground: AppColors.purpleTint,
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
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFFF0D8), Color(0xFFFFE9EE)],
                  ),
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
                        iconColor: AppColors.weight,
                        iconBackground: AppColors.weightTint,
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
                        iconColor: AppColors.water,
                        iconBackground: AppColors.waterTint,
                        label: s.learnAndSafety,
                        onTap: () => _showSafety(context),
                      ),
                      const Divider(height: 1, indent: 62),
                      SettingsRow(
                        icon: CupertinoIcons.lock,
                        iconColor: AppColors.purple,
                        iconBackground: AppColors.purpleTint,
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
                        iconColor: AppColors.water,
                        iconBackground: AppColors.waterTint,
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

  String _themeValue(BuildContext context, AppAccentTheme value) {
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    return switch (value) {
      AppAccentTheme.mint => zh ? '薄荷绿' : 'Mint',
      AppAccentTheme.ocean => zh ? '海洋蓝' : 'Ocean',
      AppAccentTheme.violet => zh ? '紫罗兰' : 'Violet',
      AppAccentTheme.coral => zh ? '珊瑚橙' : 'Coral',
      AppAccentTheme.graphite => zh ? '石墨蓝' : 'Graphite',
    };
  }

  Future<void> _showPlan(
    BuildContext context,
    WidgetRef ref,
    FastingPlan? plan,
  ) async => showLighterSheet<void>(context, _PlanSettingsSheet(plan: plan));
  Future<void> _showReminders(BuildContext context, WidgetRef ref) async =>
      showLighterSheet<void>(context, const _ReminderSettingsSheet());
  Future<void> _showLanguage(BuildContext context, WidgetRef ref) async =>
      showLighterSheet<void>(context, const _LanguageSheet());
  Future<void> _showTheme(BuildContext context) async =>
      showLighterSheet<void>(context, const _ThemeSheet());
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
    required this.sessions,
    required this.onAccountTap,
  });
  final AppController app;
  final FastingPlan? plan;
  final List<FastingSession> sessions;
  final VoidCallback onAccountTap;

  @override
  Widget build(BuildContext context) {
    final ended = sessions.where((item) => item.endedAtUtcMs != null).toList();
    final totalMinutes = ended.fold<int>(
      0,
      (sum, item) => sum + (item.endedAtUtcMs! - item.startedAtUtcMs) ~/ 60000,
    );
    final longestMinutes = ended.fold<int>(
      0,
      (value, item) =>
          math.max(value, (item.endedAtUtcMs! - item.startedAtUtcMs) ~/ 60000),
    );
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    final accent = LighterAccentPalette.of(context);
    final fastingDays = ended
        .map(
          (item) => localDateKey(
            DateTime.fromMillisecondsSinceEpoch(
              item.startedAtUtcMs,
              isUtc: true,
            ).toLocal(),
          ),
        )
        .toSet()
        .length;
    return Column(
      children: [
        InkWell(
          onTap: onAccountTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [accent.tint, AppColors.purpleTint],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    (app.authSession?.displayName ?? 'L').characters.first
                        .toUpperCase(),
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: accent.pressed,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              app.authSession?.displayName ??
                                  (zh ? 'Lighter 用户' : 'Lighter user'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Icon(
                            CupertinoIcons.pencil,
                            size: 16,
                            color: accent.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        app.authSession == null
                            ? (zh ? '游客模式 · 点击登录' : 'Guest · Tap to sign in')
                            : app.authSession!.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Icon(CupertinoIcons.gear, color: AppColors.strong, size: 24),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        LighterCard(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _stat(
                      '$fastingDays',
                      zh ? '断食天数' : 'Fasting days',
                      CupertinoIcons.calendar,
                      AppColors.water,
                      AppColors.waterTint,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: _stat(
                      '${(plan?.fastMinutes ?? 720) ~/ 60}h',
                      zh ? '当日目标' : 'Daily goal',
                      CupertinoIcons.scope,
                      accent.primary,
                      accent.tint,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: _stat(
                      '${totalMinutes ~/ 60}h',
                      zh ? '累计时长' : 'Total time',
                      CupertinoIcons.timer,
                      AppColors.calories,
                      AppColors.caloriesTint,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: _stat(
                      '${longestMinutes ~/ 60}h',
                      zh ? '最长断食' : 'Longest fast',
                      CupertinoIcons.flame_fill,
                      AppColors.steps,
                      AppColors.stepsTint,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stat(
    String value,
    String label,
    IconData icon,
    Color accent,
    Color tint,
  ) => Row(
    children: [
      Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: accent),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: AppColors.faint),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.strong,
              ),
            ),
          ],
        ),
      ),
    ],
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

class _ThemeSheet extends ConsumerWidget {
  const _ThemeSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(appControllerProvider).accentTheme;
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          zh ? '系统风格' : 'App theme',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 6),
        Text(
          zh ? '选择你喜欢的全局强调色' : 'Choose an accent that feels like you',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 18),
        for (final option in AppAccentTheme.values) ...[
          _ThemeOption(
            option: option,
            selected: current == option,
            label: _label(option, zh),
            onTap: () => ref.read(appControllerProvider).setAccentTheme(option),
          ),
          if (option != AppAccentTheme.values.last) const SizedBox(height: 10),
        ],
        const SizedBox(height: 18),
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context).close),
        ),
      ],
    );
  }

  String _label(AppAccentTheme value, bool zh) => switch (value) {
    AppAccentTheme.mint => zh ? '薄荷绿' : 'Mint',
    AppAccentTheme.ocean => zh ? '海洋蓝' : 'Ocean',
    AppAccentTheme.violet => zh ? '紫罗兰' : 'Violet',
    AppAccentTheme.coral => zh ? '珊瑚橙' : 'Coral',
    AppAccentTheme.graphite => zh ? '石墨蓝' : 'Graphite',
  };
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.option,
    required this.selected,
    required this.label,
    required this.onTap,
  });

  final AppAccentTheme option;
  final bool selected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = option.palette;
    return LighterCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      borderColor: selected ? palette.primary : AppColors.border,
      child: Row(
        children: [
          SizedBox(
            width: 68,
            height: 28,
            child: Stack(
              children: [
                _swatch(palette.soft, 0),
                _swatch(palette.tint, 20),
                _swatch(palette.primary, 40),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.titleMedium),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: selected ? palette.primary : AppColors.surface2,
              shape: BoxShape.circle,
            ),
            child: selected
                ? const Icon(
                    CupertinoIcons.check_mark,
                    color: Colors.white,
                    size: 15,
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _swatch(Color color, double left) => Positioned(
    left: left,
    child: Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    ),
  );
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
