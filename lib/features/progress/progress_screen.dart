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

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  bool monthRange = false;
  DateTime calendarMonth = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final sessions =
        ref.watch(sessionHistoryProvider).valueOrNull ??
        const <FastingSession>[];
    final weights =
        ref.watch(weightsProvider).valueOrNull ?? const <WeightEntry>[];
    final locale = Localizations.localeOf(context);
    final date = DateFormat(
      locale.languageCode == 'zh' ? 'M月d日 EEEE' : 'EEE, MMM d',
      locale.toLanguageTag(),
    ).format(DateTime.now());
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          ScreenHeader(
            title: s.progress,
            subtitle: date,
            actions: [
              IconButton(
                onPressed: _toggleLanguage,
                tooltip: s.language,
                icon: const Icon(CupertinoIcons.globe, size: 20),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                22,
                8,
                22,
                kFloatingNavigationClearance,
              ),
              children: [
                _OverviewCard(
                  sessions: sessions,
                  month: monthRange,
                  onToggle: () => setState(() => monthRange = !monthRange),
                ),
                const SizedBox(height: 24),
                SectionTitle(s.fastingCalendar),
                _CalendarCard(
                  month: calendarMonth,
                  sessions: sessions,
                  onPrevious: () => setState(
                    () => calendarMonth = DateTime(
                      calendarMonth.year,
                      calendarMonth.month - 1,
                    ),
                  ),
                  onNext: () => setState(
                    () => calendarMonth = DateTime(
                      calendarMonth.year,
                      calendarMonth.month + 1,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SectionTitle(
                  s.weightTrend,
                  action: TextButton(
                    onPressed: _addWeight,
                    child: Text(s.recordWeight),
                  ),
                ),
                _WeightCard(
                  weights: weights,
                  metric:
                      ref.watch(appControllerProvider).unitSystem ==
                      UnitSystem.metric,
                  onAdd: _addWeight,
                ),
                const SizedBox(height: 24),
                SectionTitle(s.history),
                _HistoryCard(sessions: sessions, onTap: _showSession),
                const SizedBox(height: 24),
                SectionTitle(s.weeklyInsight),
                LighterCard(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFF0EEFF), Color(0xFFF8F6FF)],
                  ),
                  onTap: () => showMessage(
                    context,
                    '${s.weeklyInsight} · ${s.comingSoon}',
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.sparkles,
                            size: 18,
                            color: AppColors.plus,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Lighter Plus',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: AppColors.plus),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        s.comingSoon,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        locale.languageCode == 'zh'
                            ? '未来将基于同步后的真实趋势提供个性化洞察。'
                            : 'Personalized insights will use your real synced trends in a future release.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addWeight() async =>
      showLighterSheet<void>(context, const _WeightSheet());

  Future<void> _showSession(FastingSession session) async =>
      showLighterSheet<void>(context, _SessionDetail(session: session));

  Future<void> _toggleLanguage() async {
    final controller = ref.read(appControllerProvider);
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    await controller.setLanguage(
      zh ? LanguagePreference.en : LanguagePreference.zh,
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.sessions,
    required this.month,
    required this.onToggle,
  });
  final List<FastingSession> sessions;
  final bool month;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final start = month
        ? DateTime(now.year, now.month)
        : now.subtract(Duration(days: now.weekday - 1));
    final filtered = sessions
        .where(
          (item) => DateTime.fromMillisecondsSinceEpoch(
            item.startedAtUtcMs,
            isUtc: true,
          ).toLocal().isAfter(start.subtract(const Duration(milliseconds: 1))),
        )
        .toList();
    final ended = filtered.where((item) => item.endedAtUtcMs != null).toList();
    final complete = ended
        .where(
          (item) =>
              (item.endedAtUtcMs! - item.startedAtUtcMs) >=
              item.targetMinutes * 60000,
        )
        .length;
    final avgMinutes = ended.isEmpty
        ? 0
        : ended
                  .map(
                    (item) =>
                        (item.endedAtUtcMs! - item.startedAtUtcMs) ~/ 60000,
                  )
                  .reduce((a, b) => a + b) ~/
              ended.length;
    final consistency = ended.isEmpty
        ? 0
        : ((complete / ended.length) * 100).round();
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    return LighterCard(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFEAF7FF), Color(0xFFF4F1FF)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  zh
                      ? '本${month ? '月' : '周'}概览'
                      : month
                      ? 'This month'
                      : 'This week',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextButton(
                onPressed: onToggle,
                child: Text(
                  zh ? (month ? '本月' : '本周') : (month ? 'Month' : 'Week'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _overviewStat(
                  context,
                  '$complete',
                  zh ? '完成次数' : 'Completed',
                  CupertinoIcons.check_mark_circled_solid,
                  AppColors.water,
                  AppColors.waterTint,
                ),
              ),
              Expanded(
                child: _overviewStat(
                  context,
                  '${avgMinutes ~/ 60}:${(avgMinutes % 60).toString().padLeft(2, '0')}',
                  zh ? '平均时长' : 'Average',
                  CupertinoIcons.timer,
                  AppColors.purple,
                  AppColors.purpleTint,
                ),
              ),
              Expanded(
                child: _overviewStat(
                  context,
                  '$consistency%',
                  zh ? '坚持度' : 'Consistency',
                  CupertinoIcons.flame_fill,
                  AppColors.coral,
                  AppColors.coralTint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .62),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Text(
              zh
                  ? '不追求每天，稳定就好。休息日也是计划的一部分。'
                  : 'Not every day — steady is enough. Rest days are part of the plan.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _overviewStat(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color accent,
    Color tint,
  ) => Column(
    children: [
      Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
        child: Icon(icon, size: 17, color: accent),
      ),
      const SizedBox(height: 8),
      Text(
        value,
        style: const TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.w700,
          color: AppColors.strong,
        ),
      ),
      const SizedBox(height: 5),
      Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 11, color: AppColors.faint),
      ),
    ],
  );
}

class _CalendarCard extends StatelessWidget {
  const _CalendarCard({
    required this.month,
    required this.sessions,
    required this.onPrevious,
    required this.onNext,
  });
  final DateTime month;
  final List<FastingSession> sessions;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final zh = locale.languageCode == 'zh';
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leading = first.weekday % 7;
    final status = <int, String>{};
    for (final item in sessions) {
      final local = DateTime.fromMillisecondsSinceEpoch(
        item.startedAtUtcMs,
        isUtc: true,
      ).toLocal();
      if (local.year != month.year || local.month != month.month) continue;
      if (item.endedAtUtcMs == null) {
        status[local.day] = 'active';
      } else {
        status[local.day] =
            (item.endedAtUtcMs! - item.startedAtUtcMs) >=
                item.targetMinutes * 60000
            ? 'done'
            : 'partial';
      }
    }
    final labels = zh
        ? const ['日', '一', '二', '三', '四', '五', '六']
        : const ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return LighterCard(
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onPrevious,
                icon: const Icon(CupertinoIcons.chevron_left, size: 18),
              ),
              Expanded(
                child: Text(
                  DateFormat(
                    zh ? 'y年M月' : 'MMMM y',
                    locale.toLanguageTag(),
                  ).format(month),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                onPressed: onNext,
                icon: const Icon(CupertinoIcons.chevron_right, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisExtent: 38,
            ),
            itemCount: 7 + leading + daysInMonth,
            itemBuilder: (context, index) {
              if (index < 7) {
                return Center(
                  child: Text(
                    labels[index],
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.faint,
                    ),
                  ),
                );
              }
              final day = index - 7 - leading + 1;
              if (day < 1 || day > daysInMonth) return const SizedBox.shrink();
              final value = status[day];
              final today = DateTime.now();
              final isToday =
                  today.year == month.year &&
                  today.month == month.month &&
                  today.day == day;
              final color = value == 'done'
                  ? AppColors.accent
                  : value == 'partial'
                  ? AppColors.accentSoft
                  : value == 'active'
                  ? AppColors.warning
                  : Colors.transparent;
              return Center(
                child: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: isToday
                        ? Border.all(color: AppColors.strong, width: 1.2)
                        : null,
                  ),
                  child: Text(
                    '$day',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                      color: value == 'done'
                          ? Colors.white
                          : AppColors.foreground,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legend(AppColors.accent, zh ? '完成' : 'Done'),
              const SizedBox(width: 14),
              _legend(AppColors.accentSoft, zh ? '提前结束' : 'Early end'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legend(Color color, String label) => Row(
    children: [
      Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 5),
      Text(label, style: const TextStyle(fontSize: 11, color: AppColors.faint)),
    ],
  );
}

class _WeightCard extends StatelessWidget {
  const _WeightCard({
    required this.weights,
    required this.metric,
    required this.onAdd,
  });
  final List<WeightEntry> weights;
  final bool metric;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    if (weights.isEmpty) {
      return LighterCard(
        onTap: onAdd,
        child: Column(
          children: [
            const Icon(
              CupertinoIcons.graph_square,
              size: 34,
              color: AppColors.accent,
            ),
            const SizedBox(height: 10),
            Text(
              Localizations.localeOf(context).languageCode == 'zh'
                  ? '记录第一次体重，开始查看趋势'
                  : 'Log your first weight to begin a trend',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }
    final latest = weights.last.kilograms;
    final display = metric ? latest : latest * 2.2046226218;
    return LighterCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                display.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                metric ? 'kg' : 'lb',
                style: const TextStyle(color: AppColors.faint),
              ),
              const Spacer(),
              IconButton.filled(
                onPressed: onAdd,
                icon: const Icon(CupertinoIcons.add, size: 18),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 105,
            width: double.infinity,
            child: CustomPaint(
              painter: _WeightChartPainter(
                weights.map((e) => e.kilograms).toList(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            Localizations.localeOf(context).languageCode == 'zh'
                ? '数值只是参考，不定义你的努力。'
                : 'Numbers are reference, not a verdict.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _WeightChartPainter extends CustomPainter {
  _WeightChartPainter(this.values);
  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height - 8),
      Offset(size.width, size.height - 8),
      gridPaint,
    );
    if (values.length == 1) {
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        4,
        Paint()..color = AppColors.accent,
      );
      return;
    }
    final minV = values.reduce(math.min);
    final maxV = values.reduce(math.max);
    final span = math.max(.5, maxV - minV);
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = i * size.width / (values.length - 1);
      final y = 8 + (size.height - 20) * (1 - (values[i] - minV) / span);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _WeightChartPainter oldDelegate) =>
      oldDelegate.values != values;
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.sessions, required this.onTap});
  final List<FastingSession> sessions;
  final ValueChanged<FastingSession> onTap;

  @override
  Widget build(BuildContext context) {
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    if (sessions.isEmpty) {
      return LighterCard(
        child: Text(
          zh
              ? '完成一次断食后，记录会出现在这里。'
              : 'Your records will appear here after your first fast.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    return Card(
      child: Column(
        children: sessions.take(8).map((item) {
          final start = DateTime.fromMillisecondsSinceEpoch(
            item.startedAtUtcMs,
            isUtc: true,
          ).toLocal();
          final ended = item.endedAtUtcMs;
          final duration = ended == null
              ? DateTime.now().difference(start)
              : Duration(milliseconds: ended - item.startedAtUtcMs);
          final complete =
              ended != null && duration.inMinutes >= item.targetMinutes;
          return Column(
            children: [
              InkWell(
                onTap: () => onTap(item),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 13,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 46,
                        child: Column(
                          children: [
                            Text(
                              '${start.day}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              DateFormat.MMM().format(start),
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.faint,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${item.targetMinutes ~/ 60}:${(24 - item.targetMinutes ~/ 60)}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')} / ${item.targetMinutes ~/ 60}:00',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: ended == null
                              ? const Color(0xFFFFF5DF)
                              : complete
                              ? AppColors.accentTint
                              : AppColors.surface2,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          ended == null
                              ? (zh ? '进行中' : 'Active')
                              : complete
                              ? (zh ? '完成' : 'Done')
                              : (zh ? '提前结束' : 'Early'),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: ended == null
                                ? AppColors.warning
                                : complete
                                ? AppColors.accent
                                : AppColors.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (item != sessions.take(8).last)
                const Divider(height: 1, indent: 16, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _WeightSheet extends ConsumerStatefulWidget {
  const _WeightSheet();
  @override
  ConsumerState<_WeightSheet> createState() => _WeightSheetState();
}

class _WeightSheetState extends ConsumerState<_WeightSheet> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final metric =
        ref.watch(appControllerProvider).unitSystem == UnitSystem.metric;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(s.recordWeight, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(
          Localizations.localeOf(context).languageCode == 'zh'
              ? '不必每天记录，一天中任意时间都可以。'
              : 'No need to log daily. Any time of day is fine.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 18),
        TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: metric ? 'kg' : 'lb',
            suffixText: metric ? 'kg' : 'lb',
          ),
        ),
        const SizedBox(height: 20),
        FilledButton(onPressed: _save, child: Text(s.save)),
      ],
    );
  }

  Future<void> _save() async {
    final value = double.tryParse(controller.text.trim());
    if (value == null) return;
    final metric =
        ref.read(appControllerProvider).unitSystem == UnitSystem.metric;
    final kg = metric ? value : value / 2.2046226218;
    try {
      await ref.read(repositoryProvider).addWeight(kilograms: kg);
      if (mounted) Navigator.pop(context);
    } on FormatException catch (error) {
      if (mounted) showMessage(context, error.message);
    }
  }
}

class _SessionDetail extends StatelessWidget {
  const _SessionDetail({required this.session});
  final FastingSession session;

  @override
  Widget build(BuildContext context) {
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    final start = DateTime.fromMillisecondsSinceEpoch(
      session.startedAtUtcMs,
      isUtc: true,
    ).toLocal();
    final end = session.endedAtUtcMs == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            session.endedAtUtcMs!,
            isUtc: true,
          ).toLocal();
    final duration = end == null
        ? DateTime.now().difference(start)
        : end.difference(start);
    final complete = duration.inMinutes >= session.targetMinutes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          zh ? '单次记录' : 'Record',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              '${session.targetMinutes ~/ 60}:${24 - session.targetMinutes ~/ 60}',
              style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: complete ? AppColors.accentTint : AppColors.surface2,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                complete ? (zh ? '完成' : 'Done') : (zh ? '提前结束' : 'Early end'),
                style: TextStyle(
                  color: complete ? AppColors.accent : AppColors.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _row(zh ? '日期' : 'Date', DateFormat.yMMMd().format(start)),
        _row(
          zh ? '断食时长' : 'Fast length',
          '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}',
        ),
        _row(zh ? '开始时间' : 'Started', DateFormat.Hm().format(start)),
        _row(
          zh ? '结束时间' : 'Ended',
          end == null ? '—' : DateFormat.Hm().format(end),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            complete
                ? (zh
                      ? '一次完整的断食。节奏稳定，继续保持。'
                      : 'A complete fast. Keep your steady rhythm.')
                : (zh
                      ? '提前结束也是完整记录。身体需要时停下是正确选择。'
                      : 'Ending early is still a complete record. Stopping when your body asks is right.'),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context).close),
        ),
      ],
    );
  }

  Widget _row(String key, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Expanded(
          child: Text(key, style: const TextStyle(color: AppColors.muted)),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}
