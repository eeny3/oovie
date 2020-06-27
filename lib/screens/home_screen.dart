import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oovieapp/constants.dart';
import 'loading_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  static final String id = 'HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool firstOptionSelected = true;
  @override
  Widget build(BuildContext context) {
    List args = ModalRoute.of(context).settings.arguments;
    var posters = args;
    return Scaffold(
      backgroundColor: Color(0xff1D1D27),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        firstOptionSelected = true;
                      });
                    },
                    child: Text(
                      'Recommended',
                      style: TextStyle(
                        color: firstOptionSelected ? Colors.white : Colors.grey,
                        fontSize: firstOptionSelected ? 26 : 20,
                        fontWeight:
                            firstOptionSelected ? FontWeight.bold : null,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        firstOptionSelected = false;
                      });
                    },
                    child: Text(
                      'Search',
                      style: TextStyle(
                        color: firstOptionSelected ? Colors.grey : Colors.white,
                        fontSize: !firstOptionSelected ? 26 : 20,
                        fontWeight:
                            !firstOptionSelected ? FontWeight.bold : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            firstOptionSelected
                ? Expanded(
                    flex: 4,
                    child: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return posters[index];
                      },
                      itemCount: posters.length,
                      controller: PageController(
                        initialPage: 0,
                        viewportFraction: 0.8,
                      ),
                    ),
                  )
                : Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 0),
                      child: TextField(
                        onSubmitted: (movieName) {
                          Navigator.pushNamed(context, LoadingScreen.id,
                              arguments: movieName);
                        },
                        cursorColor: Color(0xFFFF2D55),
                        decoration: InputDecoration(
                          hintText: 'Movie',
                          hintStyle: TextStyle(fontFamily: 'Raleway'),
                          filled: true,
                          fillColor: Colors.grey.shade700,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade900,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

/*
ClipRRect(
              borderRadius: BorderRadius.circular(15),
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
 */
/*
TextField(
                  onSubmitted: (movieName) {
                    Navigator.pushNamed(context, LoadingScreen.id,
                        arguments: movieName);
                  },
                  cursorColor: Color(0xFFFF2D55),
                  decoration: InputDecoration(
                    hintText: 'Movie',
                    hintStyle: TextStyle(fontFamily: 'Raleway'),
                    filled: true,
                    fillColor: Colors.grey.shade700,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade900,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                )
 */
