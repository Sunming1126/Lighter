class FastingClockSnapshot {
  const FastingClockSnapshot({
    required this.elapsed,
    required this.remaining,
    required this.progress,
    required this.targetReached,
  });

  final Duration elapsed;
  final Duration remaining;
  final double progress;
  final bool targetReached;
}

FastingClockSnapshot calculateFastingClock({
  required DateTime startedAt,
  required DateTime now,
  required Duration target,
}) {
  final rawElapsed = now.difference(startedAt);
  final elapsed = rawElapsed.isNegative ? Duration.zero : rawElapsed;
  final rawRemaining = target - elapsed;
  final reached = rawRemaining <= Duration.zero;
  final progress = target.inMilliseconds <= 0
      ? 1.0
      : (elapsed.inMilliseconds / target.inMilliseconds).clamp(0.0, 1.0);
  return FastingClockSnapshot(
    elapsed: elapsed,
    remaining: reached ? Duration.zero : rawRemaining,
    progress: progress,
    targetReached: reached,
  );
}
