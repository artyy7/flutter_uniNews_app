class BookMark {
  int id;
  String title;
  String link;
  String date;

  BookMark({this.id, this.title, this.link, this.date});


  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['id'] = id;
    map["title"] = title;
    map["link"] = link;
    return map;
  }

  BookMark.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map["title"];
    link = map["link"];
  }
}