import 'package:animatedimagemaker/utilities/keys.dart';
import 'package:animatedimagemaker/Youtube/YoutubeVideo.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:http/http.dart';

//GET https://www.googleapis.com/youtube/v3/search

class YoutubeAPICall {
  YoutubeAPI ytApi = new YoutubeAPI(API_KEY);
  Future<YT_API> searchVideo() async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'q': '야구',
      'key' : API_KEY,
    };
    List<YT_API> ytResult = [];
    ytResult = await ytApi.search("아");
    //return ytResult;
  }
}

class YoutubeAPIREstCall {
  Future<String> getData() async {

  }
}