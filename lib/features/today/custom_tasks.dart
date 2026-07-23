import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app_state.dart';
import '../../core/contracts.dart';
import '../../core/theme/app_theme.dart';
import '../../data/database/app_database.dart';
import '../../shared/widgets.dart';
import 'tracking_sheets.dart';

class TaskTemplatePreset {
  const TaskTemplatePreset({
    required this.key,
    required this.zhName,
    required this.enName,
    required this.iconKey,
    required this.colorKey,
    required this.goalType,
    required this.targetValue,
    required this.quickIncrement,
    required this.unit,
    this.kind = DailyTaskKind.custom,
  });

  final String key;
  final String zhName;
  final String enName;
  final String iconKey;
  final String colorKey;
  final TaskGoalType goalType;
  final double targetValue;
  final double quickIncrement;
  final String unit;
  final DailyTaskKind kind;

  String name(bool zh) => zh ? zhName : enName;
}

const _customPreset = TaskTemplatePreset(
  key: 'custom',
  zhName: '',
  enName: '',
  iconKey: 'star',
  colorKey: 'purple',
  goalType: TaskGoalType.check,
  targetValue: 1,
  quickIncrement: 1,
  unit: 'done',
);

const taskTemplates = <TaskTemplatePreset>[
  TaskTemplatePreset(
    key: 'water',
    zhName: '饮水',
    enName: 'Water',
    iconKey: 'water',
    colorKey: 'blue',
    goalType: TaskGoalType.count,
    targetValue: 2000,
    quickIncrement: 250,
    unit: 'ml',
    kind: DailyTaskKind.water,
  ),
  TaskTemplatePreset(
    key: 'calories',
    zhName: '热量',
    enName: 'Calories',
    iconKey: 'calories',
    colorKey: 'emerald',
    goalType: TaskGoalType.count,
    targetValue: 1,
    quickIncrement: 100,
    unit: 'kcal',
    kind: DailyTaskKind.calories,
  ),
  TaskTemplatePreset(
    key: 'weight',
    zhName: '体重',
    enName: 'Weight',
    iconKey: 'weight',
    colorKey: 'teal',
    goalType: TaskGoalType.check,
    targetValue: 1,
    quickIncrement: 1,
    unit: 'done',
    kind: DailyTaskKind.weight,
  ),
  TaskTemplatePreset(
    key: 'steps',
    zhName: '步数',
    enName: 'Steps',
    iconKey: 'steps',
    colorKey: 'amber',
    goalType: TaskGoalType.count,
    targetValue: 8000,
    quickIncrement: 1000,
    unit: 'steps',
    kind: DailyTaskKind.steps,
  ),
  TaskTemplatePreset(
    key: 'run',
    zhName: '跑步',
    enName: 'Running',
    iconKey: 'run',
    colorKey: 'emerald',
    goalType: TaskGoalType.duration,
    targetValue: 20,
    quickIncrement: 5,
    unit: 'min',
  ),
  TaskTemplatePreset(
    key: 'walk',
    zhName: '快走',
    enName: 'Brisk walk',
    iconKey: 'walk',
    colorKey: 'blue',
    goalType: TaskGoalType.duration,
    targetValue: 30,
    quickIncrement: 5,
    unit: 'min',
  ),
  TaskTemplatePreset(
    key: 'bike',
    zhName: '骑行',
    enName: 'Cycling',
    iconKey: 'bike',
    colorKey: 'teal',
    goalType: TaskGoalType.duration,
    targetValue: 30,
    quickIncrement: 10,
    unit: 'min',
  ),
  TaskTemplatePreset(
    key: 'rope',
    zhName: '跳绳',
    enName: 'Jump rope',
    iconKey: 'rope',
    colorKey: 'orange',
    goalType: TaskGoalType.count,
    targetValue: 500,
    quickIncrement: 100,
    unit: 'reps',
  ),
  TaskTemplatePreset(
    key: 'yoga',
    zhName: '瑜伽',
    enName: 'Yoga',
    iconKey: 'yoga',
    colorKey: 'purple',
    goalType: TaskGoalType.duration,
    targetValue: 20,
    quickIncrement: 5,
    unit: 'min',
  ),
  TaskTemplatePreset(
    key: 'stretch',
    zhName: '拉伸',
    enName: 'Stretching',
    iconKey: 'stretch',
    colorKey: 'amber',
    goalType: TaskGoalType.duration,
    targetValue: 10,
    quickIncrement: 5,
    unit: 'min',
  ),
  TaskTemplatePreset(
    key: 'pushup',
    zhName: '俯卧撑',
    enName: 'Push-ups',
    iconKey: 'pushup',
    colorKey: 'blue',
    goalType: TaskGoalType.count,
    targetValue: 30,
    quickIncrement: 10,
    unit: 'reps',
  ),
  TaskTemplatePreset(
    key: 'situp',
    zhName: '仰卧起坐',
    enName: 'Sit-ups',
    iconKey: 'situp',
    colorKey: 'orange',
    goalType: TaskGoalType.count,
    targetValue: 30,
    quickIncrement: 10,
    unit: 'reps',
  ),
  TaskTemplatePreset(
    key: 'squat',
    zhName: '深蹲',
    enName: 'Squats',
    iconKey: 'squat',
    colorKey: 'emerald',
    goalType: TaskGoalType.count,
    targetValue: 40,
    quickIncrement: 10,
    unit: 'reps',
  ),
  TaskTemplatePreset(
    key: 'plank',
    zhName: '平板支撑',
    enName: 'Plank',
    iconKey: 'plank',
    colorKey: 'purple',
    goalType: TaskGoalType.duration,
    targetValue: 5,
    quickIncrement: 1,
    unit: 'min',
  ),
];

