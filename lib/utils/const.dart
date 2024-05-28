import 'package:intl/intl.dart';

const adminuid = "jCJcJWdUN4eQTqyJfi55mks3l1m2";
List<String> photographyTypes = [
  "Wedding Photography",
  "Wildlife Photography",
  "Street Photography",
  "Fashion Photography",
  "Product Photography",
  "Macro Photography",
  "Documentary Photography",
  "Underwater Photography",
  "Drone Photography",
  "Food Photography",
  "Sports Photography",
  "Other"
];

List<String> Imagecarosalslide=[
  'assets/weeding.jpg',
  'assets/wildlife.png',
  'assets/street.png',
  'assets/fashion.jpg',
  'assets/product.jpg',
  'assets/macro.jpg',
  'assets/documentary.jpg',
  'assets/underwater.jpg',
  'assets/drone.jpg',
  'assets/food.jpg',
  'assets/sports.jpg',
  'assets/other.jpg',

];

String time = DateFormat('h:mm a').format(DateTime.now());
String date = DateFormat("dd/m/yyyy").format(DateTime.now());
