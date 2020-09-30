import 'package:artsideout_app/components/common/NoResultBanner.dart';
import 'package:artsideout_app/components/layout/MasterPageLayout.dart';
import 'package:artsideout_app/components/market/MarketDetailWidget.dart';
import 'package:artsideout_app/components/search/FetchQueries.dart';
import 'package:artsideout_app/constants/ASORouteConstants.dart';
import 'package:artsideout_app/constants/DisplayConstants.dart';
import 'package:artsideout_app/helpers/MarketFillList.dart';
import 'package:artsideout_app/models/Market.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/DisplayService.dart';
import 'package:artsideout_app/services/NavigationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// Common
import 'package:artsideout_app/components/art/ArtListCard.dart';

class MainMarketPage extends StatefulWidget {
  @override
  _MainMarketPageState createState() => _MainMarketPageState();
}

class _MainMarketPageState extends State<MainMarketPage> {
  ScrollController _scrollController;
  int selectedValue = 0;
  int currentScrollPos = 0;
  bool loading = true;

  List<Market> listMarket = List<Market>();
  NavigationService _navigationService = serviceLocator<NavigationService>();
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
    listMarket = await fillListMarket().whenComplete(() => loading = false);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setList();
  }

  // void handleTextChange(String text) async {
  //   if (text != ' ' && text != '') {
  //     listMarket =
  //     await fetchResults.getInstallationsByTypes(text, optionsMap);
  //
  //     setState(() {
  //       queryResult = text;
  //       noResults = listMarket.isEmpty ? true : false;
  //     });
  //   }
  // }

  // void handleFilterChange(String value) {
  //   setState(() {
  //     optionsMap[value] = !optionsMap[value];
  //     _fillList();
  //   });
  // }
  //
  // // Installation GraphQL Query
  // void _fillList() async {
  //   listMarket =
  //   await fetchResults.getInstallationsByTypes("", optionsMap);
  //   setState(() {
  //     noResults = false;
  //   });
  // }

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
    if (_displaySize == DisplaySize.LARGE) {
      numCards = 4;
    } else if (_displaySize == DisplaySize.MEDIUM) {
      numCards = 3;
    } else if (_displaySize == DisplaySize.SMALL) {
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
                // SearchBarFilter(
                //   handleTextChange: handleTextChange,
                //   handleTextClear: _fillList,
                //   handleFilterChange: handleFilterChange,
                //   optionsMap: optionsMap,
                // ),
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
                itemCount: listMarket.length,
                // Provide a builder function. This is where the magic happens.
                // Convert each item into a widget based on the type of item it is.
                itemBuilder: (context, index) {
                  final item = listMarket[index];

                  return GestureDetector(
                    child: ArtListCard(
                        title: item.title,
                        artist: item.profiles
                            .map((profile) => profile.name ?? "")
                            .toList()
                            .join(", "),
                        image: item.images[0]),
                    onTap: () {
                      if (_displaySize == DisplaySize.LARGE) {
                        selectedValue = index;
                        setState(() {});
                      } else {
                        _navigationService.navigateToWithId(
                            ASORoutes.MARKETS, item.id);
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

    Widget secondPageWidget = ((listMarket.length != 0)
        ? MarketDetailWidget(data: listMarket[selectedValue])
        : Container());
    return MasterPageLayout(
      pageName: "Art Market",
      pageDesc: "Blah Blah Blah",
      mainPageWidget: mainPageWidget,
      secondPageWidget: secondPageWidget,
      loading: loading,
    );
  }
}
