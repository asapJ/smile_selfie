abstract class Failure with Exception {
  Failure(this.message);

  final String message;

  @override
  String toString() {
    return message;
  }
}

class SelfieCaptureException extends Failure {
  SelfieCaptureException(String message) : super(message);
}
