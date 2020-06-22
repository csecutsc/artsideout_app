import 'package:flutter/material.dart';
import 'package:artsideout_app/graphql/Activity.dart';

class ActivityDetailWidget extends StatefulWidget {
  final Activity data;

  ActivityDetailWidget(this.data);

  @override
  _ActivityDetailWidgetState createState() => _ActivityDetailWidgetState();
}

class _ActivityDetailWidgetState extends State<ActivityDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.data.title,
              style: TextStyle(
                  fontSize: 36.0, color: Theme.of(context).primaryColor),
            ),
            Text(
              widget.data.zone,
              style: TextStyle(
                  fontSize: 36.0, color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
