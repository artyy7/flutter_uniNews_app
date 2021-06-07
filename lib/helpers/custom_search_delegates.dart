import 'package:flutter/material.dart';
import 'package:uni_news_app/db/database.dart';
import 'package:uni_news_app/models/recentsearch_model.dart';
import 'package:get/get.dart';

class CustomSearchDelegate extends SearchDelegate<RecentSearch> {
  Function showDatePicker;
  Function resetDate;
  Function beginSearch;
  Function updateList;

  Future<List<RecentSearch>> oldFilters;

  CustomSearchDelegate(
      {this.showDatePicker, this.beginSearch, this.oldFilters, this.updateList, this.resetDate})
      : super(searchFieldLabel: "searchHint".tr);

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        resetDate();
        Navigator.pop(context);
      },
      color: Theme.of(context).accentColor,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.calendar_today),
        onPressed: showDatePicker,
        color: Theme.of(context).accentColor,
      ),
      query.isEmpty
          ? Container()
          : IconButton(
              icon: Icon(Icons.clear),
              color: Theme.of(context).accentColor,
              onPressed: () => query = "",
            ),
    ];
  }

  @override
  void showResults(BuildContext context) {
    if (query.isEmpty) {
      return;
    } else
      beginSearch(query);
    DBProvider.db.insertRecentSearch(RecentSearch(id: null, recentSearch: query));
    updateList();
  }

  @override
  Widget buildResults(BuildContext context) => null;

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: oldFilters,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyList(snapshot.data, beginSearch);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class MyList extends StatefulWidget {
  final List<RecentSearch> oldFilters;
  final Function beginSearch;

  MyList(this.oldFilters, this.beginSearch);

  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.oldFilters.isEmpty
        ? Center(
            child: Text("searchFirstLaunch".tr,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)))
        : ListView.builder(
            itemCount: widget.oldFilters.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("${widget.oldFilters[index].recentSearch}"),
                leading: Icon(Icons.restore),
                trailing: IconButton(
                  icon: Icon(
                    Icons.remove,
                  ),
                  onPressed: () {
                    DBProvider.db.deleteRecentSearch(widget.oldFilters[index].id);
                    setState(() {
                      widget.oldFilters.remove(widget.oldFilters[index]);
                    });
                  },
                ),
                onTap: () => {widget.beginSearch(widget.oldFilters[index].recentSearch)},
              );
            },
          );
  }
}
