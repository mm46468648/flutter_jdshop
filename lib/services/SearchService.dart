import 'dart:convert';

import 'package:flutter_jdshop/services/Storage.dart';

class SearchService {
  static const searchHistoryKey = 'search_history_list';

  static setSearchHistory(value) async {
    var history = await Storage.getString(searchHistoryKey);

    print("setSearchHistory====${value}");
    //没有数据的时候,直接存储
    if (history == null) {
      List tempList = [];
      tempList.add(value);
      await Storage.setString(searchHistoryKey, json.encode(tempList));
      return;
    }
    var serachListData = json.decode(history);

    //有数据直接返回
    if (serachListData is List) {
      var has = serachListData.any((element) => element == value);
      if (!has) {
        serachListData.add(value);
        await Storage.setString(searchHistoryKey, json.encode(serachListData));
      }
    }
  }

  static deleteHistoryWord(keyword) async {
    var history = await Storage.getString(searchHistoryKey);

    if (history != null) {
      var serachListData = json.decode(history) as List;
      var has = serachListData.any((element) => element == keyword);
      if (has) {
        serachListData.remove(keyword);
        await Storage.setString(searchHistoryKey, json.encode(serachListData));
      }
    }
  }

  static clearHistory() async {
    await Storage.remove(searchHistoryKey);
  }

  static getSearchHistory() async {
    var value = await Storage.getString(searchHistoryKey);
    print("getSearchHistory====${value}");
    if (value == null) {
      return [];
    } else {
      return json.decode(value) as List;
    }
  }
}
