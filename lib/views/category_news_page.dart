import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_news_app/helpers/news_data_getters.dart';
import 'package:uni_news_app/helpers/news_card.dart';
import 'package:uni_news_app/models/article_model.dart';
import 'package:uni_news_app/src/services/settings_controller.dart';

class CategoryNewsPage extends StatefulWidget {
  final String categoryValue;

  CategoryNewsPage({this.categoryValue});

  @override
  _CategoryNewsPageState createState() => _CategoryNewsPageState();
}

class _CategoryNewsPageState extends State<CategoryNewsPage> {
  Future<List<Article>> newsArticles;
  GetNews service = GetNews();
  final settingsController = Get.put(SettingsController());

  @override
  void initState() {
    _getNews();
    super.initState();
  }

  _getNews() async {
    setState(() {
      newsArticles =
          service.getNewsForCategory(settingsController.curNewsRegion, widget.categoryValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        actions: [
          Opacity(
            opacity: 0,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.share,
                )),
          )
        ],
        elevation: 1,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: newsArticles,
          builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/no_internet_conn.png",
                      scale: 2,
                    ),
                    Text(
                      'snapshotErrorHomePage'.tr,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) => NewsCard(
                      article: snapshot.data[index],
                    ));
          },
        ),
      ),
    );
  }
}
