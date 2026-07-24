import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../data/database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets.dart';
import 'custom_tasks.dart';

class TodayScreen extends ConsumerStatefulWidget {
  const TodayScreen({super.key});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen>
    with WidgetsBindingObserver {
  Timer? _timer;
  DateTime now = DateTime.now();
  bool showEnded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => now = DateTime.now());
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() => now = DateTime.now());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = ref.watch(activeSessionProvider).valueOrNull;
    final plan = ref.watch(activePlanProvider).valueOrNull;
    final history =
        ref.watch(sessionHistoryProvider).valueOrNull ??
        const <FastingSession>[];
    final last = history.isEmpty ? null : history.first;
    final s = AppLocalizations.of(context);
    final date = DateFormat(
      Localizations.localeOf(context).languageCode == 'zh'
          ? 'M月d日 EEEE'
          : 'EEE, MMM d',
      Localizations.localeOf(context).toLanguageTag(),
    ).format(now);
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          ScreenHeader(
            title: s.today,
            subtitle: date,
            actions: [
              _PlanHeaderAction(plan: plan, onAdjust: _showPlanPicker),
            ],
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              child: active != null
                  ? _FastingView(
                      key: ValueKey(active.id),
                      session: active,
                      now: now,
                      onEnd: _end,
                      onAdjust: () => _showAdjust(active),
                      onDiscomfort: () => _showDiscomfort(active),
                    )
                  : showEnded && last?.endedAtUtcMs != null
                  ? _EndedView(
                      key: ValueKey('ended-${last!.id}'),
                      session: last,
                      onRestart: () => setState(() => showEnded = false),
                    )
                  : _IdleView(
                      key: const ValueKey('idle'),
                      onStart: _start,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _start() async {
    final repository = ref.read(repositoryProvider);
    final session = await repository.startFast();
    final waterEnabled =
        await repository.getPreference('reminderWater') == 'true';
    final start = DateTime.fromMillisecondsSinceEpoch(
      session.startedAtUtcMs,
      isUtc: true,
    ).toLocal();
    await ref
        .read(notificationServiceProvider)
        .scheduleFastNotifications(
          start: start,
          end: start.add(Duration(minutes: session.targetMinutes)),
          waterEnabled: waterEnabled,
        );
    if (mounted) {
      showMessage(
        context,
        Localizations.localeOf(context).languageCode == 'zh'
            ? '断食已开始'
            : 'Fast started',
      );
    }
  }

  Future<void> _end({
    String reason = 'manual',
    List<String> symptoms = const [],
  }) async {
    await ref
        .read(repositoryProvider)
        .endFast(reason: reason, symptoms: symptoms);
    await ref.read(notificationServiceProvider).cancelFastNotifications();
    if (mounted) setState(() => showEnded = true);
  }

  Future<void> _showAdjust(FastingSession session) async {
    await showLighterSheet<void>(context, _AdjustFastSheet(session: session));
  }

  Future<void> _showDiscomfort(FastingSession session) async {
    final result = await showLighterSheet<List<String>>(
      context,
      const _DiscomfortSheet(),
    );
    if (result != null) await _end(reason: 'discomfort', symptoms: result);
  }

  Future<void> _showPlanPicker() async {
    final plan = await ref.read(repositoryProvider).ensureDefaultPlan();
    if (!mounted) return;
    await showLighterSheet<void>(context, _PlanPickerSheet(plan: plan));
  }
}

class _PlanHeaderAction extends StatelessWidget {
  const _PlanHeaderAction({required this.plan, required this.onAdjust});
  final FastingPlan? plan;
  final VoidCallback onAdjust;

  @override
  Widget build(BuildContext context) {
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    return GestureDetector(
      onTap: onAdjust,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.accentTint,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _planRatio(plan?.fastMinutes ?? 720),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.accent,
              ),
            ),
            Container(
              width: 1,
              height: 13,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: AppColors.accent.withValues(alpha: .28),
            ),
            Icon(
              CupertinoIcons.slider_horizontal_3,
              size: 13,
              color: AppColors.accent,
            ),
            const SizedBox(width: 3),
            Text(
              zh ? '调整' : 'Adjust',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IdleView extends ConsumerWidget {
  const _IdleView({super.key, required this.onStart});
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(activePlanProvider).valueOrNull;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        22,
        18,
        22,
        kFloatingNavigationClearance,
      ),
      children: [
        _IdleHero(plan: plan, onStart: onStart),
        const SizedBox(height: 26),
        const _TodayTrackingSection(),
      ],
    );
  }
}

