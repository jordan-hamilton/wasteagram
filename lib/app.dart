import 'package:flutter/material.dart';

import 'screens/homepage.dart';
import 'screens/new_post.dart';
import 'screens/photo_picker.dart';
import 'screens/post_details.dart';

class App extends StatelessWidget {

  final String title;

  static final routes = {
    HomePage.routeName: (context) => HomePage(),
    NewPost.routeName: (context) => NewPost(),
    PhotoPicker.routeName: (context) => PhotoPicker(),
    PostDetails.routeName: (context) => PostDetails()
  };

  App({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      routes: routes,
    );
  }
}