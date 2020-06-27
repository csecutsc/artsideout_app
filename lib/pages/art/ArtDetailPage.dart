import 'package:flutter/material.dart';
import 'package:artsideout_app/components/art/ArtDetailWidget.dart';
import 'package:artsideout_app/graphql/Installation.dart';
import 'package:artsideout_app/theme.dart';

class ArtDetailPage extends StatefulWidget {
  final Installation data;

  ArtDetailPage(this.data);

  @override
  _ArtDetailPageState createState() => _ArtDetailPageState();
}

class _ArtDetailPageState extends State<ArtDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          widget.data.title,
          style: TextStyle(color: asoPrimary),
        ),
      ),
      body: ArtDetailWidget(widget.data),
    );
  }
}
