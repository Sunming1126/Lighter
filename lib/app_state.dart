import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'core/contracts.dart';
import 'core/theme/app_theme.dart';
import 'data/database/app_database.dart';
import 'data/repositories/app_repository.dart';
import 'data/services/notification_service.dart';

enum UnitSystem { imperial, metric }

enum LanguagePreference { system, zh, en }

final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError(),
);
final repositoryProvider = Provider<AppRepository>(
  (ref) => throw UnimplementedError(),
);
final authServiceProvider = Provider<AuthService>(
  (ref) => throw UnimplementedError(),
);
final notificationServiceProvider = Provider<NotificationService>(
  (ref) => throw UnimplementedError(),
);
final appControllerProvider = ChangeNotifierProvider<AppController>(
  (ref) => throw UnimplementedError(),
);

final activeSessionProvider = StreamProvider<FastingSession?>((ref) {
  return ref.watch(repositoryProvider).watchActiveSession();
});

final sessionHistoryProvider = StreamProvider<List<FastingSession>>((ref) {
  return ref.watch(repositoryProvider).watchSessions();
});

final weightsProvider = StreamProvider<List<WeightEntry>>((ref) {
  return ref.watch(repositoryProvider).watchWeights();
});

final activePlanProvider = StreamProvider<FastingPlan?>((ref) {
  return ref.watch(repositoryProvider).watchPlan();
});

final waterEntriesProvider = StreamProvider.family<List<WaterEntry>, String>((
  ref,
  sessionId,
) {
  return ref.watch(repositoryProvider).watchWater(sessionId);
});

final dailyWaterProvider = StreamProvider.family<List<WaterEntry>, String>((
  ref,
  dateKey,
) {
  return ref
      .watch(repositoryProvider)
      .watchWaterForDay(DateTime.parse(dateKey));
});

final dailyHealthProvider = StreamProvider.family<DailyHealthLog?, String>((
  ref,
  dateKey,
) {
  return ref.watch(repositoryProvider).watchDailyHealth(dateKey);
});

final calorieEntriesProvider =
    StreamProvider.family<List<CalorieEntry>, String>((ref, dateKey) {
      return ref.watch(repositoryProvider).watchCalories(dateKey);
    });

final dailyTasksProvider = StreamProvider<List<DailyTask>>((ref) {
  return ref.watch(repositoryProvider).watchDailyTasks();
});

final taskProgressProvider =
    StreamProvider.family<List<TaskProgressEntry>, String>((ref, dateKey) {
      return ref.watch(repositoryProvider).watchTaskProgress(dateKey);
    });

