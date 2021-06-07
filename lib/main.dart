import 'package:flutter/material.dart';
import 'package:uni_news_app/src/services/app_translations.dart';
import 'package:uni_news_app/src/services/settings_controller.dart';
import 'package:uni_news_app/src/theming/theme_controller.dart';
import 'package:uni_news_app/views/bookmarks_page.dart';
import 'package:uni_news_app/views/home_page.dart';
import 'package:uni_news_app/views/search_news_page.dart';
import 'package:uni_news_app/views/settings_page.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  return runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    final settingsController = Get.put(SettingsController());
    final box = GetStorage();
    if (box.hasData("thememode") == false) {
      box.write("thememode", "system");
    }
    return SimpleBuilder(builder: (BuildContext context) {
      return GetMaterialApp(
        translations: AppTranslations(),
        locale: settingsController.getLocale(),
        fallbackLocale: Locale('en', 'US'),
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => HomePage()),
          GetPage(name: '/favourites', page: () => BookMarksPage(), transition: Transition.fadeIn),
          GetPage(name: '/settings', page: () => SettingsPage(), transition: Transition.fadeIn),
          GetPage(name: '/searchPage', page: () => SearchNewsPage()),
        ],
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('ru', 'RU'),
        ],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        theme: themeController.lightTheme,
        darkTheme: themeController.darkTheme,
        themeMode: themeController.getThemeMode(),
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      );
    });
  }
}
