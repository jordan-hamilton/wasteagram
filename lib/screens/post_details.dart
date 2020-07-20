import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/post.dart';
import '../widgets/centered_image.dart';

class PostDetails extends StatefulWidget {

  static const routeName = 'postDetails';

  PostDetails({Key key}) : super(key: key);
  
  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  Post _post;

  @override
  Widget build(BuildContext context) {    

    if (ModalRoute.of(context).settings.arguments is Post) {
      _post = ModalRoute.of(context).settings.arguments;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Wasteagram'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[              
            Padding(
              padding: EdgeInsets.all(padding(context)),
              child: Text(
                '${parseDate(_post.date)}',
                style: Theme.of(context).textTheme.display1,
                textAlign: TextAlign.center,
              ),
            ),
            CenteredImage(
              image: Image.network(_post.imageURL, fit: BoxFit.contain),
              padding: padding(context)
            ),
            SizedBox(height: 10),
            Text(
              'Items: ${_post.quantity}',
              style: Theme.of(context).textTheme.display1,
            ),
            SizedBox(height: 10),
            Text(
              '(${_post.latitude}, ${_post.longitude})',
              style: Theme.of(context).textTheme.display1,
            ),

          ]
        ),
      ),
    );
  }
}

double padding(BuildContext context) {
  if (MediaQuery.of(context).orientation == Orientation.landscape) {
    return MediaQuery.of(context).size.width * 0.05;
  } else {
    return MediaQuery.of(context).size.width * 0.1;
  }
}

String parseDate(DateTime dateTime) {
  return '${DateFormat("EEEE',' MMM'.' d',' y").format(dateTime)}';
}