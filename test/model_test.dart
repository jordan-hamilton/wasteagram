import 'package:flutter_test/flutter_test.dart';

import '../lib/models/post.dart';

void main() {
  test('Values passed to constructor should not be null', () {

  final date = DateTime.parse('2020-03-16 22:12:59.273644');
  final imageURL = 'http://example.com/image.jpeg';
  final quantity = 6;
  final latitude = 37.7;
  final longitude = -122.4;


  final newPost = Post(
    date: date,
    imageURL: imageURL,
    quantity: quantity,
    latitude: latitude,
    longitude: longitude  
  );
    
    expect(newPost.date, isNotNull);
    expect(newPost.imageURL, isNotNull);
    expect(newPost.quantity, isNotNull);
    expect(newPost.latitude, isNotNull);
    expect(newPost.longitude, isNotNull);
  });

  test('toMap function should return a map', () {

  final date = DateTime.parse('2019-08-01 12:22:36.274654');
  final imageURL = 'http://anotherexample.org/image2.png';
  final quantity = 80;
  final latitude = 35.7;
  final longitude = -120.4;

  final newPost = Post(
    date: date,
    imageURL: imageURL,
    quantity: quantity,
    latitude: latitude,
    longitude: longitude  
  );
    
    expect(newPost.toMap(), isMap);
  });



}