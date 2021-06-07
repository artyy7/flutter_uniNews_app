import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:uni_news_app/db/database.dart';
import 'package:uni_news_app/models/bookmark_model.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share/share.dart';

class ArticleView extends StatefulWidget {
  final String postUrl;
  final String articleTitle;

  ArticleView({@required this.postUrl, this.articleTitle});

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            )
          ],
        ),
        actions: [
          widget.articleTitle != null
              ? IconButton(
                  onPressed: () {
                    DBProvider.db.insertBookMark(
                        BookMark(id: null, title: widget.articleTitle, link: widget.postUrl));
                    Get.snackbar('', "",
                        snackPosition: SnackPosition.BOTTOM,
                        barBlur: 100,
                        titleText: Text(
                          "snackSuccess".tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
                        ),
                        messageText: Text(
                          "snackMessageBookmarkAdd".tr,
                          style: TextStyle(color: Theme.of(context).accentColor),
                        ),
                        duration: Duration(seconds: 1));
                  },
                  icon: Icon(
                    Icons.bookmark_add,
                    color: Theme.of(context).accentColor,
                    size: 24,
                  ),
                )
              : Opacity(
                  opacity: 0,
                  child: IconButton(
                    icon: Icon(Icons.share),
                    onPressed: null,
                  )),
          IconButton(
              icon: Icon(
                Icons.share_outlined,
                size: 24,
              ),
              onPressed: () {
                Share.share("${widget.postUrl}");
              }),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: WebView(
          initialUrl: widget.postUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
}
