import 'package:flutter/material.dart';

class TabStyle
{
  Color _tabControllerBackgroundColor = Colors.redAccent;
  Color get tabControllerBackgroundColor => _tabControllerBackgroundColor;

  void SetStyle(int _idx)
  {
    if(_idx == 0)
      SetYoutubeStyle();
    else
      SetTwitchStyle();
  }


  void SetYoutubeStyle()
  {
    _tabControllerBackgroundColor = Colors.redAccent;
  }

  void SetTwitchStyle()
  {
   _tabControllerBackgroundColor = Colors.deepPurple;
  }
}