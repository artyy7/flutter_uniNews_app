import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_news_app/helpers/news_data_getters.dart';
import 'package:uni_news_app/helpers/news_card.dart';
import 'package:uni_news_app/models/article_model.dart';
import 'package:uni_news_app/src/services/settings_controller.dart';

import 'home_page.dart';

class SearchNewsPage extends StatefulWidget {
  final String searchValue;
  final String dateTime;
  final Function resetDate;

  SearchNewsPage({this.searchValue, this.dateTime, this.resetDate});

  @override
  _SearchNewsPageState createState() => _SearchNewsPageState();
}

class _SearchNewsPageState extends State<SearchNewsPage> {
  Future<List<Article>> _newsArticles;
  String _languageCode;
  GetNews service = GetNews();
  final settingsController = Get.put(SettingsController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCountryCode();
    _getNews();
  }

  _getCountryCode() async {
    switch (settingsController.curNewsRegion) {
      case "ru":
        _languageCode = "ru";
        break;
      case "us":
        _languageCode = "en";
        break;
      case "gb":
        _languageCode = "en";
        break;
      case "de":
        _languageCode = "de";
        break;
      case "ua":
        _languageCode = "uk";
        break;
      case "cn":
        _languageCode = "zh";
        break;
      case "jp":
        _languageCode = "ja";
        break;
    }
  }

  _getNews() async {
    setState(() {
      _newsArticles =
          service.getNewsForSearchValue(widget.searchValue, widget.dateTime, _languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        primary: Color(0xFFA9A9D0),
        shadowColor: Color(0xFFC5C5E7).withOpacity(0.17),
        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold));

    return WillPopScope(
      onWillPop: () async {
        widget.resetDate();
        Get.offAll(() => HomePage());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              widget.resetDate();
              Get.offAll(() => HomePage());
            },
            color: Theme.of(context).accentColor,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "appbarMainTitle1".tr,
                style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.w600),
              ),
              Text(
                "appbarMainTitle2".tr,
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
              )
            ],
          ),
          actions: <Widget>[
            SizedBox(
              width: 41,
            ),
          ],
        ),
        body: FutureBuilder(
            future: _newsArticles,
            builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data.length == 0) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      "assets/images/no_search_results.png",
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.31,
                      left: MediaQuery.of(context).size.width * 0.150,
                      //right: MediaQuery.of(context).size.width * 0.010,
                      child: Text(
                        "sorrySearchError".tr,
                        style: TextStyle(fontSize: 35, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.26,
                      left: MediaQuery.of(context).size.width * 0.158,
                      //right: MediaQuery.of(context).size.width * 0.010,
                      child: Text(
                        "sorrySearchErrorPhrase".tr,
                        style: TextStyle(fontSize: 15, color: Colors.white, letterSpacing: 0.2),
                      ),
                    ),
                    Positioned(
                        bottom: MediaQuery.of(context).size.height * 0.10,
                        left: MediaQuery.of(context).size.width * 0.300,
                        right: MediaQuery.of(context).size.width * 0.300,
                        child: ElevatedButton(
                          style: style,
                          child: Text(
                            "goBackButton".tr,
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async =>
                              Get.offAll(() => HomePage()),
                        )),
                  ],
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) => NewsCard(
                        article: snapshot.data[index],
                      ));
            }),
      ),
    );
  }
}
