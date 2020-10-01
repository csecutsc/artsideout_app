import 'package:artsideout_app/components/layout/MasterPageLayout.dart';
import 'package:artsideout_app/components/search/FetchResultCard.dart';
import 'package:artsideout_app/constants/ASORouteConstants.dart';
import 'package:artsideout_app/constants/DisplayConstants.dart';
import 'package:artsideout_app/models/Activity.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/DisplayService.dart';
import 'package:artsideout_app/services/NavigationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// Common
import 'package:artsideout_app/helpers/ActivityFillList.dart';
// Art
import 'package:artsideout_app/components/activity/ActivityDetailWidget.dart';

class MainWorkshopPage extends StatefulWidget {
  @override
  _MainWorkshopPageState createState() => _MainWorkshopPageState();
}

class _MainWorkshopPageState extends State<MainWorkshopPage> {
  int selectedValue = 0;
  double containerHeight = 0.0;
  bool loading = true;

  List<Activity> listActivity = List<Activity>();

  Future<void> setList() async {
    listActivity =
        await fillListWorkShops().whenComplete(() => loading = false);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setList();
  }

  @override
  Widget build(BuildContext context) {
    FetchResultCard fetchResultCard = new FetchResultCard();
    DisplaySize _displaySize = serviceLocator<DisplayService>().displaySize;
    NavigationService _navigationService = serviceLocator<NavigationService>();
    Widget mainPageWidget = Stack(children: [
      Positioned(
          top: 80,
          left: 0,
          right: 0,
          bottom: 0,
          child: ListView.builder(
            // Let the ListView know how many items it needs to build.
            itemCount: listActivity.length,
            // Provide a builder function. This is where the magic happens.
            // Convert each item into a widget based on the type of item it is.
            itemBuilder: (context, index) {
              final item = listActivity[index];
              return Material(
                color: Colors.transparent,
                child: GestureDetector(
                    child: fetchResultCard.getCard("Activity", item),
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
              );
            },
            physics: BouncingScrollPhysics(),
          ))
    ]);

    Widget secondPageWidget = (listActivity.length != 0)
        ? ActivityDetailWidget(data: listActivity[selectedValue])
        : Container();

    return MasterPageLayout(
        pageName: "Workshops",
        pageDesc: "Due to the COVID-19 pandemic, ARTSIDEOUT is introducing a new interactive aspect to the festival -- Art Workshop! There is a wide variety of workshops throughout the day that you can access and participate in.",
        mainPageWidget: mainPageWidget,
        secondPageWidget: secondPageWidget,
        loading: loading);
  }
}
