import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:safe_messages/models/url_type.dart';

class LinkVerifier {
  final dio = Dio();
  String apiKey = dotenv.env['API_KEY'] ?? 'Default API Key';

  Future<UrlType> getUrlType(String url) async {
    final requestUrl =
        'https://safebrowsing.googleapis.com/v4/threatMatches:find?key=$apiKey';
    Map<String, dynamic> reqBody = {
      "client": {
        "clientId": "your-client-id",
        "clientVersion": "1.0.0",
      },
      "threatInfo": {
        "threatTypes": ["SOCIAL_ENGINEERING", "THREAT_TYPE_UNSPECIFIED"],
        "platformTypes": ["ANY_PLATFORM"],
        "threatEntryTypes": ["URL"],
        "threatEntries": [
          {"url": url}
        ],
      },
    };

    try {
      final response = await dio.post(requestUrl, data: jsonEncode(reqBody));
      debugPrint('URL ==> \n $requestUrl');
      debugPrint('URL Response is  ==> \n ${response.data}');
      if (response.data['matches'] == null) {
        return UrlType.safe;
      } else {
        return UrlType.unsafe;
      }
    } catch (e) {
      debugPrint('URL Report Error is ==> $e');
      return UrlType.unknown;
    }
  }
}
