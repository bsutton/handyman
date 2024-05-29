class SPException implements Exception {

  SPException(this.message);
  String message;
}

class InvalidState extends SPException {
  InvalidState(super.mesage);
}
