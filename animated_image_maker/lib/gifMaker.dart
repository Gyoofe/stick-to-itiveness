import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class gifMaker
{
  final FlutterFFmpegConfig _fFmpegConfig = new FlutterFFmpegConfig();
  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  final FlutterFFprobe _flutterFFprobe = new FlutterFFprobe();

  var _pipePath;

  Future<String> makeGIF(String startTime, String endTime) async
  {
    _fFmpegConfig.enableLogCallback((level, message) => print("output ${message}"));

    Directory appDocDirectory = await getExternalStorageDirectory();
    String outputfilepath = '${appDocDirectory.path}/download.gif';

    var file = File('$outputfilepath');

    // Delete the file if exists.
    if (file.existsSync()) {
      print("exist Delete");
      file.deleteSync();
    }

    var _startTime = double.parse(startTime);
    var _endTime = double.parse(endTime);

    var duration = (_endTime-_startTime).toString();

    String gifOption = '"fps=30,scale=640:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse"';
    //String inputFilePath = "/data/user/0/com.example.animatedimagemaker/app_flutter/downloads/download.mp4";
    String inputFilePath = '${appDocDirectory.path}/downloads/download.mp4';
    var FFmpegCommand = "-nostdin -ss ${startTime} -t ${duration} -i ${inputFilePath} -vf ${gifOption} -loop 0 ${outputfilepath}";
    //var FFmpegCommand = "-ss ${startTime} -t ${duration} -i "


    print(FFmpegCommand);

    await executeFFmpeg("${FFmpegCommand}").then((rc) => print("FFMPEG PROCESS EXITED WITH RC $rc"));
//    executeFFmpeg("-nostdin -ss 60 -i /data/user/0/com.example.animatedimagemaker/app_flutter/downloads/download.mp4 -pix_fmt yuvj422p -q:v 2 -frames:v 1 /storage/emulated/0/Android/data/com.example.animatedimagemaker/files/download.jpg")
//        .then((rc) => print("FFMPEG PROCESS EXITED WITH RC $rc"));

    //_flutterFFprobe.getMediaInformation("/storage/emulated/0/Android/data/com.example.animatedimagemaker/files/download.gif").then((info)=>print("gif : ${info}"));

    return outputfilepath;
  }


 void testRunFFmpegCommand() async
 {
   print("Testing ParseArguments.");

   //parseArguments();

   var pipePath;
   //pipePath = registerNewFFmpegPipe().then((path) => savePipePath(path));

   print("Testing FFmpeg COMMAND.");

   _fFmpegConfig.enableLogCallback((level, message) => print("output ${message}"));

   var argumentArray = FlutterFFmpeg.parseArguments(
       "ffmpeg -i input_file.mp4 -ss 01:23:45 -vframes 1 output.jpg"
   );

   Directory appDocDirectory = await getExternalStorageDirectory();
   String outputfilepath = '${appDocDirectory.path}/download.jpg';

   print("${outputfilepath}");

   await executeFFmpeg("-nostdin -ss 60 -i /data/user/0/com.example.animatedimagemaker/app_flutter/downloads/download.mp4 -pix_fmt yuvj422p -q:v 2 -frames:v 1 /storage/emulated/0/Android/data/com.example.animatedimagemaker/files/download.jpg")
       .then((rc) => print("FFMPEG PROCESS EXITED WITH RC $rc"));

   _flutterFFprobe.getMediaInformation("/storage/emulated/0/Android/data/com.example.animatedimagemaker/files/download.jpg").then((info)=>print("jpg : ${info}"));
 }

 void parseArguments()
 {
   var argumentArray = FlutterFFmpeg.parseArguments(
     "ffmpeg -i input_file.mp4 -ss 01:23:45 -vframes 1 output.jpg"
   );
 }

 Future<String> registerNewFFmpegPipe() async{
   return await _fFmpegConfig.registerNewFFmpegPipe();
 }

 Future<int> executeFFmpeg(String command) async {
   return await _flutterFFmpeg.execute(command);
 }

 void commandOutputLogCallback(int level, String message)
 {
   print("output Callback:${message}");
 }

 void savePipePath(String pipePath)
 {
   _pipePath =  pipePath;
   print("pipePath, ${pipePath}");

   var outputfile = '/data/user/0/com.example.animatedimagemaker/app_flutter/downloads/download.jpg';


   print("outputFile, ${outputfile}");
   var file = File('$outputfile');

   // Delete the file if exists.
   if (file.existsSync()) {
     print("exist Delete");
     file.deleteSync();
   }
   else{
     print("notfound");
   }
 }

 void printAfter(int rccc)
 {

 }

}
