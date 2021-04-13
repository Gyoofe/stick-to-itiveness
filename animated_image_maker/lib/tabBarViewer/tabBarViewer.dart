import 'dart:convert';
import 'dart:typed_data';

import 'package:animatedimagemaker/Youtube/YoutubeSearchBar.dart';
import 'package:animatedimagemaker/Youtube/YoutubeVideoInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:animatedimagemaker/tabBarViewer/webViewerData.dart';
import 'package:animatedimagemaker/download.dart';
import 'package:animatedimagemaker/gifMaker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:share/share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'dart:math';
import 'package:connectivity/connectivity.dart';

import 'package:percent_indicator/percent_indicator.dart';

class TabBarViewer extends StatefulWidget
{
  @override
  TabBarViewerState createState() => TabBarViewerState();
}

class TabBarViewerState extends State<TabBarViewer>
{
  final videoInfo = new YoutubeVideoInfo();

  final _WebViewerData = new WebData();
  final youtubeURLController = new TextEditingController();
  final startTimeController = new TextEditingController();
  final endTimeController = new TextEditingController();
  String makebuttonText = "make!";
  String percentage = "0";
  String circularMessage = "Ready";
  double circularRadius = 150;
  String outputFilePath;
  String endTimeLable = "00:00";
  bool visibleProgress = false;
  bool visibleImage = false;
  FileImage img = FileImage(File('/storage/emulated/0/Android/data/com.example.animatedimagemaker/files/download.gif'));

  Widget visibleWidget = new SizedBox();
  //final _twitchClips = new TwitchClipData();
  InAppWebViewController webViewCon;

  void _make() async
  {
    //_WebViewerData.iframeUrl = "https://www.youtube.com/embed/" + youtubeURLController.text;
    bool connection = await checkConecction();
    if(connection == false)
      return;

    downloadAndMakeGifs(_WebViewerData.iframeUrl);
    setState(() {
      print(_WebViewerData.iframeUrl);
      webViewCon.loadData(data: _WebViewerData.getWebViewData());
      visibleProgress = true;
      visibleImage = false;
    });
  }

  Future<bool> checkConecction() async{
    var connection = await (Connectivity().checkConnectivity());

    if (connection == ConnectivityResult.wifi){
      return true;
    }
    else if (connection == ConnectivityResult.mobile){
      return _showConnectionDialog("모바일 데이터를 사용중입니다.\n 데이터 사용량에 주의하세요.\n 계속 진행하시겠습니까?");
    }
    else if (connection == ConnectivityResult.none){
      showDialog(context: context,
          builder: (BuildContext context){
            return AlertDialog(
              content: new Text("인터넷에 연결되어 있지 않습니다."),
              actions: <Widget>[
                new TextButton(onPressed: (){
                Navigator.pop(context, true);
                }, child: new Text("Ok")),
            ],
          );
        });
      return false;
    }
  }

  Future<bool> _showConnectionDialog(String contents) async {
    var returns = await showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          content: new Text(contents),
          actions: <Widget>[
            new TextButton(onPressed: (){
              Navigator.pop(context, true);
            }, child: new Text("Ok")),
            new TextButton(onPressed: (){
              Navigator.pop(context, false);
            }, child: new Text("Cancel"))
          ],
        );
      }
    );

    return returns;
  }

  format(Duration d) => d.toString().split('.').first.padLeft(8,"0");
  
  void popMake() async
  {
    _WebViewerData.iframeUrl = "https://www.youtube.com/embed/" + videoInfo.videoId;
    print(videoInfo.videoId);
    var durations = await extract(_WebViewerData.iframeUrl);
    endTimeLable = format(durations).toString();
    setState(() {
      print(_WebViewerData.iframeUrl);
      webViewCon.loadData(data: _WebViewerData.getWebViewData());
      visibleProgress = true;
      visibleImage = false;
    });
  }

  Future<File> saveFile() async{
    var status = await Permission.storage.status;
    if (!status.isGranted){
      await Permission.storage.request();
    }

    Directory tempDir = await DownloadsPathProvider.downloadsDirectory;

    var random = Random.secure();
    var values = List<int>.generate(10, (index) => random.nextInt(255));
    String name = base64UrlEncode(values);

    String tempPath = tempDir.path;
    var filePath = tempPath + '/$name' + '.gif';

    Uint8List _data = await img.file.readAsBytes();
    var bytes = ByteData.view(_data.buffer);
    final buffer = bytes.buffer;

    print("saves");

    return File(filePath).writeAsBytes(buffer.asUint8List(_data.offsetInBytes, _data.lengthInBytes));
  }


  void downloadAndMakeGifs(String _url) async
  {
    visibleImage = false;
    percentage = "0";
    circularMessage = percentage + "%";
    circularRadius = 150;
    var urlString = await downloadYoutube(_url, progressCallback);
    var gif = gifMaker();
    circularMessage = "Generating Gif...";
    setState(() {

    });
    String output = await gif.makeGIF(startTimeController.text, endTimeController.text, urlString);
    circularRadius = 0;
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
      circularMessage = percentage + "%";
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        //color: Colors.white,
      child:Column(
        children: <Widget>[
          Container(
            child: YoutubeSearchBar(videoInfo, this),
          ),
          Container(
              height: 260,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.black12,
                  height: 5,
                ),
              )
            ],
          ),
          Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top:15.0, bottom: 0.0, left: 12.0, right: 12.0),
                  child: Text(
                      "시간 설정",
                      style: TextStyle(backgroundColor: Colors.white, fontSize:15)
                      ,textAlign: TextAlign.left),
                ),
              ],
            ),
          ),
          new Theme(
            data: new ThemeData(
              primaryColor: Colors.redAccent,
              primaryColorDark: Colors.redAccent,
              secondaryHeaderColor: Colors.black,
              backgroundColor: Colors.black,
            ),
            child:Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child:TextField(
                      decoration: InputDecoration(
                        focusColor: Colors.redAccent,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent,width: 5.0),
                        ),
                        labelText: '00:00',
                      ),
                      controller: startTimeController,
                    ),
                  ),
                  Text(" ~ "),
                  Flexible(
                    child:TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: endTimeLable.toString(),
                      ),
                      controller: endTimeController,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.black12,
                  height: 5,
                ),
              )
            ],
          ),
          Visibility(
            child: Expanded(
              child: Container(
                alignment: Alignment.center,
                color:Colors.white,
                child: Visibility(
                  child: new CircularPercentIndicator(
                    radius: circularRadius,
                    backgroundColor: Colors.white,
                    percent: int.parse(percentage)/110,
                    center: new Text("${circularMessage}", style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                    progressColor: Colors.redAccent,
                  ),
                  visible: !visibleImage,
                ),
              ),
            ),
            visible: !visibleImage,
          ),
          Visibility(
            child: Expanded(
              child: Container(
                padding: EdgeInsets.only(top:15.0, left: 12.0, right: 12.0),
                color:Colors.white,
                child: Column(
                  children:<Widget>[
                    Visibility(
                      child: new Image(
                        image: img,
                      ),
                      visible: visibleImage,
                    ),
                    Expanded(
                      child: Container(
                      ),
                    )
                  ],
                ),
              ),
            ),
            visible: visibleImage,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.black12,
                  height: 1,
                ),
              )
            ],
          ),
          Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.save_alt, color: Colors.black,),
                    onPressed: (){
                      saveFile();
                    }
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
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
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.share, color: Colors.black,),
                  onPressed: (){
                    List<String> paths = List<String>();
                    paths.add(img.file.path);
                    Share.shareFiles(paths);
                  },
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}