Future<void> showAddTaskFlow(BuildContext context, WidgetRef ref) async {
  final preset = await showLighterSheet<TaskTemplatePreset>(
    context,
    const _TaskLibrarySheet(),
  );
  if (preset == null || !context.mounted) return;
  if (preset.kind != DailyTaskKind.custom) {
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    try {
      await ref.read(repositoryProvider).addSystemTask(preset.kind);
      if (context.mounted) {
        showMessage(
          context,
          zh ? '${preset.name(zh)}已添加' : '${preset.name(zh)} added',
        );
      }
    } on StateError catch (error) {
      if (context.mounted) {
        showMessage(
          context,
          error.message == 'daily_task_limit'
              ? (zh ? '每日任务最多 10 个' : 'You can have up to 10 daily tasks')
              : (zh ? '这个任务已经添加' : 'This task is already added'),
        );
      }
    }
    return;
  }
  await showTaskEditorSheet(context, preset: preset);
}

Future<void> showTaskEditorSheet(
  BuildContext context, {
  TaskTemplatePreset? preset,
  DailyTask? task,
}) => showLighterSheet<void>(
  context,
  _TaskEditorSheet(preset: preset ?? _customPreset, task: task),
);

Future<void> showTaskManagerSheet(BuildContext context) =>
    showLighterSheet<void>(context, const _TaskManagerSheet());

Future<void> showTaskDetailSheet(BuildContext context, DailyTask task) async {
  final action = await showLighterSheet<_TaskDetailAction>(
    context,
    _TaskDetailSheet(task: task),
  );
  if (action == _TaskDetailAction.edit && context.mounted) {
    await showTaskEditorSheet(context, task: task);
  }
}

class UnifiedDailyTaskGrid extends ConsumerWidget {
  const UnifiedDailyTaskGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    final dateKey = localDateKey(DateTime.now());
    final tasks = ref.watch(dailyTasksProvider).valueOrNull ?? const [];
    final entries =
        ref.watch(taskProgressProvider(dateKey)).valueOrNull ?? const [];
    final water =
        ref.watch(dailyWaterProvider(dateKey)).valueOrNull ?? const [];
    final health = ref.watch(dailyHealthProvider(dateKey)).valueOrNull;
    final weights = ref.watch(weightsProvider).valueOrNull ?? const [];
    final app = ref.watch(appControllerProvider);
    final visibleTasks = tasks
        .where(
          (task) =>
              TaskSchedule.includesWeekday(
                task.weekdaysMask,
                DateTime.now().weekday,
              ) ||
              task.kind != DailyTaskKind.custom.name,
        )
        .toList();
    double totalFor(String taskId) => entries
        .where((entry) => entry.taskId == taskId)
        .fold(0, (sum, entry) => sum + entry.deltaValue);
    final totalWater = water.fold<int>(
      0,
      (sum, entry) => sum + entry.milliliters,
    );
    final latestWeight = weights.isEmpty ? null : weights.last.kilograms;
    final weightValue = latestWeight == null
        ? '—'
        : (app.unitSystem == UnitSystem.metric
                  ? latestWeight
                  : latestWeight * 2.2046226218)
              .toStringAsFixed(1);
    final weightUnit = app.unitSystem == UnitSystem.metric ? 'kg' : 'lb';
    final tiles = <Widget>[];
    for (final task in visibleTasks) {
      final kind = dailyTaskKindFromWire(task.kind);
      switch (kind) {
        case DailyTaskKind.water:
          tiles.add(
            _DailyTaskGridTile(
              task: task,
              label: zh ? '饮水' : 'Water',
              value: app.liquidMetric
                  ? '$totalWater ml'
                  : '${(totalWater / 236.588).toStringAsFixed(1)} cups',
              detail: '${zh ? '目标' : 'Goal'} ${app.waterGoalMl} ml',
              progress: totalWater / math.max(1, app.waterGoalMl),
              trailing: _TaskQuickAction(
                label: '+${app.quickWaterMl}',
                palette: _taskPalette(task.colorKey),
                onPressed: () => ref
                    .read(repositoryProvider)
                    .addWater(milliliters: app.quickWaterMl),
              ),
              onTap: () =>
                  showTrackingSheet<void>(context, const WaterTrackingSheet()),
            ),
          );
          break;
        case DailyTaskKind.calories:
          tiles.add(
            _DailyTaskGridTile(
              task: task,
              label: zh ? '热量' : 'Calories',
              value: '${health?.calories ?? 0} kcal',
              detail: app.calorieGoal == null
                  ? (zh ? '目标未设置' : 'No goal yet')
                  : '${zh ? '目标' : 'Goal'} ${app.calorieGoal} kcal',
              progress: app.calorieGoal == null
                  ? null
                  : (health?.calories ?? 0) / math.max(1, app.calorieGoal!),
              trailing: _TaskQuickAction(
                label: '+${_compactNumber(task.quickIncrement)}',
                palette: _taskPalette(task.colorKey),
                onPressed: () => ref
                    .read(repositoryProvider)
                    .addCalorie(
                      dateKey: dateKey,
                      mealType: 'uncategorized',
                      calories: task.quickIncrement.round(),
                    ),
              ),
              onTap: () => showTrackingSheet<void>(
                context,
                const CalorieTrackingSheet(),
              ),
            ),
          );
          break;
        case DailyTaskKind.weight:
          tiles.add(
            _DailyTaskGridTile(
              task: task,
              label: zh ? '体重' : 'Weight',
              value: '$weightValue $weightUnit',
              detail: zh ? '记录与查看趋势' : 'Record and view trends',
              trailing: _TaskQuickAction(
                label: zh ? '记录' : 'Log',
                palette: _taskPalette(task.colorKey),
                onPressed: () => showTrackingSheet<void>(
                  context,
                  const WeightTrackingSheet(),
                ),
              ),
              onTap: () =>
                  showTrackingSheet<void>(context, const WeightTrackingSheet()),
            ),
          );
          break;
        case DailyTaskKind.steps:
          tiles.add(
            _DailyTaskGridTile(
              task: task,
              label: zh ? '步数' : 'Steps',
              value: NumberFormat.decimalPattern().format(health?.steps ?? 0),
              detail:
                  '${zh ? '目标' : 'Goal'} ${NumberFormat.decimalPattern().format(app.stepGoal)}',
              progress: (health?.steps ?? 0) / math.max(1, app.stepGoal),
              trailing: _TaskQuickAction(
                label: health?.stepSource == 'healthkit'
                    ? (zh ? '刷新' : 'Sync')
                    : '+${_compactNumber(task.quickIncrement)}',
                palette: _taskPalette(task.colorKey),
                onPressed: health?.stepSource == 'healthkit'
                    ? () => app.refreshHealthSteps()
                    : () => ref
                          .read(repositoryProvider)
                          .setDailyHealth(
                            dateKey: dateKey,
                            steps:
                                (health?.steps ?? 0) +
                                task.quickIncrement.round(),
                            stepSource: 'manual',
                          ),
              ),
              onTap: () =>
                  showTrackingSheet<void>(context, const StepsTrackingSheet()),
            ),
          );
          break;
        case DailyTaskKind.custom:
          tiles.add(
            _TaskRow(task: task, total: totalFor(task.id), dateKey: dateKey),
          );
          break;
      }
    }
    if (tasks.length < 10) {
      tiles.add(_AddDailyTaskTile(onTap: () => showAddTaskFlow(context, ref)));
    }
    return Column(children: _buildGridRows(tiles));
  }
}

