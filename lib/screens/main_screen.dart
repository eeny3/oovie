import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:oovieapp/constants.dart';
import 'package:oovieapp/screens/home_screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as yt;

class MainScreen extends StatefulWidget {
  static final String id = 'MainScreen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

//
//https://api.themoviedb.org/3/movie/315635/videos?api_key=53574f2b23e7e9523f57819409f55a2b&language=en-US
class _MainScreenState extends State<MainScreen> {
  yt.YoutubePlayerController _controller;

  @override
  Widget build(BuildContext context) {
    List args = ModalRoute.of(context).settings.arguments;
    final data = args[0];
    final trailer = args[1];
    final genre = args[2];
    final decode = jsonDecode(data);
    final trailerDecode = jsonDecode(trailer);
    final genreDecode = jsonDecode(genre);
    String name = decode['results'][0]['original_title'];
    String imagePath = decode['results'][0]['backdrop_path'];
    String posterPath = decode['results'][0]['poster_path'];
    String imageUrl = 'https://image.tmdb.org/t/p/w1280$imagePath';
    String posterUrl = 'https://image.tmdb.org/t/p/w500$posterPath';
    String overview = decode['results'][0]['overview'];
    String movieRating = decode['results'][0]['vote_average'].toString();
    String date = decode['results'][0]['release_date'];

    int genre1 = decode['results'][0]['genre_ids'][0];
    int genre2 = decode['results'][0]['genre_ids'].length > 1
        ? decode['results'][0]['genre_ids'][1]
        : 0;

    String genre1String = '';
    String genre2String = '';
    for (var genre in genreDecode['genres']) {
      if (genre['id'] == genre1) genre1String = genre['name'];
      if (genre['id'] == genre2) genre2String = genre['name'];
    }
    String ytKey = trailerDecode['results'][0]['key'];
    _controller = yt.YoutubePlayerController(
      initialVideoId: ytKey,
      flags: yt.YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    return Scaffold(
      backgroundColor: Color(0xff1D1D27),
      body: Stack(
        alignment: Alignment(-1, -0.95),
        children: <Widget>[
          Column(
            children: <Widget>[
              Backdrop(imageUrl: imageUrl),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  color: Color(0xff1D1D27),
                  child: ListView(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        name,
                        textAlign: TextAlign.start,
                        style: kTitleStyle,
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: CachedNetworkImage(
                              imageUrl: posterUrl,
                              placeholder: (context, url) => SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: Center(
                                      child: CircularProgressIndicator())),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.star,
                                          color: Color(0xFFFF2D55)),
                                      SizedBox(width: 10),
                                      Text(
                                        movieRating,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.date_range,
                                          color: Color(0xFFFF2D55)),
                                      SizedBox(width: 10),
                                      Text(
                                        date,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          genre1String,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'Raleway'),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border:
                                              Border.all(color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          genre2String,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'Raleway'),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border:
                                              Border.all(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Divider(
                        color: Colors.grey.shade800,
                        thickness: 2,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Storyline',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Raleway',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        overview,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Raleway',
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 15),
                      Divider(
                        color: Colors.grey.shade800,
                        thickness: 2,
                      ),
                      SizedBox(height: 15),
                      yt.YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                        onReady: () {},
                        bottomActions: <Widget>[],
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class Backdrop extends StatelessWidget {
  Backdrop({this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        child: FittedBox(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => SizedBox(
                width: 200,
                height: 200,
                child: Center(child: CircularProgressIndicator())),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
