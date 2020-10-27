import 'package:flutter/material.dart';

class YoutubeSearchBar extends SearchDelegate<String>{
  final tempData = [
    'Test1',
    'Test2',
    'Test3',
    'Test4'
  ];

  final tempResult = [
    'TestResult1',
    'TestResult2',
    'TestResult3',
    'TestResult4'
  ];


  @override
  List<Widget> buildActions(BuildContext context) {
    //actions for app bar
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: () {})
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading icon on the left of the app bar
    return IconButton(
        icon:AnimatedIcon(
          icon:AnimatedIcons.menu_arrow,
          progress: transitionAnimation,),
        onPressed: (){
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // show some result based on the selection
    // show when someone searches for something
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
          title:Text(tempResult[index])
      ),
      itemCount: tempResult.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searches for something
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        title:Text(tempData[index])
      ),
      itemCount: tempData.length,
    );
  }

}