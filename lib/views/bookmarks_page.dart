import 'package:flutter/material.dart';
import 'package:uni_news_app/db/database.dart';
import 'package:uni_news_app/models/bookmark_model.dart';
import 'package:uni_news_app/views/article_view_page.dart';
import 'package:get/get.dart';

class BookMarksPage extends StatefulWidget {
  @override
  _BookMarksPageState createState() => _BookMarksPageState();
}

class _BookMarksPageState extends State<BookMarksPage> {
  Future<List<BookMark>> _bookMarksList;
  bool iconButton = false;

  @override
  void initState() {
    super.initState();
    updateBookMarksList();
  }

  updateBookMarksList() {
    setState(() {
      _bookMarksList = DBProvider.db.getBookMarks();
    });
  }

  Widget _buildIconButton() {
    return iconButton == true
        ? IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Get.defaultDialog(
                title: "clearBookmarksListTitle".tr,
                middleText: "clearBookmarksListMiddle".tr,
                confirm: TextButton(
                    onPressed: () {
                      //Navigator.of(context).pop();
                      DBProvider.db.deleteAllBookMarks();
                      updateBookMarksList();
                      setState(() {
                        iconButton = false;
                      });
                      _buildIconButton();
                      Get.back();
                    },
                    child: Text("clearYes".tr)),
                cancel: TextButton(onPressed: () => Get.back(), child: Text("clearNo".tr)),
              );
            })
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "appbarBookmarksTitle".tr,
          textAlign: TextAlign.center,
          style: TextStyle(
              //color: Theme.of(context).accentColor,
              fontWeight: FontWeight.w600),
        ),
        elevation: 1,
        actions: [_buildIconButton()],
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: _bookMarksList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _generateList(snapshot.data);
              }
              if (snapshot.hasError) {
                return Text("No data found");
              }
              return CircularProgressIndicator();
            }),
      ),
    );
  }

  _generateList(List<BookMark> bookMarks) {
    if (bookMarks.isNotEmpty) {
      Future.delayed(Duration.zero, () async {
        setState(() {
          iconButton = true;
        });
      });
    }
    return bookMarks.isEmpty
        ? Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: 100,
                child: Image.asset(
                  Get.isDarkMode
                      ? "assets/images/bookmark_add_white.png"
                      : "assets/images/bookmark_add_black.png",
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text("favouritesAddNewMessage".tr, style: TextStyle(fontSize: 16)),
            ]),
          )
        : ListView.builder(
            itemCount: bookMarks.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,
                child: ListTile(
                  leading: Image.asset(
                    "assets/images/news_paper_icon.png",
                    scale: 1.05,
                  ),
                  title: Text(
                    '${bookMarks[index].title}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ArticleView(
                                  postUrl: bookMarks[index].link,
                                )));
                  },
                  trailing: IconButton(
                    icon: Icon(
                      Icons.remove_circle_outline,
                      color: Theme.of(context).errorColor,
                    ),
                    onPressed: () {
                      DBProvider.db.deleteBookMark(bookMarks[index].id);
                      updateBookMarksList();
                      Get.snackbar(
                        "",
                        "",
                        snackPosition: SnackPosition.BOTTOM,
                        duration: Duration(seconds: 1),
                        titleText: Text(
                          "snackSuccess".tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
                        ),
                        messageText: Text(
                          "snackMessageBookmarkDelete".tr,
                          style: TextStyle(color: Theme.of(context).accentColor),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
  }
}
