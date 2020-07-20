import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import '../models/post.dart';
import '../widgets/centered_image.dart';

class NewPost extends StatefulWidget {

  static const routeName = 'newPost';

  const NewPost({Key key}) : super(key: key);

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  
  final _formKey = GlobalKey<FormState>();
  
  File _image;

  Post _newPost;

  LocationData locationData;
  var locationService = Location();

  void initState() {
    super.initState();
    retrieveLocation();
  }

  void retrieveLocation() async {   
    try {
      var _serviceEnabled = await locationService.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await locationService.requestService();
        if (!_serviceEnabled) {
          print('Failed to enable service. Returning.');
          return;
        }
      }

      var _permissionGranted = await locationService.hasPermission();
      if (_permissionGranted == PermissionStatus.DENIED) {
        _permissionGranted = await locationService.requestPermission();
        if (_permissionGranted != PermissionStatus.GRANTED) {
          print('Location service permission not granted. Returning.');
        }
      }

      locationData = await locationService.getLocation();
    } on PlatformException catch (e) {
      print('Error: ${e.toString()}, code: ${e.code}');
      locationData = null;
    }
    setState(() {});
  }

  void createPost(int value) async {

    String url = await uploadPhoto(_image);
    
    _newPost = Post(
      quantity: value,
      date: DateTime.now(),
      latitude: locationData.latitude,
      longitude: locationData.longitude,
      imageURL: url
    );
    
    Firestore.instance.collection('posts').add(_newPost.toMap());
  }

  Future<String> uploadPhoto(image) async {
    StorageReference storageReference = FirebaseStorage.instance.ref().child(DateTime.now().toString());
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    return await storageReference.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {    

    if (ModalRoute.of(context).settings.arguments is File) {
      _image = ModalRoute.of(context).settings.arguments;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Wasteagram'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CenteredImage(
              image: Image.file(
                _image,
                fit: BoxFit.contain
              ),
              padding: padding(context)
            ),
            Form(
              key: _formKey,
              child: Column(children: formFields(context))
            ),
          ]
        ),
      ),
    );
  }
  
  List<Widget> formFields(BuildContext context) {
    return [
      SizedBox(height: 10),
      Container(
        width: 100,
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Quantity',
            border: OutlineInputBorder()
          ),
          autofocus: true,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ],
          keyboardType: TextInputType.number,
          onSaved: (value) => createPost(int.parse(value)),
          validator: (value) =>
            value.isEmpty ? 'Quantity?' : null
        ),
      ),
      SizedBox(height: 10),
      Semantics(
        label: 'Upload a photo and create a post',
        button: true,
        child: RaisedButton.icon(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              Navigator.of(context).pop();
            }
          },
          icon: Icon(Icons.cloud_upload),
          label: Text('Save this post')
        ),
      ),
      SizedBox(height: 20),
    ];
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
  return '${DateFormat("EEEE',' MMM'.' d").format(dateTime)}';
}