class _TaskRow extends ConsumerWidget {
  const _TaskRow({
    required this.task,
    required this.total,
    required this.dateKey,
  });

  final DailyTask task;
  final double total;
  final String dateKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    final palette = _taskPalette(task.colorKey);
    final type = taskGoalTypeFromWire(task.goalType);
    final completed = total >= task.targetValue;
    final progress = (total / task.targetValue).clamp(0.0, 1.0);
    final action = type == TaskGoalType.check
        ? _TaskQuickAction(
            label: completed ? (zh ? '已完成' : 'Done') : (zh ? '完成' : 'Done'),
            palette: palette,
            completed: completed,
            onPressed: () async {
              final repository = ref.read(repositoryProvider);
              if (completed) {
                await repository.undoLatestTaskProgress(
                  taskId: task.id,
                  dateKey: dateKey,
                );
              } else {
                await repository.addTaskProgress(
                  taskId: task.id,
                  dateKey: dateKey,
                  deltaValue: 1,
                );
              }
            },
          )
        : _TaskQuickAction(
            label: '+${_compactNumber(task.quickIncrement)}',
            palette: palette,
            onPressed: () => ref
                .read(repositoryProvider)
                .addTaskProgress(
                  taskId: task.id,
                  dateKey: dateKey,
                  deltaValue: task.quickIncrement,
                ),
          );
    return _DailyTaskGridTile(
      task: task,
      label: task.title,
      value: completed
          ? (zh ? '已完成' : 'Done')
          : '${_compactNumber(total)} / ${_compactNumber(task.targetValue)}',
      detail: _scheduleLabel(task.weekdaysMask, zh),
      progress: progress,
      trailing: action,
      onTap: () => showTaskDetailSheet(context, task),
    );
  }
}

class _DailyTaskGridTile extends StatelessWidget {
  const _DailyTaskGridTile({
    required this.task,
    required this.label,
    required this.value,
    required this.detail,
    required this.onTap,
    this.progress,
    this.trailing,
  });