String localDateKey(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-'
    '${value.month.toString().padLeft(2, '0')}-'
    '${value.day.toString().padLeft(2, '0')}';

class AppController extends ChangeNotifier {
  AppController({
    required this.repository,
    required this.authService,
    required this.notificationService,
  });

  final AppRepository repository;
  final AuthService authService;
  final NotificationService notificationService;

  bool initialized = false;
  bool onboardingComplete = false;
  int onboardingStep = 0;
  LanguagePreference language = LanguagePreference.system;
  AppAccentTheme accentTheme = AppAccentTheme.mint;
  UnitSystem unitSystem = UnitSystem.imperial;
  bool liquidMetric = false;
  int waterGoalMl = 2000;
  int stepGoal = 8000;
  int quickWaterMl = 250;
  int? calorieGoal;
  double? targetWeightKg;
  HealthReadStatus healthStepStatus = HealthReadStatus.permissionRequired;
  bool syncingHealthSteps = false;
  AuthSession? authSession;

  Locale? get locale => switch (language) {
    LanguagePreference.system => null,
    LanguagePreference.zh => const Locale('zh'),
    LanguagePreference.en => const Locale('en'),
  };

  Future<void> initialize() async {
    final onboarding = await repository.loadOnboarding();
    onboardingComplete = onboarding?.completed ?? false;
    onboardingStep = onboarding?.currentStep ?? 0;
    language = _languageFrom(await repository.getPreference('language'));
    accentTheme = _accentThemeFrom(
      await repository.getPreference('accentTheme'),
    );
    unitSystem = (await repository.getPreference('unitSystem')) == 'metric'
        ? UnitSystem.metric
        : UnitSystem.imperial;
    liquidMetric = (await repository.getPreference('liquidMetric')) == 'true';
    waterGoalMl =
        int.tryParse(await repository.getPreference('waterGoalMl') ?? '') ??
        2000;
    stepGoal =
        int.tryParse(await repository.getPreference('stepGoal') ?? '') ?? 8000;
    quickWaterMl =
        int.tryParse(await repository.getPreference('quickWaterMl') ?? '') ??
        250;
    calorieGoal = int.tryParse(
      await repository.getPreference('calorieGoal') ?? '',
    );
    targetWeightKg = double.tryParse(
      await repository.getPreference('targetWeightKg') ?? '',
    );
    authSession = await authService.restore();
    await repository.ensureDefaultPlan();
    await repository.ensureDefaultDailyTasks();
    initialized = true;
    notifyListeners();
    if (await repository.getPreference('healthStepsPermissionRequested') ==
        'true') {
      await refreshHealthSteps();
    }
  }

  Future<void> completeOnboarding(Map<String, Object?> answers) async {
    onboardingComplete = true;
    onboardingStep = 10;
    await repository.saveOnboarding(
      currentStep: 10,
      completed: true,
      answers: answers,
    );
    notifyListeners();
  }

  Future<void> saveOnboardingProgress(
    int step,
    Map<String, Object?> answers,
  ) async {
    onboardingStep = step;
    await repository.saveOnboarding(
      currentStep: step,
      completed: false,
      answers: answers,
    );
    notifyListeners();
  }

  Future<void> setLanguage(LanguagePreference value) async {
    language = value;
    await repository.setPreference('language', value.name);
    notifyListeners();
  }

  Future<void> setAccentTheme(AppAccentTheme value) async {
    accentTheme = value;
    await repository.setPreference('accentTheme', value.name);
    notifyListeners();
  }

  Future<void> setUnits(UnitSystem value, {bool? metricLiquid}) async {
    unitSystem = value;
    if (metricLiquid != null) liquidMetric = metricLiquid;
    await repository.setPreference('unitSystem', value.name);
    await repository.setPreference('liquidMetric', liquidMetric.toString());
    notifyListeners();
  }

  Future<void> setWaterGoal(int value) async {
    if (value < 250 || value > 10000) return;
    waterGoalMl = value;
    await repository.setPreference('waterGoalMl', '$value');
    notifyListeners();
  }

  Future<void> setStepGoal(int value) async {
    if (value < 500 || value > 100000) return;
    stepGoal = value;
    await repository.setPreference('stepGoal', '$value');
    notifyListeners();
  }

  Future<void> setQuickWater(int value) async {
    if (value < 10 || value > 5000) return;
    quickWaterMl = value;
    await repository.setPreference('quickWaterMl', '$value');
    notifyListeners();
  }

  Future<void> setCalorieGoal(int? value) async {
    calorieGoal = value;
    await repository.setPreference('calorieGoal', value?.toString() ?? '');
    notifyListeners();
  }

  Future<void> setTargetWeightKg(double? value) async {
    targetWeightKg = value;
    await repository.setPreference('targetWeightKg', value?.toString() ?? '');
    notifyListeners();
  }

  Future<StepReadResult> refreshHealthSteps({
    bool requestPermission = false,
  }) async {
    if (syncingHealthSteps) {
      return StepReadResult(status: healthStepStatus);
    }
    syncingHealthSteps = true;
    notifyListeners();
    final result = await repository.syncTodaySteps(
      requestPermission: requestPermission,
    );
    healthStepStatus = result.status;
    syncingHealthSteps = false;
    notifyListeners();
    return result;
  }

  Future<void> setAuthSession(AuthSession? value) async {
    authSession = value;
    notifyListeners();
  }

  Future<void> logout() async {
    await authService.logout();
    authSession = null;
    notifyListeners();
  }

  Future<File> exportJson() async {
    final data = await repository.exportSnapshot();
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/lighter-backup-${DateTime.now().millisecondsSinceEpoch}.json',
    );
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(data),
      flush: true,
    );
    return file;
  }

  Future<File> exportCsv() async {
    final data = await repository.exportSnapshot();
    const columns = [
      'recordType',
      'id',
      'startedAtUtcMs',
      'endedAtUtcMs',
      'targetMinutes',
      'endReason',
      'milliliters',
      'kilograms',
      'loggedAtUtcMs',
      'deletedAtUtcMs',
      'dateKey',
      'calories',
      'steps',
      'mealType',
      'stepSource',
      'stepsSyncedAtUtcMs',
      'taskId',
      'kind',
      'title',
      'iconKey',
      'colorKey',
      'goalType',
      'targetValue',
      'unit',
      'quickIncrement',
      'weekdaysMask',
      'reminderMinute',
      'sortOrder',
      'enabled',
      'deltaValue',
      'goalSnapshot',
      'unitSnapshot',
    ];
    final rows = <List<Object?>>[columns];
    void append(String recordType, Object? raw) {
      final record = raw! as Map<String, Object?>;
      rows.add(
        columns
            .map<Object?>(
              (column) => column == 'recordType' ? recordType : record[column],
            )
            .toList(),
      );
    }

    for (final row in (data['sessions'] as List<Object?>? ?? const [])) {
      append('fastingSession', row);
    }
    for (final row in (data['waterEntries'] as List<Object?>? ?? const [])) {
      append('waterEntry', row);
    }
    for (final row in (data['weightEntries'] as List<Object?>? ?? const [])) {
      append('weightEntry', row);
    }
    for (final row in (data['dailyHealthLogs'] as List<Object?>? ?? const [])) {
      append('dailyHealthLog', row);
    }
    for (final row in (data['calorieEntries'] as List<Object?>? ?? const [])) {
      append('calorieEntry', row);
    }
    for (final row in (data['dailyTasks'] as List<Object?>? ?? const [])) {
      append('dailyTask', row);
    }
    for (final row
        in (data['taskProgressEntries'] as List<Object?>? ?? const [])) {
      append('taskProgressEntry', row);
    }
    final csv = rows
        .map((row) => row.map(_csvCell).join(','))
        .join(Platform.lineTerminator);
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/lighter-records-${DateTime.now().millisecondsSinceEpoch}.csv',
    );
    await file.writeAsString('\uFEFF$csv', flush: true);
    return file;
  }

  Future<void> shareExport(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    final origin = box == null
        ? null
        : box.localToGlobal(Offset.zero) & box.size;
    final files = await Future.wait([exportJson(), exportCsv()]);
    await SharePlus.instance.share(
      ShareParams(
        files: files.map((file) => XFile(file.path)).toList(),
        subject: 'Lighter data export',
        sharePositionOrigin: origin,
      ),
    );
  }

  String _csvCell(Object? value) {
    if (value == null) return '';
    final text = value.toString();
    if (!text.contains(RegExp('[,"\\n\\r]'))) return text;
    return '"${text.replaceAll('"', '""')}"';
  }

  Future<void> clearData() async {
    final tasks = await repository.getDailyTasks();
    for (final task in tasks) {
      await notificationService.cancelTaskReminder(task.id);
    }
    await repository.clearLocalData();
    await authService.logout();
    authSession = null;
    onboardingComplete = false;
    onboardingStep = 0;
    language = LanguagePreference.system;
    accentTheme = AppAccentTheme.mint;
    unitSystem = UnitSystem.imperial;
    liquidMetric = false;
    waterGoalMl = 2000;
    stepGoal = 8000;
    quickWaterMl = 250;
    calorieGoal = null;
    targetWeightKg = null;
    healthStepStatus = HealthReadStatus.permissionRequired;
    await repository.ensureDefaultPlan();
    await repository.ensureDefaultDailyTasks();
    notifyListeners();
  }

  LanguagePreference _languageFrom(String? value) => switch (value) {
    'zh' => LanguagePreference.zh,
    'en' => LanguagePreference.en,
    _ => LanguagePreference.system,
  };

  AppAccentTheme _accentThemeFrom(String? value) => switch (value) {
    'ocean' => AppAccentTheme.ocean,
    'violet' => AppAccentTheme.violet,
    'coral' => AppAccentTheme.coral,
    'graphite' => AppAccentTheme.graphite,
    _ => AppAccentTheme.mint,
  };
}
