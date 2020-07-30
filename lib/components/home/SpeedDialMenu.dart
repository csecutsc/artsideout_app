import 'package:flutter/material.dart';
import 'package:artsideout_app/theme.dart';
import 'package:artsideout_app/layout.dart' as Layout;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class SpeedDialMenu extends StatefulWidget {
  @override
  _SpeedDialMenuState createState() => _SpeedDialMenuState();

  final Function onTabTapped;
  final List<Layout.NavigationItem> barItems;

  SpeedDialMenu({this.onTabTapped, this.barItems});
}

class _SpeedDialMenuState extends State<SpeedDialMenu> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SpeedDial(
      backgroundColor: asoPrimary,
      animatedIcon: AnimatedIcons.home_menu,
      marginBottom: (height / 10) - 30,
      marginRight: (width / 2) - 15,
      children: [
        SpeedDialChild(
            child: widget.barItems[3].icon,
            backgroundColor: Colors.white,
            label: widget.barItems[3].title.data,
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                widget.onTabTapped(3);
              });
            }),
        SpeedDialChild(
            child: widget.barItems[4].icon,
            backgroundColor: Colors.white,
            label: widget.barItems[4].title.data,
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                widget.onTabTapped(4);
              });
            }),
        SpeedDialChild(
            child: widget.barItems[5].icon,
            backgroundColor: Colors.white,
            label: widget.barItems[5].title.data,
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                widget.onTabTapped(5);
              });
            }),
      ],
      onPress: () {
        setState(() {
          widget.onTabTapped(1);
        });
      },
    );
  }
}
