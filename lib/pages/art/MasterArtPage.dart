import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// GraphQL
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:artsideout_app/graphql/config.dart';
import 'package:artsideout_app/graphql/Installation.dart';
// Common
import 'package:artsideout_app/components/PageHeader.dart';
import 'package:artsideout_app/components/card.dart';
import 'package:artsideout_app/components/common.dart';
// Art
import 'package:artsideout_app/components/art/ArtDetailWidget.dart';
import 'package:artsideout_app/pages/art/ArtDetailPage.dart';
import 'package:artsideout_app/pages/activity/MasterActivityPage.dart';

class MasterArtPage extends StatefulWidget {
  @override
  _MasterArtPageState createState() => _MasterArtPageState();
}

class _MasterArtPageState extends State<MasterArtPage> {
  int selectedValue = 0;
  int secondFlexSize = 1;
  int numCards = 2;
  var isLargeScreen = false;
  var isMediumScreen = false;

  List<Installation> listInstallation = List<Installation>();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

  @override
  void initState() {
    super.initState();
    _fillList();
  }

  // Installation GraphQL Query
  void _fillList() async {
    InstallationQueries queryInstallation = InstallationQueries();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.query(
      QueryOptions(
        documentNode: gql(queryInstallation.getAll),
      ),
    );
    if (!result.hasException) {
      for (var i = 0; i < result.data["installations"].length; i++) {
        setState(() {
          listInstallation.add(
            Installation(
              result.data["installations"][i]["title"],
              result.data["installations"][i]["desc"],
              zone: result.data["installations"][i]["zone"],
              imgUrl: result.data["installations"][i]["image"] == null
                  ? 'https://via.placeholder.com/350'
                  : result.data["installations"][i]["image"]["url"],
              location: {
                'latitude': result.data["installations"][i]["location"] == null
                    ? 0.0
                    : result.data["installations"][i]["location"]["latitude"],
                'longitude': result.data["installations"][i]["location"] == null
                    ? 0.0
                    : result.data["installations"][i]["location"]["longitude"],
              },
              locationRoom: result.data["installations"][i]["locationroom"],
              profiles: [],
            ),
          );
        });
      }
    }
  }

  final List<ListActions> listActions = [
    ListActions("Featured", Color(0xFF62BAA6),
        "assets/icons/aboutConnections.svg", 300, MasterArtPage()),
    ListActions("Activities", Color(0xFFC155A5), "assets/icons/activities.svg",
        300, MasterActivityPage()),
    ListActions("Saved", Color(0xFF9CC9F5), "assets/icons/saved.svg", 300,
        MasterArtPage())
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        // Desktop Size
        if (MediaQuery.of(context).size.width > 1200) {
          secondFlexSize = 6;
          isLargeScreen = true;
          numCards = 3;
          // Tablet Size
        } else if (MediaQuery.of(context).size.width > 600) {
          secondFlexSize = 5;
          isLargeScreen = false;
          isMediumScreen = true;
          numCards = MediaQuery.of(context).orientation == Orientation.portrait
              ? 2
              : 3;
          // Phone Size
        } else {
          isLargeScreen = false;
          isMediumScreen = false;
          numCards = 2;
        }
        return Row(
          children: <Widget>[
            Expanded(
              flex: secondFlexSize,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Column(children: <Widget>[
                  Container(
                    color: Color(0xFFF9EBEB),
                    padding: EdgeInsets.only(left: 12.0),
                    child: Header(
                      image: "assets/icons/lightPinkBg.svg",
                      textTop: "INSTALLATIONS",
                      subtitle: "Connections",
                    ),
                  ),
                  Expanded(
                      child: Container(
                    child: Stack(children: [
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: Header(
                          image: "assets/icons/lightPinkBg.svg",
                          textTop: "",
                          subtitle: "",
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        color: Colors.transparent,
                        child: PlatformSvg.asset(
                          "assets/icons/roadBg.svg",
                          width: 300,
                          height: double.infinity,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          (isLargeScreen)
                              ? Expanded(
                                  flex: 4,
                                  child: Container(
                                    width: 325,
                                    color: Colors.transparent,
                                    child: Container(
                                      child: StaggeredGridView.countBuilder(
                                        padding: EdgeInsets.zero,
                                        crossAxisCount: 1,
                                        itemCount: listActions.length,
                                        itemBuilder: (BuildContext context,
                                                int index) =>
                                            Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 10, 0),
                                                child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
//                                                        Navigator.push(context,
//                                                            CupertinoPageRoute(
//                                                          builder: (context) {
//                                                            return listActions[
//                                                                    index]
//                                                                .page;
//                                                          },
//                                                        ));
//                                                        onTabTapped(index);
                                                      });
                                                    },
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                        child: Container(
                                                          color:
                                                              listActions[index]
                                                                  .color,
                                                          child: Stack(
                                                            children: <Widget>[
                                                              Positioned(
                                                                top: -20,
                                                                left: 10,
                                                                child:
                                                                    PlatformSvg
                                                                        .asset(
                                                                  listActions[
                                                                          index]
                                                                      .imgUrl,
                                                                  width: listActions[
                                                                          index]
                                                                      .imgWidth,
                                                                  fit: BoxFit
                                                                      .fitWidth,
                                                                  alignment:
                                                                      Alignment
                                                                          .topCenter,
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment:
                                                                    Alignment(
                                                                        -0.8,
                                                                        0.8),
                                                                child: Text(
                                                                    listActions[
                                                                            index]
                                                                        .title,
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .headline5
                                                                        .copyWith(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.white)),
                                                              ),
                                                            ],
                                                          ),
                                                        )))),
                                        staggeredTileBuilder: (int index) =>
                                            new StaggeredTile.count(
                                          1,
                                          0.57,
                                        ),
                                        mainAxisSpacing: 15.0,
                                        crossAxisSpacing: 5.0,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            flex: 7,
                            child: Container(
                              width: 500,
                              color: Colors.transparent,
                              child: GridView.builder(
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: numCards,
                                  crossAxisSpacing: 5.0,
                                  mainAxisSpacing: 5.0,
                                ),
                                // Let the ListView know how many items it needs to build.
                                itemCount: listInstallation.length,
                                // Provide a builder function. This is where the magic happens.
                                // Convert each item into a widget based on the type of item it is.
                                itemBuilder: (context, index) {
                                  final item = listInstallation[index];
                                  return Center(
                                    child: GestureDetector(
                                      child: ArtListCard(
                                        title: item.title,
                                        artist: item.zone,
                                        image: item.imgUrl,
                                      ),
                                      onTap: () {
                                        if (isLargeScreen) {
                                          setState(() {
                                            selectedValue = index;
                                          });
                                        } else {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) {
                                                return ArtDetailPage(item);
                                              },
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ]),
                  )),
                ]),
              ),
            ),

            // If large screen, render installation detail page
            ((isLargeScreen || isMediumScreen) && listInstallation.length != 0)
                ? Expanded(
                    flex: 3,
                    child: ArtDetailWidget(listInstallation[selectedValue]))
                : Container(),
          ],
        );
      }),
    );
  }
}

class ListActions {
  String title;
  Color color;
  String imgUrl;
  double imgWidth;
  Widget page;

  ListActions(this.title, this.color, this.imgUrl, this.imgWidth, this.page);
}
