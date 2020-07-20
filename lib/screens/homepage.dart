import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'photo_picker.dart';
import 'post_details.dart';
import '../models/post.dart';

class HomePage extends StatefulWidget {

  static const routeName = '/';

  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void pushPhotoPicker(BuildContext context) => Navigator.of(context).pushNamed(PhotoPicker.routeName);
  void pushPostDetails(BuildContext context, Post post) => Navigator.of(context).pushNamed(
    PostDetails.routeName,
    arguments: post
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wasteagram'),
      ),
      body: getStream(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => pushPhotoPicker(context),
        tooltip: 'Photo Picker',
        child: Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  StreamBuilder getStream() {
    return StreamBuilder(
      stream: Firestore.instance.collection('posts').orderBy('date', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.documents.length > 0) {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              var post = snapshot.data.documents[index];
              var postModel = Post(
                date: post['date'].toDate(),
                imageURL: post['imageURL'],
                quantity: post['quantity'],
                latitude: post['latitude'],
                longitude: post['longitude'],
              );
              return ListTile(
                title: Text(parseDate(post['date'].toDate())),
                trailing: Text(post['quantity'].toString()),
                onTap: () => pushPostDetails(context, postModel)
              );
            }
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}

String parseDate(DateTime dateTime) {
  return '${DateFormat("EEEE',' MMM'.' d").format(dateTime)}';
}
