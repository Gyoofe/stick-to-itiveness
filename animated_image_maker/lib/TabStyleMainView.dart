import 'package:animatedimagemaker/TabControllerWidgets/TabStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'TabControllerWidgets/CustomTab.dart';

class TabStyleMainView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'GifMaker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: GifMakerTabController(),
    );
  }
}

class GifMakerTabController extends StatefulWidget {

  _GifMakerTabControllerState _state;
  _GifMakerTabControllerState get state => _state;

  TabStyle tabStyle = new TabStyle();

  @override
  _GifMakerTabControllerState createState() {
    _state = _GifMakerTabControllerState();
    return _state;
  }
}

class _GifMakerTabControllerState extends State<GifMakerTabController>{


  @override
  Widget build(BuildContext context)
  {
    setState(() {

    });

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: widget.tabStyle.tabControllerBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            unselectedLabelColor: Colors.blue,
            onTap: (int index){
              setState(() {
                widget.tabStyle.SetStyle(index);
              });
            },
            indicator: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: Colors.redAccent,
            ),
            tabs:[
              //YoutubeTab(),
              new Builder(builder: (context){
                return YoutubeTab();
              },),
              new Builder(builder: (context){
                return TwitchTab();
              },)
            ]
          ),
        ),
        body: TabBarView(children: <Widget>[
          Icon(Icons.play_arrow),
          Icon(Icons.movie),
        ]),
      ),
    );
  }
}