class SmileSelfieOptions {
  ///Must be a value between 0.0 and 1.0 inclusive
  final double smileProbability;

  ///Must be a value between 0.0 and 1.0 inclusive
  final double eyesOpenProbabilty;

  ///Add a delay before the first capture is processed
  final Duration? delay;

  const SmileSelfieOptions({
    this.delay,
    this.smileProbability = 0.0,
    this.eyesOpenProbabilty = 0.0,
  });
}
