import 'package:artsideout_app/components/common/ASOCard.dart';
import 'package:artsideout_app/constants/ASORouteConstants.dart';
import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/constants/DisplayConstants.dart';
import 'package:artsideout_app/models/ASOCardInfo.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/DisplayService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/cupertino.dart';

class HomeDetailWidget extends StatelessWidget {
  final List<ASOCardInfo> listHomeActions = [
    ASOCardInfo("About Connections", Color(0xFF62BAA6), "assets/home/about.png",
        350, ASORoutes.ACTIVITIES),
    ASOCardInfo("Event Information", ColorConstants.PRIMARY,
        "assets/home/event.png", 300, ASORoutes.ACTIVITIES),
    ASOCardInfo("News", Colors.purple[200], "assets/home/news.png", 300,
        ASORoutes.ACTIVITIES),
    ASOCardInfo("Studio\nInstallations", Colors.blue[200],
        "assets/home/installations.png", 200, ASORoutes.INSTALLATIONS),
    ASOCardInfo("Schedule", Colors.yellow[200], "assets/home/schedule.png", 300,
        ASORoutes.ACTIVITIES),
    ASOCardInfo("Performances", Colors.yellow[200],
        "assets/home/performances.png", 300, ASORoutes.ACTIVITIES),
    ASOCardInfo("Saved", Colors.orange[200], "assets/icons/saved.svg", 200,
        ASORoutes.INSTALLATIONS)
  ];

  Widget build(BuildContext context) {
    DisplaySize _displaySize = serviceLocator<DisplayService>().displaySize;
    return StaggeredGridView.countBuilder(
      padding: EdgeInsets.only(top: 70),
      mainAxisSpacing: 15.0,
      crossAxisSpacing: 5.0,
      crossAxisCount: 4, //listHomeActions.length,
      itemCount: listHomeActions.length,
      itemBuilder: (BuildContext context, int index) => Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: ASOCard(listHomeActions[index], false)),
      staggeredTileBuilder: (int index) => new StaggeredTile.count(
        _displaySize == DisplaySize.MEDIUM || _displaySize == DisplaySize.SMALL
            ? getItemWidthTablet(index)
            : getItemWidthPC(index),
        _displaySize == DisplaySize.MEDIUM || _displaySize == DisplaySize.SMALL
            ? getItemHeightTablet(index)
            : getItemHeightPC(index),
      ),
    );
  }
}

// TODO remove hard coded values and maybe change to a multiplier
double getItemHeightPC(index) {
  if (index == 0 || index == 1) {
    //height
    return 1;
  } else if (index == 4) {
    return 1.4;
  } else
    return index.isOdd ? 0.7 : 0.7;
}

int getItemWidthPC(index) {
  if (index == 0 || index == 1) {
    return 2;
  } else if (index == 4) {
    return 2;
  } else {
    return index.isOdd ? 1 : 1;
  }
}

int getItemWidthTablet(index) {
  if (index == 0 || index == 1) {
    return 4;
  } else if (index == 2 || index == 3 || index == 5 || index == 6) {
    return 2;
  } else {
    return 4;
  }
}

int getItemHeightTablet(index) {
  if (index == 0 || index == 1) {
    return 1;
  } else if (index == 2 || index == 3 || index == 5 || index == 6) {
    return 2;
  } else {
    return 2;
  }
}
