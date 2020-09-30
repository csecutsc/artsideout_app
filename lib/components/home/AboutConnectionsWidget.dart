import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/graphql/ProfileQueries.dart';
import 'package:artsideout_app/helpers/GraphQlFactory.dart';
import 'package:artsideout_app/models/Profile.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/GraphQLConfiguration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// TODO Fix Styling
class AboutConnectionsWidget extends StatefulWidget {
  @override
  _AboutConnectionsWidgetState createState() => _AboutConnectionsWidgetState();
}

class _AboutConnectionsWidgetState extends State<AboutConnectionsWidget> {
  List<Profile> sponsors = List<Profile>();
  List<Profile> partners = List<Profile>();
  void _getSponsors() async {
    GraphQLConfiguration graphQLConfiguration =
        serviceLocator<GraphQLConfiguration>();
    ProfileQueries profileQueries = ProfileQueries();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.query(
      QueryOptions(
        documentNode: gql(profileQueries.getAllSponsors),
      ),
    );
    if (!result.hasException) {
      for (var i = 0; i < result.data["profiles"].length; i++) {
        setState(() {
          sponsors.add(GraphQlFactory.buildProfile(result.data["profiles"][i]));
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
                crossAxisCount: 3,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              // Let the ListView know how many items it needs to build.
              itemCount: sponsors.length,
              // Provide a builder function. This is where the magic happens.
              // Convert each item into a widget based on the type of item it is.
              itemBuilder: (context, index) {
                final item = sponsors[index];
                print(item.social["website"]);
                return GestureDetector(
                    child: Image.network(item.profilePic),
                    onTap: () async {
                      if (item.social.isNotEmpty) {
                        var url = item.social.values.toList()[0].toLowerCase();
                        if (!url.startsWith("http")) {
                          url = "http://" + url;
                        }
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch';
                        }
                      }
                    });
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
                crossAxisCount: 3,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
              ),
              // Let the ListView know how many items it needs to build.
              itemCount: partners.length,
              // Provide a builder function. This is where the magic happens.
              // Convert each item into a widget based on the type of item it is.
              itemBuilder: (context, index) {
                final item = partners[index];
                print(item.social["website"]);
                return GestureDetector(
                    child: Image.network(item.profilePic),
                    onTap: () async {
                      if (item.social.isNotEmpty) {
                        var url = item.social.values.toList()[0].toLowerCase();
                        if (!url.startsWith("http")) {
                          url = "http://" + url;
                        }
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch';
                        }
                      }
                    });
              },
            ),
            ListTile(
              leading: SelectableText('Special Thanks',
                  style: Theme.of(context).textTheme.headline5),
            ),
          ]),
        ])));
    // ])
  }
}
