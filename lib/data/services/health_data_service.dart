import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:health/health.dart';

import '../../core/contracts.dart';

class AppleHealthDataSource implements HealthDataSource {
  AppleHealthDataSource([Health? health]) : _health = health ?? Health();

  final Health _health;
  bool _configured = false;

  @override
  Future<StepReadResult> readTodaySteps({
    required bool requestAuthorization,
  }) async {
    if (!Platform.isIOS || !_health.isDataTypeAvailable(HealthDataType.STEPS)) {
      return const StepReadResult(status: HealthReadStatus.unavailable);
    }
    try {
      if (!_configured) {
        await _health.configure();
        _configured = true;
      }
      if (requestAuthorization) {
        final accepted = await _health.requestAuthorization(
          const [HealthDataType.STEPS],
          permissions: const [HealthDataAccess.READ],
        );
        if (!accepted) {
          return const StepReadResult(
            status: HealthReadStatus.permissionRequired,
          );
        }
      }
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, now.day);
      final steps = await _health.getTotalStepsInInterval(start, now);
      if (steps == null) {
        return const StepReadResult(
          status: HealthReadStatus.permissionRequired,
        );
      }
      return StepReadResult(
        status: HealthReadStatus.ready,
        steps: steps,
        synchronizedAt: now.toUtc(),
      );
    } catch (error, stackTrace) {
      debugPrint('HealthKit step read unavailable: $error');
      debugPrintStack(stackTrace: stackTrace);
      return StepReadResult(
        status: HealthReadStatus.error,
        debugMessage: error.runtimeType.toString(),
      );
    }
  }
}

class UnavailableHealthDataSource implements HealthDataSource {
  const UnavailableHealthDataSource();

  @override
  Future<StepReadResult> readTodaySteps({
    required bool requestAuthorization,
  }) async => const StepReadResult(status: HealthReadStatus.unavailable);
}

class MockHealthDataSource implements HealthDataSource {
  const MockHealthDataSource({this.steps = 6420});

  final int steps;

  @override
  Future<StepReadResult> readTodaySteps({
    required bool requestAuthorization,
  }) async => StepReadResult(
    status: HealthReadStatus.ready,
    steps: steps,
    synchronizedAt: DateTime.now().toUtc(),
  );
}
