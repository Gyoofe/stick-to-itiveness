import 'package:flutter/material.dart';

class TabStyle
{
  Color _tabControllerBackgroundColor = Colors.white;
  Color get tabControllerBackgroundColor => _tabControllerBackgroundColor;

  Color _tabBoxColor = Colors.redAccent;
  Color get tabBoxColor => _tabBoxColor;

  Color _unselectedColor = Colors.deepPurple;
  Color get unselectedColor => _unselectedColor;

  void SetStyle(int _idx)
  {
    if(_idx == 0)
      SetYoutubeStyle();
    else
      SetTwitchStyle();
  }


  void SetYoutubeStyle()
  {
    _tabControllerBackgroundColor = Colors.white;
    _tabBoxColor = Colors.redAccent;
    _unselectedColor = Colors.deepPurple;
  }

  void SetTwitchStyle()
  {
   _tabControllerBackgroundColor = Colors.deepPurple;
   _tabBoxColor = Colors.deepPurple;
   _unselectedColor = Colors.redAccent;
  }
}