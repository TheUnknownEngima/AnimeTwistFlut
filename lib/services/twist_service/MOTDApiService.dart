// Message of the day utils

// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import '../../secrets.dart';

class MOTDApiService {
  Future<List<String>> getMOTD() async {
    List<String> data = [];
    var response = await http.get(
      'https://twist.moe/api/motd',
      headers: {
        'x-access-token': x_access_token,
      },
    );

    Map<String, dynamic> jsonData = jsonDecode(response.body);

    data.add(jsonData["title"]);
    data.add(_parseMOTD(jsonData["message"]));
    return data;
  }

  String _parseMOTD(String motd) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return motd.replaceAll(exp, '');
  }
}
