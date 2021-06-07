import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:uni_news_app/src/services/settings_controller.dart';
import 'package:uni_news_app/src/theming/theme_controller.dart';
import 'package:package_info/package_info.dart';
import 'package:uni_news_app/db/database.dart';
import '/helpers/settings_lists.dart';
import 'package:smart_select/smart_select.dart';

class SettingsPage extends StatefulWidget {

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final settingsController = Get.put(SettingsController());
  List<String> selectedDomain = [];

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "drawerItem3".tr,
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.w600),
        ),
        elevation: 1,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  "settingsHeader1".tr,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Card(
              child: Column(
                children: [
                  ListTile(
                    enabled: settingsController.checkNewsFeedStatus == "custom" ? false : true,
                    title: Text("settingsChangeNewsLang".tr),
                    leading: Icon(Icons.article_outlined),
                    subtitle: Text(settingsController.curNewsRegionName),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => Get.defaultDialog(
                      title: "settingsChangeNewsLang".tr,
                      content: Container(
                        width: double.maxFinite,
                        height: deviceHeight < 500
                            ? 160
                            : deviceHeight > 800
                                ? 200
                                : deviceHeight * 0.5,
                        child: ListView.builder(
                            itemCount: newsCountry.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  title: Text(newsCountry[index]['name'].toString()),
                                  trailing: Icon(Icons.keyboard_arrow_right),
                                  onTap: () {
                                    settingsController
                                        .changeNewsRegion(newsCountry[index]['value']);
                                    settingsController
                                        .saveNewsRegionName(newsCountry[index]['name']);
                                    Get.offAllNamed("/");
                                  });
                            }),
                      ),
                    ),
                  ),
                  ListTile(
                    enabled: settingsController.checkNewsFeedStatus == "custom" ? false : true,
                    title: Text("settingsChangeNewsDefaultCategory".tr),
                    leading: Icon(Icons.analytics_sharp),
                    subtitle: Text(settingsController.curNewsCategoryName),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => Get.defaultDialog(
                      title: "settingsChangeNewsDefaultCategoryDialog".tr,
                      content: Container(
                        height: deviceHeight < 500
                            ? 160
                            : deviceHeight > 800
                                ? 200
                                : deviceHeight * 0.5,
                        width: double.maxFinite,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: newsCategories.length,
                          itemBuilder: (context, position) {
                            return InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {},
                                child: ListTile(
                                  title: Text(newsCategories[position]['name']),
                                  trailing: Icon(Icons.keyboard_arrow_right),
                                  onTap: () => {
                                    settingsController.changeNewsDefaultCategory(
                                        newsCategories[position]['value']),
                                    settingsController.saveNewsDefaultCategoryName(
                                        newsCategories[position]['name']),
                                    Get.offAllNamed("/"),
                                  },
                                ));
                          },
                        ),
                      ),
                    ),
                  ),
                  SmartSelect<String>.multiple(
                    title: 'selectedSources'.tr,
                    onChange: (selected) => setState(() => selectedDomain = selected.value),
                    choiceItems: newsDomains,
                    modalType: S2ModalType.popupDialog,
                    modalConfirm: true,
                    placeholder: settingsController.getNewsDomains?.replaceAll(RegExp(','), ', ') ??
                        'chooseOne'.tr,
                    choiceStyle: S2ChoiceStyle(
                      activeColor: Colors.blue,
                      titleStyle: TextStyle(color: Theme.of(context).accentColor),
                    ),
                    modalValidation: (value) {
                      return value.length > 0 ? null : 'chooseOne'.tr;
                    },
                    modalHeaderStyle: S2ModalHeaderStyle(
                      textStyle: TextStyle(color: Theme.of(context).accentColor),
                      backgroundColor: Theme.of(context).cardColor,
                    ),
                    modalConfig: const S2ModalConfig(
                      style: S2ModalStyle(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                      ),
                    ),
                    tileBuilder: (context, state) {
                      return S2Tile.fromState(
                        state,
                        enabled: Get.deviceLocale == Locale('ru', 'RU') ||
                                settingsController.curLocale == "ru"
                            ? true
                            : false,
                        isTwoLine: true,
                        leading: Container(
                          width: 30,
                          padding: EdgeInsets.only(left: 1.1),
                          alignment: Alignment.centerLeft,
                          child: const Icon(Icons.add_chart),
                        ),
                      );
                    },
                    modalActionsBuilder: (context, state) {
                      return [];
                    },
                    modalDividerBuilder: (context, state) {
                      return Divider(
                        height: 1,
                        color: Theme.of(context).accentColor,
                      );
                    },
                    modalFooterBuilder: (context, state) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 7.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            const Spacer(),
                            TextButton(
                              child: Text('clearNo'.tr),
                              onPressed: () => state.closeModal(confirmed: false),
                            ),
                            const SizedBox(width: 5),
                            TextButton(
                                child: Text('Oк (${state.changes.length})'),
                                onPressed: state.changes.length >= 1 && state.changes.length <= 5
                                    ? () => {
                                          settingsController
                                              .saveDomains(state.changes.value.join(',')),
                                          print(settingsController.getNewsDomains),
                                          settingsController.changeNewsFeedStatus("custom"),
                                          state.closeModal(confirmed: true),
                                          Get.offAllNamed("/"),
                                        }
                                    : null),
                          ],
                        ),
                      );
                    },
                    value: [],
                  ),
                  ListTile(
                    title: Text("clearSources".tr),
                    leading: Icon(Icons.delete_forever),
                    enabled: Get.deviceLocale == Locale('ru', 'RU') ||
                            settingsController.curLocale == "ru"
                        ? true
                        : false,
                    onTap: () {
                      Get.defaultDialog(
                          title: "clearSearchHistoryTitle".tr,
                          content: Text("clearSourcesDialog".tr),
                          confirm: TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedDomain.clear();
                                  settingsController.changeNewsFeedStatus("default");
                                  settingsController.clearNewsDomains();
                                });
                                Get.back();
                              },
                              child: Text("clearYes".tr)),
                          cancel:
                              TextButton(onPressed: () => Get.back(), child: Text("clearNo".tr)));
                    },
                  )
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  "settingsHeader2".tr,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text('settingsChangeAppThemeToSystem'.tr),
                    value: themeController.themeModeStatus == "system",
                    onChanged: (val) {
                      if (val) {
                        themeController.changeThemeModeToSystem();
                      } else {
                        themeController.changeThemeModeToLight();
                      }
                    },
                    secondary: const Icon(Icons.brightness_auto),
                    // ),
                  ),
                  SwitchListTile(
                    title: Text('settingsChangeAppThemeToDark'.tr),
                    value: themeController.themeModeStatus == "dark",
                    onChanged: themeController.themeModeStatus != "system"
                        ? (val) {
                            if (val) {
                              themeController.changeThemeModeToDark();
                            } else {
                              themeController.changeThemeModeToLight();
                            }
                          }
                        : null,
                    secondary: const Icon(Icons.brightness_2),
                    // ),
                  ),
                  ListTile(
                    title: Text("settingsChangeAppLang".tr),
                    leading: Icon(Icons.language_sharp),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => Get.defaultDialog(
                      title: "settingsChangeAppLang".tr,
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text("Русский"),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () {
                              Get.updateLocale(Locale("ru", "RU"));
                              settingsController.saveLocale("ru");
                              Get.back();
                            },
                          ),
                          ListTile(
                            title: Text("English"),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () {
                              Get.updateLocale(Locale("en", "US"));
                              settingsController.saveLocale("en");
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text("settingsClearSearchHistory".tr),
                    leading: Icon(Icons.delete),
                    onTap: () {
                      Get.defaultDialog(
                          title: "clearSearchHistoryTitle".tr,
                          content: Text("clearSearchHistoryMiddle".tr),
                          confirm: TextButton(
                              onPressed: () => {
                                    DBProvider.db.deleteAllRecentSearches(),
                                    Get.back(),
                                  },
                              child: Text("clearYes".tr)),
                          cancel:
                              TextButton(onPressed: () => Get.back(), child: Text("clearNo".tr)));
                    },
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  'appInfoTitle'.tr,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Card(
              child: Column(
                children: [
                  ListTile(
                    enabled: false,
                    title: Text(
                      'appVersion'.tr,
                      style: TextStyle(color: Get.isDarkMode ? Colors.white70 : Colors.black45),
                    ),
                    trailing: FutureBuilder<PackageInfo>(
                        future: PackageInfo.fromPlatform(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              '${snapshot.data.version}',
                              style: TextStyle(
                                  color: Get.isDarkMode ? Colors.white70 : Colors.black45),
                            );
                          }
                          return Text("...");
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
