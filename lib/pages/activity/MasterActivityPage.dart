import 'dart:convert';
import 'dart:html';

import 'package:artsideout_app/components/activity/ActivityWebMenu.dart';
import 'package:artsideout_app/components/home/HomeDetailWidget.dart';
import 'package:artsideout_app/graphql/Profile.dart';
import 'package:artsideout_app/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// GraphQL
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:artsideout_app/graphql/config.dart';
import 'package:artsideout_app/graphql/Activity.dart';
// Common
import 'package:artsideout_app/components/PageHeader.dart';
import 'package:artsideout_app/components/activitycard.dart';
import 'package:artsideout_app/pages/home/HomePage.dart';
import 'package:artsideout_app/components/home/Sidebar.dart';
// import 'package:artsideout_app/components/navigation.dart';
// Art
import 'package:artsideout_app/components/activity/ActivityDetailWidget.dart';
import 'package:artsideout_app/pages/activity/ActivityDetailPage.dart';
import 'package:artsideout_app/components/common.dart';
import 'package:artsideout_app/pages/art/MasterArtPage.dart';

class MasterActivityPage extends StatefulWidget {
  @override
  _MasterActivityPageState createState() => _MasterActivityPageState();
}

class _MasterActivityPageState extends State<MasterActivityPage> {
  int selectedValue = 0;
  int secondFlexSize = 1;
  int numCards = 2;
  double containerHeight = 0.0;
  bool isLargeScreen = false;
  bool isMediumScreen = false;
  bool selected = false;
  double headerFontSize;

  List<Activity> listActivity = List<Activity>();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

