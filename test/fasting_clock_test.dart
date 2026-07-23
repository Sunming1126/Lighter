import 'package:flutter_test/flutter_test.dart';
import 'package:lighter/core/fasting_clock.dart';

void main() {
  test('calculates progress from timestamps instead of accumulated ticks', () {
    final start = DateTime.utc(2026, 7, 22, 12);
    final snapshot = calculateFastingClock(
      startedAt: start,
      now: start.add(const Duration(hours: 6)),
      target: const Duration(hours: 12),
    );

    expect(snapshot.elapsed, const Duration(hours: 6));
    expect(snapshot.remaining, const Duration(hours: 6));
    expect(snapshot.progress, .5);
    expect(snapshot.targetReached, isFalse);
  });

  test('continues safely after the target is reached', () {
    final start = DateTime.utc(2026, 7, 22, 12);
    final snapshot = calculateFastingClock(
      startedAt: start,
      now: start.add(const Duration(hours: 14)),
      target: const Duration(hours: 12),
    );

    expect(snapshot.elapsed, const Duration(hours: 14));
    expect(snapshot.remaining, Duration.zero);
    expect(snapshot.progress, 1);
    expect(snapshot.targetReached, isTrue);
  });

  test('guards against device clock moving before start', () {
    final start = DateTime.utc(2026, 7, 22, 12);
    final snapshot = calculateFastingClock(
      startedAt: start,
      now: start.subtract(const Duration(minutes: 30)),
      target: const Duration(hours: 12),
    );

    expect(snapshot.elapsed, Duration.zero);
    expect(snapshot.progress, 0);
  });
}
