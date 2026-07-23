import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int step = 0;
  bool consent = false;
  bool blocked = false;
  final Set<String> risks = {};
  String? goal;
  String? experience;
  final Set<String> barriers = {};
  UnitSystem unit = UnitSystem.imperial;
  bool startReminder = true;
  bool windowReminder = true;
  bool waterReminder = false;
  TimeOfDay firstMeal = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay lastMeal = const TimeOfDay(hour: 20, minute: 0);
  TimeOfDay sleep = const TimeOfDay(hour: 23, minute: 30);

  bool get _zh => Localizations.localeOf(context).languageCode == 'zh';

  Map<String, Object?> get _answers => {
    'goal': goal,
    'risks': risks.toList(),
    'experience': experience,
    'barriers': barriers.toList(),
    'unitSystem': unit.name,
    'firstMeal': '${firstMeal.hour}:${firstMeal.minute}',
    'lastMeal': '${lastMeal.hour}:${lastMeal.minute}',
    'sleep': '${sleep.hour}:${sleep.minute}',
    'startReminder': startReminder,
    'windowReminder': windowReminder,
    'waterReminder': waterReminder,
  };

  @override
  void initState() {
    super.initState();
    step = ref.read(appControllerProvider).onboardingStep.clamp(0, 9);
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    if (step == 0) return _Splash(onContinue: _next);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 8, 14, 8),
              child: Row(
                children: [
                  if (step > 1)
                    IconButton(
                      onPressed: _back,
                      icon: const Icon(CupertinoIcons.chevron_left, size: 21),
                    )
                  else
                    const SizedBox(width: 48),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        minHeight: 4,
                        value: step / 10,
                        backgroundColor: AppColors.border,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: s.language,
                    onPressed: _toggleLanguage,
                    icon: const Icon(CupertinoIcons.globe, size: 20),
                  ),
                ],
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                child: SingleChildScrollView(
                  key: ValueKey('$step-$blocked'),
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
                  child: blocked ? _blockedView(s) : _stepView(s),
                ),
              ),
            ),
            if (!blocked)
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 18),
                child: Column(
                  children: [
                    FilledButton(
                      onPressed: _canContinue ? _next : null,
                      child: Text(
                        step == 9
                            ? (_zh ? '开启通知' : 'Enable notifications')
                            : step == 10
                            ? s.today
                            : s.continueLabel,
                      ),
                    ),
                    if (step == 9)
                      TextButton(
                        onPressed: _next,
                        child: Text(_zh ? '以后再说' : 'Maybe later'),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool get _canContinue => switch (step) {
    2 => consent,
    3 => risks.isNotEmpty,
    4 => goal != null,
    6 => experience != null,
    _ => true,
  };

  Widget _stepView(AppLocalizations s) => switch (step) {
    1 => _IntroStep(
      eyebrow: _zh ? '欢迎使用 Lighter' : 'WELCOME TO LIGHTER',
      title: s.onboardingWelcome,
      body: s.onboardingWelcomeBody,
      items: _zh
          ? const ['适合新手的温和计划', '随时可调整的时间安排', '没有批评和羞耻感的反馈']
          : const [
              'A gentle plan for beginners',
              'A schedule you can adjust anytime',
              'Progress without blame or shame',
            ],
    ),
    2 => _SafetyStep(
      title: s.safetyTitle,
      body: s.safetyBody,
      consent: consent,
      consentLabel: s.safetyConsent,
      onConsent: (value) => setState(() => consent = value),
      zh: _zh,
    ),
    3 => _ChoiceStep(
      title: s.screeningTitle,
      subtitle: s.screeningQuestion,
      multi: true,
      choices: _zh
          ? const {
              'under18': '我未满 18 岁',
              'pregnant': '我处于孕期或哺乳期',
              'diabetes': '我患有 1 型糖尿病',
              'eating': '我目前或过去有进食障碍',
              'medical': '我正在服药，或有其他健康问题',
              'none': '以上都不符合',
            }
          : const {
              'under18': 'I am under 18',
              'pregnant': 'I am pregnant or breastfeeding',
              'diabetes': 'I have type 1 diabetes',
              'eating': 'I have a current or past eating disorder',
              'medical': 'I take medication or have a relevant condition',
              'none': 'None of the above',
            },
      selected: risks,
      onTap: _toggleRisk,
    ),
    4 => _ChoiceStep(
      title: s.goalTitle,
      choices: _zh
          ? const {
              'weight': '稳定地减轻体重',
              'rhythm': '建立规律的饮食节奏',
              'night': '减少夜间进食',
              'timing': '更好地管理进食时间',
            }
          : const {
              'weight': 'Lose weight steadily',
              'rhythm': 'Build a regular eating rhythm',
              'night': 'Reduce late-night eating',
              'timing': 'Manage meal timing better',
            },
      selected: goal == null ? const <String>{} : {goal!},
      onTap: (value) => setState(() => goal = value),
      footer: Text(
        _zh
            ? '不设完成日期，也不承诺减重速度。'
            : 'No deadline and no promise of a rate of weight loss.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ),
    5 => _RoutineStep(
      title: s.routineTitle,
      firstMeal: firstMeal,
      lastMeal: lastMeal,
      sleep: sleep,
      zh: _zh,
      onFirstMeal: () => _pickTime(firstMeal, (v) => firstMeal = v),
      onLastMeal: () => _pickTime(lastMeal, (v) => lastMeal = v),
      onSleep: () => _pickTime(sleep, (v) => sleep = v),
    ),
    6 => _ExperienceStep(
      title: s.experienceTitle,
      zh: _zh,
      experience: experience,
      barriers: barriers,
      onExperience: (v) => setState(() => experience = v),
      onBarrier: (v) => setState(
        () => barriers.contains(v) ? barriers.remove(v) : barriers.add(v),
      ),
    ),
    7 => _ReminderStep(
      title: s.remindersTitle,
      zh: _zh,
      unit: unit,
      startReminder: startReminder,
      windowReminder: windowReminder,
      waterReminder: waterReminder,
      onUnit: (v) => setState(() => unit = v),
      onStart: (v) => setState(() => startReminder = v),
      onWindow: (v) => setState(() => windowReminder = v),
      onWater: (v) => setState(() => waterReminder = v),
    ),
    8 => _PlanStep(title: s.planTitle, zh: _zh, lastMeal: lastMeal),
    9 => _NotificationStep(title: s.notificationTitle, zh: _zh),
    10 => _ReadyStep(title: s.readyTitle, zh: _zh),
    _ => const SizedBox.shrink(),
  };

  Widget _blockedView(AppLocalizations s) => Column(
    children: [
      const SizedBox(height: 36),
      const CircleAvatar(
        radius: 34,
        backgroundColor: AppColors.accentTint,
        child: Icon(
          CupertinoIcons.exclamationmark_circle,
          color: AppColors.accent,
          size: 32,
        ),
      ),
      const SizedBox(height: 24),
      Text(
        s.screeningBlocked,
        style: Theme.of(context).textTheme.headlineLarge,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 14),
      Text(
        s.screeningBlockedBody,
        style: Theme.of(context).textTheme.bodyLarge,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 28),
      LighterCard(
        child: Column(
          children: [
            _infoLine(
              CupertinoIcons.person_2,
              _zh ? '建议先咨询医生，确认是否适合断食' : 'Talk with a clinician before fasting',
            ),
            const Divider(height: 28),
            _infoLine(
              CupertinoIcons.book,
              _zh ? '仍可阅读安全说明' : 'You can still read the safety guidance',
            ),
          ],
        ),
      ),
      const SizedBox(height: 28),
      FilledButton(
        onPressed: () => setState(() => blocked = false),
        child: Text(_zh ? '返回修改' : 'Go back and review'),
      ),
    ],
  );

  Widget _infoLine(IconData icon, String text) => Row(
    children: [
      Icon(icon, size: 20, color: AppColors.accent),
      const SizedBox(width: 12),
      Expanded(child: Text(text)),
    ],
  );

  void _toggleRisk(String value) {
    setState(() {
      if (value == 'none') {
        risks
          ..clear()
          ..add('none');
      } else {
        risks.remove('none');
        risks.contains(value) ? risks.remove(value) : risks.add(value);
      }
    });
  }

  Future<void> _next() async {
    if (step == 3 && !risks.contains('none')) {
      setState(() => blocked = true);
      return;
    }
    if (step == 9) {
      final repository = ref.read(repositoryProvider);
      await repository.updatePlan(
        fastMinutes: 720,
        startMinuteOfDay: lastMeal.hour * 60 + lastMeal.minute,
      );
      await repository.setPreference('reminderStart', startReminder.toString());
      await repository.setPreference(
        'reminderWindow',
        windowReminder.toString(),
      );
      await repository.setPreference('reminderWater', waterReminder.toString());
      await ref
          .read(appControllerProvider)
          .setUnits(unit, metricLiquid: unit == UnitSystem.metric);
      final notifications = ref.read(notificationServiceProvider);
      await notifications.requestPermission();
      if (startReminder) {
        await notifications.scheduleDailyStartReminder(
          lastMeal.hour * 60 + lastMeal.minute,
        );
      }
    }
    if (step >= 10) {
      await ref.read(appControllerProvider).completeOnboarding(_answers);
      return;
    }
    setState(() => step += 1);
    await ref
        .read(appControllerProvider)
        .saveOnboardingProgress(step, _answers);
  }

  void _back() => setState(() {
    blocked = false;
    if (step > 1) step -= 1;
  });

  Future<void> _pickTime(
    TimeOfDay initial,
    ValueChanged<TimeOfDay> assign,
  ) async {
    final value = await showTimePicker(context: context, initialTime: initial);
    if (value != null) setState(() => assign(value));
  }

  Future<void> _toggleLanguage() async {
    final controller = ref.read(appControllerProvider);
    await controller.setLanguage(
      _zh ? LanguagePreference.en : LanguagePreference.zh,
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash({required this.onContinue});
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    return Scaffold(
      body: InkWell(
        onTap: onContinue,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'Lighter'),
                    TextSpan(
                      text: '.',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 12),
              Text(
                s.tagline,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: 32),
              IconButton(
                onPressed: onContinue,
                icon: const Icon(CupertinoIcons.arrow_right),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surface2,
                  foregroundColor: AppColors.foreground,
                  side: const BorderSide(color: AppColors.border),
                  minimumSize: const Size(56, 56),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                Localizations.localeOf(context).languageCode == 'zh'
                    ? '轻点继续'
                    : 'Tap to continue',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntroStep extends StatelessWidget {
  const _IntroStep({
    required this.eyebrow,
    required this.title,
    required this.body,
    required this.items,
  });
  final String eyebrow;
  final String title;
  final String body;
  final List<String> items;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        eyebrow,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.faint,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
      const SizedBox(height: 12),
      Text(title, style: Theme.of(context).textTheme.headlineLarge),
      const SizedBox(height: 14),
      Text(body, style: Theme.of(context).textTheme.bodyLarge),
      const SizedBox(height: 30),
      ...items.map(
        (item) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: LighterCard(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.check_mark_circled,
                  color: AppColors.accent,
                  size: 21,
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(item)),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

class _SafetyStep extends StatelessWidget {
  const _SafetyStep({
    required this.title,
    required this.body,
    required this.consent,
    required this.consentLabel,
    required this.onConsent,
    required this.zh,
  });
  final String title;
  final String body;
  final bool consent;
  final String consentLabel;
  final ValueChanged<bool> onConsent;
  final bool zh;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const CircleAvatar(
        radius: 27,
        backgroundColor: AppColors.accentTint,
        child: Icon(CupertinoIcons.shield, color: AppColors.accent),
      ),
      const SizedBox(height: 20),
      Text(title, style: Theme.of(context).textTheme.headlineLarge),
      const SizedBox(height: 12),
      Text(body, style: Theme.of(context).textTheme.bodyLarge),
      const SizedBox(height: 26),
      ...List.generate(3, (i) {
        final labels = zh
            ? ['从温和的计划开始', '身体不适时及时停止', '不确定时咨询专业人士']
            : [
                'Start with a gentle plan',
                'Stop when you feel unwell',
                'Ask a professional when unsure',
              ];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.surface2,
                child: Text(
                  '${i + 1}',
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  labels[i],
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        );
      }),
      const SizedBox(height: 16),
      CheckboxListTile(
        value: consent,
        onChanged: (v) => onConsent(v ?? false),
        activeColor: AppColors.accent,
        contentPadding: EdgeInsets.zero,
        title: Text(
          consentLabel,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    ],
  );
}

class _ChoiceStep extends StatelessWidget {
  const _ChoiceStep({
    required this.title,
    required this.choices,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.multi = false,
    this.footer,
  });
  final String title;
  final String? subtitle;
  final Map<String, String> choices;
  final Set<String> selected;
  final ValueChanged<String> onTap;
  final bool multi;
  final Widget? footer;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.headlineLarge),
      if (subtitle != null) ...[
        const SizedBox(height: 10),
        Text(subtitle!, style: Theme.of(context).textTheme.bodyLarge),
      ],
      const SizedBox(height: 22),
      ...choices.entries.map((choice) {
        final active = selected.contains(choice.key);
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Material(
            color: active ? AppColors.accentTint : AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: active ? AppColors.accent : AppColors.border,
                width: active ? 1.4 : .7,
              ),
            ),
            child: InkWell(
              onTap: () => onTap(choice.key),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        choice.value,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Icon(
                      active
                          ? CupertinoIcons.check_mark_circled_solid
                          : (multi
                                ? CupertinoIcons.square
                                : CupertinoIcons.circle),
                      color: active ? AppColors.accent : AppColors.faint,
                      size: 21,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
      if (footer != null) ...[const SizedBox(height: 8), footer!],
    ],
  );
}

class _RoutineStep extends StatelessWidget {
  const _RoutineStep({
    required this.title,
    required this.firstMeal,
    required this.lastMeal,
    required this.sleep,
    required this.zh,
    required this.onFirstMeal,
    required this.onLastMeal,
    required this.onSleep,
  });
  final String title;
  final TimeOfDay firstMeal;
  final TimeOfDay lastMeal;
  final TimeOfDay sleep;
  final bool zh;
  final VoidCallback onFirstMeal;
  final VoidCallback onLastMeal;
  final VoidCallback onSleep;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.headlineLarge),
      const SizedBox(height: 10),
      Text(
        zh ? '这些时间以后都可以修改。' : 'You can change these times later.',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      const SizedBox(height: 24),
      _timeTile(
        context,
        zh ? '通常几点吃第一餐' : 'First meal',
        firstMeal,
        onFirstMeal,
      ),
      _timeTile(context, zh ? '通常几点结束最后一餐' : 'Last meal', lastMeal, onLastMeal),
      _timeTile(context, zh ? '通常几点睡觉' : 'Bedtime', sleep, onSleep),
    ],
  );

  Widget _timeTile(
    BuildContext context,
    String label,
    TimeOfDay time,
    VoidCallback onTap,
  ) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: LighterCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.titleMedium),
          ),
          Text(
            time.format(context),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    ),
  );
}

class _ExperienceStep extends StatelessWidget {
  const _ExperienceStep({
    required this.title,
    required this.zh,
    required this.experience,
    required this.barriers,
    required this.onExperience,
    required this.onBarrier,
  });
  final String title;
  final bool zh;
  final String? experience;
  final Set<String> barriers;
  final ValueChanged<String> onExperience;
  final ValueChanged<String> onBarrier;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _ChoiceStep(
        title: title,
        choices: zh
            ? const {'first': '这是我第一次尝试', 'few': '我尝试过几次', 'habit': '断食已经是生活习惯'}
            : const {
                'first': 'This is my first time',
                'few': 'I have tried a few times',
                'habit': 'Fasting is part of my routine',
              },
        selected: experience == null ? const <String>{} : {experience!},
        onTap: onExperience,
      ),
      const SizedBox(height: 18),
      Text(
        zh ? '过去什么最容易让你中断？' : 'What usually gets in the way?',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 12),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children:
            (zh
                    ? const {
                        'hunger': '饥饿',
                        'energy': '精力不足',
                        'social': '社交聚餐',
                        'schedule': '作息变化',
                        'forget': '经常忘记',
                        'strict': '限制太多',
                      }
                    : const {
                        'hunger': 'Hunger',
                        'energy': 'Low energy',
                        'social': 'Social meals',
                        'schedule': 'Schedule changes',
                        'forget': 'Forgetting',
                        'strict': 'Too restrictive',
                      })
                .entries
                .map(
                  (item) => FilterChip(
                    selected: barriers.contains(item.key),
                    onSelected: (_) => onBarrier(item.key),
                    label: Text(item.value),
                    selectedColor: AppColors.accentTint,
                    checkmarkColor: AppColors.accent,
                  ),
                )
                .toList(),
      ),
    ],
  );
}

class _ReminderStep extends StatelessWidget {
  const _ReminderStep({
    required this.title,
    required this.zh,
    required this.unit,
    required this.startReminder,
    required this.windowReminder,
    required this.waterReminder,
    required this.onUnit,
    required this.onStart,
    required this.onWindow,
    required this.onWater,
  });
  final String title;
  final bool zh;
  final UnitSystem unit;
  final bool startReminder;
  final bool windowReminder;
  final bool waterReminder;
  final ValueChanged<UnitSystem> onUnit;
  final ValueChanged<bool> onStart;
  final ValueChanged<bool> onWindow;
  final ValueChanged<bool> onWater;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.headlineLarge),
      const SizedBox(height: 22),
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
        selected: {unit},
        onSelectionChanged: (v) => onUnit(v.first),
        showSelectedIcon: false,
      ),
      const SizedBox(height: 24),
      _switch(
        zh ? '断食开始前提醒我' : 'Before the fast starts',
        zh ? '提前 30 分钟' : '30 minutes before',
        startReminder,
        onStart,
      ),
      _switch(
        zh ? '进食窗口开启时提醒我' : 'When the eating window opens',
        zh ? '到达目标时' : 'At your target time',
        windowReminder,
        onWindow,
      ),
      _switch(
        zh ? '温和喝水提醒' : 'Gentle water reminder',
        zh ? '断食期间少量多次' : 'Small amounts during a fast',
        waterReminder,
        onWater,
      ),
    ],
  );

  Widget _switch(
    String label,
    String detail,
    bool value,
    ValueChanged<bool> onChanged,
  ) => SwitchListTile.adaptive(
    contentPadding: EdgeInsets.zero,
    title: Text(label),
    subtitle: Text(detail),
    value: value,
    activeTrackColor: AppColors.accent,
    onChanged: onChanged,
  );
}

