import 'package:artsideout_app/constants/ASORouteConstants.dart';
import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/NavigationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class MobileMenu extends StatefulWidget {
  @override
  _MobileMenuState createState() => _MobileMenuState();
}

class _MobileMenuState extends State<MobileMenu> {
  final List<_MobileMenuItem> _menuItems = [
    _MobileMenuItem("Installations", Icons.palette, ASORoutes.INSTALLATIONS),
    _MobileMenuItem("Performances", Icons.face, ASORoutes.ACTIVITIES),
    _MobileMenuItem("Profiles", Icons.group, ASORoutes.PROFILES),
    _MobileMenuItem("Art Market", Icons.store, ASORoutes.MARKETS),
    _MobileMenuItem("Workshops", Icons.calendar_today, ASORoutes.WORKSHOPS),
  ];
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    final NavigationService _navigationService =
        serviceLocator<NavigationService>();

    return SpeedDial(
      backgroundColor: ColorConstants.PRIMARY,
      animatedIcon: AnimatedIcons.view_list,
      marginBottom: 25,
      marginRight: (width / 2) - 15,
      children: [
        for (var item in _menuItems.reversed)
          SpeedDialChild(
              child: Icon(item.iconData, color: Colors.black),
              backgroundColor: Colors.white,
              label: item.name,
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                setState(() {
                  _navigationService.navigateTo(item.route);
                });
              })
      ],
    );
  }
}

class _MobileMenuItem {
  String name;
  IconData iconData;
  String route;

  _MobileMenuItem(this.name, this.iconData, this.route);
}
