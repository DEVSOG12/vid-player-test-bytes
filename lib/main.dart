import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vs/video_screen.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String bytes;
  @override
  void initState() {
    super.initState();
    http
        .get(Uri.parse(
            "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_480_1_5MG.mp4"))
        .then((value) {
      bytes = base64Encode(value.bodyBytes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bytes == null
          ? Center(child: CircularProgressIndicator())
          : MovieTheaterBody(
              encodedBytes: bytes,
            ),
    );
  }
}
