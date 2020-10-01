import 'package:artsideout_app/components/layout/MasterPageLayout.dart';
import 'package:artsideout_app/components/search/FetchQueries.dart';
import 'package:artsideout_app/components/search/FetchResultCard.dart';
import 'package:artsideout_app/components/search/SearchBarFilter.dart';
import 'package:artsideout_app/constants/ASORouteConstants.dart';
import 'package:artsideout_app/constants/DisplayConstants.dart';
import 'package:artsideout_app/models/Activity.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/DisplayService.dart';
import 'package:artsideout_app/services/NavigationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// Common
import 'package:artsideout_app/helpers/ActivityFillList.dart';
// Art
import 'package:artsideout_app/components/activity/ActivityDetailWidget.dart';

class MasterActivityPage extends StatefulWidget {
  @override
  _MasterActivityPageState createState() => _MasterActivityPageState();
}

class _MasterActivityPageState extends State<MasterActivityPage> {
  int selectedValue = 0;
  double containerHeight = 0.0;
  bool loading = true;
  bool noResults = false;
  String queryResult = "";

  Map<String, bool> optionsMap = {
    "Music": true,
    "SpokenWord": true,
    "Theatre": true,
    "Other": true,
  };

  List<Activity> listActivity = List<Activity>();
  FetchResults fetchResults = new FetchResults();
  Future<void> setList() async {
    listActivity = await fillList().whenComplete(() => loading = false);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setList();
  }

  void handleTextChange(String text) async {
    if (text != ' ' && text != '') {
      listActivity = await fetchResults.getActivitiesByTypes(text, optionsMap);

      setState(() {
        queryResult = text;
        noResults = listActivity.isEmpty ? true : false;
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
    listActivity = await fetchResults.getActivitiesByTypes("", optionsMap);
    setState(() {
      noResults = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).size.height / 8;
    double topPaddingVeryLarge = MediaQuery.of(context).size.height / 25;
    DisplaySize _displaySize = serviceLocator<DisplayService>().displaySize;
    NavigationService _navigationService = serviceLocator<NavigationService>();
    int width = MediaQuery.of(context).size.width.toInt();
    Widget mainPageWidget = Stack(children: [
      Positioned(
        top: (topPadding > 120) ? topPaddingVeryLarge : topPadding,
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
          top: (topPadding > 120) ? MediaQuery.of(context).size.height / 12 : MediaQuery.of(context).size.height / 5,
          left: 0,
          right: 0,
          bottom: 0,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            // Let the ListView know how many items it needs to build.
            itemCount: listActivity.length,
            // Provide a builder function. This is where the magic happens.
            // Convert each item into a widget based on the type of item it is.
            itemBuilder: (context, index) {
              final item = listActivity[index];
              FetchResultCard fetchResultCard = new FetchResultCard();
              return Material(
                color: Colors.transparent,
                child: GestureDetector(
                    child: fetchResultCard.getCard("Activity", item),
                    onTap: () {
                      if (_displaySize == DisplaySize.LARGE ||
                          _displaySize == DisplaySize.MEDIUM) {
                        selectedValue = index;
                        setState(() {});
                      } else {
                        _navigationService.navigateToWithId(
                            ASORoutes.ACTIVITIES, item.id);
                      }
                    }),
              );
            },
          ))
    ]);

    Widget secondPageWidget = (listActivity.length != 0)
        ? ActivityDetailWidget(data: listActivity[selectedValue])
        : Container();
    return MasterPageLayout(
        pageName: "PERFORMANCES",
        pageDesc: "This year, ARTSIDEOUT's performances range from spoken word, theatre, improv, music, and dance.",
        mainPageWidget: mainPageWidget,
        secondPageWidget: secondPageWidget,
        loading: loading);
  }
}
