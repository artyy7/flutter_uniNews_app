class RecentSearch {
  int id;
  String recentSearch;

  RecentSearch({this.id, this.recentSearch});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['id'] = id;
    map["searchValue"] = recentSearch;
    return map;
  }

  RecentSearch.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    recentSearch = map["searchValue"];
  }
}
