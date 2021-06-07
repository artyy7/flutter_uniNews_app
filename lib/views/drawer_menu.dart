import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_news_app/views/category_list_drawer.dart';
import '/helpers/settings_lists.dart';

class CustomDrawerMenu extends StatefulWidget {

  @override
  _CustomDrawerMenuState createState() => _CustomDrawerMenuState();
}

class _CustomDrawerMenuState extends State<CustomDrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.only(left: 15, right: 15),
        children: <Widget>[
          DrawerHeader(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: 83,
                      child: Container(child: Image.asset("assets/images/news_logo.png"))),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'drawerTitle'.tr,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 24,
                    ),
                  ),
                ]),
          ),
          ExpansionTile(
            leading: Icon(Icons.list),
            title: Text('drawerItem1'.tr),
            children: [
              ListView.builder(
                  itemCount: newsCategories.length,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return CategoryList(
                      categoryName: newsCategories[index]["name"],
                      categoryValue: newsCategories[index]["value"],
                    );
                  })
            ],
          ),
          ListTile(
            title: Text("drawerItem2".tr),
            leading: Icon(Icons.bookmark),
            onTap: () => Get.toNamed('/favourites'),
          ),
          ListTile(
            title: Text("drawerItem3".tr),
            leading: Icon(Icons.settings),
            onTap: () => Get.toNamed('/settings'),
          ),
          ListTile(
            title: Text("drawerItem4".tr),
            leading: Icon(Icons.exit_to_app),
            onTap: () => exit(0),
          ),
        ],
      ),
    );
  }
}