class _IdleHero extends StatelessWidget {
  const _IdleHero({required this.plan, required this.onStart});

  final FastingPlan? plan;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    final minutes = plan?.fastMinutes ?? 720;
    final startMinute = plan?.startMinuteOfDay ?? 1200;
    final endMinute = (startMinute + minutes) % 1440;
    final endsTomorrow = startMinute + minutes >= 1440;
    String time(int value) =>
        '${(value ~/ 60).toString().padLeft(2, '0')}:${(value % 60).toString().padLeft(2, '0')}';
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final ringSize = math.min(constraints.maxWidth, 310.0);
            return SizedBox.square(
              dimension: ringSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: ExcludeSemantics(
                      child: CustomPaint(
                        painter: _OpenRingPainter(
                          color: LighterAccentPalette.of(context).soft,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      ringSize * .13,
                      ringSize * .105,
                      ringSize * .13,
                      ringSize * .11,
                    ),
                    child: Column(
                      children: [
                        Text(
                          zh ? '进食阶段' : 'Eating window',
                          style: const TextStyle(
                            color: AppColors.strong,
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 19),
                        Text(
                          zh ? '你的断食开始于' : 'Your fast starts at',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.foreground),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          time(startMinute),
                          style: const TextStyle(
                            fontSize: 44,
                            height: 1.05,
                            letterSpacing: -1.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.strong,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 210,
                          height: 46,
                          child: FilledButton(
                            onPressed: onStart,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: Text(AppLocalizations.of(context).startFast),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(
          height: 52,
          child: Transform.translate(
            offset: const Offset(0, -10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _PlanTimeLabel(
                    label: zh ? '开始时间' : 'Start time',
                    value: zh
                        ? '今天，${time(startMinute)}'
                        : 'Today, ${time(startMinute)}',
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: _PlanTimeLabel(
                    label: zh ? '结束时间' : 'End time',
                    value: zh
                        ? '${endsTomorrow ? '明天' : '今天'}，${time(endMinute)}'
                        : '${endsTomorrow ? 'Tomorrow' : 'Today'}, ${time(endMinute)}',
                    alignEnd: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PlanTimeLabel extends StatelessWidget {
  const _PlanTimeLabel({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final alignment = alignEnd
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.faint),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
          style: const TextStyle(
            color: AppColors.strong,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _OpenRingPainter extends CustomPainter {
  const _OpenRingPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = math.max(17.0, size.width * .06);
    final inset = strokeWidth / 2;
    final paint = Paint()
      ..color = color.withValues(alpha: .82)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    canvas.drawArc(rect, math.pi * .75, math.pi * 1.5, false, paint);
  }

  @override
  bool shouldRepaint(covariant _OpenRingPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _FastingView extends ConsumerWidget {
  const _FastingView({
    super.key,
    required this.session,
    required this.now,
    required this.onEnd,
    required this.onAdjust,
    required this.onDiscomfort,
  });
  final FastingSession session;
  final DateTime now;
  final VoidCallback onEnd;
  final VoidCallback onAdjust;
  final VoidCallback onDiscomfort;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final started = DateTime.fromMillisecondsSinceEpoch(
      session.startedAtUtcMs,
      isUtc: true,
    ).toLocal();
    final elapsed = now.difference(started);
    final target = Duration(minutes: session.targetMinutes);
    final remaining = target - elapsed;
    final completed = remaining.isNegative;
    final shown = completed ? elapsed - target : remaining;
    final progress = math.min(
      1.0,
      math.max(0.0, elapsed.inSeconds / target.inSeconds),
    );
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        22,
        14,
        22,
        kFloatingNavigationClearance,
      ),
      children: [
        Center(
          child: SizedBox(
            width: 218,
            height: 218,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 210,
                  height: 210,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    strokeCap: StrokeCap.round,
                    backgroundColor: AppColors.accentTint,
                    color: AppColors.accent,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _duration(shown.abs()),
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1.2,
                        color: AppColors.strong,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      completed
                          ? (Localizations.localeOf(context).languageCode ==
                                    'zh'
                                ? '已超过目标'
                                : 'Past your goal')
                          : (Localizations.localeOf(context).languageCode ==
                                    'zh'
                                ? '距进食窗口开启'
                                : 'Until eating window'),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.faint,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentTint,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        s.fastingNow,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        OutlinedButton(onPressed: onEnd, child: Text(s.endFast)),
        TextButton(onPressed: onAdjust, child: Text(s.adjustTime)),
        const SizedBox(height: 18),
        const _TodayTrackingSection(),
        const SizedBox(height: 18),
        LighterCard(
          color: const Color(0xFFFFFBF3),
          onTap: onDiscomfort,
          child: Row(
            children: [
              const Icon(CupertinoIcons.heart, color: AppColors.warning),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.discomfort,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      Localizations.localeOf(context).languageCode == 'zh'
                          ? '不舒服可以随时结束，这很正常'
                          : 'You can stop anytime. That is completely okay.',
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
        SectionTitle(
          Localizations.localeOf(context).languageCode == 'zh'
              ? '温和建议'
              : 'Gentle tip',
        ),
        LighterCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(CupertinoIcons.sparkles, color: AppColors.accent),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  Localizations.localeOf(context).languageCode == 'zh'
                      ? '感到饥饿很常见。喝口水、走一走，身体通常会慢慢适应。'
                      : 'Hunger can be normal. Sip some water, move gently, and give your body time to settle.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _duration(Duration value) {
    final hours = value.inHours.toString().padLeft(2, '0');
    final minutes = (value.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (value.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}

class _EndedView extends StatelessWidget {
  const _EndedView({super.key, required this.session, required this.onRestart});
  final FastingSession session;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final duration = Duration(
      milliseconds:
          (session.endedAtUtcMs ?? session.updatedAtUtcMs) -
          session.startedAtUtcMs,
    );
    final target = Duration(minutes: session.targetMinutes);
    final pct = ((duration.inSeconds / target.inSeconds) * 100)
        .clamp(0, 999)
        .round();
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        22,
        32,
        22,
        kFloatingNavigationClearance,
      ),
      children: [
        const Center(
          child: CircleAvatar(
            radius: 38,
            backgroundColor: AppColors.accentTint,
            child: Icon(
              CupertinoIcons.check_mark,
              size: 30,
              color: AppColors.accent,
            ),
          ),
        ),
        const SizedBox(height: 22),
        Text(
          s.endedTitle,
          style: Theme.of(context).textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          s.endedBody,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 26),
        Row(
          children: [
            Expanded(
              child: _stat(
                context,
                '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}',
                Localizations.localeOf(context).languageCode == 'zh'
                    ? '本次时长'
                    : 'Duration',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _stat(
                context,
                '$pct%',
                Localizations.localeOf(context).languageCode == 'zh'
                    ? '计划达成'
                    : 'Of plan',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: onRestart,
          child: Text(
            Localizations.localeOf(context).languageCode == 'zh'
                ? '返回今日'
                : 'Back to Today',
          ),
        ),
        const SizedBox(height: 26),
        const _TodayTrackingSection(),
      ],
    );
  }

  Widget _stat(BuildContext context, String value, String label) => LighterCard(
    child: Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 5),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    ),
  );
}

class _PlanPickerSheet extends ConsumerStatefulWidget {
  const _PlanPickerSheet({required this.plan});
  final FastingPlan plan;

  @override
  ConsumerState<_PlanPickerSheet> createState() => _PlanPickerSheetState();
}

class _PlanPickerSheetState extends ConsumerState<_PlanPickerSheet> {
  late int selected = widget.plan.fastMinutes;
  late int group = _planGroupIndex(widget.plan.fastMinutes);

  @override
  Widget build(BuildContext context) {
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    final groups = _planGroups(zh);
    final options = groups[group].options;
    return SizedBox(
      height: math.min(MediaQuery.sizeOf(context).height * .8, 700),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            zh ? '调整断食计划' : 'Adjust fasting plan',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 5),
          Text(
            zh
                ? '选择适合当前生活节奏的计划，之后仍可随时更改。'
                : 'Choose a rhythm that fits your life. You can change it anytime.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          SegmentedButton<int>(
            segments: List.generate(
              groups.length,
              (index) =>
                  ButtonSegment(value: index, label: Text(groups[index].name)),
            ),
            selected: {group},
            showSelectedIcon: false,
            onSelectionChanged: (value) => setState(() => group = value.first),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView.separated(
              itemCount: options.length + (group == 2 ? 1 : 0),
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                if (index == options.length) {
                  return Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8EA),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      zh
                          ? '高级计划对身体要求更高。如有不适请立即停止；有健康问题或用药时请先咨询专业人士。'
                          : 'Advanced plans are more demanding. Stop if unwell and consult a professional for health conditions or medication.',
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.45,
                        color: AppColors.warning,
                      ),
                    ),
                  );
                }
                final option = options[index];
                return _PlanOptionTile(
                  option: option,
                  startMinute: widget.plan.startMinuteOfDay,
                  selected: selected == option.fastMinutes,
                  onTap: () => setState(() => selected = option.fastMinutes),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          FilledButton(
            onPressed: _save,
            child: Text(zh ? '使用这个计划' : 'Use this plan'),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final repository = ref.read(repositoryProvider);
    await repository.updatePlan(
      fastMinutes: selected,
      startMinuteOfDay: widget.plan.startMinuteOfDay,
    );
    if (await repository.getPreference('reminderStart') == 'true') {
      await ref
          .read(notificationServiceProvider)
          .scheduleDailyStartReminder(widget.plan.startMinuteOfDay);
    }
    if (mounted) Navigator.pop(context);
  }
}

class _PlanOptionTile extends StatelessWidget {
  const _PlanOptionTile({
    required this.option,
    required this.startMinute,
    required this.selected,
    required this.onTap,
  });
  final _PlanOption option;
  final int startMinute;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    final endMinute = (startMinute + option.fastMinutes) % 1440;
    return LighterCard(
      onTap: onTap,
      color: selected ? AppColors.accentTint : AppColors.surface,
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.accent : AppColors.surface2,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _planRatio(option.fastMinutes),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : AppColors.strong,
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 3),
                Text(
                  zh
                      ? '断食 ${_hours(option.fastMinutes)} · 进餐 ${_hours(1440 - option.fastMinutes)}'
                      : 'Fast ${_hours(option.fastMinutes)} · Eat ${_hours(1440 - option.fastMinutes)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  zh
                      ? '${_formatMinute(startMinute)}—${_formatMinute(endMinute)} 断食'
                      : 'Fast ${_formatMinute(startMinute)}—${_formatMinute(endMinute)}',
                  style: const TextStyle(fontSize: 11, color: AppColors.faint),
                ),
              ],
            ),
          ),
          Icon(
            selected
                ? CupertinoIcons.check_mark_circled_solid
                : CupertinoIcons.circle,
            color: selected ? AppColors.accent : AppColors.borderStrong,
          ),
        ],
      ),
    );
  }
}

class _TodayTrackingSection extends ConsumerWidget {
  const _TodayTrackingSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(
          zh ? '每日任务' : 'Daily essentials',
          action: TextButton.icon(
            onPressed: () => showTaskManagerSheet(context),
            icon: const Icon(CupertinoIcons.slider_horizontal_3, size: 15),
            label: Text(zh ? '管理' : 'Manage'),
          ),
        ),
        const UnifiedDailyTaskGrid(),
        const SizedBox(height: 10),
        Text(
          zh ? '按自己的节奏完成，今天记录一点就很好。' : 'A little progress still counts.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11, color: AppColors.faint),
        ),
      ],
    );
  }
}

class _PlanGroup {
  const _PlanGroup(this.name, this.options);
  final String name;
  final List<_PlanOption> options;
}

class _PlanOption {
  const _PlanOption(this.fastMinutes, this.name);
  final int fastMinutes;
  final String name;
}

List<_PlanGroup> _planGroups(bool zh) => [
  _PlanGroup(zh ? '基础计划' : 'Basic', [
    _PlanOption(600, zh ? '轻松起步' : 'Easy start'),
    _PlanOption(660, zh ? '稳定节奏' : 'Steady rhythm'),
    _PlanOption(720, zh ? '温和入门' : 'Gentle start'),
    _PlanOption(780, zh ? '逐步适应' : 'Build gradually'),
  ]),
  _PlanGroup(zh ? '进阶计划' : 'Progressive', [
    _PlanOption(840, zh ? '进阶起步' : 'Progressive start'),
    _PlanOption(900, zh ? '延长窗口' : 'Longer fast'),
    _PlanOption(960, zh ? '经典进阶' : 'Classic advanced'),
    _PlanOption(1020, zh ? '稳步挑战' : 'Steady challenge'),
  ]),
  _PlanGroup(zh ? '高级计划' : 'Advanced', [
    _PlanOption(1080, zh ? '高级起步' : 'Advanced start'),
    _PlanOption(1140, zh ? '窄进食窗' : 'Narrow window'),
    _PlanOption(1200, zh ? '深度计划' : 'Deep fast'),
    _PlanOption(1380, zh ? '每日一餐' : 'One meal a day'),
  ]),
];

int _planGroupIndex(int minutes) => minutes < 840
    ? 0
    : minutes < 1080
    ? 1
    : 2;

String _planRatio(int fastMinutes) =>
    '${_hours(fastMinutes)}:${_hours(1440 - fastMinutes)}';

String _hours(int minutes) =>
    minutes % 60 == 0 ? '${minutes ~/ 60}' : (minutes / 60).toStringAsFixed(1);

String _formatMinute(int minute) =>
    '${(minute ~/ 60).toString().padLeft(2, '0')}:'
    '${(minute % 60).toString().padLeft(2, '0')}';

class _AdjustFastSheet extends ConsumerStatefulWidget {
  const _AdjustFastSheet({required this.session});
  final FastingSession session;

  @override
  ConsumerState<_AdjustFastSheet> createState() => _AdjustFastSheetState();
}

class _AdjustFastSheetState extends ConsumerState<_AdjustFastSheet> {
  late DateTime start;
  late int duration;

  @override
  void initState() {
    super.initState();
    start = DateTime.fromMillisecondsSinceEpoch(
      widget.session.startedAtUtcMs,
      isUtc: true,
    ).toLocal();
    duration = widget.session.targetMinutes;
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(s.adjustTime, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(
          zh
              ? '这次调整只影响本轮，不会改变你的日常计划。'
              : 'This only changes the current fast, not your regular plan.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 22),
        LighterCard(
          onTap: _pickStart,
          child: Row(
            children: [
              Expanded(child: Text(zh ? '开始时间' : 'Start time')),
              Text(
                DateFormat.Hm().format(start),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SegmentedButton<int>(
          segments: const [
            ButtonSegment(value: 600, label: Text('10h')),
            ButtonSegment(value: 720, label: Text('12h')),
            ButtonSegment(value: 840, label: Text('14h')),
            ButtonSegment(value: 960, label: Text('16h')),
          ],
          selected: {duration},
          onSelectionChanged: (v) => setState(() => duration = v.first),
          showSelectedIcon: false,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(s.cancel),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton(onPressed: _save, child: Text(s.save)),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickStart() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(start),
    );
    if (picked == null) return;
    setState(
      () => start = DateTime(
        start.year,
        start.month,
        start.day,
        picked.hour,
        picked.minute,
      ),
    );
  }

  Future<void> _save() async {
    await ref
        .read(repositoryProvider)
        .adjustActiveFast(start: start, targetMinutes: duration);
    final waterEnabled =
        await ref.read(repositoryProvider).getPreference('reminderWater') ==
        'true';
    await ref
        .read(notificationServiceProvider)
        .scheduleFastNotifications(
          start: start,
          end: start.add(Duration(minutes: duration)),
          waterEnabled: waterEnabled,
        );
    if (mounted) Navigator.pop(context);
  }
}

class _DiscomfortSheet extends StatefulWidget {
  const _DiscomfortSheet();
  @override
  State<_DiscomfortSheet> createState() => _DiscomfortSheetState();
}

class _DiscomfortSheetState extends State<_DiscomfortSheet> {
  final selected = <String>{};
  @override
  Widget build(BuildContext context) {
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    final s = AppLocalizations.of(context);
    final options = zh
        ? const {
            'dizzy': '头晕',
            'shaky': '心慌',
            'hungry': '极度饥饿',
            'cold': '发冷',
            'other': '其他',
          }
        : const {
            'dizzy': 'Dizzy',
            'shaky': 'Shaky',
            'hungry': 'Very hungry',
            'cold': 'Cold',
            'other': 'Other',
          };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          zh ? '先照顾自己' : 'Take care of yourself first',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          zh
              ? '结束断食是合理的选择，不算失败。严重不适请咨询医生。'
              : 'Ending is a reasonable choice, not a failure. Seek care for severe symptoms.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.entries
              .map(
                (item) => FilterChip(
                  selected: selected.contains(item.key),
                  label: Text(item.value),
                  onSelected: (_) => setState(
                    () => selected.contains(item.key)
                        ? selected.remove(item.key)
                        : selected.add(item.key),
                  ),
                  selectedColor: AppColors.accentTint,
                  checkmarkColor: AppColors.accent,
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(zh ? '继续坚持' : 'Keep going'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton(
                onPressed: () => Navigator.pop(context, selected.toList()),
                child: Text(s.endFast),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
