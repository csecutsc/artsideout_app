import 'package:artsideout_app/pages/activity/ActivityDetailPage.dart';
import 'package:artsideout_app/pages/activity/MainWorkshopPage.dart';
import 'package:artsideout_app/pages/home/AboutConnectionsPage.dart';
import 'package:artsideout_app/pages/market/MainMarketPage.dart';
import 'package:artsideout_app/pages/market/MarketDetailPage.dart';
import 'package:artsideout_app/pages/profile/MainProfilePage.dart';
import 'package:artsideout_app/pages/profile/ProfileDetailPage.dart';
import 'package:artsideout_app/pages/project/ProjectDetailPage.dart';
import 'package:artsideout_app/pages/search/MasterSearchPage.dart';
import 'package:flutter/material.dart';
import 'package:artsideout_app/constants/ASORouteConstants.dart';
// Main pages
import "package:artsideout_app/pages/home/HomePage.dart";
import 'package:artsideout_app/pages/art/MasterArtPage.dart';
import 'package:artsideout_app/pages/activity/MasterActivityPage.dart';
import 'package:artsideout_app/pages/undefined_routes/UndefinedRoute.dart';

// Detailed pages
import 'package:artsideout_app/pages/art/ArtDetailPage.dart';

// TODO add route that handles side widget
class ASORouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget Function(BuildContext, Animation<double>, Animation<double>)
        pageBuilder;
    final parts = settings.name.split('?');
    // final args = (settings.arguments);
    switch (parts[0]) {
      case ASORoutes.HOME:
        pageBuilder = ((BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            HomePage());
        break;
      case ASORoutes.ABOUT:
        pageBuilder = ((BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) =>
            AboutConnectionsPage());
        break;
      case ASORoutes.INSTALLATIONS:
        var pageRoute;
        if (parts.length == 2) {
          String artDetails = parts[1].substring(3);
          pageRoute = ArtDetailPage(artDetails);
        } else if (parts.length == 1) {
          pageRoute = MasterArtPage();
        }
        pageBuilder = ((BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            pageRoute);
        break;
      case ASORoutes.ACTIVITIES:
        var pageRoute;
        if (parts.length == 2) {
          String activityDetails = parts[1].substring(3);
          pageRoute = ActivityDetailPage(activityDetails);
        } else if (parts.length == 1) {
          pageRoute = MasterActivityPage();
        }
        pageBuilder = ((BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            pageRoute);
        break;
      case ASORoutes.SEARCH:
        var pageRoute;
        if (parts.length == 2) {
          String searchDetails = parts[1].substring(3);
          pageRoute = ActivityDetailPage(searchDetails);
        } else if (parts.length == 1) {
          pageRoute = MasterSearchPage();
        }
        pageBuilder = ((BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) =>
        pageRoute);
        break;
      case ASORoutes.MARKETS:
        var pageRoute;
        if (parts.length == 2) {
          String searchDetails = parts[1].substring(3);
          pageRoute = MarketDetailPage(searchDetails);
        } else if (parts.length == 1) {
          pageRoute = MainMarketPage();
        }
        pageBuilder = ((BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) =>
        pageRoute);
        break;
      case ASORoutes.PROFILES:
        var pageRoute;
        if (parts.length == 2) {
          String searchDetails = parts[1].substring(3);
          pageRoute = ProfileDetailPage(searchDetails);
        } else if (parts.length == 1) {
          pageRoute = MainProfilePage();
        }
        pageBuilder = ((BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) =>
        pageRoute);
        break;
      case ASORoutes.PROJECT:
        var pageRoute;
        if (parts.length == 2) {
          String searchDetails = parts[1].substring(3);
          pageRoute = ProjectDetailPage(searchDetails);
        } else if (parts.length == 1) {
          pageRoute = UndefinedRoute();
        }
        pageBuilder = ((BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) =>
        pageRoute);
        break;
      case ASORoutes.WORKSHOPS:
        var pageRoute;
        if (parts.length == 2) {
          String searchDetails = parts[1].substring(3);
          pageRoute = ActivityDetailPage(searchDetails);
        } else if (parts.length == 1) {
          pageRoute = MainWorkshopPage();
        }
        pageBuilder = ((BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) =>
        pageRoute);
        break;
      case ASORoutes.UNDEFINED_ROUTE:
      default:
        pageBuilder = ((BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            UndefinedRoute());
    }
    return PageRouteBuilder(
        pageBuilder: pageBuilder,
        settings: settings,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              ),
            ),
            child: child,
          );
        });
  }
}
