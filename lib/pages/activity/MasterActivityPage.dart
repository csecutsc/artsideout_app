import 'package:artsideout_app/graphql/Profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// GraphQL
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:artsideout_app/graphql/config.dart';
import 'package:artsideout_app/graphql/Installation.dart';
// Common
import 'package:artsideout_app/components/PageHeader.dart';
import 'package:artsideout_app/components/card.dart';
import 'package:artsideout_app/components/navigation.dart';
// Art
import 'package:artsideout_app/components/art/ArtDetailWidget.dart';
import 'package:artsideout_app/pages/art/ArtDetailPage.dart';

class MasterActivityPage extends StatefulWidget {
  @override
  _MasterActivityPageState createState() => _MasterActivityPageState();
}

class _MasterActivityPageState extends State<MasterActivityPage> {
  int selectedValue = 0;
  int secondFlexSize = 1;
  int numCards = 2;
  var isLargeScreen = false;

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
          // Profile profile = Profile(
          //   result.data["installations"][i]["profile"]["name"],
          //   result.data["installations"][i]["profile"]["desc"],
          //   result.data["installations"][i]["profile"]["social"],
          //   result.data["installations"][i]["profile"]["type"],
          //   [],
          //   []
          // );
          listInstallation.add(
            Installation(
                result.data["installations"][i]["title"],
                result.data["installations"][i]["desc"],
                zone: result.data["installations"][i]["zone"],
                imgUrl: result.data["installations"][i]["image"]["url"],
                location: {'latitude': result.data["installations"][i]["location"]["latitude"],
                'longitude': result.data["installations"][i]["location"]["longitude"],
                },
                locationRoom: result.data["installations"][i]["locationroom"],
                profiles: []
            ),
          );
        });
      }
    }
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
          numCards = 5;
          // Tablet Size
        } else if (MediaQuery.of(context).size.width > 600) {
          secondFlexSize = 1;
          isLargeScreen = true;
          numCards = MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3;
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
                  Header( // title header
                    image: "assets/icons/activities.svg",
                    textTop: "ACTIVITIES",
                    textBottom: "",
                    subtitle: "",
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration( // calendar box design
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
                        Padding( 
                          padding: const EdgeInsets.only(left: 30.0, top: 15.0, bottom: 15.0),
                          child: Text( // calendar title
                              'Calendar',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                        ),
                        SizedBox(height:50),
                        GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: numCards,
                            crossAxisSpacing: 3.0,
                            mainAxisSpacing: 3.0,
                          ),
                          // Let the ListView know how many items it needs to build.
                          itemCount: listInstallation.length,
                          // Provide a builder function. This is where the magic happens.
                          // Convert each item into a widget based on the type of item it is.
                          itemBuilder: (context, index) {
                            final item = listInstallation[index];
                            return Center(
                              child: ArtListCard(
                                  title: item.title,
                                  artist: (item.profiles.length > 0) ? item.profiles[0].name : "",
                                  image: item.imgUrl,
                                  pageButton: Row(
                                    children: <Widget>[
                                      FlatButton(
                                        child: const Text('VIEW'),
                                        onPressed: () {
                                          if (isLargeScreen) {
                                            selectedValue = index;
                                            setState(() {});
                                          } else {
                                            Navigator.push(context,
                                                CupertinoPageRoute(
                                              builder: (context) {
                                                return ArtDetailPage(item);
                                              },
                                            ));
                                          }
                                        },
                                      ),
                                    ],
                                  )),
                            );
                          },
                        ),
                      ],
                    ),
                  )),
                ]),
              )),
          // If large screen, render installation detail page
          (isLargeScreen && listInstallation.length != 0)
              ? Expanded(
                  child: ArtDetailWidget(listInstallation[selectedValue]))
              : Container(),
        ]);
      }),
    );
  }
}
