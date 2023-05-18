import 'package:safe_messages/models/url_type.dart';

class UrlStatusModel {
  final String url;
  final UrlType type;

  const UrlStatusModel({
    required this.url,
    required this.type,
  });
}
