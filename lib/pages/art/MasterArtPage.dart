import 'package:artsideout_app/components/common/ASOCard.dart';
import 'package:artsideout_app/components/common/NoResultBanner.dart';
import 'package:artsideout_app/components/layout/MasterPageLayout.dart';
import 'package:artsideout_app/components/search/FetchQueries.dart';
import 'package:artsideout_app/components/search/FetchResultCard.dart';
import 'package:artsideout_app/components/search/SearchBarFilter.dart';
import 'package:artsideout_app/constants/ASORouteConstants.dart';
import 'package:artsideout_app/constants/DisplayConstants.dart';
import 'package:artsideout_app/models/ASOCardInfo.dart';
import 'package:artsideout_app/models/Installation.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/DisplayService.dart';
import 'package:artsideout_app/services/GraphQLConfiguration.dart';
import 'package:artsideout_app/services/NavigationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:artsideout_app/components/art/ArtDetailWidget.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:artsideout_app/helpers/ArtFillList.dart';

class MasterArtPage extends StatefulWidget {
  @override
  _MasterArtPageState createState() => _MasterArtPageState();
}

class _MasterArtPageState extends State<MasterArtPage> {
  int selectedValue = 0;
  bool loading = true;

  List<Installation> listInstallation = List<Installation>();
  GraphQLConfiguration graphQLConfiguration =
      serviceLocator<GraphQLConfiguration>();

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

  Future<void> setList() async {
    listInstallation = await fillList().whenComplete(() => loading = false);
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

  @override
  Widget build(BuildContext context) {
    DisplaySize _displaySize = serviceLocator<DisplayService>().displaySize;
    NavigationService _navigationService = serviceLocator<NavigationService>();
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
            (_displaySize == DisplaySize.LARGE)
                ? Container(
                    width: 325,
                    color: Colors.transparent,
                    child: Container(
                      child: StaggeredGridView.countBuilder(
                        padding: EdgeInsets.zero,
                        crossAxisCount: 1,
                        itemCount: listActions.length,
                        itemBuilder: (BuildContext context, int index) =>
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: ASOCard(listActions[index], false)),
                        staggeredTileBuilder: (int index) =>
                            new StaggeredTile.count(
                          1,
                          0.57,
                        ),
                        mainAxisSpacing: 15.0,
                        crossAxisSpacing: 5.0,
                      ),
                    ),
                  )
                : Container(),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                cacheExtent: 200,
                addAutomaticKeepAlives: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                ),
                // Let the ListView know how many items it needs to build.
                itemCount: listInstallation.length,
                // Provide a builder function. This is where the magic happens.
                // Convert each item into a widget based on the type of item it is.
                itemBuilder: (context, index) {
                  final item = listInstallation[index];
                  FetchResultCard fetchResultCard = new FetchResultCard();
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
    return MasterPageLayout(
      pageName: "Studio Installations",
      pageDesc: "Blah Blah Blah",
      mainPageWidget: mainPageWidget,
      secondPageWidget: secondPageWidget,
      loading: loading,
    );
  }

  String getThumbnail(String videoURL) {
    return YoutubePlayerController.getThumbnail(
        videoId: YoutubePlayerController.convertUrlToId(videoURL));
  }
}
