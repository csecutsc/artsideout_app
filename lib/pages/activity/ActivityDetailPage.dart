import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/constants/PlaceholderConstants.dart';
import 'package:artsideout_app/graphql/ActivityQueries.dart';
import 'package:artsideout_app/models/Profile.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/GraphQLConfiguration.dart';
import 'package:flutter/material.dart';
import 'package:artsideout_app/models/Activity.dart';
import 'package:artsideout_app/components/activity/ActivityDetailWidget.dart';
// GraphQL
import 'package:graphql_flutter/graphql_flutter.dart';

class ActivityDetailPage extends StatefulWidget {
  final String activityPageId;
  ActivityDetailPage(this.activityPageId);

  @override
  _ActivityDetailPageState createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  Activity activityDetails;

  GraphQLConfiguration graphQLConfiguration =
      serviceLocator<GraphQLConfiguration>();
  @override
  void initState() {
    super.initState();
    _getActivityPost(widget.activityPageId);
  }

  void _getActivityPost(pageId) async {
    ActivityQueries queryActivity = ActivityQueries();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.query(
      QueryOptions(
        documentNode: gql(queryActivity.getOneByID(pageId)),
      ),
    );
    if (!result.hasException) {
      List<Map<String, String>> images = [];

      if (result.data["activity"]["images"] != null) {
        for (int j = 0;
        j < result.data["activity"]["images"].length;
        j++) {
          String url = result.data["activity"]["images"]
          [j]["url"];
          String altText = result.data["activity"]["images"]
          [j]["altText"];
          images.add({"url": url, "altText": altText});
        }
      }

      Map<String, double> location =
          (result.data["activity"]["location"] != null)
              ? {
                  'latitude': result.data["activity"]["location"]["latitude"],
                  'longitude': result.data["activity"]["location"]["longitude"]
                }
              : {'latitude': -1.0, 'longitude': -1.0};

      Map<String, String> time = {
        'startTime': result.data["activity"]["startTime"] ?? "",
        'endTime': result.data["activity"]["endTime"] ?? ""
      };

      List<Profile> profilesList = [];

      if (result.data["activity"]["profile"] != null) {
        for (var j = 0; j < result.data["activity"]["profile"].length; j++) {
          Map<String, String> socialMap = new Map();
          if (result.data["activity"]["profile"][j]["social"] != null) {
            for (var key
                in result.data["activity"]["profile"][j]["social"].keys) {
              socialMap[key] =
                  result.data["activity"]["profile"][j]["social"][key];
            }
          }
          profilesList.add(Profile(
              result.data["activity"]["profile"][j]["name"],
              result.data["activity"]["profile"][j]["desc"],
              social: socialMap,
              type: result.data["activity"]["profile"][j]["type"] ?? "",
              installations: [],
              activities: []));
        }
      }

      setState(() {
        activityDetails = Activity(
            id: result.data["activity"]["id"],
            title: result.data["activity"]["title"],
            desc: result.data["activity"]["desc"],
            zone: result.data["activity"]["zone"],
            location: location,
            profiles: profilesList,
            images: images,
            time: time);
      });
    } else {
      print("CANNOT GET ART DETAILS");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO TEMP FIX
    Widget cool;
    if (activityDetails == null) {
      cool = Container();
    } else {
      cool = ActivityDetailWidget(data: activityDetails);
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0.0,
        backgroundColor: ColorConstants.SCAFFOLD,
      ),
      body: cool,
    );
  }
}
