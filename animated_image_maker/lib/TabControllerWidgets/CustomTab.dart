import 'package:animatedimagemaker/TabStyleMainView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animatedimagemaker/TabControllerWidgets/TabStyle.dart';

class YoutubeTab extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Tab(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text("Youtube"),
        )
      ),
    );
  }
}

class TwitchTab extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Tab(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text("Twitch"),
        )
      ),
    );
  }
}