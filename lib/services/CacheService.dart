import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class CacheService {
  static const String BOX_NAME = 'networkCache';

  final String key;
  final Duration cacheUpdateInterval;

  CacheService(this.key, this.cacheUpdateInterval);

  /// Open the hive box and get ready for reading and writing the cache.
  Future initialize() async {
    await Hive.initFlutter((await getApplicationDocumentsDirectory()).path);
    await Hive.openBox(BOX_NAME);
  }

  /// Caches the given data with [DateTime.now()] so that the time can be
  /// compared later if we want to update.
  Future cache({@required String data}) async {
    var box = Hive.box(BOX_NAME);
    await box.put(key, [DateTime.now().toString(), data]);
  }

  /// Gets the cached data which is stored in index 1 of the list we store.
  Future<String> getCachedData() async {
    var data = await Hive.box(BOX_NAME).get(key);
    if (data == null || data[1] == null) return null;
    return data[1];
  }

  /// Gets the cached [DateTime] which is stored in index 0 of the list we store.
  Future<DateTime> getCachedDateTime() async {
    var data = await Hive.box(BOX_NAME).get(key);
    if (data == null || data[0] == null) return null;
    return DateTime.parse(data[0]);
  }

  bool shouldUpdateCache({String cachedData, DateTime cachedDateTime}) {
    if (cachedData == null) return true;
    if (cachedData.isEmpty) return true;
    DateTime now = DateTime.now();
    bool hasAnime =
        (jsonDecode(cachedData.isEmpty ? "{[]}" : cachedData) as List<dynamic>)
                .length >
            0;
    if (!hasAnime) return true;
    return now.difference(cachedDateTime).abs() > cacheUpdateInterval;
  }

  Future<String> getDataAndCacheIfNeeded({
    Future<String> Function() getData,
    Function() onCache,
    Function() onSkipCache,
  }) async {
    String cachedAnimeData = await getCachedData();
    DateTime cachedDate = await getCachedDateTime();
    String ret;

    if (shouldUpdateCache(
        cachedData: cachedAnimeData, cachedDateTime: cachedDate)) {
      ret = await getData();
      cache(data: ret);
      await onCache();
    } else {
      ret = cachedAnimeData;
      await onSkipCache();
    }
    return ret;
  }
}
