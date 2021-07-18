// @dart=2.9
import 'dart:async';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(myapp());
}

class myapp extends StatefulWidget {
  const myapp({key}) : super(key: key);

  @override
  _myappState createState() => _myappState();
}

class _myappState extends State<myapp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      title: "YoYo Test",
      home: homepage(),
    );
  }
}

class homepage extends StatefulWidget {
  const homepage({key}) : super(key: key);

  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  int levelTime = 8;
  Timer timer;
  int counter = 25;
  int leveTime=15;
  int level=1;
  int varSpeed=1;
  int warning=0;
  //late Timer timer;
  var startLocation = "";
  var endLocation = "";
  var distanceMessage = "";
  var speedMessage = "";
  var endResult="";
  // ignore: non_constant_identifier_names
  double s_lat=0.0, s_long=0.0,e_lat=0.0, e_long=0.0;
  double distanceInMeter=0.0;

  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayerState audioPlayerState = AudioPlayerState.PAUSED;
  AudioCache audioCache;
  String filePath = 'song.ogg';
  String beepPath='beep.ogg';
  String restPath='rest.ogg';
  String stopPath='stop.ogg';

  //getting starting location
  getStartLoc() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    s_lat= position.latitude;
    s_long= position.longitude;
    setState(() {
      startLocation = "lat: $s_lat, long:$s_long";
    });
  }
  // getting end location
  void getEndLoc() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      e_lat = position.latitude;
      e_long = position.longitude;
      endLocation = "lat:$e_lat ,long: $e_long";
    });
  }




  @override
  void initState() {
    super.initState();

    /// Compulsory
    audioPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: audioPlayer);

    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      setState(() {
        audioPlayerState = s;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    audioCache.clearCache();
    super.dispose();
  }

  playMusic() async {
    await audioCache.play(filePath);
  }

  beepMusic() async {
    await audioCache.play(beepPath);
  }
  restMusic() async {
    await audioCache.play(restPath);
  }
  stopMusic() async {
    await audioCache.play(stopPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("YoYo Test"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Level:$level",
            style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.bold,
                fontSize: 24,
                fontFamily: 'Open Sans'),
          ),

          //First row for Distance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                "Distance Travel:",
                style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ],
          ),
          //second row level time
          Text(
            "$distanceMessage",
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          //third row beep time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              (counter > 10)
                  ? Text(
                "Beep:",
                style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              )
                  : Text(
                "Rest:",
                style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              Text(
                "$counter sec",
                style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

              Text(
                "Level Time:",
                style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              Text(
                "$leveTime sec",
                style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              )
            ],
          ),
          Text(
            "Getting Location",
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          Text(
            "Start:$startLocation",
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 12),
          ),
          Text(
            "End:$endLocation",
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 12),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Speed:",
                style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              Text(
                "$speedMessage",
                style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ],
          ),
          Text("->Results<-",
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          Text("$endResult",
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              //start button
              RaisedButton(
                onPressed:startTimer,
                child: Text(
                  "Start",
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //method to be called on button press event
  void startTimer() {
    level=1;
    varSpeed=1;
    leveTime=15;
    warning=0;
    counter = 25;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (counter > 0) {
          int newl=level;
          if ((counter == 25 && newl==1) || (counter==23 && newl==2) || (counter==21 && newl==3) || (counter==21 && newl==4) || (counter==20 && newl==5) || (counter==20 && newl==6) || (counter==20 && newl==7)) {
            getStartLoc();
            beepMusic();
            endResult="";
            leveTime=counter-10;
          }
          if (counter >= 10) {
            getEndLoc();
            distanceInMeter=Geolocator.distanceBetween(s_lat, s_long, e_lat, e_long);
            var ldist=(distanceInMeter/100).toStringAsFixed(2);
            distanceMessage="$ldist m";
            var speed=(distanceInMeter/varSpeed).toStringAsFixed(2);
            speedMessage="$speed km/hr";
            if(distanceInMeter >= 2000.0){
              stopMusic();
              var speed=(distanceInMeter/varSpeed).toStringAsFixed(2);
              endResult="Result Score:$speed km/hr";
              speedMessage="$speed km/hr";
              Fluttertoast.showToast(msg: "Great! You did it! speed:$speed");
              leveTime=0;
              counter=9;
              distanceInMeter=0.0;
            }
          }

          if(counter ==10){restMusic();}

          if (counter == 10 && distanceInMeter < 2000.0) {
            var speed=(distanceInMeter/varSpeed).toStringAsFixed(2);

            warning++;
            distanceInMeter=0.0;
            Fluttertoast.showToast(msg: "Increase Your Speed warnings:$warning");
            if(warning>2){
              stopMusic();
              timer.cancel();
              var speed=(distanceInMeter/varSpeed).toStringAsFixed(2);
              speedMessage="$speed km/hr";
              Fluttertoast.showToast(msg: "End due to warning result speed:$speed km/hr");
              endResult="End Due to Multiple warnings Result Score:$speed km/hr";
            }
          }
          if(leveTime>0){
            leveTime--;
          }

          counter--;
          varSpeed++;
          if (counter == 0) {
            if(level >=7){
              stopMusic();
              timer.cancel();
              level=0;
              var speed=(distanceInMeter/varSpeed).toStringAsFixed(2);
              endResult="Great You passed. Result Score:$speed km/hr";
              speedMessage="$speed";
              Fluttertoast.showToast(msg: "Great You clear all levels result: speed:$speed km/hr");
            }
            level++;
            if(level==2){
              counter=23;
            }
            if(level==3){
              counter=21;
            }
            if(level==4){
              counter=21;
            }
            if(level==5){
              counter=20;
            }
            if(level==6){
              counter=20;
            }
            if(level==7){
              counter=20;
            }

          }
        }
      });
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Timer>('timer', timer));
  }
}

