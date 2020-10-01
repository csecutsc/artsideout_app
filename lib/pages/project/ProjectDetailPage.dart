import 'package:artsideout_app/components/common/NoResultBanner.dart';
import 'package:artsideout_app/components/layout/MasterPageLayout.dart';
import 'package:artsideout_app/components/search/FetchQueries.dart';
import 'package:artsideout_app/components/search/FetchResultCard.dart';
import 'package:artsideout_app/components/search/SearchBarFilter.dart';
import 'package:artsideout_app/constants/ASORouteConstants.dart';
import 'package:artsideout_app/constants/DisplayConstants.dart';
import 'package:artsideout_app/graphql/ProjectQueries.dart';
import 'package:artsideout_app/helpers/GraphQlFactory.dart';
import 'package:artsideout_app/models/ASOCardInfo.dart';
import 'package:artsideout_app/models/Installation.dart';
import 'package:artsideout_app/models/Profile.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/DisplayService.dart';
import 'package:artsideout_app/services/GraphQLConfiguration.dart';
import 'package:artsideout_app/services/NavigationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
// GraphQL
import 'package:graphql_flutter/graphql_flutter.dart';
// Art
import 'package:artsideout_app/components/art/ArtDetailWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class ProjectDetailPage extends StatefulWidget {
  final String projectPageId;
  ProjectDetailPage(this.projectPageId);
  @override
  _ProjectDetailPageState createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  ScrollController _scrollController;
  int selectedValue = 0;
  int currentScrollPos = 0;
  bool loading = true;

  List<Installation> listInstallation = List<Installation>();
  Map<String, String> mapPageDetails = Map<String, String>();
  List<Profile> profileDetails = List<Profile>();
  GraphQLClient _client =
      serviceLocator<GraphQLConfiguration>().clientToQuery();

  FetchResults fetchResults = new FetchResults();
  bool isLoading = false;
  bool noResults = false;
  String queryResult = "";

  Future<Map<String, String>> getProjectDetails(String term) async {
    ProjectQueries queryProject = ProjectQueries();
    QueryResult result = await _client.query(
      QueryOptions(
        documentNode: gql(queryProject.getOneStudioById(term)),
      ),
    );
    if (!result.hasException) {
      setState(() {
        for (var i = 0; i < result.data["project"]["profiles"].length; i++) {
          profileDetails.add(GraphQlFactory.buildProfile(
              result.data["project"]["profiles"][i]));
        }
      });
      return {
        "title": result.data["project"]["title"],
        "desc": result.data["project"]["desc"]
      };
    }
    return {};
  }

  Future<List<Installation>> getProjectInstallations(String term) async {
    var listInstallation = List<Installation>();
    ProjectQueries queryProject = ProjectQueries();
    QueryResult result = await _client.query(
      QueryOptions(
        documentNode: gql(queryProject.getOneStudioById(term)),
      ),
    );
    if (!result.hasException) {
      for (var i = 0; i < result.data["project"]["elements"].length; i++) {
        listInstallation.add(GraphQlFactory.buildInstallation(
            result.data["project"]["elements"][i]));
      }
    }
    return listInstallation;
  }

  Future<void> setList() async {
    mapPageDetails = await getProjectDetails(widget.projectPageId);
    listInstallation = await getProjectInstallations(widget.projectPageId)
        .whenComplete(() => loading = false);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setList();
  }

  final List<ASOCardInfo> listActions = [
    ASOCardInfo("Featured", Color(0xFF62BAA6),
        "assets/icons/aboutConnections.svg", 300, ASORoutes.ACTIVITIES),
    ASOCardInfo("Activities", Color(0xFFC155A5), "assets/icons/activities.svg",
        300, ASORoutes.ACTIVITIES),
    ASOCardInfo("Saved", Color(0xFF9CC9F5), "assets/icons/saved.svg", 300,
        ASORoutes.ACTIVITIES)
  ];

  void initScrollController() {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.hasClients)
          setState(() {
            for (int i = 0; i < 2; i++) {
              if (_scrollController.position.pixels < 270 * (i + 1) &&
                  _scrollController.position.pixels > 270 * i) {
                currentScrollPos = i;
              }
            }
          });
      });
  }

  @override
  Widget build(BuildContext context) {
    int numCards = 2;
    double topPadding = MediaQuery.of(context).size.height / 8;
    double topPaddingVeryLarge = MediaQuery.of(context).size.height / 25;
    DisplaySize _displaySize = serviceLocator<DisplayService>().displaySize;
    NavigationService _navigationService = serviceLocator<NavigationService>();
    FetchResultCard fetchResultCard = FetchResultCard();
    if (_displaySize == DisplaySize.LARGE) {
      numCards = 3;
    } else {
      numCards = 2;
    }
    Widget mainPageWidget = Stack(children: [
      Positioned(
        top: (topPadding > 120) ? topPaddingVeryLarge : topPadding,
        left: 0,
        right: 0,
        bottom: 0,
        child: ListView(
          shrinkWrap: true,
          children: [
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
                          data: (mapPageDetails["desc"] != null)
                              ? mapPageDetails["desc"]
                              : "",
                          onTapLink: (url) async {
                            if (!url.startsWith("http")) {
                              url = "http://" + url;
                            }
                            if (await canLaunch(url)) {
                            await launch(url);
                            } else {
                            throw 'Could not launch';
                            }
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
                controller: _scrollController,
                padding: EdgeInsets.zero,
                cacheExtent: 200,
                addAutomaticKeepAlives: true,
                physics: new NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                  return GestureDetector(
                    child: fetchResultCard.getCard("Installation", item),
                    onTap: () {
                      if (_displaySize == DisplaySize.LARGE) {
                        selectedValue = index;
                        setState(() {});
                      } else {
                        _navigationService.navigateToWithId(
                            ASORoutes.INSTALLATIONS, item.id);
                      }
                    },
                  );
                },
              ),
          ],
        ),
      ),
      NoResultBanner(queryResult, noResults),
    ]);

    Widget secondPageWidget = ((listInstallation.length != 0)
        ? ArtDetailWidget(data: listInstallation[selectedValue])
        : Container());
    if (mapPageDetails.isNotEmpty) {
      return MasterPageLayout(
        pageName: mapPageDetails["title"],
        pageDesc: profileDetails
            .map((profile) => profile.name ?? "")
            .toList()
            .join(", "),
        mainPageWidget: mainPageWidget,
        secondPageWidget: secondPageWidget,
        loading: loading,
      );
    } else {
      return Container();
    }
  }

  String getThumbnail(String videoURL) {
    return YoutubePlayerController.getThumbnail(
        videoId: YoutubePlayerController.convertUrlToId(videoURL));
  }
}
