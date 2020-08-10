import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'download.dart';
import 'gifMaker.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //extract();
    //download();
    //var gif = gifMaker();
    //gif.testRunFFmpegCommand();
    return MaterialApp(initialRoute: '/', routes: {
      '/': (context) => InAppWebViewExampleScreen(),
    });
  }
}

class InAppWebViewExampleScreen extends StatefulWidget {
  @override
  _InAppWebViewExampleScreenState createState() =>
      new _InAppWebViewExampleScreenState();
}

class _InAppWebViewExampleScreenState extends State<InAppWebViewExampleScreen> {
  InAppWebViewController webView;
  Uint8List screenshotBytes;
  final youtubeURLController = new TextEditingController();
  final startTimeController = new TextEditingController();
  final endTimeController = new TextEditingController();
  String iframeUrl = "https://www.youtube.com/embed/sPW7nDBqt8w";
  String makebuttonText = "make!";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void progressCallback(String _text)
  {
    setState(() {
      makebuttonText = _text;
    });
  }

  void downloadAndMakeGifs(String _url) async
  {
    await downloadYoutube(_url, progressCallback);
    var gif = gifMaker();
    gif.makeGIF(startTimeController.text, endTimeController.text);
    print("gif");
  }


  void _make()
  {
    iframeUrl = "https://www.youtube.com/embed/" + youtubeURLController.text;
    downloadAndMakeGifs(iframeUrl);
    setState(() {
      print(iframeUrl);
      webView.loadData(data: """
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <title>Flutter InAppWebView</title>
    </head>
    <body>
      <iframe src="$iframeUrl" width="100%" height="100%" frameborder="0" allowfullscreen></iframe>
    </body>
</html>""");
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
        appBar: AppBar(title: Text("InAppWebView")),
        body: Container(
            margin: const EdgeInsets.all(5.0),
            width: double.infinity,
            child: Column(children: <Widget>[
              Container(
                  width: 512,
                  height: 256,
                  child: InAppWebView(
                    initialData: InAppWebViewInitialData(
                        data: """
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <title>Flutter InAppWebView</title>
    </head>
    <body>
      <iframe src="$iframeUrl" width="100%" height="100%" frameborder="0" allowfullscreen></iframe>
    </body>
</html>"""
                    ),
                    initialHeaders: {},
                    initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                          debuggingEnabled: true),
                    ),
                    onWebViewCreated: (InAppWebViewController controller) {
                      webView = controller;
                    },
                    onLoadStart: (InAppWebViewController controller, String url) {},
//                    onLoadStop: (InAppWebViewController controller, String url) async {
//                      screenshotBytes = await controller.takeScreenshot();
//                      showDialog(
//                        context: context,
//                        builder: (context) {
//                          return AlertDialog(
//                            content: Image.memory(screenshotBytes),
//                          );
//                        },
//                      );
//                    },
                  )
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Youtube URL'
                ),
                controller: youtubeURLController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    child:TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
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
              RaisedButton(
                child: Text("${makebuttonText}"),
                onPressed: _make,
              )
            ])));
  }
}