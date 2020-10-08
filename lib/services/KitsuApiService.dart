// Dart imports:
import 'dart:convert';

// Project imports:
import '../cached_http_get/CachedHttpGet.dart';
import '../models/KitsuModel.dart';

class KitsuApiService {
  Future<KitsuModel> getKitsuModel(int kitsuID) async {
    String response = await CachedHttpGet.get(
      Request(
        url: 'https://kitsu.io/api/edge/anime/$kitsuID',
        header: {
          'accept': 'application/vnd.api+json',
          'content-type': 'application/vnd.api+json'
        },
      ),
    );

    Map<dynamic, dynamic> jsonData = jsonDecode(response);
    // Check if the kitsu id is invalid.
    // A better solution would be to check for the status code but CachedHttpGet
    // doesnt support this as of now.
    if (jsonData["errors"] != null) return null;

    return KitsuModel.fromJson(jsonData);
  }
}
