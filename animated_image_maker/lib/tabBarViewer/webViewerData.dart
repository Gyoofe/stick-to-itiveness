
class WebData
{
  String _iframeUrl = "https://www.youtube.com/embed/sPW7nDBqt8w";

  String get iframeUrl => _iframeUrl;
  set iframeUrl(String iframeUrl){
    _iframeUrl = iframeUrl;
  }

  String getWebViewData()
  {
    return
      """
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <title>Flutter InAppWebView</title>
    </head>
    <body>
          <iframe src="$_iframeUrl" width="100%" height="240px" frameborder="0" allowfullscreen></iframe>
    </body>
</html>
""";
  }
}

class TwitchClipData
{
  String _slug = "TawdryCrazyCaribouPanicBasket";
  String getWebViewData()
  {
    return
    """
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <title>Flutter InAppWebView</title>
    </head>
    <body>
          <iframe
   src="https://clips.twitch.tv/embed?clip=$_slug"
   height="100%"
   width="100%"
   frameborder="0"
   scrolling="no"
   allowfullscreen="true">
</iframe>
    </body>
</html>
""";
  }


}
