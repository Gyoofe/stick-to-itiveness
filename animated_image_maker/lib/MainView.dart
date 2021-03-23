import 'package:animatedimagemaker/TabControllerWidgets/TabStyle.dart';
import 'package:animatedimagemaker/Youtube/YoutubeSearchBar.dart';
import 'package:animatedimagemaker/tabBarViewer/tabBarViewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'TabControllerWidgets/CustomTab.dart';

class MainView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GifMaker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: MainViewWidget(),
    );
  }
}

class MainViewWidget extends StatefulWidget {
  @override
  _MainViewWidgetState createState() => _MainViewWidgetState();
}

class _MainViewWidgetState extends State<MainViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarViewer(),
    );
  }
}
