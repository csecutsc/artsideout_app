import 'package:artsideout_app/components/search/FetchResultCard.dart';
import 'package:artsideout_app/constants/ASORouteConstants.dart';
import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/constants/DisplayConstants.dart';
import 'package:artsideout_app/graphql/ProfileQueries.dart';
import 'package:artsideout_app/helpers/GraphQlFactory.dart';
import 'package:artsideout_app/models/Profile.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/DisplayService.dart';
import 'package:artsideout_app/services/GraphQLConfiguration.dart';
import 'package:artsideout_app/services/NavigationService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// TODO Fix Styling
class AboutConnectionsWidget extends StatefulWidget {
  final bool expandedScreen;
  AboutConnectionsWidget({Key key, this.expandedScreen = false})
      : super(key: key);
  @override
  _AboutConnectionsWidgetState createState() => _AboutConnectionsWidgetState();
}

class _AboutConnectionsWidgetState extends State<AboutConnectionsWidget> {
  List<Profile> sponsors = List<Profile>();
  List<Profile> partners = List<Profile>();
  List<Profile> developers = List<Profile>();
  void _getSponsors() async {
    GraphQLConfiguration graphQLConfiguration =
        serviceLocator<GraphQLConfiguration>();
    ProfileQueries profileQueries = ProfileQueries();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.query(
      QueryOptions(
        documentNode: gql(profileQueries.getSponsorsAndDevelopers),
      ),
    );
    if (!result.hasException) {
      for (var i = 0; i < result.data["UTSC"].length; i++) {
        setState(() {
          sponsors.add(GraphQlFactory.buildProfile(result.data["UTSC"][i]));
        });
      }
      for (var i = 0; i < result.data["regular"].length; i++) {
        setState(() {
          sponsors.add(GraphQlFactory.buildProfile(result.data["regular"][i]));
        });
      }
      for (var i = 0; i < result.data["developer"].length; i++) {
        setState(() {
          developers.add(GraphQlFactory.buildProfile(result.data["developer"][i]));
        });
      }
    } else {
      print("CANNOT GET ART DETAILS");
    }
  }

  void _getPartners() async {
    GraphQLConfiguration graphQLConfiguration =
        serviceLocator<GraphQLConfiguration>();
    ProfileQueries profileQueries = ProfileQueries();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.query(
      QueryOptions(
        documentNode: gql(profileQueries.getAllPartners),
      ),
    );
    if (!result.hasException) {
      for (var i = 0; i < result.data["profiles"].length; i++) {
        setState(() {
          partners.add(GraphQlFactory.buildProfile(result.data["profiles"][i]));
        });
      }
    } else {
      print("CANNOT GET ART DETAILS");
    }
  }

  @override
  void initState() {
    super.initState();
    _getSponsors();
    _getPartners();
  }

