import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:oovieapp/screens/home_screen.dart';
import 'package:oovieapp/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:oovieapp/main.dart';
import 'package:oovieapp/screens/loading_screen.dart';

class StartScreen extends StatefulWidget {
  static final String id = 'StartScreen';

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  Future getList() async {
    setState(() {
      showSpinner = true;
    });
    List<dynamic> posters = [];
    for (String movie in kRecommended) {
      var movieData = await http.get('$kDbUrl1$movie$kDbUrl2');
      String data = movieData.body;
      final decode = jsonDecode(data);
      String posterPath = decode['results'][0]['poster_path'];
      String posterUrl = 'https://image.tmdb.org/t/p/w500$posterPath';
      String title = decode['results'][0]['original_title'];
      posters.add(
        Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, LoadingScreen.id,
                      arguments: title);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl: posterUrl,
                    placeholder: (context, url) => SizedBox(
                        width: 200,
                        height: 200,
                        child: Center(child: CircularProgressIndicator())),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),
            //SizedBox(height: 15),
            Expanded(
              flex: 1,
              child: Container(
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Raleway'),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    setState(() {
      showSpinner = false;
    });
    return posters;
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Color(0xff1D1D27),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(55, 145, 55, 45),
            color: Color(0xBF1D1D27),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 14),
                    Icon(
                      Icons.live_tv,
                      color: Colors.white,
                      size: 42,
                    ),
                    SizedBox(width: 15),
                    Text(
                      'ooviE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontFamily: 'MuseoModerno',
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    var postersToSend = await getList();
                    Navigator.pushNamed(context, HomeScreen.id,
                        arguments: postersToSend);
                  },
                  child: Card(
                    color: Color(0xFFFF2D55),
                    child: ListTile(
                      title: Text(
                        "Let's get started",
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Icon(Icons.arrow_forward, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