  final DailyTask task;
  final String label;
  final String value;
  final String detail;
  final double? progress;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = _taskPalette(task.colorKey);
    return SizedBox(
      height: 150,
      child: LighterCard(
        color: palette.tint,
        borderColor: palette.border,
        padding: const EdgeInsets.all(14),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.strong,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                trailing ??
                    Icon(
                      CupertinoIcons.add_circled,
                      size: 18,
                      color: palette.primary,
                    ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                SizedBox(
                  width: 42,
                  height: 42,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress?.clamp(0.0, 1.0) ?? .14,
                        strokeWidth: 4,
                        strokeCap: StrokeCap.round,
                        backgroundColor: Colors.white.withValues(alpha: .84),
                        color: palette.primary,
                      ),
                      Icon(
                        _taskIcon(task.iconKey),
                        size: 18,
                        color: palette.primary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      color: AppColors.strong,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              detail,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10.5, color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskQuickAction extends StatelessWidget {
  const _TaskQuickAction({
    required this.label,
    required this.palette,
    required this.onPressed,
    this.completed = false,
  });

  final String label;
  final _TaskPalette palette;
  final VoidCallback onPressed;
  final bool completed;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Material(
          color: completed
              ? palette.primary.withValues(alpha: .92)
              : Colors.white.withValues(alpha: .46),
          child: InkWell(
            onTap: onPressed,
            child: Container(
              constraints: const BoxConstraints(minWidth: 44, minHeight: 31),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: completed
                      ? Colors.white.withValues(alpha: .5)
                      : Colors.white.withValues(alpha: .92),
                ),
                boxShadow: [
                  BoxShadow(
                    color: palette.primary.withValues(alpha: .16),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
                gradient: completed
                    ? null
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: .72),
                          palette.primary.withValues(alpha: .12),
                        ],
                      ),
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  color: completed ? Colors.white : palette.primary,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.15,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _AddDailyTaskTile extends StatelessWidget {
  const _AddDailyTaskTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    return SizedBox(
      height: 150,
      child: LighterCard(
        color: AppColors.surface2,
        borderColor: AppColors.borderStrong,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: AppColors.purpleTint,
                shape: BoxShape.circle,
              ),
              child: const Icon(CupertinoIcons.add, color: AppColors.purple),
            ),
            const SizedBox(height: 10),
            Text(
              zh ? '添加任务' : 'Add a task',
              style: const TextStyle(
                color: AppColors.strong,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Widget> _buildGridRows(List<Widget> tiles) {
  final rows = <Widget>[];
  for (var index = 0; index < tiles.length; index += 2) {
    rows.add(
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: tiles[index]),
          const SizedBox(width: 10),
          Expanded(
            child: index + 1 < tiles.length
                ? tiles[index + 1]
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
    if (index + 2 < tiles.length) rows.add(const SizedBox(height: 10));
  }
  return rows;
}

class _TaskLibrarySheet extends ConsumerWidget {
  const _TaskLibrarySheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    final tasks = ref.watch(dailyTasksProvider).valueOrNull ?? const [];
    return SizedBox(
      height: math.min(MediaQuery.sizeOf(context).height * .76, 680),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            zh ? '添加每日任务' : 'Add a daily task',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 6),
          Text(
            zh
                ? '选择模板后仍可修改目标和重复日期。'
                : 'You can adjust every template before saving.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          LighterCard(
            color: AppColors.purpleTint,
            borderColor: const Color(0xFFDCD7FA),
            onTap: () => Navigator.pop(context, _customPreset),
            child: Row(
              children: [
                const Icon(CupertinoIcons.sparkles, color: AppColors.purple),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        zh ? '创建自定义任务' : 'Create a custom task',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        zh
                            ? '名称、目标、单位和颜色都由你决定'
                            : 'Choose the name, goal, unit, and color',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const Icon(CupertinoIcons.chevron_right, size: 17),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: taskTemplates.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.55,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final preset = taskTemplates[index];
                final palette = _taskPalette(preset.colorKey);
                final alreadyAdded =
                    preset.kind != DailyTaskKind.custom &&
                    tasks.any((task) => task.kind == preset.kind.name);
                return LighterCard(
                  color: alreadyAdded ? AppColors.surface2 : palette.tint,
                  borderColor: palette.border,
                  padding: const EdgeInsets.all(13),
                  onTap: alreadyAdded
                      ? null
                      : () => Navigator.pop(context, preset),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _taskIcon(preset.iconKey),
                        size: 22,
                        color: palette.primary,
                      ),
                      const SizedBox(height: 7),
                      Text(
                        preset.name(zh),
                        style: const TextStyle(
                          color: AppColors.strong,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        alreadyAdded
                            ? (zh ? '已添加' : 'Added')
                            : preset.kind == DailyTaskKind.custom
                            ? _goalLabel(
                                preset.targetValue,
                                preset.goalType,
                                zh,
                              )
                            : (zh ? '健康记录' : 'Health tracking'),
                        style: TextStyle(
                          color: alreadyAdded
                              ? AppColors.faint
                              : AppColors.muted,
                          fontSize: 11,
                          fontWeight: alreadyAdded
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskEditorSheet extends ConsumerStatefulWidget {
  const _TaskEditorSheet({required this.preset, this.task});

  final TaskTemplatePreset preset;
  final DailyTask? task;

  @override
  ConsumerState<_TaskEditorSheet> createState() => _TaskEditorSheetState();
}

class _TaskEditorSheetState extends ConsumerState<_TaskEditorSheet> {
  late final TextEditingController _title;
  late final TextEditingController _target;
  late final TextEditingController _quick;
  late TaskGoalType _goalType;
  late String _iconKey;
  late String _colorKey;
  late int _weekdaysMask;
  late bool _reminderEnabled;
  late TimeOfDay _reminderTime;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    final preset = widget.preset;
    _title = TextEditingController(text: task?.title ?? preset.zhName);
    _goalType = task == null
        ? preset.goalType
        : taskGoalTypeFromWire(task.goalType);
    _target = TextEditingController(
      text: _compactNumber(task?.targetValue ?? preset.targetValue),
    );
    _quick = TextEditingController(
      text: _compactNumber(task?.quickIncrement ?? preset.quickIncrement),
    );
    _iconKey = task?.iconKey ?? preset.iconKey;
    _colorKey = task?.colorKey ?? preset.colorKey;
    _weekdaysMask = task?.weekdaysMask ?? TaskSchedule.everyDay;
    _reminderEnabled = task?.reminderMinute != null;
    final reminder = task?.reminderMinute ?? 1200;
    _reminderTime = TimeOfDay(hour: reminder ~/ 60, minute: reminder % 60);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.task == null && _title.text == widget.preset.zhName) {
      _title.text = widget.preset.name(
        Localizations.localeOf(context).languageCode == 'zh',
      );
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _target.dispose();
    _quick.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    return SizedBox(
      height: math.min(MediaQuery.sizeOf(context).height * .82, 730),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.task == null
                      ? (zh ? '设置任务' : 'Set up task')
                      : (zh ? '编辑任务' : 'Edit task'),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              TextButton(
                onPressed: _saving ? null : _save,
                child: Text(zh ? '保存' : 'Save'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                TextField(
                  controller: _title,
                  maxLength: 30,
                  decoration: InputDecoration(
                    labelText: zh ? '任务名称' : 'Task name',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  zh ? '图标' : 'Icon',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 9),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _iconKeys.map((key) {
                    final selected = key == _iconKey;
                    return InkWell(
                      onTap: () => setState(() => _iconKey = key),
                      borderRadius: BorderRadius.circular(13),
                      child: Container(
                        width: 43,
                        height: 43,
                        decoration: BoxDecoration(
                          color: selected
                              ? _taskPalette(_colorKey).tint
                              : AppColors.surface2,
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: selected
                                ? _taskPalette(_colorKey).primary
                                : Colors.transparent,
                          ),
                        ),
                        child: Icon(
                          _taskIcon(key),
                          size: 20,
                          color: selected
                              ? _taskPalette(_colorKey).primary
                              : AppColors.muted,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                Text(
                  zh ? '颜色' : 'Color',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 9),
                Wrap(
                  spacing: 12,
                  children: _colorKeys.map((key) {
                    final palette = _taskPalette(key);
                    final selected = key == _colorKey;
                    return InkWell(
                      onTap: () => setState(() => _colorKey = key),
                      borderRadius: BorderRadius.circular(99),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: palette.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 3,
                            color: selected ? AppColors.strong : Colors.white,
                          ),
                        ),
                        child: selected
                            ? const Icon(
                                CupertinoIcons.check_mark,
                                size: 14,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                DropdownButtonFormField<TaskGoalType>(
                  initialValue: _goalType,
                  decoration: InputDecoration(
                    labelText: zh ? '目标类型' : 'Goal type',
                  ),
                  items: TaskGoalType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(_goalTypeLabel(type, zh)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _goalType = value;
                      switch (value) {
                        case TaskGoalType.check:
                          _target.text = '1';
                          _quick.text = '1';
                          break;
                        case TaskGoalType.count:
                          _target.text = '30';
                          _quick.text = '10';
                          break;
                        case TaskGoalType.duration:
                          _target.text = '20';
                          _quick.text = '5';
                          break;
                        case TaskGoalType.distance:
                          _target.text = '3';
                          _quick.text = '1';
                          break;
                      }
                    });
                  },
                ),
                if (_goalType != TaskGoalType.check) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _target,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: InputDecoration(
                            labelText: zh ? '每日目标' : 'Daily goal',
                            suffixText: _unitLabel(_goalType, zh),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _quick,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: InputDecoration(
                            labelText: zh ? '快捷增加' : 'Quick add',
                            suffixText: _unitLabel(_goalType, zh),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                Text(
                  zh ? '重复日期' : 'Repeat',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 9),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _repeatChip(zh ? '每天' : 'Daily', TaskSchedule.everyDay),
                    _repeatChip(zh ? '工作日' : 'Weekdays', TaskSchedule.workdays),
                    _repeatChip(zh ? '周末' : 'Weekend', TaskSchedule.weekend),
                    ChoiceChip(
                      label: Text(zh ? '自选' : 'Custom'),
                      selected: !_presetSchedule,
                      onSelected: (_) => setState(() => _weekdaysMask = 1),
                    ),
                  ],
                ),
                if (!_presetSchedule) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: List.generate(7, (index) {
                      final weekday = index + 1;
                      final selected = TaskSchedule.includesWeekday(
                        _weekdaysMask,
                        weekday,
                      );
                      final labels = zh
                          ? const ['一', '二', '三', '四', '五', '六', '日']
                          : const ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                      return FilterChip(
                        label: Text(labels[index]),
                        selected: selected,
                        onSelected: (_) {
                          final next = TaskSchedule.toggleWeekday(
                            _weekdaysMask,
                            weekday,
                          );
                          if (next != 0) setState(() => _weekdaysMask = next);
                        },
                      );
                    }),
                  ),
                ],
                const SizedBox(height: 16),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  value: _reminderEnabled,
                  title: Text(zh ? '任务提醒' : 'Task reminder'),
                  subtitle: Text(
                    _reminderEnabled
                        ? _reminderTime.format(context)
                        : (zh ? '不提醒' : 'Off'),
                  ),
                  onChanged: (value) =>
                      setState(() => _reminderEnabled = value),
                  secondary: const Icon(CupertinoIcons.bell),
                ),
                if (_reminderEnabled)
                  OutlinedButton.icon(
                    onPressed: _pickReminder,
                    icon: const Icon(CupertinoIcons.clock),
                    label: Text(
                      zh
                          ? '提醒时间 ${_reminderTime.format(context)}'
                          : 'Reminder at ${_reminderTime.format(context)}',
                    ),
                  ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(zh ? '保存任务' : 'Save task'),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool get _presetSchedule =>
      _weekdaysMask == TaskSchedule.everyDay ||
      _weekdaysMask == TaskSchedule.workdays ||
      _weekdaysMask == TaskSchedule.weekend;

  Widget _repeatChip(String label, int mask) => ChoiceChip(
    label: Text(label),
    selected: _weekdaysMask == mask,
    onSelected: (_) => setState(() => _weekdaysMask = mask),
  );

  Future<void> _pickReminder() async {
    final value = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (value != null) setState(() => _reminderTime = value);
  }

  Future<void> _save() async {
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    final target = _goalType == TaskGoalType.check
        ? 1.0
        : double.tryParse(_target.text.trim());
    final quick = _goalType == TaskGoalType.check
        ? 1.0
        : double.tryParse(_quick.text.trim());
    if (_title.text.trim().isEmpty || target == null || quick == null) {
      showMessage(
        context,
        zh ? '请完整填写任务信息' : 'Complete the task details first',
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final repository = ref.read(repositoryProvider);
      final reminderMinute = _reminderEnabled
          ? _reminderTime.hour * 60 + _reminderTime.minute
          : null;
      final unit = switch (_goalType) {
        TaskGoalType.check => 'done',
        TaskGoalType.count => 'reps',
        TaskGoalType.duration => 'min',
        TaskGoalType.distance => 'km',
      };
      final task = widget.task == null
          ? await repository.createCustomTask(
              title: _title.text,
              iconKey: _iconKey,
              colorKey: _colorKey,
              goalType: _goalType,
              targetValue: target,
              unit: unit,
              quickIncrement: quick,
              weekdaysMask: _weekdaysMask,
              reminderMinute: reminderMinute,
            )
          : await repository.updateCustomTask(
              id: widget.task!.id,
              title: _title.text,
              iconKey: _iconKey,
              colorKey: _colorKey,
              goalType: _goalType,
              targetValue: target,
              unit: unit,
              quickIncrement: quick,
              weekdaysMask: _weekdaysMask,
              reminderMinute: reminderMinute,
            );
      var permissionDenied = false;
      final notifications = ref.read(notificationServiceProvider);
      if (reminderMinute == null) {
        await notifications.cancelTaskReminder(task.id);
      } else {
        final granted = await notifications.requestPermission();
        if (granted) {
          await notifications.scheduleTaskReminder(
            taskId: task.id,
            title: task.title,
            weekdaysMask: task.weekdaysMask,
            minuteOfDay: reminderMinute,
          );
        } else {
          await notifications.cancelTaskReminder(task.id);
          permissionDenied = true;
        }
      }
      if (!mounted) return;
      showMessage(
        context,
        permissionDenied
            ? (zh ? '任务已保存，通知权限未开启' : 'Saved. Notifications are not enabled.')
            : (zh ? '任务已保存' : 'Task saved'),
      );
      Navigator.pop(context);
    } on StateError catch (error) {
      if (mounted) {
        showMessage(
          context,
          error.message == 'daily_task_limit'
              ? (zh ? '每日任务最多 10 个' : 'You can have up to 10 daily tasks')
              : (zh ? '暂时无法保存任务' : 'The task could not be saved'),
        );
      }
    } on FormatException {
      if (mounted) {
        showMessage(context, zh ? '请检查目标和重复日期' : 'Check the goal and schedule');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

enum _TaskDetailAction { edit }

class _TaskDetailSheet extends ConsumerStatefulWidget {
  const _TaskDetailSheet({required this.task});

  final DailyTask task;

  @override
  ConsumerState<_TaskDetailSheet> createState() => _TaskDetailSheetState();
}

class _TaskDetailSheetState extends ConsumerState<_TaskDetailSheet> {
  late final TextEditingController _amount;

  @override
  void initState() {
    super.initState();
    _amount = TextEditingController(
      text: _compactNumber(widget.task.quickIncrement),
    );
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    final dateKey = localDateKey(DateTime.now());
    final entries =
        ref.watch(taskProgressProvider(dateKey)).valueOrNull ?? const [];
    final taskEntries = entries
        .where((entry) => entry.taskId == widget.task.id)
        .toList();
    final total = taskEntries.fold<double>(
      0,
      (sum, entry) => sum + entry.deltaValue,
    );
    final type = taskGoalTypeFromWire(widget.task.goalType);
    final completed = total >= widget.task.targetValue;
    final palette = _taskPalette(widget.task.colorKey);
    return SizedBox(
      height: math.min(MediaQuery.sizeOf(context).height * .66, 560),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: palette.tint,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  _taskIcon(widget.task.iconKey),
                  color: palette.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.task.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      _scheduleLabel(widget.task.weekdaysMask, zh),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context, _TaskDetailAction.edit),
                tooltip: zh ? '编辑任务' : 'Edit task',
                icon: const Icon(CupertinoIcons.pencil),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: SizedBox(
              width: 166,
              height: 166,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(
                    child: CircularProgressIndicator(
                      value: (total / widget.task.targetValue).clamp(0.0, 1.0),
                      strokeWidth: 12,
                      strokeCap: StrokeCap.round,
                      color: palette.primary,
                      backgroundColor: palette.tint,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTaskValue(total, type, zh),
                        style: const TextStyle(
                          color: AppColors.strong,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        completed
                            ? (zh ? '今日已完成' : 'Completed today')
                            : '${zh ? '目标' : 'Goal'} ${_formatTaskValue(widget.task.targetValue, type, zh)}',
                        style: TextStyle(
                          color: completed ? palette.primary : AppColors.muted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (type == TaskGoalType.check)
            FilledButton.icon(
              onPressed: () => _toggleCheck(completed, dateKey),
              style: FilledButton.styleFrom(backgroundColor: palette.primary),
              icon: Icon(
                completed
                    ? CupertinoIcons.arrow_uturn_left
                    : CupertinoIcons.check_mark,
              ),
              label: Text(
                completed
                    ? (zh ? '撤销完成' : 'Undo completion')
                    : (zh ? '标记完成' : 'Mark complete'),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amount,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: zh ? '本次记录' : 'Add this time',
                      suffixText: _unitLabel(type, zh),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton(
                  onPressed: () => _add(dateKey),
                  style: FilledButton.styleFrom(
                    backgroundColor: palette.primary,
                    minimumSize: const Size(94, 54),
                  ),
                  child: Text(zh ? '记录' : 'Add'),
                ),
              ],
            ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: taskEntries.isEmpty ? null : () => _undo(dateKey),
            icon: const Icon(CupertinoIcons.arrow_uturn_left, size: 16),
            label: Text(zh ? '撤销最近一次记录' : 'Undo latest entry'),
          ),
          const Spacer(),
          Text(
            zh
                ? '只记录你真实完成的量，超过目标也会保留。'
                : 'Your real progress is kept even when it exceeds the goal.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: AppColors.faint),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleCheck(bool completed, String dateKey) async {
    final repository = ref.read(repositoryProvider);
    if (completed) {
      await repository.undoLatestTaskProgress(
        taskId: widget.task.id,
        dateKey: dateKey,
      );
    } else {
      await repository.addTaskProgress(
        taskId: widget.task.id,
        dateKey: dateKey,
        deltaValue: 1,
      );
    }
  }

  Future<void> _add(String dateKey) async {
    final value = double.tryParse(_amount.text.trim());
    if (value == null || value <= 0) {
      final zh = Localizations.localeOf(context).languageCode == 'zh';
      showMessage(context, zh ? '请输入有效的记录数值' : 'Enter a valid amount');
      return;
    }
    await ref
        .read(repositoryProvider)
        .addTaskProgress(
          taskId: widget.task.id,
          dateKey: dateKey,
          deltaValue: value,
        );
  }

  Future<void> _undo(String dateKey) => ref
      .read(repositoryProvider)
      .undoLatestTaskProgress(taskId: widget.task.id, dateKey: dateKey);
}

class _TaskManagerSheet extends ConsumerStatefulWidget {
  const _TaskManagerSheet();

  @override
  ConsumerState<_TaskManagerSheet> createState() => _TaskManagerSheetState();
}

class _TaskManagerSheetState extends ConsumerState<_TaskManagerSheet> {
  @override
  Widget build(BuildContext context) {
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    final tasks = ref.watch(dailyTasksProvider).valueOrNull ?? const [];
    return SizedBox(
      height: math.min(MediaQuery.sizeOf(context).height * .72, 620),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      zh ? '管理每日任务' : 'Manage daily tasks',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      zh
                          ? '${tasks.length}/10 个任务 · 长按拖动排序'
                          : '${tasks.length} of 10 tasks · Hold and drag to reorder',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              if (tasks.length < 10)
                IconButton.filledTonal(
                  onPressed: () => showAddTaskFlow(context, ref),
                  icon: const Icon(CupertinoIcons.add),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (tasks.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  zh ? '还没有每日任务' : 'No daily tasks yet',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          else
            Expanded(
              child: ReorderableListView.builder(
                buildDefaultDragHandles: false,
                itemCount: tasks.length,
                onReorderItem: (oldIndex, newIndex) {
                  final ordered = [...tasks];
                  final moved = ordered.removeAt(oldIndex);
                  ordered.insert(newIndex, moved);
                  ref
                      .read(repositoryProvider)
                      .reorderDailyTasks(
                        ordered.map((task) => task.id).toList(),
                      );
                },
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  final palette = _taskPalette(task.colorKey);
                  return Padding(
                    key: ValueKey(task.id),
                    padding: const EdgeInsets.only(bottom: 9),
                    child: LighterCard(
                      color: palette.tint,
                      borderColor: palette.border,
                      padding: const EdgeInsets.fromLTRB(12, 9, 5, 9),
                      child: Row(
                        children: [
                          Icon(_taskIcon(task.iconKey), color: palette.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _dailyTaskTitle(task, zh),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.strong,
                                  ),
                                ),
                                Text(
                                  _isFixedTask(task)
                                      ? (zh
                                            ? '固定任务 · 可自由排序'
                                            : 'Fixed · Reorder anytime')
                                      : task.kind == DailyTaskKind.custom.name
                                      ? _scheduleLabel(task.weekdaysMask, zh)
                                      : (zh ? '健康记录' : 'Health tracking'),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_isFixedTask(task))
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                CupertinoIcons.lock_fill,
                                size: 16,
                                color: AppColors.faint,
                              ),
                            )
                          else
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  showTaskEditorSheet(context, task: task);
                                }
                                if (value == 'delete') {
                                  _delete(task);
                                }
                              },
                              itemBuilder: (context) => [
                                if (task.kind == DailyTaskKind.custom.name)
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Text(zh ? '编辑' : 'Edit'),
                                  ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text(
                                    zh ? '删除' : 'Delete',
                                    style: const TextStyle(
                                      color: AppColors.danger,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ReorderableDragStartListener(
                            index: index,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 12,
                              ),
                              child: Icon(
                                CupertinoIcons.line_horizontal_3,
                                color: AppColors.faint,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          if (tasks.length < 10)
            OutlinedButton.icon(
              onPressed: () => showAddTaskFlow(context, ref),
              icon: const Icon(CupertinoIcons.add, size: 17),
              label: Text(zh ? '添加任务' : 'Add a task'),
            ),
        ],
      ),
    );
  }

  Future<void> _delete(DailyTask task) async {
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(zh ? '删除“${task.title}”？' : 'Delete “${task.title}”?'),
        content: Text(
          task.kind == DailyTaskKind.custom.name
              ? (zh
                    ? '今日页面将不再显示该任务，历史记录会保留为可同步的软删除数据。'
                    : 'The task will disappear from today while its history remains sync-safe.')
              : (zh
                    ? '只会移除每日任务卡片，历史数据、进度页和健康数据同步都不受影响。'
                    : 'Only the daily card is removed. History, Progress, and health-data sync remain available.'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(zh ? '取消' : 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              zh ? '删除' : 'Delete',
              style: const TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(notificationServiceProvider).cancelTaskReminder(task.id);
    await ref.read(repositoryProvider).deleteDailyTask(task.id);
  }
}

class _TaskPalette {
  const _TaskPalette(this.primary, this.tint, this.border);

  final Color primary;
  final Color tint;
  final Color border;
}

_TaskPalette _taskPalette(String key) => switch (key) {
  'blue' => const _TaskPalette(
    AppColors.water,
    AppColors.waterTint,
    Color(0xFFBFE4FC),
  ),
  'orange' => const _TaskPalette(
    AppColors.coral,
    AppColors.coralTint,
    Color(0xFFF6CFC8),
  ),
  'teal' => const _TaskPalette(
    AppColors.weight,
    AppColors.weightTint,
    Color(0xFFBDEBDD),
  ),
  'amber' => const _TaskPalette(
    AppColors.steps,
    AppColors.stepsTint,
    Color(0xFFF2DBA8),
  ),
  'purple' => const _TaskPalette(
    AppColors.purple,
    AppColors.purpleTint,
    Color(0xFFD8D2F8),
  ),
  _ => const _TaskPalette(
    AppColors.accent,
    AppColors.accentTint,
    AppColors.accentSoft,
  ),
};

const _iconKeys = <String>[
  'run',
  'walk',
  'bike',
  'rope',
  'yoga',
  'stretch',
  'pushup',
  'situp',
  'squat',
  'plank',
  'star',
  'heart',
];

const _colorKeys = <String>[
  'emerald',
  'blue',
  'teal',
  'orange',
  'amber',
  'purple',
];

IconData _taskIcon(String key) => switch (key) {
  'water' => CupertinoIcons.drop_fill,
  'calories' => CupertinoIcons.flame_fill,
  'weight' => Icons.monitor_weight_rounded,
  'steps' => Icons.directions_walk_rounded,
  'run' => Icons.directions_run_rounded,
  'walk' => Icons.directions_walk_rounded,
  'bike' => Icons.directions_bike_rounded,
  'rope' => Icons.sports_gymnastics_rounded,
  'yoga' => Icons.self_improvement_rounded,
  'stretch' => Icons.accessibility_new_rounded,
  'pushup' => Icons.fitness_center_rounded,
  'situp' => Icons.airline_seat_flat_rounded,
  'squat' => Icons.sports_martial_arts_rounded,
  'plank' => Icons.horizontal_rule_rounded,
  'heart' => CupertinoIcons.heart_fill,
  _ => CupertinoIcons.star_fill,
};

bool _isFixedTask(DailyTask task) {
  final kind = dailyTaskKindFromWire(task.kind);
  return kind == DailyTaskKind.water || kind == DailyTaskKind.calories;
}

String _dailyTaskTitle(DailyTask task, bool zh) =>
    switch (dailyTaskKindFromWire(task.kind)) {
      DailyTaskKind.water => zh ? '饮水' : 'Water',
      DailyTaskKind.calories => zh ? '热量' : 'Calories',
      DailyTaskKind.weight => zh ? '体重' : 'Weight',
      DailyTaskKind.steps => zh ? '步数' : 'Steps',
      DailyTaskKind.custom => task.title,
    };

String _goalTypeLabel(TaskGoalType type, bool zh) => switch (type) {
  TaskGoalType.check => zh ? '完成一次' : 'Complete once',
  TaskGoalType.count => zh ? '次数' : 'Count',
  TaskGoalType.duration => zh ? '时长' : 'Duration',
  TaskGoalType.distance => zh ? '距离' : 'Distance',
};

String _unitLabel(TaskGoalType type, bool zh) => switch (type) {
  TaskGoalType.check => '',
  TaskGoalType.count => zh ? '次' : 'reps',
  TaskGoalType.duration => zh ? '分钟' : 'min',
  TaskGoalType.distance => zh ? '公里' : 'km',
};

String _goalLabel(double target, TaskGoalType type, bool zh) =>
    type == TaskGoalType.check
    ? (zh ? '完成一次' : 'Complete once')
    : '${_compactNumber(target)} ${_unitLabel(type, zh)}';

String _formatTaskValue(double value, TaskGoalType type, bool zh) {
  if (type == TaskGoalType.check) {
    return value >= 1 ? (zh ? '完成' : 'Done') : '0';
  }
  return '${_compactNumber(value)} ${_unitLabel(type, zh)}';
}

String _compactNumber(double value) => value == value.roundToDouble()
    ? value.toInt().toString()
    : value.toStringAsFixed(1);

String _scheduleLabel(int mask, bool zh) {
  if (mask == TaskSchedule.everyDay) return zh ? '每天' : 'Daily';
  if (mask == TaskSchedule.workdays) return zh ? '工作日' : 'Weekdays';
  if (mask == TaskSchedule.weekend) return zh ? '周末' : 'Weekend';
  final labels = zh
      ? const ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
      : const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return List.generate(7, (index) => index + 1)
      .where((weekday) => TaskSchedule.includesWeekday(mask, weekday))
      .map((weekday) => labels[weekday - 1])
      .join(zh ? '、' : ', ');
}
