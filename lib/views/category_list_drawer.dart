import 'package:flutter/material.dart';
import 'package:uni_news_app/views/category_news_page.dart';

class CategoryList extends StatelessWidget {
  final String categoryName, categoryValue;

  CategoryList({this.categoryName, this.categoryValue});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryNewsPage(
                      categoryValue: categoryValue,
                    )));
      },
      child: Container(
        padding: EdgeInsets.only(left: 6),
        height: 50,
        child: ListTile(
          trailing: Icon(Icons.keyboard_arrow_right),
          title: Text(
            categoryName,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Theme.of(context).accentColor, fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
