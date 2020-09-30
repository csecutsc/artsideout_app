import 'package:artsideout_app/components/common/MobileMenu.dart';
import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/constants/DisplayConstants.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/DisplayService.dart';
import 'package:artsideout_app/services/NavigationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../common/PlatformSvg.dart';
// Named Routes
import 'package:artsideout_app/constants/ASORouteConstants.dart';
import 'package:artsideout_app/components/common/Sidebar.dart';

class AppLayout extends StatelessWidget {
  final Widget childPage;
  const AppLayout({Key key, this.childPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DisplayService _displayService = serviceLocator<DisplayService>();
    _displayService.updateDisplaySize(context);

    Widget _buildDesktopLayout() {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

      return new Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(children: <Widget>[
            Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: PlatformSvg.asset(
                  "assets/common/background.png",
                  fit: BoxFit.cover,
                )),
            Row(children: <Widget>[Sidebar(), Expanded(child: childPage)])
          ]));
    }

    Widget _buildTabletLayout() {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

      return new Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(children: <Widget>[
            Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: PlatformSvg.asset(
                  "assets/common/background.png",
                  fit: BoxFit.fitHeight,
                )),
            Row(children: <Widget>[Sidebar(), Expanded(child: childPage)])
          ]));
    }

    // TODO Fix Global Back Button
    Widget _buildMobileLayout() {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
      final NavigationService _navigationService =
          serviceLocator<NavigationService>();
      return Stack(children: <Widget>[
        Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: PlatformSvg.asset(
              "assets/common/background.png",
              fit: BoxFit.cover,
            )),
        Positioned(
            left: 500,
            bottom: 100,
            child: Text("Copyright")),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: childPage,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: MobileMenu(),
          bottomNavigationBar: BottomAppBar(
            color: ColorConstants.PRIMARY.withOpacity(0.45),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(50.0, 8.0, 8.0, 12.0),
                  child: IconButton(
                    onPressed: () {
                      _navigationService.navigateTo(ASORoutes.HOME);
                    },
                    icon: Icon(
                      Icons.home,
                      semanticLabel: "Home",
                      size: 29.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 50.0, 12.0),
                  child: IconButton(
                    onPressed: () {
                      _navigationService.navigateTo(ASORoutes.SEARCH);
                    },
                    icon: Icon(
                      Icons.search,
                      semanticLabel: "Search",
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ]);
    }

    switch (_displayService.displaySize) {
      case DisplaySize.LARGE:
        return _buildDesktopLayout();
      case DisplaySize.MEDIUM:
        return _buildTabletLayout();
      case DisplaySize.SMALL:
      default:
        return _buildMobileLayout();
    }
  }
}
