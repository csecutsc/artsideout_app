import 'package:artsideout_app/components/layout/MasterPageLayout.dart';
import 'package:artsideout_app/constants/ASORouteConstants.dart';
import 'package:artsideout_app/constants/DisplayConstants.dart';
import 'package:artsideout_app/models/Activity.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/DisplayService.dart';
import 'package:artsideout_app/services/GraphQLConfiguration.dart';
import 'package:artsideout_app/services/NavigationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// Common
import 'package:artsideout_app/components/activity/ActivityCard.dart';
import 'package:artsideout_app/helpers/ActivityFillList.dart';
// Art
import 'package:artsideout_app/components/activity/ActivityDetailWidget.dart';

class MasterActivityPage extends StatefulWidget {
  @override
  _MasterActivityPageState createState() => _MasterActivityPageState();
}

class _MasterActivityPageState extends State<MasterActivityPage> {
  int selectedValue = 0;
  double containerHeight = 0.0;
  bool loading = true;

  List<Activity> listActivity = List<Activity>();
  GraphQLConfiguration graphQLConfiguration =
      serviceLocator<GraphQLConfiguration>();

  Future<void> setList() async {
    listActivity = await fillList().whenComplete(() => loading = false);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setList();
  }

  @override
  Widget build(BuildContext context) {
    DisplaySize _displaySize = serviceLocator<DisplayService>().displaySize;
    NavigationService _navigationService = serviceLocator<NavigationService>();
    Widget mainPageWidget = ListView.builder(
      // Let the ListView know how many items it needs to build.
      itemCount: listActivity.length,
      // Provide a builder function. This is where the magic happens.
      // Convert each item into a widget based on the type of item it is.
      itemBuilder: (context, index) {
        final item = listActivity[index];
        return AnimatedContainer(
          duration: Duration(milliseconds: 50),
          curve: Curves.fastOutSlowIn,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
                child: ActivityCard(
                    title: item.title,
                    desc: item.desc,
                    image: item.imgUrl,
                    time: item.time,
                    zone: item.zone),
                onTap: () {
                  if (_displaySize == DisplaySize.LARGE ||
                      _displaySize == DisplaySize.MEDIUM) {
                    selectedValue = index;
                    setState(() {});
                  } else {
                    _navigationService.navigateToWithId(
                        ASORoutes.ACTIVITIES, item.id);
                  }
                }),
          ),
        );
      },
      physics: BouncingScrollPhysics(),
    );

    Widget secondPageWidget = (listActivity.length != 0)
        ? ActivityDetailWidget(data: listActivity[selectedValue])
        : Container();
    return AnimatedSwitcher(
        duration: Duration(milliseconds: 250),
        transitionBuilder: (child, animation) {
          return Align(
              child: ScaleTransition(
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
          ));
        },
        child: (loading == false)
            ? MasterPageLayout(
                pageName: "PERFORMANCES",
                pageDesc: "Blah Blah Blah",
                mainPageWidget: mainPageWidget,
                secondPageWidget: secondPageWidget)
            : Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ));
  }
}
