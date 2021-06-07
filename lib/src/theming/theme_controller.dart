import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final darkTheme = ThemeData(
    //primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF212121),
    accentColor: Colors.white,
    accentIconTheme: IconThemeData(color: Colors.black),
    dividerColor: Colors.black12,
  );

  final lightTheme = ThemeData(
    //primarySwatch: Colors.grey,
    primaryColor: Colors.white,
    brightness: Brightness.light,
    backgroundColor: const Color(0xFFE5E5E5),
    accentColor: Colors.black,
    accentIconTheme: IconThemeData(color: Colors.white),
    dividerColor: Colors.white54,
  );

  final box = GetStorage();

  String get themeModeStatus => box.read("thememode");

  void changeTheme(bool val) {
    box.write('darkmode', val);
    update();
  }

  void changeThemeModeToDark() {
    box.write('thememode', "dark");
    update();
  }

  void changeThemeModeToLight() {
    box.write('thememode', "light");
    update();
  }

  void changeThemeModeToSystem() {
    box.write('thememode', "system");
    update();
  }

  ThemeMode getThemeMode() {
    if (box.read("thememode") == "dark") {
      return ThemeMode.dark;
    }
    if (box.read("thememode") == "light") {
      return ThemeMode.light;
    }
    return ThemeMode.system;
  }
}
