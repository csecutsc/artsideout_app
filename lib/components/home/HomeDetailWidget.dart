import 'package:artsideout_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// Pages
import 'package:artsideout_app/pages/home/HomePage.dart';
// Home
import 'package:artsideout_app/components/home/HomeHeader.dart';

import 'package:flutter/cupertino.dart';
import 'package:artsideout_app/components/common.dart';
import 'package:artsideout_app/components/home/Sidebar.dart';

class HomeDetailWidget extends StatefulWidget {
  HomeDetailWidget(
      this.isMediumScreen, this.isLargeScreen, this.listHomeActions);

  final bool isMediumScreen;
  final bool isLargeScreen;
  final List<HomeAction> listHomeActions;

  @override
  _HomeDetailWidgetState createState() => _HomeDetailWidgetState();
}

class _HomeDetailWidgetState extends State<HomeDetailWidget> {
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Sidebar(),
          Expanded(
            flex: 8,
            child: Stack(
              fit: StackFit.passthrough,
              overflow: Overflow.clip,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Positioned(
                  //color: Colors.black,
                  top: MediaQuery.of(context).size.height / 5,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: PlatformSvg.asset(
                    "assets/icons/roadBg.svg",
                    width: 1200, //300,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment(0.5, 0.8),
                  ),
                  //margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  left: 20,
                  bottom: MediaQuery.of(context).size.height / 3,
                  child: GestureDetector(
                    onTap: () {
//                      if (!isLargeScreen) {
//                        Navigator.push(context, CupertinoPageRoute(
//                          builder: (context) {
//                            return HomeDetailPage();
//                          },
//                        ));
//                      }
                    },
                    child: Header(
                      image: widget.isLargeScreen || widget.isMediumScreen
                          ? "assets/icons/lightPinkBg.svg"
                          : "assets/icons/roadBg.svg",
                      textTop: "ARTSIDEOUT",
                      textBottom: "2020",
                      subtitle: "Connections",
                      offset: 0,
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height / 10,
                  right: 20,
                  left: 20,
                  bottom: 0,
                  child: StaggeredGridView.countBuilder(
                    padding: EdgeInsets.only(top: 70),
                    mainAxisSpacing: 15.0,
                    crossAxisSpacing: 5.0,
                    crossAxisCount: 4, //listHomeActions.length,
                    itemCount: widget.listHomeActions.length,
                    itemBuilder: (BuildContext context, int index) => Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, CupertinoPageRoute(
                                builder: (context) {
                                  return widget.listHomeActions[index].page;
                                },
                              ));
                            },
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Container(
                                  color: widget.listHomeActions[index].color,
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        top: -20,
                                        left: 10,
                                        child: PlatformSvg.asset(
                                          widget.listHomeActions[index].imgUrl,
                                          width: widget
                                              .listHomeActions[index].imgWidth,
                                          fit: BoxFit.fitWidth,
                                          alignment: Alignment.topCenter,
                                        ),
                                      ),
                                      new Align(
                                        alignment: Alignment(-0.8, 0.8),
                                        child: Text(
                                            widget.listHomeActions[index].title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        index == 0 || index == 1
                                                            ? Colors.white
                                                            : Colors.black)),
                                      ),
                                    ],
                                  ),
                                )))),
                    staggeredTileBuilder: (int index) =>
                        new StaggeredTile.count(
                      widget.isMediumScreen
                          ? getItemWidthTablet(index)
                          : getItemWidthPC(index),
                      widget.isMediumScreen
                          ? getItemHeightTablet(index)
                          : getItemHeightPC(index),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

double getItemHeightPC(index) {
  if (index == 0 || index == 1) //height
    return 1.1;
  else if (index == 4) {
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
