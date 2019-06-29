import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate<String> {
  final friends = [
    "Pranav Bedre",
    "Balachandra D.S",
    "Ananya Prakash",
    "Ruthik Raj N",
    "Raj Shetty",
    "Snigdha S",
    "Keerthana Bhat",
    "Suraksh N.S",
    "Nanditha Suspharsha",
    "Rishabh Jain",
    "Alen Peter",
    "Ann Frieda",
    "Sthav Prakash"
  ];
  final recentfriends = [
    "Pranav Bedre",
    "Balachandra D.S",
    "Ananya Prakash",
    "Ruthik Raj N"
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentfriends
        : friends.where((p) => p.contains(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
            onTap: () {
              showResults(context);
            },
            leading: Icon(Icons.person),
            title: RichText(
              text: TextSpan(
                  text: suggestionList[index].substring(0, query.length),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                        text: suggestionList[index].substring(query.length),
                        style: TextStyle(color: Colors.grey))
                  ]),
            ),
          ),
      itemCount: suggestionList.length,
    );
  }
}
