import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'new_post.dart';

class PhotoPicker extends StatefulWidget {

  static const routeName = 'photoPicker';

  const PhotoPicker({Key key}) : super(key: key);

  @override
  _PhotoPickerState createState() => _PhotoPickerState();
}

class _PhotoPickerState extends State<PhotoPicker> {

  File _image;

  void getPhoto(ImageSource source) async {
    _image = await ImagePicker.pickImage(source: source);
    _image == null
      ? print('No image selected.')
      : Navigator.pushReplacementNamed(context, NewPost.routeName, arguments: _image);
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wasteagram'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Semantics(
              label: 'Select an existing photo on your device.',
              button: true,
              child: RaisedButton(
                child: Text("Select a photo"),
                onPressed: () => getPhoto(ImageSource.gallery),
              ),
            ),
            Semantics(
              label: 'Use the camera to take a photo.',
              button: true,
              child: RaisedButton(
                child: Text("Take a photo"),
                onPressed: () => getPhoto(ImageSource.camera),
              ),
            ),
          ],
        )
      ),
    );
  }
}
