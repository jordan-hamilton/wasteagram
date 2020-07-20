import 'package:flutter/material.dart';

class CenteredImage extends StatelessWidget {

  final double padding;
  final Image image;

  const CenteredImage({Key key, this.padding, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: image,
      ),
    );
  }
}
