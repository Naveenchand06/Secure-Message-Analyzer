extension NumFormat on String {
  String toNumFormat() => replaceAll('+91', '').replaceAll(' ', '');
}
