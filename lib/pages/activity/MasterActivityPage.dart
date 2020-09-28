import 'package:artsideout_app/components/layout/MasterPageLayout.dart';
import 'package:artsideout_app/components/search/FetchResultCard.dart';
import 'package:artsideout_app/constants/DisplayConstants.dart';
import 'package:artsideout_app/constants/PlaceholderConstants.dart';
import 'package:artsideout_app/models/Activity.dart';
import 'package:artsideout_app/models/Profile.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/DisplayService.dart';
import 'package:artsideout_app/services/GraphQLConfiguration.dart';
import 'package:artsideout_app/services/NavigationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// GraphQL
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:artsideout_app/graphql/ActivityQueries.dart';
// Art
import 'package:artsideout_app/components/activity/ActivityDetailWidget.dart';

class MasterActivityPage extends StatefulWidget {
  @override
  _MasterActivityPageState createState() => _MasterActivityPageState();
}

class _MasterActivityPageState extends State<MasterActivityPage> {
  int selectedValue = 0;
  double containerHeight = 0.0;

  List<Activity> listActivity = List<Activity>();
  GraphQLConfiguration graphQLConfiguration =
      serviceLocator<GraphQLConfiguration>();

  @override
  void initState() {
    super.initState();
    _fillList();
  }

  // Activity GraphQL Query
  void _fillList() async {
    ActivityQueries queryActivity = ActivityQueries();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.query(
      QueryOptions(
        documentNode: gql(queryActivity.getAll),
      ),
    );
    if (!result.hasException) {
      for (var i = 0; i < result.data["activities"].length; i++) {
        List<Map<String, String>> images = [];

        if (result.data["activities"][i]["images"] != null) {
          for (int j = 0;
          j < result.data["activities"][i]["images"].length;
          j++) {
            String url = result.data["activities"][i]["images"]
            [j]["url"];
            String altText = result.data["activities"][i]["images"]
            [j]["altText"];
            images.add({"url": url, "altText": altText});
          }
        }

        List<Profile> profilesList = [];

        if (result.data["activities"][i]["profile"] != null) {
          for (var j = 0;
              j < result.data["activities"][i]["profile"].length;
              j++) {
            Map<String, String> socialMap = new Map();
            for (var key
                in result.data["activities"][i]["profile"][j]["social"].keys) {
              socialMap[key] =
                  result.data["activities"][i]["profile"][j]["social"][key];
            }
            profilesList.add(Profile(
                result.data["activities"][i]["profile"][j]["name"],
                result.data["activities"][i]["profile"][j]["desc"],
                social: socialMap,
                type: result.data["activities"][i]["profile"][j]["type"] ?? "",
                installations: [],
                activities: []));
          }
        }
        Map<String, double> location =
            (result.data["activities"][i]["location"] != null)
                ? {
                    'latitude': result.data["activities"][i]["location"]
                        ["latitude"],
                    'longitude': result.data["activities"][i]["location"]
                        ["longitude"]
                  }
                : {'latitude': -1.0, 'longitude': -1.0};
        Map<String, String> time = {
          'startTime': result.data["activities"][i]["startTime"] ?? "",
          'endTime': result.data["activities"][i]["endTime"] ?? ""
        };
        setState(() {
          listActivity.add(
            Activity(
                id: result.data["activities"][i]["id"],
                title: result.data["activities"][i]["title"],
                desc: result.data["activities"][i]["desc"],
                zone: result.data["activities"][i]["zone"],
                images: images,
                time: time,
                location: location,
                profiles: profilesList),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    DisplaySize _displaySize = serviceLocator<DisplayService>().displaySize;
    NavigationService _navigationService = serviceLocator<NavigationService>();
    Widget mainPageWidget = ListView.builder(
      // Let the ListView know how many items it needs to build.
      itemCount: listActivity.length,
      // Provide a builder function. This is where the magic happens.
      // Convert each item into a widget based on the type of item it is.
      itemBuilder: (context, index) {
        final item = listActivity[index];
        FetchResultCard fetchResultCard = new FetchResultCard();
        return AnimatedContainer(
          duration: Duration(milliseconds: 50),
          curve: Curves.fastOutSlowIn,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
                child: fetchResultCard.getCard("Activity", item),
                onTap: () {
                  if (_displaySize == DisplaySize.LARGE ||
                      _displaySize == DisplaySize.MEDIUM) {
                    selectedValue = index;
                    setState(() {});
                  } else {
                    print(item.id);
                    _navigationService.navigateToWithId(
                        fetchResultCard.getRouteConstant("Activity"), item.id);
                  }
                }),
          ),
        );
      },
      physics: BouncingScrollPhysics(),
    );

    Widget secondPageWidget = (listActivity.length != 0)
        ? ActivityDetailWidget(data: listActivity[selectedValue])
        : Container();
    return MasterPageLayout(
        pageName: "PERFORMANCES",
        pageDesc: "Blah Blah Blah",
        mainPageWidget: mainPageWidget,
        secondPageWidget: secondPageWidget);
  }
}
