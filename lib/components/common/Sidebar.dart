import 'package:artsideout_app/constants/ASORouteConstants.dart';
import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/NavigationService.dart';
import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NavigationService _navigationService =
        serviceLocator<NavigationService>();

    final List<_SidebarAction> _sideBarActions = [
      _SidebarAction("Home", Icons.home, ASORoutes.HOME),
      _SidebarAction("Search", Icons.search, ASORoutes.SEARCH),
      _SidebarAction(
          "Studio Installations", Icons.palette, ASORoutes.INSTALLATIONS),
      _SidebarAction("Performances", Icons.face, ASORoutes.ACTIVITIES),
      _SidebarAction("Profiles", Icons.person, ASORoutes.PROFILES),
      _SidebarAction("Art Market", Icons.store, ASORoutes.MARKETS),
      _SidebarAction("Workshops", Icons.calendar_today, ASORoutes.WORKSHOPS),
    ];

    return Container(
      height: MediaQuery.of(context).size.height,
      width: 100,
      color: ColorConstants.PRIMARY.withOpacity(0.65),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: CircleAvatar(
                radius: 35.0,
                backgroundImage: NetworkImage("assets/assets/common/icon.png")),
          ),
          for (var action in _sideBarActions)
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(action.icon, semanticLabel: action.name),
                iconSize: 40.0,
                onPressed: () {
                  _navigationService.navigateTo(action.route);
                },
              ),
            )
        ],
      ),
    );
  }
}

class _SidebarAction {
  String name;
  IconData icon;
  String route;

  _SidebarAction(this.name, this.icon, this.route);
}
