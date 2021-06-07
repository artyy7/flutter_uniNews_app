import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:uni_news_app/models/bookmark_model.dart';
import 'package:uni_news_app/models/recentsearch_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database _dataBase;

  ///Bookmarks table.
  String bookMarksTable = "BookMarks";
  String bookMarkId = "id";
  String bookMarkTitle = "title";
  String bookMarkLink = "link";
  String bookMarkDate = "date";

  ///Recent search table.
  String recentSearchTable = "RecentSearch";
  String recentSearchId = "id";
  String recentSearchValue = "searchValue";

  Future<Database> get database async {
    if (_dataBase != null) return _dataBase;

    _dataBase = await _initDB();
    return _dataBase;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "UserStorage.db";
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $bookMarksTable ($bookMarkId INTEGER PRIMARY KEY AUTOINCREMENT, $bookMarkTitle TEXT, $bookMarkLink TEXT, $bookMarkDate TEXT)");
    await db.execute(
        "CREATE TABLE $recentSearchTable ($recentSearchId INTEGER PRIMARY KEY AUTOINCREMENT, $recentSearchValue TEXT)");
  }

  ///Get list of Bookmarks.
  Future<List<BookMark>> getBookMarks() async {
    Database db = await this.database;
    final List<Map<String, dynamic>> bookMarksMapList = await db.query(bookMarksTable);
    final List<BookMark> bookMarksList = [];
    bookMarksMapList.forEach((bookMarkMap) {
      bookMarksList.add(BookMark.fromMap(bookMarkMap));
    });
    return bookMarksList;
  }

  ///Insert bookmark into db.
  Future<BookMark> insertBookMark(BookMark bookMark) async {
    Database db = await this.database;
    bookMark.id = await db.insert(bookMarksTable, bookMark.toMap());
    return bookMark;
  }

  ///Delete bookmark by id.
  Future<int> deleteBookMark(int id) async {
    Database db = await this.database;
    return await db.delete(bookMarksTable, where: "$bookMarkId = ?", whereArgs: [id]);
  }

  Future<void> deleteAllBookMarks() async {
    Database db = await this.database;
    await db.execute("DELETE FROM " + bookMarksTable);
  }

  ///Get list of recent search.
  Future<List<RecentSearch>> getRecentSearches() async {
    Database db = await this.database;
    final List<Map<String, dynamic>> recentSearchMapList = await db.query(recentSearchTable);
    final List<RecentSearch> recentSearchList = [];
    recentSearchMapList.forEach((recentSearchMap) {
      recentSearchList.add(RecentSearch.fromMap(recentSearchMap));
    });
    return recentSearchList.reversed.toList();
  }

  ///Insert recent search velue into db.
  Future<RecentSearch> insertRecentSearch(RecentSearch recentSearch) async {
    Database db = await this.database;
    recentSearch.id = await db.insert(recentSearchTable, recentSearch.toMap());
    return recentSearch;
  }

  ///Delete recent search velue by id.
  Future<int> deleteRecentSearch(int id) async {
    Database db = await this.database;
    return await db.delete(recentSearchTable, where: "$recentSearchId = ?", whereArgs: [id]);
  }

  Future<void> deleteAllRecentSearches() async {
    Database db = await this.database;
    await db.execute("DELETE FROM " + recentSearchTable);
  }
}
