import 'package:flutter/material.dart';
import 'package:artsideout_app/components/activity/ActivityDetailWidget.dart';
import 'package:artsideout_app/graphql/Activity.dart';

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
      appBar: AppBar(),
      body: ActivityDetailWidget(widget.data),
    );
  }
}