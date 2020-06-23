import 'package:flutter/material.dart';
import 'package:artsideout_app/graphql/Installation.dart';

class ArtDetailWidget extends StatefulWidget {
  final Installation data;

  ArtDetailWidget(this.data);

  @override
  _ArtDetailWidgetState createState() => _ArtDetailWidgetState();
}

class _ArtDetailWidgetState extends State<ArtDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration( 
        color: Colors.white,
        // borderRadius: BorderRadius.circular(25),
        boxShadow: [ 
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5, 
            blurRadius: 7, 
            offset: Offset(10, 3),
          ),
        ],
      ),
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
