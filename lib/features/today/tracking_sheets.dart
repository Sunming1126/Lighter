import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app_state.dart';
import '../../core/contracts.dart';
import '../../core/theme/app_theme.dart';
import '../../data/database/app_database.dart';
import '../../shared/widgets.dart';

Future<T?> showTrackingSheet<T>(BuildContext context, Widget child) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.strong.withValues(alpha: .38),
    builder: (context) => AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: FractionallySizedBox(
        heightFactor: .92,
        alignment: Alignment.bottomCenter,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: Material(color: AppColors.background, child: child),
        ),
      ),
    ),
  );
}

class TrackingSheetFrame extends StatelessWidget {
  const TrackingSheetFrame({
    required this.title,
    required this.subtitle,
    required this.child,
    this.trailing,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const SizedBox(height: 9),
      Container(
        width: 42,
        height: 5,
        decoration: BoxDecoration(
          color: AppColors.borderStrong,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(18, 11, 12, 10),
        child: Row(
          children: [
            IconButton.filledTonal(
              onPressed: () => Navigator.pop(context),
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              icon: const Icon(CupertinoIcons.xmark, size: 17),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.strong,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.faint,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 48, child: trailing),
          ],
        ),
      ),
      const Divider(height: 1),
      Expanded(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 34),
          child: child,
        ),
      ),
    ],
  );
}

class WaterTrackingSheet extends ConsumerStatefulWidget {
  const WaterTrackingSheet({super.key});

  @override
  ConsumerState<WaterTrackingSheet> createState() => _WaterTrackingSheetState();
}

