extension NumFormat on String {
  String toNumFormat() => replaceAll('+91', '').replaceAll(' ', '');
  bool containsUrl() {
    final urlRegExp = RegExp(r'https?://[^\s]+');
    final matches = urlRegExp.allMatches(this);
    if (matches.isNotEmpty) {
      return true;
    }
    return false;
  }
}

List<String?> extractURLs(String text) {
  final urlRegExp = RegExp(r'https?://[^\s]+');
  final matches = urlRegExp.allMatches(text);
  final urlsInStr = matches.map((match) => match.group(0)).toList();
  return urlsInStr;
}
