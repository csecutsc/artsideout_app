import 'package:flutter/material.dart';
import 'package:artsideout_app/components/activity/ActivityDetailWidget.dart';
import 'package:artsideout_app/graphql/Activity.dart';
import 'package:artsideout_app/theme.dart';

class ActivityDetailPage extends StatefulWidget {

  final Activity data;

  ActivityDetailPage(this.data);

  @override
  _ActivityDetailPageState createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        iconTheme: IconThemeData( 
          color: Colors.black, 
        ),
        elevation: 0.0, 
        backgroundColor: Colors.transparent,
        title: Text( 
          widget.data.title, 
          style: TextStyle( 
            color: asoPrimary,
          ),
        ),
      ),
      body: ActivityDetailWidget(widget.data),
    );
  }
}