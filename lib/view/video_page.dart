import 'package:flutter/material.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_agile_story_flutter_app/view/home_page.dart';

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
    _channel.invokeMethod('/playYoutubeVideo', params);
  }

  Stream<String> done;

  Stream<String> get onVideoEnded {
    var d = _stream.receiveBroadcastStream().map<String>((element) => element);
    return d;
  }
}


class MyVideoPage extends StatefulWidget {
  static const String id ='MyVideoPage';
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
      videoUrl: myUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: AppBar(
          title: Text('My Agile Story Videos',style: TextStyle(fontSize: 17,)),
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
              IconButton(
                tooltip: 'Go back',
                icon: Icon(FontAwesomeIcons.angleLeft), onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, MyHomePage.id,(Route<dynamic> route) => false);
                  },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding:EdgeInsets.symmetric(vertical: 16.0),
                      width: 300,
                      child: Text("The videos are from the JimmySoft LLC youtube channel.  You can play the entire video or just click the the clip your are interested in.",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                      maxLines: 4,),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () {
                            playYoutubeVideo("https://youtu.be/PHabA6CTFXA");
                          },
                          minWidth: 200.0,
                          height: 42.0,
                          child: Text(
                            'Play Entire Video',
                          ),
                        ),
                      ),
                    ),
//                    Padding(
//                      padding: EdgeInsets.symmetric(vertical: 16.0),
//                      child: Material(
//                        color: Colors.lightBlueAccent,
//                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                        elevation: 5.0,
//                        child: MaterialButton(
//                          onPressed: () {
//                            playYoutubeVideo("https://youtu.be/PHabA6CTFXA");
//                          },
//                          minWidth: 200.0,
//                          height: 42.0,
//                          child: Text(
//                            'Create a new user',
//                          ),
//                        ),
//                      ),
//                    ),
//                    Padding(
//                      padding: EdgeInsets.symmetric(vertical: 16.0),
//                      child: Material(
//                        color: Colors.lightBlueAccent,
//                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                        elevation: 5.0,
//                        child: MaterialButton(
//                          onPressed: () {
//                            playYoutubeVideo("https://youtu.be/PHabA6CTFXA");
//                          },
//                          minWidth: 200.0,
//                          height: 42.0,
//                          child: Text(
//                            'Create a project',
//                          ),
//                        ),
//                      ),
//                    ),
//                    Padding(
//                      padding: EdgeInsets.symmetric(vertical: 16.0),
//                      child: Material(
//                        color: Colors.lightBlueAccent,
//                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                        elevation: 5.0,
//                        child: MaterialButton(
//                          onPressed: () {
//                            playYoutubeVideo("https://youtu.be/PHabA6CTFXA");;
//                          },
//                          minWidth: 200.0,
//                          height: 42.0,
//                          child: Text(
//                            'Create a user story',
//                          ),
//                        ),
//                      ),
//                    ),
                  ],
              )
          ),
        ),
      ),
    );
  }
}