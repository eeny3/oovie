import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:oovieapp/constants.dart';
import 'package:oovieapp/screens/main_screen.dart';

class LoadingScreen extends StatefulWidget {
  static final String id = 'LoadingString';

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  var movie;

  void getMovieData(String movie) async {
    var movieData = await http.get('$kDbUrl1$movie$kDbUrl2');
    if (jsonDecode(movieData.body)['results'].length == 0) {
      Fluttertoast.showToast(
          msg: "Movie not found :(",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
    }
    String movieId = jsonDecode(movieData.body)['results'][0]['id'].toString();
    var trailerData = await http.get(
        "https://api.themoviedb.org/3/movie/$movieId/videos?api_key=53574f2b23e7e9523f57819409f55a2b&language=en-US");
    var genres = await http.get(
        'https://api.themoviedb.org/3/genre/movie/list?api_key=53574f2b23e7e9523f57819409f55a2b&language=en-US');
    if (movieData.statusCode == 200) {
      String data = movieData.body;
      String trailer = trailerData.body;
      String genresData = genres.body;
      Navigator.pushNamed(context, MainScreen.id,
          arguments: [data, trailer, genresData]);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    String args = ModalRoute.of(context).settings.arguments;
    getMovieData(args);
    return Scaffold(
      backgroundColor: Color(0xff1D1D27),
      body: Center(
        child: SpinKitPumpingHeart(
          color: Color(0xFFFF2D55),
        ),
      ),
    );
  }
}