  List<String> socials = List<String>();
//move title to widget
  @override
  Widget build(BuildContext context) {
    FetchResultCard fetchResultCard = new FetchResultCard();
    NavigationService _navigationService = serviceLocator<NavigationService>();
    DisplaySize _displaySize = serviceLocator<DisplayService>().displaySize;
    String desc = "2020 is the start of a new decade.";
    String desc2 =
        "With the changes that are happening around the world, our lives have shifted in a multitude of ways, from environmental, to economic, and existential changes. It brings about our awareness and appreciation of the connections we have as human beings. As we are “physically distanced,” we have in many ways come closer together through creative and technological means.";
    String desc3 =
        "In thinking about Connections, we invite artists to challenge their adaptability, resiliency, and creativity, to think outside their boundaries in producing multidisciplinary artworks, and to explore what Connections mean in this extraordinary time.";
    return Scaffold(
        backgroundColor: ColorConstants.PREVIEW_SCREEN,
        body: Center(
            child: ListView(shrinkWrap: true, children: <Widget>[
          Column(children: <Widget>[
            SizedBox(
              height: 15.0,
            ),
            ListTile(
              leading: SelectableText('Connections',
                  style: Theme.of(context).textTheme.headline5),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 16.0,
                  ),
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.only(bottom: 14.0),
                    child: MarkdownBody(
                      selectable: true,
                      data: desc,
                      onTapLink: (url) {
                        launch(url);
                      },
                      styleSheet:
                          MarkdownStyleSheet.fromTheme(Theme.of(context))
                              .copyWith(
                                  p: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(fontSize: 16.0)),
                    ),
                  )),
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 16.0,
                  ),
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.only(bottom: 14.0),
                    child: MarkdownBody(
                      selectable: true,
                      data: desc2,
                      onTapLink: (url) {
                        launch(url);
                      },
                      styleSheet:
                          MarkdownStyleSheet.fromTheme(Theme.of(context))
                              .copyWith(
                                  p: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(fontSize: 16.0)),
                    ),
                  )),
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 16.0,
                  ),
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.only(bottom: 14.0),
                    child: MarkdownBody(
                      selectable: true,
                      data: desc3,
                      onTapLink: (url) {
                        launch(url);
                      },
                      styleSheet:
                          MarkdownStyleSheet.fromTheme(Theme.of(context))
                              .copyWith(
                                  p: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(fontSize: 16.0)),
                    ),
                  )),
                ],
              ),
            ),
            ListTile(
              leading: SelectableText('Sponsors',
                  style: Theme.of(context).textTheme.headline5),
            ),
            GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              addAutomaticKeepAlives: true,
              physics: new NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (widget.expandedScreen &&
                    (_displaySize == DisplaySize.LARGE ||
                        _displaySize == DisplaySize.MEDIUM))
                    ? MediaQuery.of(context).size.width.toInt() ~/ 200
                    : 2,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
                childAspectRatio: 2,
              ),
              // Let the ListView know how many items it needs to build.
              itemCount: sponsors.length,
              // Provide a builder function. This is where the magic happens.
              // Convert each item into a widget based on the type of item it is.
              itemBuilder: (context, index) {
                final item = sponsors[index];
                return Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: GestureDetector(
                        child: Image.network(item.profilePic),
                        onTap: () async {
                          if (item.social.isNotEmpty) {
                            var url =
                            item.social.values.toList()[0].toLowerCase();
                            if (!url.startsWith("http")) {
                              url = "http://" + url;
                            }
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch';
                            }
                          }
                        }));
              },
            ),
            ListTile(
              leading: SelectableText('Partners',
                  style: Theme.of(context).textTheme.headline5),
            ),
            GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: new NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (widget.expandedScreen &&
                        (_displaySize == DisplaySize.LARGE ||
                            _displaySize == DisplaySize.MEDIUM))
                    ? MediaQuery.of(context).size.width.toInt() ~/ 200
                    : 3,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
                childAspectRatio: 2,
              ),
              // Let the ListView know how many items it needs to build.
              itemCount: partners.length,
              // Provide a builder function. This is where the magic happens.
              // Convert each item into a widget based on the type of item it is.
              itemBuilder: (context, index) {
                final item = partners[index];
                return Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: GestureDetector(
                        child: Image.network(item.profilePic),
                        onTap: () async {
                          if (item.social.isNotEmpty) {
                            var url =
                                item.social.values.toList()[0].toLowerCase();
                            if (!url.startsWith("http")) {
                              url = "http://" + url;
                            }
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch';
                            }
                          }
                        }));
              },
            ),
            ListTile(
              leading: SelectableText('Special Thanks',
                  style: Theme.of(context).textTheme.headline5),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 16.0,
                  ),
                  Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 14.0),
                        child: MarkdownBody(
                          selectable: true,
                          data: "Thank you to the following participating developers of the ASO Project and the [Computer Science Enrichment Club (CSEC)](https://csec.club) team for creating this application in record time."
                              " Despite the transition to an online ARTSIDEOUT, the team had converted the experience to a web application. [Link to the open source code](https://github.com/csecutsc/artsideout_app)",
                          onTapLink: (url) {
                            launch(url);
                          },
                          styleSheet:
                          MarkdownStyleSheet.fromTheme(Theme.of(context))
                              .copyWith(
                              p: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(fontSize: 16.0)),
                        ),
                      )),
                ],
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: new NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (widget.expandedScreen &&
                    (_displaySize == DisplaySize.LARGE ||
                        _displaySize == DisplaySize.MEDIUM))
                    ? MediaQuery.of(context).size.width.toInt() ~/ 200
                    : 2,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
              ),
              // Let the ListView know how many items it needs to build.
              itemCount: developers.length,
              // Provide a builder function. This is where the magic happens.
              // Convert each item into a widget based on the type of item it is.
              itemBuilder: (context, index) {
                final item = developers[index];
                return Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: GestureDetector(
                child: fetchResultCard.getCard("Profile", item),
                onTap: () {
                _navigationService.navigateToWithId(
                ASORoutes.PROFILES, item.id);
                }
                ));
              },
            ),
          ]),
        ])));
    // ])
  }
}
