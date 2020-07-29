import 'package:flutter/material.dart';
import 'package:artsideout_app/theme.dart';

class Sidebar extends StatefulWidget {
  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: 85,
      decoration: BoxDecoration(
        color: asoPrimary,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            minRadius: 30.0,
          ),
          SizedBox(
            height: 40.0,
          ),
          Icon(
            Icons.map,
            size: 40.0,
          ),
          SizedBox(
            height: 25,
          ),
          Icon(
            Icons.search,
            size: 40.0,
          ),
          SizedBox(height: 145),
          Icon(
            Icons.palette,
            size: 40.0,
          ),
          SizedBox(
            height: 25,
          ),
          Icon(
            Icons.local_activity,
            size: 40.0,
          ),
          SizedBox(
            height: 25,
          ),
          Icon(
            Icons.bookmark,
            size: 40.0,
          )
        ],
      ),
    );
  }
}
