import 'package:animatedimagemaker/Youtube/YoutubeSearch.dart';
import 'package:animatedimagemaker/Youtube/YoutubeVideoInfo.dart';
import 'package:animatedimagemaker/tabBarViewer/tabBarViewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YoutubeSearchBar extends StatelessWidget
{
  YoutubeVideoInfo videoInfo;
  TabBarViewerState parentWidget;

  YoutubeSearchBar(YoutubeVideoInfo _videoInfo, TabBarViewerState _parentWidget)
  {
    this.videoInfo = _videoInfo;
    this.parentWidget = _parentWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: new BoxDecoration(
          color: Colors.redAccent,
        ),
        child:Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Row(
                children:<Widget>[
                  IconButton(
                      alignment: Alignment.centerLeft,
                      icon: Icon(Icons.search, color: Colors.transparent,),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text('Youtube GIF Maker',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                      ),
                    )
                  ),
                  IconButton(
                      icon: Icon(Icons.search, color: Colors.white,),
                      onPressed:() {popMake(context);}
                  )
                ]),
          ],
        )
    );
  }

  void popMake(BuildContext context) async
  {
    //showSearch(context: context, delegate: YoutubeSearchBar());
    final id = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchBarMain()),
    );
    print("id");
    print(id);
    this.videoInfo.videoId = id;
    this.parentWidget.popMake();
    /*
    _WebViewerData.iframeUrl = "https://www.youtube.com/embed/" + id;
    var durations = await extract(_WebViewerData.iframeUrl);
    endTimeLable = format(durations).toString();
    setState(() {
      print(_WebViewerData.iframeUrl);
      webViewCon.loadData(data: _WebViewerData.getWebViewData());
      visibleProgress = true;
      visibleImage = false;
    });
    */
  }
}