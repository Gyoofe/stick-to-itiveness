
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:animatedimagemaker/tabBarViewer/webViewerData.dart';
import 'package:animatedimagemaker/download.dart';
import 'package:animatedimagemaker/gifMaker.dart';
import 'dart:io';

import 'package:percent_indicator/percent_indicator.dart';
import '../Youtube/YoutubeSearch.dart';

class TabBarViewer extends StatefulWidget
{
  @override
  _TabBarViewerState createState() => _TabBarViewerState();
}

class _TabBarViewerState extends State<TabBarViewer>
{
  final _WebViewerData = new WebData();
  final youtubeURLController = new TextEditingController();
  final startTimeController = new TextEditingController();
  final endTimeController = new TextEditingController();
  String makebuttonText = "make!";
  String percentage = "0";
  String outputFilePath;
  bool visibleProgress = false;
  bool visibleImage = false;
  FileImage img = FileImage(File('/storage/emulated/0/Android/data/com.example.animatedimagemaker/files/download.gif'));

  Widget visibleWidget = new SizedBox();
  //final _twitchClips = new TwitchClipData();
  InAppWebViewController webViewCon;

  void _make()
  {
    _WebViewerData.iframeUrl = "https://www.youtube.com/embed/" + youtubeURLController.text;
    downloadAndMakeGifs(_WebViewerData.iframeUrl);
    setState(() {
      print(_WebViewerData.iframeUrl);
      webViewCon.loadData(data: _WebViewerData.getWebViewData());
      visibleProgress = true;
      visibleImage = false;
    });
  }

  void downloadAndMakeGifs(String _url) async
  {
    await downloadYoutube(_url, progressCallback);
    var gif = gifMaker();
    String output = await gif.makeGIF(startTimeController.text, endTimeController.text);
    setState(() {
      imageCache.clear();
      outputFilePath = output;
      img = new FileImage(File(outputFilePath));
      print("Clear!!");
      visibleImage = true;
    });
  }

  void progressCallback(String _text)
  {
    setState(() {
      percentage = _text;

    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(5.0),
        width: double.infinity,
        //color: Colors.white,
      child:Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Container(
            width: 640,
            height: 160,
              child: InAppWebView(
                initialData: InAppWebViewInitialData(
                    data: _WebViewerData.getWebViewData(),
                ),
                initialHeaders: {},
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                      debuggingEnabled: true),
                ),
                onWebViewCreated: (InAppWebViewController controller) {
                  webViewCon = controller;
                },
                onLoadStart: (InAppWebViewController controller, String url) {},
              ),
          ),
          SizedBox(
            height: 50,
            //child: Container(color: Colors, margin: EdgeInsets.only(bottom: 5)),
          ),
          new Theme(
            data: new ThemeData(
              primaryColor: Colors.redAccent,
              primaryColorDark: Colors.blue,
            ),
            child:Row(
              children:<Widget>[
                Expanded(
                  child:TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent,width: 5.0),
                        ),
                        labelText: 'Youtube URL',
                        fillColor: Colors.redAccent,
                    ),
                    controller: youtubeURLController,
                  )
                ),
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: (){
                      showSearch(context: context, delegate: YoutubeSearchBar());
                    })
            ])
          ),
          SizedBox(
            height: 3,
          ),
          new Theme(
            data: new ThemeData(
              primaryColor: Colors.redAccent,
              primaryColorDark: Colors.white,
              secondaryHeaderColor: Colors.white,
            ),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  child:TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent,width: 5.0),
                      ),
                      labelText: '00:00',
                    ),
                    controller: startTimeController,
                  ),
                ),
                Flexible(
                  child:TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '00:00',
                    ),
                    controller: endTimeController,
                  ),
                ),
              ],
            ),
          ),
          new Theme(
            data: new ThemeData(
              buttonTheme: ButtonThemeData(
                buttonColor: Colors.white,
                textTheme: ButtonTextTheme.accent,
                colorScheme:
                  Theme.of(context).colorScheme.copyWith(secondary: Colors.redAccent),
              )
            ),
            child:RaisedButton(
              child: Text("${makebuttonText}"),
              color: Colors.white,
              onPressed: _make,
            )
          ),
          Container(
            child: Visibility(
              child: new CircularPercentIndicator(
                radius: 60.0,
                lineWidth: 5.0,
                percent: int.parse(percentage)/100,
                center: new Text("${percentage}%"),
                progressColor: Colors.green,
              ),
              visible: visibleProgress,
            ),
          ),
          Container(
            child: Visibility(
              child: new Image(
                image: img,
              ),
              visible: visibleImage,
            ),
          )
        ],
      )
    );
  }
}