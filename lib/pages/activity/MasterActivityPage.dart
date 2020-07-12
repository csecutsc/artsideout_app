import 'dart:html';

import 'package:artsideout_app/graphql/Profile.dart';
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
import 'package:artsideout_app/components/navigation.dart';
// Art
import 'package:artsideout_app/components/activity/ActivityDetailWidget.dart';
import 'package:artsideout_app/pages/activity/ActivityDetailPage.dart';

class MasterActivityPage extends StatefulWidget {
  @override
  _MasterActivityPageState createState() => _MasterActivityPageState();
}

class _MasterActivityPageState extends State<MasterActivityPage> {
  int selectedValue = 0;
  int secondFlexSize = 1;
  int numCards = 2;
  var isLargeScreen = false;
  bool selected = false;

  List<Activity> listActivity = List<Activity>();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

  @override
  void initState() {
    super.initState();
    _fillList();
  }

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

        String imgUrlTest = (result.data["activities"][i]["image"] != null)
            ? result.data["activities"][i]["image"]["url"]
            : "https://via.placeholder.com/350";

        List<Profile> profilesList = [];

        if (result.data["activities"][i]["profile"] != null) {
          for (var j = 0;
              j < result.data["activities"][i]["profile"].length;
              j++) {
            Map<String, String> socialMap =
                (result.data["activities"][i]["profile"][j]["social"] != null)
                    ? {
                        'website': result.data["activities"][i]["profile"][j]
                                ["social"]["website"] ??
                            "",
                        'pinterest': result.data["activities"][i]["profile"][j]
                                ["social"]["pinterest"] ??
                            ""
                      }
                    : {'website': "", 'pinterest': ""};

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
                imgUrl: imgUrlTest,
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ASOAppBar(),
      body: OrientationBuilder(builder: (context, orientation) {
        // Desktop Size
        if (MediaQuery.of(context).size.width > 1200) {
          secondFlexSize = 3;
          isLargeScreen = true;
          numCards = 2;
          // Tablet Size
        } else if (MediaQuery.of(context).size.width > 600) {
          secondFlexSize = 1;
          isLargeScreen = true;
          numCards = MediaQuery.of(context).orientation == Orientation.portrait
              ? 2
              : 3;
          // Phone Size
        } else {
          isLargeScreen = false;
          numCards = 2;
        }
        return Row(children: <Widget>[
          Expanded(
              flex: secondFlexSize,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFFCEAEB),
                ),
                child: Column(children: <Widget>[
                  Header(
                    image: "assets/icons/activities.svg",
                    textTop: "ACTIVITIES",
                    textBottom: "",
                    subtitle: "",
                  ),
                  Expanded(
                      // Calendar Box
                      child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30.0, top: 15.0, bottom: 15.0),
                          child: Text(
                            'Calendar',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                        SizedBox(height: 50),
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
                                  // Activity Card Button

                                  // pageButton: Row(
                                  //   children: <Widget>[
                                  //     FlatButton(
                                  //       child: const Text('VIEW'),
                                  //       onPressed: () {
                                  //         if (isLargeScreen) {
                                  //           selectedValue = index;
                                  //           setState(() {});
                                  //         } else {
                                  //           Navigator.push(context,
                                  //               CupertinoPageRoute(
                                  //             builder: (context) {
                                  //               return ActivityDetailPage(item);
                                  //             },
                                  //           ));
                                  //         }
                                  //       },
                                  //     ),
                                  //   ],
                                  // ),
                                ),
                              ),
                            );
                          },
                          physics: BouncingScrollPhysics(),
                        ),
                        // old Grid View for Activities
                        // GridView.builder(
                        //   gridDelegate:
                        //       SliverGridDelegateWithFixedCrossAxisCount(
                        //     crossAxisCount: numCards,
                        //     crossAxisSpacing: 3.0,
                        //     mainAxisSpacing: 3.0,
                        //   ),
                        //   // Let the ListView know how many items it needs to build.
                        //   itemCount: listActivity.length,
                        //   // Provide a builder function. This is where the magic happens.
                        //   // Convert each item into a widget based on the type of item it is.
                        //   itemBuilder: (context, index) {
                        //     final item = listActivity[index];
                        //     return Center(
                        //       child: ActivityCard(
                        //           title: item.title,
                        //           desc: (item.profiles.length > 0)
                        //               ? item.profiles[0].name
                        //               : "",
                        //           image: item.imgUrl,
                        //           pageButton: Row(
                        //             children: <Widget>[
                        //               FlatButton(
                        //                 child: const Text('VIEW'),
                        //                 onPressed: () {
                        //                   if (isLargeScreen) {
                        //                     selectedValue = index;
                        //                     setState(() {});
                        //                   } else {
                        //                     Navigator.push(context,
                        //                         CupertinoPageRoute(
                        //                       builder: (context) {
                        //                         return ActivityDetailPage(item);
                        //                       },
                        //                     ));
                        //                   }
                        //                 },
                        //               ),
                        //             ],
                        //           )),
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  )),
                ]),
              )),
          // If large screen, render activity detail page
          (isLargeScreen && listActivity.length != 0)
              ? Expanded(
                  child: ActivityDetailWidget(listActivity[selectedValue]))
              : Container(),
        ]);
      }),
    );
  }
}
