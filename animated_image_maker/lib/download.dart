import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future extract(String _youtubeURL) async
{
  var yt = YoutubeExplode();

  String url = "https://www.youtube.com/watch?v=" + _youtubeURL;
  var video = await yt.videos.get(url);

  var title = video.title;
  var author = video.author;
  var duration = video.duration;

  print('${title}');
  print('${author}');
  print('${duration}');

  return video.duration;
}

Future<String> downloadYoutube(String _youtubeURL, var progressCallback) async
{
  var yt = YoutubeExplode();
  List<String> splits = _youtubeURL.split("/");
  String url = "https://www.youtube.com/watch?v=" + splits.last;
  var info = await yt.videos.get(url);

  var title = info.title;
  var author = info.author;
  var duration = info.duration;

  print('${title}');
  print('${author}');
  print('${duration}');

  print(url);
  print(_youtubeURL);
  print(splits.last);
  var manifest = await yt.videos.streamsClient.getManifest(url);
  print("manifest");
  var stream = manifest.muxed;
  var videos = stream.sortByVideoQuality().first;
  var videoStream = yt.videos.streamsClient.get(videos);

  print("STREAM");
  print(manifest.video.first.url);
  print(videos.url);
  return videos.url.toString();
  print("URL");


  Directory appDocDirectory = await getExternalStorageDirectory();

  print(appDocDirectory.path);

  new Directory(appDocDirectory.path+'/'+'downloads').createSync(recursive: true);

  // Compose the file name removing the unallowed characters in windows.
  var fileName = '${info.title}.${videos.container.name.toString()}'
      .replaceAll(r'\', '')
      .replaceAll('/', '')
      .replaceAll('*', '')
      .replaceAll('?', '')
      .replaceAll('"', '')
      .replaceAll('<', '')
      .replaceAll('>', '')
      .replaceAll('|', '');

  var downloads = appDocDirectory.path+'/'+'downloads/' + 'download.mp4';
  //var downloads = '/'+'downloads/' + fileName;

  print('${downloads}');

  var file = File('$downloads');

  // Delete the file if exists.
  if (file.existsSync()) {
    print("exist Delete");
    file.deleteSync();
  }
  else{
    print("notfound");
  }

  // Open the file in writeAppend.
  var output = file.openWrite(mode: FileMode.writeOnlyAppend);

  // Track the file download status.
  var len = videos.size.totalBytes;
  var count = 0;

  // Create the message and set the cursor position.
  var msg = 'Downloading ${info.title}.${videos.container.name}';
  stdout.writeln(msg);

  // Listen for data received.
  await for (var data in videoStream) {

    // Keep track of the current downloaded data.
    count += data.length;

    // Calculate the current progress.
    print('${((count / len) * 100).ceil()}');
    progressCallback('${((count / len) * 100).ceil()}');

    // Write to file.
    output.add(data);
  }
  await output.close();

  print("download Complete");
  AlertDialog(
    title: new Text("'${info.title}"),
    content: new Text("다운로드 완료"),
  );
}


void download() async
{
  var yt = YoutubeExplode();

  var video = await yt.videos.get('https://www.youtube.com/watch?v=IjdXSqkfnbc');
  var manifest = await yt.videos.streamsClient.getManifest('IjdXSqkfnbc');
  //var streams = manifest.videoOnly.where((element) => element.container == Container.mp4);
  var streams = manifest.muxed;

  var videos = streams.sortByVideoQuality().first;
  //var videos = streams.withHighestBitrate();
  var videoStream = yt.videos.streamsClient.get(videos);

  // Save the video to the download directory.
  Directory appDocDirectory = await getApplicationDocumentsDirectory();
  //Directory appDocDirectory = await getExternalStorageDirectory();

  print(appDocDirectory.path);

  new Directory(appDocDirectory.path+'/'+'downloads').createSync(recursive: true);

  // Compose the file name removing the unallowed characters in windows.
  var fileName = '${video.title}.${videos.container.name.toString()}'
      .replaceAll(r'\', '')
      .replaceAll('/', '')
      .replaceAll('*', '')
      .replaceAll('?', '')
      .replaceAll('"', '')
      .replaceAll('<', '')
      .replaceAll('>', '')
      .replaceAll('|', '');

  var downloads = appDocDirectory.path+'/'+'downloads/' + 'download.mp4';
  //var downloads = '/'+'downloads/' + fileName;

  print('${downloads}');

  var file = File('$downloads');

  // Delete the file if exists.
  if (file.existsSync()) {
    print("exist Delete");
    file.deleteSync();
  }
  else{
    print("notfound");
  }

  // Open the file in writeAppend.
  var output = file.openWrite(mode: FileMode.writeOnlyAppend);

  // Track the file download status.
  var len = videos.size.totalBytes;
  var count = 0;

  // Create the message and set the cursor position.
  var msg = 'Downloading ${video.title}.${videos.container.name}';
  stdout.writeln(msg);

  // Listen for data received.
  await for (var data in videoStream) {

    // Keep track of the current downloaded data.
    count += data.length;

    // Calculate the current progress.
    print('${((count / len) * 100).ceil()}');


    // Write to file.
    output.add(data);
  }
  await output.close();

  print("download Complete");
}
