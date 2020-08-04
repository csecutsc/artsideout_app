import 'package:flutter/material.dart';
import 'package:artsideout_app/theme.dart';

const int HOMEPAGE_INDEX = 10;

class Sidebar extends StatefulWidget {
  @override
  _SidebarState createState() => _SidebarState();

  Sidebar(this.onTabTapped);

  final Function onTabTapped;
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: 100,
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
          IconButton(
            icon: Icon(Icons.home),
            iconSize: 40.0,
            onPressed: () {
              changeScreen(HOMEPAGE_INDEX);
            },
          ),
          SizedBox(
            height: 25,
          ),
          IconButton(
            icon: Icon(Icons.map),
            iconSize: 40.0,
            onPressed: () {
              changeScreen(0);
            },
          ),
          SizedBox(
            height: 25,
          ),
          IconButton(
            icon: Icon(Icons.search),
            iconSize: 40.0,
            onPressed: () {
              changeScreen(0);
            },
          ),
          SizedBox(height: 145),
          IconButton(
            icon: Icon(Icons.palette),
            iconSize: 40.0,
            onPressed: () {
              changeScreen(3);
            },
          ),
          SizedBox(
            height: 25,
          ),
          IconButton(
            icon: Icon(Icons.local_activity),
            iconSize: 40.0,
            onPressed: () {
              changeScreen(5);
            },
          ),
          SizedBox(
            height: 25,
          ),
          IconButton(
            icon: Icon(Icons.bookmark),
            iconSize: 40.0,
            onPressed: () {
              changeScreen(0);
            },
          ),
        ],
      ),
    );
  }

  changeScreen(int index) {
    setState(() {
      widget.onTabTapped(index);
    });
  }
}