class _PlanStep extends StatelessWidget {
  const _PlanStep({
    required this.title,
    required this.zh,
    required this.lastMeal,
  });
  final String title;
  final bool zh;
  final TimeOfDay lastMeal;

  @override
  Widget build(BuildContext context) {
    final end = TimeOfDay(
      hour: (lastMeal.hour + 12) % 24,
      minute: lastMeal.minute,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          zh ? '为你推荐' : 'RECOMMENDED FOR YOU',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.faint,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 10),
        Text(title, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 22),
        LighterCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const Text(
                '12:12',
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                zh
                    ? '断食 12 小时，在另外 12 小时内进食。'
                    : 'Fast for 12 hours and eat within the other 12.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(height: 10, color: AppColors.accentSoft),
                    ),
                    Expanded(
                      child: Container(height: 10, color: AppColors.accent),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lastMeal.format(context),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    end.format(context),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ...[
          zh ? '符合你的日常作息' : 'Fits your routine',
          zh ? '适合第一次尝试' : 'Gentle for a first attempt',
          zh ? '生活变化时随时调整' : 'Easy to adjust when life changes',
        ].map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                const Icon(CupertinoIcons.check_mark, color: AppColors.accent),
                const SizedBox(width: 12),
                Text(e),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NotificationStep extends StatelessWidget {
  const _NotificationStep({required this.title, required this.zh});
  final String title;
  final bool zh;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      const SizedBox(height: 22),
      const CircleAvatar(
        radius: 32,
        backgroundColor: AppColors.accentTint,
        child: Icon(CupertinoIcons.bell, color: AppColors.accent, size: 28),
      ),
      const SizedBox(height: 22),
      Text(
        title,
        style: Theme.of(context).textTheme.headlineLarge,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 12),
      Text(
        zh
            ? '在关键节点温和提醒你，拒绝权限也不影响使用。'
            : 'Gentle reminders at key moments. You can keep using Lighter if you decline.',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      const SizedBox(height: 26),
      LighterCard(
        child: Row(
          children: [
            const Icon(CupertinoIcons.clock, color: AppColors.accent),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                zh
                    ? '你的进食窗口将在目标时间开启'
                    : 'Your eating window will open at your goal time',
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _ReadyStep extends StatelessWidget {
  const _ReadyStep({required this.title, required this.zh});
  final String title;
  final bool zh;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      const SizedBox(height: 80),
      const CircleAvatar(
        radius: 40,
        backgroundColor: AppColors.accent,
        child: Icon(CupertinoIcons.check_mark, color: Colors.white, size: 34),
      ),
      const SizedBox(height: 26),
      Text(
        title,
        style: Theme.of(context).textTheme.headlineLarge,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 12),
      Text(
        zh
            ? '你的 12:12 计划已就绪。今天轻松迈出第一步。'
            : 'Your 12:12 plan is ready. Take the first gentle step today.',
        style: Theme.of(context).textTheme.bodyLarge,
        textAlign: TextAlign.center,
      ),
    ],
  );
}
