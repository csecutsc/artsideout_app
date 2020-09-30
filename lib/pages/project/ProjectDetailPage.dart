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
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/DisplayService.dart';
import 'package:artsideout_app/services/GraphQLConfiguration.dart';
import 'package:artsideout_app/services/NavigationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// GraphQL
import 'package:graphql_flutter/graphql_flutter.dart';
// Art
import 'package:artsideout_app/components/art/ArtDetailWidget.dart';
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
  GraphQLClient _client =
      serviceLocator<GraphQLConfiguration>().clientToQuery();

  FetchResults fetchResults = new FetchResults();
  bool isLoading = false;
  bool noResults = false;
  String queryResult = "";
  Map<String, bool> optionsMap = {
    "Sculpture": true,
    "DigitalMedia": true,
    "MixMedia": true,
    "DrawingsAndPaintings": true,
    "Other": true,
  };

  Future<Map<String, String>> getProjectDetails(String term) async {
    ProjectQueries queryProject = ProjectQueries();
    QueryResult result = await _client.query(
      QueryOptions(
        documentNode: gql(queryProject.getOneStudioById(term)),
      ),
    );
    if (!result.hasException) {
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
        listInstallation.add(
            GraphQlFactory.buildInstallation(
                result.data["project"]["elements"][i])
        );
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

  void handleTextChange(String text) async {
    if (text != ' ' && text != '') {
      listInstallation =
          await fetchResults.getInstallationsByTypes(text, optionsMap);

      setState(() {
        queryResult = text;
        noResults = listInstallation.isEmpty ? true : false;
      });
    }
  }

  void handleFilterChange(String value) {
    setState(() {
      optionsMap[value] = !optionsMap[value];
      _fillList();
    });
  }

  // Installation GraphQL Query
  void _fillList() async {
    listInstallation =
        await fetchResults.getInstallationsByTypes("", optionsMap);
    setState(() {
      noResults = false;
    });
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
        top: 45,
        left: 0,
        right: 0,
        bottom: 0,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Container(
            height: 85,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchBarFilter(
                  handleTextChange: handleTextChange,
                  handleTextClear: _fillList,
                  handleFilterChange: handleFilterChange,
                  optionsMap: optionsMap,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
      Positioned(
        top: 125,
        left: 0,
        right: 0,
        bottom: 0,
        child: Row(
          children: [
            Expanded(
              child: GridView.builder(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                cacheExtent: 200,
                addAutomaticKeepAlives: true,
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
        pageDesc: "Need to place description somewhere",
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
