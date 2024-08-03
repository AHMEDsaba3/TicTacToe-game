import 'package:flutter/cupertino.dart';
double heightR(double x,BuildContext context){
  var h = MediaQuery.of(context).size.height;
  return x/844*h;
}
double widthR(double x,BuildContext context){
  var w = MediaQuery.of(context).size.width;
  return x/390*w;
}
double sizeR(double x,BuildContext context){
  var h = MediaQuery.of(context).size.height;
  var w = MediaQuery.of(context).size.width;
  return x/326160*w*h;
}