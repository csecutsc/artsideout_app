import 'package:artsideout_app/components/common/NoResultBanner.dart';
import 'package:artsideout_app/components/layout/MasterPageLayout.dart';
import 'package:artsideout_app/components/profile/ProfileDetailWidget.dart';
import 'package:artsideout_app/components/search/FetchQueries.dart';
import 'package:artsideout_app/components/search/FetchResultCard.dart';
import 'package:artsideout_app/components/search/SearchBarFilter.dart';
import 'package:artsideout_app/constants/ASORouteConstants.dart';
import 'package:artsideout_app/constants/DisplayConstants.dart';
import 'package:artsideout_app/helpers/ProfileFillList.dart';
import 'package:artsideout_app/models/Profile.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/DisplayService.dart';
import 'package:artsideout_app/services/GraphQLConfiguration.dart';
import 'package:artsideout_app/services/NavigationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MainProfilePage extends StatefulWidget {
  @override
  _MainProfilePageState createState() => _MainProfilePageState();
}

class _MainProfilePageState extends State<MainProfilePage> {
  ScrollController _scrollController;
  int selectedValue = 0;
  int currentScrollPos = 0;
  bool loading = true;

  List<Profile> listProfiles = List<Profile>();
  GraphQLConfiguration graphQLConfiguration =
      serviceLocator<GraphQLConfiguration>();

  FetchResults fetchResults = new FetchResults();
  bool isLoading = false;
  bool noResults = false;
  String queryResult = "";
  Map<String, bool> optionsMap = {
    "Artist": true,
    "Organizer": true,
    "Partner": true,
    "ASO": true,
    "Other": true,
  };

  Future<void> setList() async {
    listProfiles = await fillProfileList().whenComplete(() => loading = false);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setList();
  }

  void handleTextChange(String text) async {
    if (text != ' ' && text != '') {
      listProfiles = await fetchResults.getProfilesByTypes(text, optionsMap);

      setState(() {
        queryResult = text;
        noResults = listProfiles.isEmpty ? true : false;
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
    listProfiles = await fetchResults
        .getProfilesByTypes("", optionsMap)
        .whenComplete(() => loading = false);
    setState(() {
      noResults = false;
    });
  }

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
      numCards = 4;
    } else if (_displaySize == DisplaySize.MEDIUM) {
      numCards = 3;
    } else if (_displaySize == DisplaySize.SMALL) {
      numCards = 2;
    }
    Widget mainPageWidget = Stack(children: [
      Positioned(
        top: (_displaySize == DisplaySize.SMALL) ? 60 : 40,
        left: 0,
        right: 0,
        bottom: 0,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
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
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                // Let the ListView know how many items it needs to build.
                itemCount: listProfiles.length,
                // Provide a builder function. This is where the magic happens.
                // Convert each item into a widget based on the type of item it is.
                itemBuilder: (context, index) {
                  final item = listProfiles[index];

                  return GestureDetector(
                    child: fetchResultCard.getCard("Profile", item),
                    onTap: () {
                      if (_displaySize == DisplaySize.LARGE) {
                        selectedValue = index;
                        setState(() {});
                      } else {
                        _navigationService.navigateToWithId(
                            ASORoutes.PROFILES, item.id);
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

    Widget secondPageWidget = ((listProfiles.length != 0)
        ? ProfileDetailWidget(listProfiles[selectedValue])
        : Container());
    return MasterPageLayout(
      pageName: "Profiles",
      pageDesc: "All the people and organizations who contributed to ARTSIDEOUT 2020",
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