  @override
  void initState() {
    super.initState();
    _fillList();
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

  // Activity GraphQL Query
  void _fillList() async {
    ActivityQueries queryActivity = ActivityQueries();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.query(
      QueryOptions(
        documentNode: gql(queryActivity.getAll),
      ),
    );
    if (!result.hasException) {
      for (var i = 0; i < result.data["activities"].length; i++) {
        //print(result.data["activities"][i]);
        // result.data["activities"][i]["image"]["url"] ??

        String imgUrl = (result.data["activities"][i]["image"] != null)
            ? result.data["activities"][i]["image"]["url"]
            : "https://via.placeholder.com/350";

        List<Profile> profilesList = [];

        if (result.data["activities"][i]["profile"] != null) {
          for (var j = 0;
              j < result.data["activities"][i]["profile"].length;
              j++) {
            Map<String, String> socialMap = new Map();
            for (var key
                in result.data["activities"][i]["profile"][j]["social"].keys) {
              socialMap[key] =
                  result.data["activities"][i]["profile"][j]["social"][key];
            }
            /*
            Map<String, String> socialMap =
                (result.data["activities"][i]["profile"][j]["social"] != null)
                    ? {
                        'website': result.data["activities"][i]["profile"][j]
                                ["social"]["website"] ??
                            "",
                        'pinterest': result.data["activities"][i]["profile"][j]
                                ["social"]["pinterest"] ??
                            ""
                      } //REMOVE
                    : {
                        'facebook': "",
                        'instagram': "",
                        'website': "",
                        'pinterest': ""
                      };
                    */
            profilesList.add(Profile(
                result.data["activities"][i]["profile"][j]["name"],
                result.data["activities"][i]["profile"][j]["desc"],
                social: socialMap,
                type: result.data["activities"][i]["profile"][j]["type"] ?? "",
                installations: [],
                activities: []));
            print(profilesList[j].name);
            print(profilesList[j].social);
            print(profilesList[j].type);
          }
        }

        print(profilesList);

        Map<String, double> location =
            (result.data["activities"][i]["location"] != null)
                ? {
                    'latitude': result.data["activities"][i]["location"]
                        ["latitude"],
                    'longitude': result.data["activities"][i]["location"]
                        ["longitude"]
                  }
                : {'latitude': -1.0, 'longitude': -1.0};

        Map<String, String> time = {
          'startTime': result.data["activities"][i]["startTime"] ?? "",
          'endTime': result.data["activities"][i]["endTime"] ?? ""
        };
        setState(() {
          listActivity.add(
            Activity(
                result.data["activities"][i]["title"],
                result.data["activities"][i]["desc"],
                result.data["activities"][i]["zone"],
                imgUrl: imgUrl,
                time: time,
                location: location,
                profiles: profilesList),
          );
        });
      }
    }
    print(listActivity);
  }

  @override
  Widget build(BuildContext context) {
    // if statements for render
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        // Desktop Size
        if (MediaQuery.of(context).size.width > 1200) {
          secondFlexSize = 3;
          isLargeScreen = true;
          isMediumScreen = false;
          numCards = 2;
          // Tablet Size
        } else if (MediaQuery.of(context).size.width > 1000) {
          secondFlexSize = 1;
          isLargeScreen = false;
          if (MediaQuery.of(context).size.height > 1300) {
            isMediumScreen = false;
          }
          else {
            isMediumScreen = true;
          }
          numCards = MediaQuery.of(context).orientation == Orientation.portrait
              ? 2
              : 3;
          // Phone Size
        } else {
          isLargeScreen = false;
          isMediumScreen = false;
          numCards = 2;
        }

        // "Activity" header font size
        if (MediaQuery.of(context).size.width > 700) {
          headerFontSize = 50.0;
        } else if (MediaQuery.of(context).size.width > 440) { 
          headerFontSize = 40.0;
        } else if (MediaQuery.of(context).size.width > 330) {
          headerFontSize = 35.0;
        } else {
          headerFontSize = 30.0;
        }

        return Row(children: <Widget>[
          (isLargeScreen || isMediumScreen)
            ? Expanded( 
                flex: 5, 
                child: Sidebar(),
              )
            : Container(), 
          (isLargeScreen || isMediumScreen)
            ? ActivityWebMenu( 
                ListView.builder(
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
                              child: ActivityCard(
                                title: item.title,
                                desc: item.desc,
                                image: item.imgUrl,
                                time: item.time,
                                zone: item.zone,
                                detailPageButton: InkWell(
                                  splashColor:
                                      Colors.grey[200].withOpacity(0.25),
                                  onTap: () {
                                    if (isLargeScreen) {
                                      selectedValue = index;
                                      setState(() {});
                                    } else {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) {
                                            return ActivityDetailPage(item);
                                          },
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                        physics: BouncingScrollPhysics(),
                      ),
            )
          : Expanded(
              flex: 70,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFFCEAEB),
                ),
                child: Column(children: <Widget>[
                  // Header(
                  //   image: "assets/icons/activities.svg",
                  //   textTop: "ACTIVITIES",
                  //   textBottom: "",
                  //   subtitle: "",
                  // ),
                  // Container(
                  //   padding: const EdgeInsets.only(top: 60.0, left: 15.0, bottom: 20.0),
                  //   color: Color(0xFFFCEAEB),
                  //   alignment: Alignment.centerLeft,
                  //   child: Text(
                  //     "Activities",
                  //     style: TextStyle( 
                  //       fontWeight: FontWeight.bold,  
                  //       fontSize: 35.0,
                  //       fontFamily: 'Roboto',
                  //       color: asoPrimary,
                  //     ),
                  //   ),
                  // ),
                  Stack( 
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(top: 2.0, left: 15.0, bottom: 25.0),
                        color: Color(0xFFFCEAEB),
                        alignment: Alignment.centerLeft,
                        child: SafeArea(
                          child: Text(
                          "Activities",
                          style: TextStyle( 
                              fontWeight: FontWeight.bold,  
                              fontSize: headerFontSize,
                              fontFamily: 'Roboto',
                              color: asoPrimary,
                            ),
                          ),
                        ),
                      ),  
                      Positioned(
                        top: 0.0,
                        right: 0.0,
                        child: PlatformSvg.asset(
                          "assets/icons/activities.svg",
                          width: MediaQuery.of(context).size.width / 2,
                          height: 125,
                          fit: BoxFit.contain,
                          alignment: Alignment.topCenter,
                        ),
                      ),                    
                    ],
                  ),
                  Expanded(
                    flex: secondFlexSize,
                    child: Container( 
                      color: Color(0xFFFCEAEB),
                      child: ListView.builder(
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
                              child: ActivityCard(
                                title: item.title,
                                desc: item.desc,
                                image: item.imgUrl,
                                time: item.time,
                                zone: item.zone,
                                detailPageButton: InkWell(
                                  splashColor:
                                      Colors.grey[200].withOpacity(0.25),
                                  onTap: () {
                                    if (isLargeScreen) {
                                      selectedValue = index;
                                      setState(() {});
                                    } else {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) {
                                            return ActivityDetailPage(item);
                                          },
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                        physics: BouncingScrollPhysics(),
                      ),
                    ),
                  ),
                ]),
              )),
                        // If large screen, render activity detail page
        (isLargeScreen && listActivity.length != 0)
              ? Expanded(
                flex: 25,
                  child: ActivityDetailWidget(listActivity[selectedValue]
                  )
              )
              : Container(), 
        ]);
      }),
    );
  }
}
