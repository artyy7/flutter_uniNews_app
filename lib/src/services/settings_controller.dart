import 'dart:ui';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final settingsBox = GetStorage();
  String get curNewsRegion => settingsBox.read("newsLanguage") ?? "ru";
  String get curNewsRegionName => settingsBox.read("newsRegName") ?? "Россия";

  String get curNewsCategory => settingsBox.read('newsCategory') ?? 'technology';
  String get curNewsCategoryName => settingsBox.read('newsCategoryName') ?? 'newsCategory7'.tr;

  String get getNewsDomains => settingsBox.read("newsDomains");

  String get curLocale => settingsBox.read("curLocale");

  String get checkNewsFeedStatus => settingsBox.read("newsFeedStatus") ?? "default";

  void changeNewsRegion(var value) {
    settingsBox.write('newsLanguage', value);
  }

  void saveNewsRegionName(var value) {
    settingsBox.write('newsRegName', value);
  }

  void changeNewsDefaultCategory(var value) {
    settingsBox.write('newsCategory', value);
  }

  void saveNewsDefaultCategoryName(var value) {
    settingsBox.write('newsCategoryName', value);
  }

  void saveLocale(var curLocale) {
    switch (curLocale) {
      case "ru":
        settingsBox.write("curLocale", curLocale);
        break;
      case "en":
        settingsBox.write("curLocale", curLocale);
        break;
    }
  }

  Locale getLocale() {
    if (settingsBox.read("curLocale") == "ru") {
      return Locale('ru', 'RU');
    }
    if (settingsBox.read("curLocale") == "en") {
      return Locale('en', 'US');
    }
    return Get.deviceLocale;
  }

  void saveDomains(var value) {
    settingsBox.write("newsDomains", value);
  }

  void changeNewsFeedStatus(var value) {
    settingsBox.write("newsFeedStatus", value);
  }

  void clearNewsDomains() {
    settingsBox.remove("newsDomains");
  }

  void testingLOL(var value) {
    settingsBox.write("testing", value);
  }
}
