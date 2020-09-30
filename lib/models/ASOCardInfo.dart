import 'dart:ui';

import 'package:flutter/cupertino.dart';

class ASOCardInfo {
  String title;
  Color color;
  String imgUrl;
  double imgWidth;
  String route;
  String altUrl;
  String itemId;

  ASOCardInfo(this.title, this.color, this.imgUrl, this.imgWidth, this.route, {this.altUrl, this.itemId});
}
