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
          Expanded(
            flex: 1,
            child: CircleAvatar(
              radius: 35.0,
              backgroundColor: Colors.white,
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.home),
              iconSize: 40.0,
              onPressed: () {
                changeScreen(HOMEPAGE_INDEX);
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.map),
              iconSize: 40.0,
              onPressed: () {
                changeScreen(0);
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.search),
              iconSize: 40.0,
              onPressed: () {
                changeScreen(0);
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.palette),
              iconSize: 40.0,
              onPressed: () {
                changeScreen(3);
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.local_activity),
              iconSize: 40.0,
              onPressed: () {
                changeScreen(5);
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.bookmark),
              iconSize: 40.0,
              onPressed: () {
                changeScreen(0);
              },
            ),
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
