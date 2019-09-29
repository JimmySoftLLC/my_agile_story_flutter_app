import 'package:flutter/material.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FlutterYoutube {
  static const MethodChannel _channel =
  const MethodChannel('PonnamKarthik/flutter_youtube');

  static const EventChannel _stream =
  const EventChannel('PonnamKarthik/flutter_youtube_stream');

  static String getIdFromUrl(String url, [bool trimWhitespaces = true]) {
    if (url == null || url.length == 0) return null;

    if (trimWhitespaces) url = url.trim();

    for (var exp in _regexps) {
      Match match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }

    return null;
  }

  static List<RegExp> _regexps = [
    new RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
    new RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
    new RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
  ];

  playYoutubeVideoByUrl(
      {@required String apiKey,
        @required String videoUrl,
        bool autoPlay = false,
        bool fullScreen = false}) {
    if (apiKey.isEmpty || apiKey == null) {
      throw "Invalid API Key";
    }

    if (videoUrl == null || videoUrl.isEmpty) {
      throw "Invalid Youtube URL";
    }

    String id = getIdFromUrl(videoUrl);

    if (id == null) {
      throw "Error extracting Youtube id from URL";
    }

    final Map<String, dynamic> params = <String, dynamic>{
      'api': apiKey,
      'id': id,
      'autoPlay': autoPlay,
      'fullScreen': fullScreen
    };
    _channel.invokeMethod('playYoutubeVideo', params);
  }

  playYoutubeVideoById(
      {@required String apiKey,
        @required String videoId,
        bool autoPlay = false,
        bool fullScreen = false}) {
    if (apiKey.isEmpty || apiKey == null) {
      throw "Invalid API Key";
    }

    if (videoId == null || videoId.isEmpty) {
      throw "Invalid Youtube URL";
    }

    final Map<String, dynamic> params = <String, dynamic>{
      'api': apiKey,
      'id': videoId,
      'autoPlay': autoPlay,
      'fullScreen': fullScreen
    };
    _channel.invokeMethod('playYoutubeVideo', params);
  }

  Stream<String> done;

  Stream<String> get onVideoEnded {
    var d = _stream.receiveBroadcastStream().map<String>((element) => element);
    return d;
  }
}


class MyVideoPage extends StatefulWidget {
  @override
  _MyVideoPageState createState() => new _MyVideoPageState();
}

class _MyVideoPageState extends State<MyVideoPage> {
  TextEditingController textEditingControllerUrl = new TextEditingController();
  TextEditingController textEditingControllerId = new TextEditingController();

  var youtube = new FlutterYoutube();

  @override
  initState() {
    super.initState();
  }

  void playYoutubeVideo(myUrl) {
    youtube.playYoutubeVideoByUrl(
      apiKey: "<API_KEY>",
      videoUrl: "https://youtu.be/PHabA6CTFXA",
    );
  }

  void playYoutubeVideoEdit() {
    youtube.onVideoEnded.listen((onData) {
      //perform your action when video playing is done
    });

    youtube.playYoutubeVideoByUrl(
      apiKey: "<API_KEY>",
      videoUrl: textEditingControllerUrl.text,
    );
  }

  void playYoutubeVideoIdEdit() {
    youtube.onVideoEnded.listen((onData) {
      //perform your action when video playing is done
    });

    youtube.playYoutubeVideoById(
      apiKey: "<API_KEY>",
      videoId: textEditingControllerId.text,
    );
  }

  void playYoutubeVideoIdEditAuto() {
    youtube.onVideoEnded.listen((onData) {
      //perform your action when video playing is done
    });

    youtube.playYoutubeVideoById(
        apiKey: "<API_KEY>",
        videoId: textEditingControllerId.text,
        autoPlay: true);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: AppBar(
          title: Text('My Agile Story',style: TextStyle(fontSize: 17,)),
          backgroundColor: Colors.blue,
          actions: <Widget>[
            // overflow menu
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(icon: Icon(FontAwesomeIcons.angleLeft), onPressed: () {Navigator.pushReplacementNamed(context, '/MyHomePage');},),
            ],
          ),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                      child: new Text("Play Entire Video"),
                      onPressed: () {playYoutubeVideo("https://youtu.be/PHabA6CTFXA");},),
                  RaisedButton(
                      child: new Text("Start at Set up user"),
                    onPressed: () {playYoutubeVideo("https://youtu.be/PHabA6CTFXA?t=37");},),
                  RaisedButton(
                      child: new Text("Start at Logging in"),
                    onPressed: () {playYoutubeVideo("https://youtu.be/PHabA6CTFXA");},),
                  RaisedButton(
                      child: new Text("Start at Create project"),
                    onPressed: () {playYoutubeVideo("https://youtu.be/PHabA6CTFXA");},),
                  RaisedButton(
                      child: new Text("Start at Create user story"),
                    onPressed: () {playYoutubeVideo("https://youtu.be/PHabA6CTFXA");},),
                  RaisedButton(
                  child: new Text("Start at My Agile Story example"),
                    onPressed: () {playYoutubeVideo("https://youtu.be/PHabA6CTFXA");},),
                ],
            )
        ),
      ),
    );
  }
}


//@override
//Widget build(BuildContext context) {
//  return new MaterialApp(
//    home: new Scaffold(
//      appBar: new AppBar(
//        title: new Text('Youtube Player'),
//      ),
//      body: new SingleChildScrollView(
//        child: new Column(
//          children: <Widget>[
//            new Padding(
//              padding: const EdgeInsets.all(10.0),
//              child: new TextField(
//                controller: textEditingControllerUrl,
//                decoration:
//                new InputDecoration(labelText: "Enter Youtube URL"),
//              ),
//            ),
//            new Padding(
//              padding: const EdgeInsets.all(10.0),
//              child: new RaisedButton(
//                  child: new Text("Play Video By Url"),
//                  onPressed: playYoutubeVideoEdit),
//            ),
//            new Padding(
//              padding: const EdgeInsets.all(10.0),
//              child: new RaisedButton(
//                  child: new Text("Play Default Video"),
//                  onPressed: playYoutubeVideo),
//            ),
//            new Padding(
//              padding: const EdgeInsets.all(10.0),
//              child: new TextField(
//                controller: textEditingControllerId,
//                decoration: new InputDecoration(
//                    labelText: "Youtube Video Id (fhWaJi1Hsfo)"),
//              ),
//            ),
//            new Padding(
//              padding: const EdgeInsets.all(10.0),
//              child: new RaisedButton(
//                  child: new Text("Play Video By Id"),
//                  onPressed: playYoutubeVideoIdEdit),
//            ),
//            new Padding(
//              padding: const EdgeInsets.all(10.0),
//              child: new RaisedButton(
//                  child: new Text("Auto Play Video By Id"),
//                  onPressed: playYoutubeVideoIdEditAuto),
//            ),
//          ],
//        ),
//      ),
//    ),
//  );
//}
//}