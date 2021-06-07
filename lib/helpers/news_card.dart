import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uni_news_app/db/database.dart';
import 'package:uni_news_app/models/article_model.dart';
import 'package:uni_news_app/models/bookmark_model.dart';
import 'package:uni_news_app/views/article_view_page.dart';
import 'package:uni_news_app/helpers/extensions.dart';
import 'package:share/share.dart';

class NewsCard extends StatelessWidget {
  final Article article;
  final DateTime postDate;

  NewsCard({this.postDate, this.article});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArticleView(
                      postUrl: '${article.articleUrl}',
                      articleTitle: '${article.title}',
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 185,
                    width: 400,
                    child: CachedNetworkImage(
                      placeholder: (context, imgUrl) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, imgUrl, error) => ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Image.asset(
                              "assets/images/placeholder-news.jpg",
                            ),
                          )),
                      imageUrl: '${article.urlToImage}' ?? "",
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 7),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Text(
                    truncateString("${article.title}", 90),
                    maxLines: 4,
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 7),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Text(
                    article.description != null
                        ? truncateString("${article.description}", 80)
                        : "noDescription".tr,
                    maxLines: 3,
                    style: TextStyle(color: Theme.of(context).accentColor, fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    children: [
                      Text(DateFormat('d/M/y').format(article.publishedAt)),
                      Text(' • '),
                      Text(truncateString(article.source.name, 12)),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          DBProvider.db.insertBookMark(BookMark(
                            id: null,
                            title: article.title,
                            link: article.articleUrl,
                          ));
                          DBProvider.db.getBookMarks();
                          Get.snackbar('', "",
                              snackPosition: SnackPosition.BOTTOM,
                              barBlur: 100,
                              titleText: Text(
                                "snackSuccess".tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).accentColor),
                              ),
                              messageText: Text(
                                "snackMessageBookmarkAdd".tr,
                                style: TextStyle(color: Theme.of(context).accentColor),
                              ),
                              duration: Duration(seconds: 1));
                        },
                        icon: Icon(
                          Icons.bookmark_add,
                          size: 23,
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.share_outlined,
                            size: 23,
                          ),
                          onPressed: () {
                            Share.share("${article.articleUrl}");
                          })
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
