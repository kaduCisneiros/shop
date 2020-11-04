class HttpExeption implements Exception {
  final String msg;

  const HttpExeption(this.msg);

  @override
  String toString() {
    return msg;
  }
}
