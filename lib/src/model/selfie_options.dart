class SmileSelfieOptions {
  ///Must be a value between 0.0 and 1.0 inclusive
  final double smileTreshold;

  ///Must be a value between 0.0 and 1.0 inclusive
  final double eyesOpenTreshold;
  final double imagePreviewSize;
  final String title;

  const SmileSelfieOptions(
      {this.smileTreshold = 0.0,
      this.title = 'Smile to take a selfie',
      this.eyesOpenTreshold = 0.0,
      this.imagePreviewSize = 500});
}