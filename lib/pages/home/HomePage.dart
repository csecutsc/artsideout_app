import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:artsideout_app/theme.dart';
// GraphQL
import 'package:artsideout_app/graphql/config.dart';
import 'package:artsideout_app/graphql/Installation.dart';
import 'package:artsideout_app/components/common.dart';
// Home
import 'package:artsideout_app/components/home/HomeDetailWidget.dart';
import 'package:artsideout_app/components/home/HomeHeader.dart';
import 'package:artsideout_app/pages/home/HomeDetailPage.dart';
// Pages
import 'package:artsideout_app/pages/art/MasterArtPage.dart';
import 'package:artsideout_app/pages/activity/MasterActivityPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedValue = 0;
  int secondFlexSize = 1;
  bool isLargeScreen = false;
  bool isMediumScreen = false; // tablet

  List<Installation> listInstallation = List<Installation>();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

  @override
  void initState() {
    super.initState();
  }

  final List<HomeAction> listHomeActions = [
    HomeAction("Event Information", asoPrimary, "assets/icons/asoBg.svg", 300,
        MasterActivityPage()),
    HomeAction("About Connections", Color(0xFF62BAA6),
        "assets/icons/aboutConnections.svg", 350, MasterActivityPage()),
    HomeAction("News", Colors.purple[200], "assets/icons/activities.svg", 300,
        MasterArtPage()),
    HomeAction("Art", Colors.blue[200], "assets/icons/installation.svg", 200,
        MasterArtPage()),
    HomeAction("Schedule", Colors.yellow[200], "assets/icons/activities.svg",
        300, MasterActivityPage()),
    HomeAction("Activities", Colors.yellow[200], "assets/icons/activities.svg",
        300, MasterActivityPage()),
    HomeAction("Saved", Colors.orange[200], "assets/icons/saved.svg", 200,
        MasterArtPage())
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (MediaQuery.of(context).size.width > 1200) {
            secondFlexSize = 6;
            isLargeScreen = true;
            isMediumScreen = false;
          } else if (MediaQuery.of(context).size.width > 600) {
            secondFlexSize = 5;
            isLargeScreen = true;
            isMediumScreen = true;
          } else {
            isLargeScreen = false;
            isMediumScreen = false;
          }
          return Row(children: <Widget>[
            (isLargeScreen)
                ? Expanded(
                    flex: secondFlexSize,
                    child: HomeDetailWidget(
                        isMediumScreen, isLargeScreen, listHomeActions))
                : Container(),
            (isLargeScreen)
                ? Expanded(
                    flex: (secondFlexSize / 2).round(),
                    child: Center(
                      child: Text("About Page"),
                    ),
                  )
                : Expanded(
                    flex: 1,
                    child: Stack(
                      fit: StackFit.passthrough,
                      overflow: Overflow.clip,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Positioned(
                          top: 0,
                          right: 0,
                          left: 0,
                          bottom: MediaQuery.of(context).size.height / 3,
                          child: GestureDetector(
                            onTap: () {
                              if (!isLargeScreen) {
                                Navigator.push(context, CupertinoPageRoute(
                                  builder: (context) {
                                    return Container();
                                  },
                                ));
                              }
                            },
                            child: Header(
                              image: "assets/icons/lightPinkBg.svg",
                              textTop: "ARTSIDEOUT",
                              textBottom: "2020",
                              subtitle: "Connections",
                              offset: 0,
                            ),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height / 5.3,
                          right: 0,
                          left: 0,
                          bottom: 0,
                          child: StaggeredGridView.countBuilder(
                            // padding: EdgeInsets.zero,
                            crossAxisCount: 2,
                            itemCount: listHomeActions.length,
                            itemBuilder: (BuildContext context, int index) =>
                                Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(context,
                                              CupertinoPageRoute(
                                            builder: (context) {
                                              return listHomeActions[index]
                                                  .page;
                                            },
                                          ));
                                        },
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            child: Container(
                                              color:
                                                  listHomeActions[index].color,
                                              child: Stack(
                                                children: <Widget>[
                                                  Positioned(
                                                    top: -20,
                                                    left: 10,
                                                    child: PlatformSvg.asset(
                                                      listHomeActions[index]
                                                          .imgUrl,
                                                      width:
                                                          listHomeActions[index]
                                                              .imgWidth,
                                                      fit: BoxFit.fitWidth,
                                                      alignment:
                                                          Alignment.topCenter,
                                                    ),
                                                  ),
                                                  new Align(
                                                    alignment:
                                                        Alignment(-0.8, 0.8),
                                                    child: new Text(
                                                        listHomeActions[index]
                                                            .title,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline5
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: index ==
                                                                            0 ||
                                                                        index ==
                                                                            1
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black)),
                                                  ),
                                                ],
                                              ),
                                            )))),
                            staggeredTileBuilder: (int index) =>
                                new StaggeredTile.count(
                              getItemWidth(index),
                              getItemHeight(index),
                            ),
                            mainAxisSpacing: 15.0,
                            crossAxisSpacing: 5.0,
                          ),
                        ),
                      ],
                    ),
                  ),
          ]);
        },
      ),
    );
  }
}

double getItemHeight(index) {
  if (index == 0 || index == 1) //height
    return 0.6;
  else if (index == 4) {
    return 1.0;
  } else
    return 0.9;
}

int getItemWidth(index) {
  if (index == 0 || index == 1 || index == 4) {
    return 2;
  } else {
    return 1;
  }
}

class HomeAction {
  String title;
  Color color;
  String imgUrl;
  double imgWidth;
  Widget page;

  HomeAction(this.title, this.color, this.imgUrl, this.imgWidth, this.page);
}
