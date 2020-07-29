import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// GraphQL
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:artsideout_app/graphql/config.dart';
import 'package:artsideout_app/graphql/Installation.dart';
// Common
import 'package:artsideout_app/components/PageHeader.dart';
import 'package:artsideout_app/components/card.dart';
// Art
import 'package:artsideout_app/components/art/ArtDetailWidget.dart';
import 'package:artsideout_app/pages/art/ArtDetailPage.dart';

class MasterArtPage extends StatefulWidget {
  @override
  _MasterArtPageState createState() => _MasterArtPageState();
}

class _MasterArtPageState extends State<MasterArtPage> {
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
          secondFlexSize = 3;
          isLargeScreen = true;
          numCards = 5;
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
        return Row(
          children: <Widget>[
            Expanded(
              flex: secondFlexSize,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFFCEAEB),
                ),
                child: Column(children: <Widget>[
                  Header(
                    image: "assets/icons/installation.svg",
                    textTop: "INSTALLATIONS",
                    subtitle: "Cool Beans",
                  ),
                  Expanded(
                      child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: Stack(
                        children: <Widget>[
                          SizedBox(height: 50),
                          GridView.builder(
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
                                      selectedValue = index;
                                      setState(() {});
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
                        ],
                      ),
                    ),
                  )),
                ]),
              ),
            ),
            // If large screen, render installation detail page
            (isLargeScreen && listInstallation.length != 0)
                ? Expanded(
                    child: ArtDetailWidget(listInstallation[selectedValue]))
                : Container(),
          ],
        );
      }),
    );
  }
}
