import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uni_news_app/db/database.dart';
import 'package:uni_news_app/helpers/custom_search_delegates.dart';
import 'package:uni_news_app/helpers/news_card.dart';
import 'package:uni_news_app/models/article_model.dart';
import 'package:uni_news_app/models/recentsearch_model.dart';
import 'package:uni_news_app/src/services/settings_controller.dart';
import 'package:uni_news_app/views/drawer_menu.dart';
import 'package:uni_news_app/views/search_news_page.dart';
import '../helpers/news_data_getters.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showBackToTopButton = false;
  ScrollController _scrollController;
  DateTime _selectedDateForSearch;
  DateTime _emptyDate;
  Future<List<RecentSearch>> _recentSearchList;
  Future<List<Article>> _newsArticles;
  GetNews service = GetNews();
  final settingsController = Get.put(SettingsController());

  @override
  void initState() {
    super.initState();
    _getNews();
    _getRecentSearches();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset > 900) {
            _showBackToTopButton = true;
          } else {
            _showBackToTopButton = false;
          }
        });
      });
  }

  _getNews() async {
    setState(() {
      switch (settingsController.checkNewsFeedStatus) {
        case "default":
          _newsArticles = service.getNewsData(
              settingsController.curNewsRegion, settingsController.curNewsCategory);
          break;
        case "custom":
          _newsArticles = service.getNewsForSelectedDomains(settingsController.getNewsDomains);
      }
    });
  }

  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      switch (settingsController.checkNewsFeedStatus) {
        case "default":
          _newsArticles = service.getNewsData(
              settingsController.curNewsRegion, settingsController.curNewsCategory);
          break;
        case "custom":
          _newsArticles = service.getNewsForSelectedDomains(settingsController.getNewsDomains);
      }
    });
  }

  _getRecentSearches() {
    setState(() {
      _recentSearchList = DBProvider.db.getRecentSearches();
    });
  }

  ///Open DatePicker for extended search.
  void _presentDatePicker() async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
      locale: settingsController.getLocale(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDateForSearch = pickedDate;
      });
    });
  }

  ///Resets the chosen date.
  void _resetDate() {
    setState(() {
      _selectedDateForSearch = null;
    });
  }

  ///Open SearchPage.
  void _beginSearch(String searchValue) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SearchNewsPage(
                  searchValue: searchValue,
                  resetDate: _resetDate,
                  dateTime: _selectedDateForSearch != null
                      ? DateFormat.yMd().format(_selectedDateForSearch)
                      : _emptyDate,
                )));
  }

  ///Opens SearchAppBar.
  Future<void> _showSearch() async {
    await _getRecentSearches();
    await showSearch<RecentSearch>(
      context: context,
      delegate: CustomSearchDelegate(
        oldFilters: _recentSearchList,
        showDatePicker: _presentDatePicker,
        beginSearch: _beginSearch,
        updateList: _getRecentSearches,
        resetDate: _resetDate,
      ),
    );
  }

  ///Jump to top.
  void _scrollToTop() async {
    await _scrollController.animateTo(0, duration: Duration(seconds: 1), curve: Curves.bounceIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawerMenu(),
      appBar: AppBar(
          centerTitle: true,
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
              ),
            ],
          ),
          elevation: 1,
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: _showSearch,
            ),
          ]),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: FutureBuilder(
            future: _newsArticles,
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
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          'snapshotErrorHomePage'.tr,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                            onPressed: _refreshData, child: Text("snapshotErrorUpdateButton".tr)),
                      )
                    ],
                  ),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  controller: _scrollController,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) => NewsCard(
                        article: snapshot.data[index],
                      ));
            },
          ),
        ),
      ),
      floatingActionButton: _showBackToTopButton == false
          ? null
          : FloatingActionButton(
              onPressed: _scrollToTop,
              backgroundColor: Colors.lightBlue,
              foregroundColor: Colors.white,
              child: Icon(Icons.arrow_upward),
            ),
    );
  }
}
