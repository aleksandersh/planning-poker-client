class AppConfig {
  static final Uri host = _getApiHost();
  static const _hostLocal = "http://127.0.0.1:80";

  static Uri _getApiHost() {
    const host =
        String.fromEnvironment("POKER_API_HOST", defaultValue: _hostLocal);
    return Uri.parse(host);
  }
}