class _WaterTrackingSheetState extends ConsumerState<WaterTrackingSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _wave = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  )..repeat();

  @override
  void dispose() {
    _wave.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final zh = _zh(context);
    final dateKey = localDateKey(DateTime.now());
    final entries =
        ref.watch(dailyWaterProvider(dateKey)).valueOrNull ?? const [];
    final app = ref.watch(appControllerProvider);
    final total = entries.fold<int>(0, (sum, entry) => sum + entry.milliliters);
    final goal = app.waterGoalMl;
    final remaining = math.max(0, goal - total);
    final progress = goal == 0 ? 0.0 : (total / goal).clamp(0.0, 1.0);
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return TrackingSheetFrame(
      title: zh ? '喝水追踪' : 'Water tracking',
      subtitle: DateFormat(
        zh ? 'M月d日 EEEE' : 'EEEE, MMM d',
      ).format(DateTime.now()),
      trailing: IconButton(
        onPressed: () => _editGoal(context, app.waterGoalMl),
        tooltip: zh ? '调整目标' : 'Edit goal',
        icon: const Icon(CupertinoIcons.slider_horizontal_3, size: 20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MetricHeadline(
            value: '$total',
            unit: 'ml',
            caption: remaining == 0
                ? (zh ? '今日目标已完成' : 'Today’s goal is complete')
                : (zh ? '还差 $remaining ml 喝够' : '$remaining ml remaining'),
            goal: zh ? '目标 $goal ml' : 'Goal $goal ml',
            onGoalTap: () => _editGoal(context, goal),
          ),
          const SizedBox(height: 18),
          Center(
            child: SizedBox.square(
              dimension: 248,
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: progress),
                duration: reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 650),
                curve: Curves.easeOutCubic,
                builder: (context, level, _) => AnimatedBuilder(
                  animation: _wave,
                  builder: (context, _) => CustomPaint(
                    painter: _WaterVesselPainter(
                      level: level,
                      phase: reduceMotion ? 0 : _wave.value,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            progress >= 1
                                ? CupertinoIcons.check_mark_circled_solid
                                : CupertinoIcons.drop_fill,
                            color: progress >= 1
                                ? AppColors.accentPressed
                                : AppColors.accent,
                            size: 26,
                          ),
                          const SizedBox(height: 7),
                          Text(
                            '${(total / math.max(1, goal) * 100).round()}%',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: AppColors.strong,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              SizedBox.square(
                dimension: 56,
                child: IconButton.filledTonal(
                  onPressed: entries.isEmpty ? null : _undo,
                  tooltip: zh ? '撤销最近一次' : 'Undo latest',
                  icon: const Icon(CupertinoIcons.minus),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _add,
                  icon: const Icon(CupertinoIcons.plus, size: 20),
                  label: Text('+ ${app.quickWaterMl} ml'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          _Panel(
            title: zh ? '每次增加' : 'Quick amount',
            child: Wrap(
              spacing: 9,
              runSpacing: 9,
              children: [
                for (final amount in const [100, 250, 350, 500])
                  ChoiceChip(
                    label: Text('$amount ml'),
                    selected: app.quickWaterMl == amount,
                    onSelected: (_) => app.setQuickWater(amount),
                  ),
                ActionChip(
                  avatar: const Icon(CupertinoIcons.pencil, size: 15),
                  label: Text(zh ? '自定义' : 'Custom'),
                  onPressed: () => _editQuickAmount(context, app.quickWaterMl),
                ),
              ],
            ),
          ),
          if (entries.isNotEmpty) ...[
            const SizedBox(height: 14),
            _Panel(
              title: zh ? '今日明细' : 'Today’s entries',
              child: Column(
                children: [
                  for (final entry in entries.reversed.take(6))
                    _HistoryRow(
                      icon: CupertinoIcons.drop_fill,
                      title: '+${entry.milliliters} ml',
                      subtitle: DateFormat('HH:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(
                          entry.loggedAtUtcMs,
                          isUtc: true,
                        ).toLocal(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _add() async {
    final app = ref.read(appControllerProvider);
    await ref.read(repositoryProvider).addWater(milliliters: app.quickWaterMl);
  }

  Future<void> _undo() async {
    await ref.read(repositoryProvider).undoLatestWaterForDay(DateTime.now());
  }

  Future<void> _editGoal(BuildContext context, int current) async {
    final result = await _integerDialog(
      context,
      title: _zh(context) ? '每日饮水目标' : 'Daily water goal',
      initialValue: current,
      suffix: 'ml',
      min: 250,
      max: 10000,
    );
    if (result != null) {
      await ref.read(appControllerProvider).setWaterGoal(result);
    }
  }

  Future<void> _editQuickAmount(BuildContext context, int current) async {
    final result = await _integerDialog(
      context,
      title: _zh(context) ? '自定义单次容量' : 'Custom quick amount',
      initialValue: current,
      suffix: 'ml',
      min: 10,
      max: 5000,
    );
    if (result != null) {
      await ref.read(appControllerProvider).setQuickWater(result);
    }
  }
}

class WeightTrackingSheet extends ConsumerStatefulWidget {
  const WeightTrackingSheet({super.key});

  @override
  ConsumerState<WeightTrackingSheet> createState() =>
      _WeightTrackingSheetState();
}

class _WeightTrackingSheetState extends ConsumerState<WeightTrackingSheet> {
  final _controller = TextEditingController();
  double? _selectedKg;
  int _days = 7;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final zh = _zh(context);
    final app = ref.watch(appControllerProvider);
    final metric = app.unitSystem == UnitSystem.metric;
    final weights = ref.watch(weightsProvider).valueOrNull ?? const [];
    final latest = weights.isEmpty ? null : weights.last;
    _selectedKg ??= latest?.kilograms ?? 70;
    if (_controller.text.isEmpty) {
      _controller.text = _displayWeight(
        _selectedKg!,
        metric,
      ).toStringAsFixed(1);
    }
    final previous = weights.length > 1 ? weights[weights.length - 2] : null;
    final first = weights.isEmpty ? null : weights.first;
    final unit = metric ? 'kg' : 'lb';
    final min = metric ? 25.0 : 55.0;
    final max = metric ? 200.0 : 440.0;
    final sliderValue = _displayWeight(_selectedKg!, metric).clamp(min, max);
    return TrackingSheetFrame(
      title: zh ? '体重记录' : 'Weight tracking',
      subtitle: zh ? '关注长期趋势，而不是单次波动' : 'Focus on trends, not one reading',
      trailing: IconButton(
        onPressed: () => _editGoal(context, app.targetWeightKg),
        tooltip: zh ? '目标体重' : 'Target weight',
        icon: const Icon(CupertinoIcons.flag, size: 20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MetricHeadline(
            value: latest == null
                ? '—'
                : _displayWeight(latest.kilograms, metric).toStringAsFixed(1),
            unit: unit,
            caption: previous == null
                ? (zh ? '记录第一次体重，开始观察趋势' : 'Add your first reading')
                : _deltaText(
                    latest!.kilograms - previous.kilograms,
                    metric,
                    zh ? '较上次' : 'Since last',
                  ),
            goal: app.targetWeightKg == null
                ? (zh ? '目标未设置' : 'No target set')
                : '${zh ? '目标' : 'Target'} ${_displayWeight(app.targetWeightKg!, metric).toStringAsFixed(1)} $unit',
            onGoalTap: () => _editGoal(context, app.targetWeightKg),
          ),
          const SizedBox(height: 18),
          _Panel(
            title: zh ? '本次体重' : 'New reading',
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: InputDecoration(suffixText: unit),
                        onChanged: (value) {
                          final parsed = double.tryParse(value);
                          if (parsed != null) {
                            setState(() {
                              _selectedKg = metric
                                  ? parsed
                                  : parsed / 2.2046226218;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _ScaleTicks(value: sliderValue, min: min, max: max),
                Slider(
                  value: sliderValue,
                  min: min,
                  max: max,
                  divisions: ((max - min) * 10).round(),
                  onChanged: (value) => setState(() {
                    _selectedKg = metric ? value : value / 2.2046226218;
                    _controller.text = value.toStringAsFixed(1);
                  }),
                ),
                FilledButton(
                  onPressed: _save,
                  child: Text(zh ? '保存本次体重' : 'Save reading'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _Panel(
            title: zh ? '趋势' : 'Trend',
            trailing: SegmentedButton<int>(
              segments: [
                ButtonSegment(value: 7, label: Text(zh ? '7天' : '7D')),
                ButtonSegment(value: 30, label: Text(zh ? '30天' : '30D')),
              ],
              selected: {_days},
              showSelectedIcon: false,
              onSelectionChanged: (value) =>
                  setState(() => _days = value.first),
              style: const ButtonStyle(
                visualDensity: VisualDensity.compact,
                textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 11)),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _WeightTrendPainter(
                      values: _weightTrend(weights, _days),
                    ),
                  ),
                ),
                if (latest != null && first != null)
                  Text(
                    _deltaText(
                      latest.kilograms - first.kilograms,
                      metric,
                      zh ? '较首次' : 'Since first',
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.muted,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final value = double.tryParse(_controller.text.trim());
    if (value == null) return;
    final metric =
        ref.read(appControllerProvider).unitSystem == UnitSystem.metric;
    try {
      await ref
          .read(repositoryProvider)
          .addWeight(kilograms: metric ? value : value / 2.2046226218);
      if (mounted) FocusScope.of(context).unfocus();
    } on FormatException catch (error) {
      if (mounted) showMessage(context, error.message);
    }
  }

  Future<void> _editGoal(BuildContext context, double? currentKg) async {
    final app = ref.read(appControllerProvider);
    final metric = app.unitSystem == UnitSystem.metric;
    final value = await _decimalDialog(
      context,
      title: _zh(context) ? '目标体重（可选）' : 'Target weight (optional)',
      initialValue: currentKg == null
          ? null
          : _displayWeight(currentKg, metric),
      suffix: metric ? 'kg' : 'lb',
      allowClear: true,
    );
    if (value.cleared) {
      await app.setTargetWeightKg(null);
    } else if (value.value != null) {
      await app.setTargetWeightKg(
        metric ? value.value : value.value! / 2.2046226218,
      );
    }
  }
}

class CalorieTrackingSheet extends ConsumerWidget {
  const CalorieTrackingSheet({super.key});

  static const _colors = {
    'breakfast': Color(0xFFE2B968),
    'lunch': Color(0xFF78A98F),
    'dinner': Color(0xFF7E8EB7),
    'snack': Color(0xFFC78B78),
    'uncategorized': AppColors.faint,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zh = _zh(context);
    final key = localDateKey(DateTime.now());
    final entries =
        ref.watch(calorieEntriesProvider(key)).valueOrNull ?? const [];
    final app = ref.watch(appControllerProvider);
    final totals = <String, int>{};
    for (final entry in entries) {
      totals.update(
        entry.mealType,
        (value) => value + entry.calories,
        ifAbsent: () => entry.calories,
      );
    }
    final total = entries.fold<int>(0, (sum, item) => sum + item.calories);
    final remaining = app.calorieGoal == null
        ? null
        : math.max(0, app.calorieGoal! - total);
    return TrackingSheetFrame(
      title: zh ? '热量记录' : 'Calories',
      subtitle: zh ? '按餐记录，更容易回顾一天' : 'Log by meal for a clearer day',
      trailing: IconButton(
        onPressed: () => _editGoal(context, ref, app.calorieGoal),
        tooltip: zh ? '热量目标' : 'Calorie goal',
        icon: const Icon(CupertinoIcons.flag, size: 20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MetricHeadline(
            value: '$total',
            unit: 'kcal',
            caption: app.calorieGoal == null
                ? (zh ? '今日累计摄入' : 'Total intake today')
                : remaining == 0
                ? (zh ? '已达到今日设定值' : 'Daily target reached')
                : (zh
                      ? '距离设定值还差 $remaining kcal'
                      : '$remaining kcal remaining'),
            goal: app.calorieGoal == null
                ? (zh ? '目标未设置' : 'No target set')
                : '${zh ? '目标' : 'Goal'} ${app.calorieGoal} kcal',
            onGoalTap: () => _editGoal(context, ref, app.calorieGoal),
          ),
          const SizedBox(height: 18),
          Center(
            child: SizedBox.square(
              dimension: 226,
              child: CustomPaint(
                painter: _MealDonutPainter(totals: totals, colors: _colors),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        CupertinoIcons.flame_fill,
                        color: AppColors.warning,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '$total',
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        'kcal',
                        style: TextStyle(color: AppColors.faint),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _Panel(
            title: zh ? '快速记录' : 'Quick log',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final type in const [
                      'breakfast',
                      'lunch',
                      'dinner',
                      'snack',
                    ])
                      ActionChip(
                        avatar: CircleAvatar(
                          radius: 5,
                          backgroundColor: _colors[type],
                        ),
                        label: Text(_mealName(type, zh)),
                        onPressed: () => _showEntryEditor(
                          context,
                          ref,
                          dateKey: key,
                          initialType: type,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: () => _showEntryEditor(
                    context,
                    ref,
                    dateKey: key,
                    initialType: _mealForNow(),
                  ),
                  icon: const Icon(CupertinoIcons.plus),
                  label: Text(zh ? '添加一餐' : 'Add meal entry'),
                ),
              ],
            ),
          ),
          if (entries.isNotEmpty) ...[
            const SizedBox(height: 14),
            _Panel(
              title: zh ? '今日明细' : 'Today’s entries',
              child: Column(
                children: [
                  for (final entry in entries.reversed)
                    _CalorieEntryRow(
                      entry: entry,
                      color: _colors[entry.mealType] ?? AppColors.faint,
                      zh: zh,
                      onEdit: () => _showEntryEditor(
                        context,
                        ref,
                        dateKey: key,
                        initialType: entry.mealType,
                        entry: entry,
                      ),
                      onDelete: () =>
                          ref.read(repositoryProvider).deleteCalorie(entry.id),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _editGoal(
    BuildContext context,
    WidgetRef ref,
    int? current,
  ) async {
    final result = await _integerDialog(
      context,
      title: _zh(context) ? '每日热量设定（可选）' : 'Daily calorie target (optional)',
      initialValue: current ?? 1800,
      suffix: 'kcal',
      min: 500,
      max: 10000,
      allowClear: true,
    );
    if (result == -1) {
      await ref.read(appControllerProvider).setCalorieGoal(null);
    } else if (result != null) {
      await ref.read(appControllerProvider).setCalorieGoal(result);
    }
  }

  Future<void> _showEntryEditor(
    BuildContext context,
    WidgetRef ref, {
    required String dateKey,
    required String initialType,
    CalorieEntry? entry,
  }) async {
    final zh = _zh(context);
    var mealType = initialType;
    final controller = TextEditingController(
      text: entry == null ? '' : '${entry.calories}',
    );
    final save = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            entry == null
                ? (zh ? '添加热量记录' : 'Add calorie entry')
                : (zh ? '编辑热量记录' : 'Edit calorie entry'),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    for (final type in const [
                      'breakfast',
                      'lunch',
                      'dinner',
                      'snack',
                    ])
                      ChoiceChip(
                        label: Text(_mealName(type, zh)),
                        selected: mealType == type,
                        onSelected: (_) => setState(() => mealType = type),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'kcal',
                    suffixText: 'kcal',
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  children: [
                    for (final amount in const [100, 250, 400, 600])
                      ActionChip(
                        label: Text('$amount'),
                        onPressed: () => controller.text = '$amount',
                      ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(zh ? '取消' : 'Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(zh ? '保存' : 'Save'),
            ),
          ],
        ),
      ),
    );
    final calories = int.tryParse(controller.text.trim());
    controller.dispose();
    if (save != true || calories == null) return;
    try {
      if (entry == null) {
        await ref
            .read(repositoryProvider)
            .addCalorie(
              dateKey: dateKey,
              mealType: mealType,
              calories: calories,
            );
      } else {
        await ref
            .read(repositoryProvider)
            .updateCalorie(
              id: entry.id,
              mealType: mealType,
              calories: calories,
            );
      }
    } on FormatException catch (error) {
      if (context.mounted) showMessage(context, error.message);
    }
  }
}

class StepsTrackingSheet extends ConsumerStatefulWidget {
  const StepsTrackingSheet({super.key});

  @override
  ConsumerState<StepsTrackingSheet> createState() => _StepsTrackingSheetState();
}

class _StepsTrackingSheetState extends ConsumerState<StepsTrackingSheet> {
  final _manualController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appControllerProvider).refreshHealthSteps();
    });
  }

  @override
  void dispose() {
    _manualController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final zh = _zh(context);
    final key = localDateKey(DateTime.now());
    final health = ref.watch(dailyHealthProvider(key)).valueOrNull;
    final app = ref.watch(appControllerProvider);
    final steps = health?.steps ?? 0;
    final goal = app.stepGoal;
    final remaining = math.max(0, goal - steps);
    final progress = (steps / math.max(1, goal)).clamp(0.0, 1.0);
    final healthKitActive = health?.stepSource == 'healthkit';
    final fallbackVisible =
        app.healthStepStatus != HealthReadStatus.ready && !healthKitActive;
    return TrackingSheetFrame(
      title: zh ? '步数追踪' : 'Step tracking',
      subtitle: healthKitActive
          ? (zh ? '数据来自 Apple 健康' : 'From Apple Health')
          : (zh
                ? '连接 Apple 健康以自动更新'
                : 'Connect Apple Health for automatic updates'),
      trailing: IconButton(
        onPressed: () => _editGoal(context, goal),
        tooltip: zh ? '步数目标' : 'Step goal',
        icon: const Icon(CupertinoIcons.flag, size: 20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MetricHeadline(
            value: NumberFormat.decimalPattern().format(steps),
            unit: zh ? '步' : 'steps',
            caption: remaining == 0
                ? (zh ? '今日目标已完成' : 'Today’s goal is complete')
                : (zh
                      ? '还差 ${NumberFormat.decimalPattern().format(remaining)} 步'
                      : '${NumberFormat.decimalPattern().format(remaining)} steps remaining'),
            goal:
                '${zh ? '目标' : 'Goal'} ${NumberFormat.decimalPattern().format(goal)}',
            onGoalTap: () => _editGoal(context, goal),
          ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox.square(
              dimension: 232,
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: progress),
                duration: MediaQuery.of(context).disableAnimations
                    ? Duration.zero
                    : const Duration(milliseconds: 700),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) => CustomPaint(
                  painter: _ProgressRingPainter(
                    progress: value,
                    color: AppColors.accent,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.directions_walk_rounded,
                          size: 34,
                          color: AppColors.accent,
                        ),
                        const SizedBox(height: 7),
                        Text(
                          '${(steps / math.max(1, goal) * 100).round()}%',
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _Panel(
            title: zh ? 'Apple 健康' : 'Apple Health',
            trailing: app.syncingHealthSteps
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () => app.refreshHealthSteps(),
                    tooltip: zh ? '刷新' : 'Refresh',
                    icon: const Icon(CupertinoIcons.refresh, size: 18),
                  ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEFF0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        CupertinoIcons.heart_fill,
                        color: Color(0xFFE45C67),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        healthKitActive
                            ? _syncText(health?.stepsSyncedAtUtcMs, zh)
                            : (zh
                                  ? '授权后自动读取 iPhone 与 Apple Watch 的汇总步数。'
                                  : 'Reads the combined total from iPhone and Apple Watch.'),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.muted,
                        ),
                      ),
                    ),
                  ],
                ),
                if (!healthKitActive) ...[
                  const SizedBox(height: 14),
                  FilledButton.tonal(
                    onPressed: app.syncingHealthSteps
                        ? null
                        : () => app.refreshHealthSteps(requestPermission: true),
                    child: Text(zh ? '连接 Apple 健康' : 'Connect Apple Health'),
                  ),
                ],
              ],
            ),
          ),
          if (fallbackVisible) ...[
            const SizedBox(height: 14),
            _Panel(
              title: zh ? '手动兜底' : 'Manual fallback',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    zh
                        ? '仅在 Apple 健康不可用时使用；两种来源不会相加。'
                        : 'Only used when Apple Health is unavailable. Sources are never added together.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _manualController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: zh ? '今日步数' : 'Steps today',
                      suffixText: zh ? '步' : 'steps',
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _saveManual,
                    child: Text(zh ? '保存手动步数' : 'Save manual steps'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _saveManual() async {
    final steps = int.tryParse(_manualController.text.trim());
    if (steps == null) return;
    try {
      await ref
          .read(repositoryProvider)
          .setDailyHealth(
            dateKey: localDateKey(DateTime.now()),
            steps: steps,
            stepSource: 'manual',
          );
      if (mounted) FocusScope.of(context).unfocus();
    } on FormatException catch (error) {
      if (mounted) showMessage(context, error.message);
    }
  }

  Future<void> _editGoal(BuildContext context, int current) async {
    final result = await _integerDialog(
      context,
      title: _zh(context) ? '每日步数目标' : 'Daily step goal',
      initialValue: current,
      suffix: _zh(context) ? '步' : 'steps',
      min: 500,
      max: 100000,
    );
    if (result != null) {
      await ref.read(appControllerProvider).setStepGoal(result);
    }
  }
}

class _MetricHeadline extends StatelessWidget {
  const _MetricHeadline({
    required this.value,
    required this.unit,
    required this.caption,
    required this.goal,
    required this.onGoalTap,
  });

  final String value;
  final String unit;
  final String caption;
  final String goal;
  final VoidCallback onGoalTap;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w700,
                color: AppColors.strong,
                letterSpacing: -1,
              ),
            ),
            TextSpan(
              text: ' $unit',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.muted,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 4),
      Text(caption, style: const TextStyle(color: AppColors.muted)),
      const SizedBox(height: 8),
      TextButton.icon(
        onPressed: onGoalTap,
        icon: const Icon(CupertinoIcons.pencil, size: 14),
        label: Text(goal),
      ),
    ],
  );
}

class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ?trailing,
          ],
        ),
        const SizedBox(height: 14),
        child,
      ],
    ),
  );
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Icon(icon, size: 17, color: AppColors.accent),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: AppColors.faint),
        ),
      ],
    ),
  );
}

class _CalorieEntryRow extends StatelessWidget {
  const _CalorieEntryRow({
    required this.entry,
    required this.color,
    required this.zh,
    required this.onEdit,
    required this.onDelete,
  });

  final CalorieEntry entry;
  final Color color;
  final bool zh;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        CircleAvatar(radius: 6, backgroundColor: color),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _mealName(entry.mealType, zh),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                DateFormat('HH:mm').format(
                  DateTime.fromMillisecondsSinceEpoch(
                    entry.loggedAtUtcMs,
                    isUtc: true,
                  ).toLocal(),
                ),
                style: const TextStyle(fontSize: 11, color: AppColors.faint),
              ),
            ],
          ),
        ),
        Text(
          '${entry.calories} kcal',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        IconButton(
          onPressed: onEdit,
          tooltip: zh ? '编辑' : 'Edit',
          icon: const Icon(CupertinoIcons.pencil, size: 17),
        ),
        IconButton(
          onPressed: onDelete,
          tooltip: zh ? '删除' : 'Delete',
          icon: const Icon(CupertinoIcons.trash, size: 17),
        ),
      ],
    ),
  );
}

class _WaterVesselPainter extends CustomPainter {
  const _WaterVesselPainter({required this.level, required this.phase});

  final double level;
  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    final border = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = AppColors.borderStrong;
    final background = Paint()..color = AppColors.surface;
    canvas.drawCircle(size.center(Offset.zero), size.width / 2 - 2, background);
    canvas.save();
    final clip = Path()
      ..addOval(
        Rect.fromCircle(
          center: size.center(Offset.zero),
          radius: size.width / 2 - 4,
        ),
      );
    canvas.clipPath(clip);
    final waterTop = size.height * (1 - level);
    final path = Path()..moveTo(0, waterTop);
    const waves = 2.0;
    for (double x = 0; x <= size.width; x += 4) {
      final y =
          waterTop +
          math.sin(
                (x / size.width * waves * math.pi * 2) + phase * math.pi * 2,
              ) *
              5;
      path.lineTo(x, y);
    }
    path
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = AppColors.accentSoft);
    final front = Path()..moveTo(0, waterTop + 5);
    for (double x = 0; x <= size.width; x += 4) {
      final y =
          waterTop +
          5 +
          math.sin(
                (x / size.width * waves * math.pi * 2) +
                    phase * math.pi * 2 +
                    1.5,
              ) *
              4;
      front.lineTo(x, y);
    }
    front
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      front,
      Paint()..color = AppColors.accent.withValues(alpha: .72),
    );
    canvas.restore();
    canvas.drawCircle(size.center(Offset.zero), size.width / 2 - 2, border);
  }

  @override
  bool shouldRepaint(covariant _WaterVesselPainter oldDelegate) =>
      oldDelegate.level != level || oldDelegate.phase != phase;
}

class _ProgressRingPainter extends CustomPainter {
  const _ProgressRingPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(12, 12, size.width - 24, size.height - 24);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 15
        ..strokeCap = StrokeCap.round
        ..color = AppColors.surface2,
    );
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 15
        ..strokeCap = StrokeCap.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

class _MealDonutPainter extends CustomPainter {
  const _MealDonutPainter({required this.totals, required this.colors});

  final Map<String, int> totals;
  final Map<String, Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(13, 13, size.width - 26, size.height - 26);
    final total = totals.values.fold<int>(0, (sum, value) => sum + value);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 22
      ..color = AppColors.surface2;
    canvas.drawArc(rect, 0, math.pi * 2, false, base);
    if (total == 0) return;
    var start = -math.pi / 2;
    for (final type in const [
      'breakfast',
      'lunch',
      'dinner',
      'snack',
      'uncategorized',
    ]) {
      final value = totals[type] ?? 0;
      if (value == 0) continue;
      final sweep = math.pi * 2 * value / total;
      canvas.drawArc(
        rect,
        start + .025,
        math.max(0, sweep - .05),
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 22
          ..strokeCap = StrokeCap.round
          ..color = colors[type] ?? AppColors.faint,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _MealDonutPainter oldDelegate) =>
      oldDelegate.totals.toString() != totals.toString();
}

class _WeightTrendPainter extends CustomPainter {
  const _WeightTrendPainter({required this.values});

  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    for (var i = 1; i <= 3; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    if (values.isEmpty) return;
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final range = math.max(.5, maxValue - minValue);
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = values.length == 1
          ? size.width / 2
          : size.width * i / (values.length - 1);
      final y = 12 + (size.height - 24) * (1 - (values[i] - minValue) / range);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _WeightTrendPainter oldDelegate) =>
      oldDelegate.values.toString() != values.toString();
}

class _ScaleTicks extends StatelessWidget {
  const _ScaleTicks({
    required this.value,
    required this.min,
    required this.max,
  });

  final double value;
  final double min;
  final double max;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 36,
    child: LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          for (var i = 0; i < 21; i++)
            Positioned(
              left: constraints.maxWidth * i / 20,
              bottom: 0,
              child: Container(
                width: i == 10 ? 2 : 1,
                height: i % 5 == 0 ? 24 : 13,
                color: i == 10 ? AppColors.accent : AppColors.borderStrong,
              ),
            ),
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              value.toStringAsFixed(1),
              style: const TextStyle(fontSize: 11, color: AppColors.muted),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<int?> _integerDialog(
  BuildContext context, {
  required String title,
  required int initialValue,
  required String suffix,
  required int min,
  required int max,
  bool allowClear = false,
}) async {
  final controller = TextEditingController(text: '$initialValue');
  final result = await showDialog<int>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(suffixText: suffix),
      ),
      actions: [
        if (allowClear)
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, -1),
            child: Text(_zh(context) ? '清除目标' : 'Clear'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(_zh(context) ? '取消' : 'Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final value = int.tryParse(controller.text.trim());
            if (value != null && value >= min && value <= max) {
              Navigator.pop(dialogContext, value);
            }
          },
          child: Text(_zh(context) ? '保存' : 'Save'),
        ),
      ],
    ),
  );
  controller.dispose();
  return result;
}

class _DecimalResult {
  const _DecimalResult({this.value, this.cleared = false});
  final double? value;
  final bool cleared;
}

Future<_DecimalResult> _decimalDialog(
  BuildContext context, {
  required String title,
  required double? initialValue,
  required String suffix,
  bool allowClear = false,
}) async {
  final controller = TextEditingController(
    text: initialValue?.toStringAsFixed(1) ?? '',
  );
  final result = await showDialog<_DecimalResult>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(suffixText: suffix),
      ),
      actions: [
        if (allowClear)
          TextButton(
            onPressed: () => Navigator.pop(
              dialogContext,
              const _DecimalResult(cleared: true),
            ),
            child: Text(_zh(context) ? '清除目标' : 'Clear'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(_zh(context) ? '取消' : 'Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final value = double.tryParse(controller.text.trim());
            if (value != null && value >= 25 && value <= 440) {
              Navigator.pop(dialogContext, _DecimalResult(value: value));
            }
          },
          child: Text(_zh(context) ? '保存' : 'Save'),
        ),
      ],
    ),
  );
  controller.dispose();
  return result ?? const _DecimalResult();
}

bool _zh(BuildContext context) =>
    Localizations.localeOf(context).languageCode == 'zh';

double _displayWeight(double kilograms, bool metric) =>
    metric ? kilograms : kilograms * 2.2046226218;

String _deltaText(double deltaKg, bool metric, String prefix) {
  final value = metric ? deltaKg : deltaKg * 2.2046226218;
  final sign = value > 0 ? '+' : '';
  return '$prefix $sign${value.toStringAsFixed(1)} ${metric ? 'kg' : 'lb'}';
}

List<double> _weightTrend(List<WeightEntry> entries, int days) {
  final cutoff = DateTime.now().subtract(Duration(days: days));
  final latestByDay = <String, WeightEntry>{};
  for (final entry in entries) {
    final local = DateTime.fromMillisecondsSinceEpoch(
      entry.loggedAtUtcMs,
      isUtc: true,
    ).toLocal();
    if (local.isBefore(cutoff)) continue;
    latestByDay[localDateKey(local)] = entry;
  }
  final ordered = latestByDay.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));
  return ordered.map((item) => item.value.kilograms).toList();
}

String _mealName(String type, bool zh) => switch (type) {
  'breakfast' => zh ? '早餐' : 'Breakfast',
  'lunch' => zh ? '午餐' : 'Lunch',
  'dinner' => zh ? '晚餐' : 'Dinner',
  'snack' => zh ? '加餐' : 'Snack',
  _ => zh ? '未分类' : 'Uncategorized',
};

String _mealForNow() {
  final hour = DateTime.now().hour;
  if (hour < 10) return 'breakfast';
  if (hour < 15) return 'lunch';
  if (hour < 21) return 'dinner';
  return 'snack';
}

String _syncText(int? utcMs, bool zh) {
  if (utcMs == null) return zh ? '等待首次同步' : 'Waiting for first sync';
  final time = DateTime.fromMillisecondsSinceEpoch(
    utcMs,
    isUtc: true,
  ).toLocal();
  return zh
      ? '最近同步 ${DateFormat('HH:mm').format(time)} · 只读取步数'
      : 'Synced ${DateFormat('HH:mm').format(time)} · Read-only';
}
