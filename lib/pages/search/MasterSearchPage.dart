import 'package:artsideout_app/components/common/NoResultBanner.dart';
import 'package:artsideout_app/components/layout/MasterPageLayout.dart';

import 'package:artsideout_app/components/search/FetchQueries.dart';
import 'package:artsideout_app/components/search/FetchResultCard.dart';
import 'package:artsideout_app/components/search/SearchBarFilter.dart';
import 'package:artsideout_app/constants/DisplayConstants.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/DisplayService.dart';
import 'package:artsideout_app/services/GraphQLConfiguration.dart';
import 'package:artsideout_app/services/NavigationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MasterSearchPage extends StatefulWidget {
  @override
  _MasterSearchPageState createState() => _MasterSearchPageState();
}

class _MasterSearchPageState extends State<MasterSearchPage> {
  Widget selectedItem;
  int columnCount = 2;

  GraphQLConfiguration graphQLConfiguration =
      serviceLocator<GraphQLConfiguration>();
  List<dynamic> listResults = List<dynamic>();
  FetchResults fetchResults = new FetchResults();
  FetchResultCard fetchResultCard = new FetchResultCard();

  bool isLoading = false;
  bool noResults = false;
  String queryResult = "";
  Map<String, bool> optionsMap = {
    "Music": true,
    "Spoken Word": true,
    "Theatre": true,
    "Sculpture": true,
    "DigitalMedia": true,
    "MixMedia": true,
    "DrawingsAndPaintings": true,
    "Artist": true,
    "Organizer": true,
    "Sponsor": true,
    "Workshops": true,
    "ASO": true,
    "Partner": true,
    "Other": true,
  };

  void handleTextChange(String text) async {
    if (text != ' ' && text != '') {
      setState(() {
        selectedItem = null;
        queryResult = text;
      });

      listResults = await fetchResults.getResults(text, optionsMap);
      setState(() {
        noResults = listResults.isEmpty;
      });
    }
  }

  void handleFilterChange(String value) {
    setState(() {
      optionsMap[value] = !optionsMap[value];
    });
  }

  @override
  Widget build(BuildContext context) {
    DisplaySize _displaySize = serviceLocator<DisplayService>().displaySize;
    NavigationService _navigationService = serviceLocator<NavigationService>();

    if (_displaySize == DisplaySize.MEDIUM || _displaySize == DisplaySize.SMALL)
      setState(() {
        columnCount = 2;
      });
    else
      setState(() {
        columnCount = 4;
      });

    Widget mainPageWidget = Stack(children: [
      Positioned(
        top: 80,
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
                    handleFilterChange: handleFilterChange,
                    optionsMap: optionsMap),
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
              child: Center(
                child: StaggeredGridView.countBuilder(
                    padding: EdgeInsets.only(top: 20),
                    crossAxisCount: columnCount,
                    itemCount: listResults.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = listResults[index];
                      var type = item.runtimeType.toString();
                      var card = fetchResultCard.getCard(type, item);
                      var detailWidget =
                          fetchResultCard.getDetailWidget(type, item);
                      var routeConst = fetchResultCard.getRouteConstant(type);
                      return GestureDetector(
                        child: card,
                        onTap: () {
                          if (_displaySize == DisplaySize.LARGE ||
                              _displaySize == DisplaySize.MEDIUM) {
                            setState(() {
                              selectedItem = detailWidget;
                            });
                          } else {
                            _navigationService.navigateToWithId(
                                routeConst, item.id);
                          }
                        },
                      );
                    },
                    staggeredTileBuilder: (int index) {
                      String type = listResults[index].runtimeType.toString();
                      return StaggeredTile.count(
                        type == "Activity" ? 2 : 1,
                        type == "Activity" ? 0.8 : 1,
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
      NoResultBanner(queryResult, noResults),
    ]);
    Widget secondPageWidget =
        (listResults.length != 0) ? selectedItem : Container();

    return MasterPageLayout(
      pageName: "Search",
      pageDesc: "The all seeing eye",
      mainPageWidget: mainPageWidget,
      secondPageWidget: secondPageWidget,
    );
  }

  String getThumbnail(String videoURL) {
    return YoutubePlayerController.getThumbnail(
        videoId: YoutubePlayerController.convertUrlToId(videoURL));
  }
}
