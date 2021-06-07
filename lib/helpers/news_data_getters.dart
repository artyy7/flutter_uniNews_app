import 'package:http/http.dart';
import 'package:uni_news_app/models/article_model.dart';
import 'dart:convert';

import 'package:uni_news_app/helpers/apiKey.dart';

class GetNews {
  ///Main screen news getter.
  Future<List<Article>> getNewsData(var newsRegion, var newsCategory) async {
    final url =
        "https://newsapi.org/v2/top-headlines?country=$newsRegion&category=$newsCategory&pageSize=100&apiKey=$apiKey";

    Response response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);

      List<dynamic> body = json['articles'];
      List<Article> articles = [];

      articles = body.map((dynamic item) => Article.fromJson(item)).toList();
      return articles;
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      throw ("Can't get the Articles");
    }
  }

  ///News for categories getter.
  Future<List<Article>> getNewsForCategory(var newsRegion, var category) async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=$newsRegion&category=$category&pageSize=100&apiKey=$apiKey";

    Response response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);

      List<dynamic> body = json['articles'];
      List<Article> articles = [];

      articles = body.map((dynamic item) => Article.fromJson(item)).toList();
      return articles;
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      throw ("Can't get the Articles");
    }
  }

  ///News for searchValue getter.
  Future<List<Article>> getNewsForSearchValue(
      String searchValue, String dateValue, var newsLanguageCode) async {
    String url;
    if (dateValue != null) {
      url =
          "https://newsapi.org/v2/everything?language=$newsLanguageCode&q=$searchValue&from=$dateValue&to=$dateValue&sortBy=publishedAt&pageSize=80&apiKey=$apiKey";
    } else {
      url =
          "https://newsapi.org/v2/everything?language=$newsLanguageCode&q=$searchValue&sortBy=publishedAt&pageSize=100&apiKey=$apiKey";
    }
    Response response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);

      List<dynamic> body = json['articles'];
      List<Article> articles = [];

      articles = body.map((dynamic item) => Article.fromJson(item)).toList();
      return articles;
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      throw ("Can't get the Articles");
    }
  }

  ///Custom news domains getter.
  Future<List<Article>> getNewsForSelectedDomains(String newsDomains) async {
    final url =
        "https://newsapi.org/v2/everything?domains=$newsDomains&sortBy=publishedAt&pageSize=100&apiKey=$apiKey";

    Response response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);

      List<dynamic> body = json['articles'];
      List<Article> articles = [];

      articles = body.map((dynamic item) => Article.fromJson(item)).toList();
      return articles;
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      throw ("Can't get the Articles");
    }
  }
}
