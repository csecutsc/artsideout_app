import 'package:artsideout_app/constants/PlaceholderConstants.dart';
import 'package:artsideout_app/models/Profile.dart';
// GraphQL
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/GraphQLConfiguration.dart';
import 'package:artsideout_app/models/Activity.dart';
import 'package:artsideout_app/graphql/ActivityQueries.dart';

// Activity GraphQL Query
Future<List<Activity>> fillList() async {
  var listActivity = List<Activity>();
  GraphQLConfiguration graphQLConfiguration =
      serviceLocator<GraphQLConfiguration>();
  ActivityQueries queryActivity = ActivityQueries();
  GraphQLClient _client = graphQLConfiguration.clientToQuery();
  QueryResult result = await _client.query(
    QueryOptions(
      documentNode: gql(queryActivity.getAll),
    ),
  );
  if (!result.hasException) {
    for (var i = 0; i < result.data["activities"].length; i++) {
      String imgUrl = (result.data["activities"][i]["image"] != null)
          ? result.data["activities"][i]["image"]["url"]
          : PlaceholderConstants.GENERIC_IMAGE;

      List<Profile> profilesList = [];

      if (result.data["activities"][i]["profile"] != null) {
        for (var j = 0;
            j < result.data["activities"][i]["profile"].length;
            j++) {
          Map<String, String> socialMap = new Map();
          if (result.data["activities"][i]["profile"][j]["social"] != null) {
            for (var key
                in result.data["activities"][i]["profile"][j]["social"].keys) {
              socialMap[key] =
                  result.data["activities"][i]["profile"][j]["social"][key];
            }
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
      Map<String, double> location = new Map();
      if (result.data["activities"][i]["location"] != null) {
        location = {
          'latitude':
              result.data["activities"][i]["location"]["latitude"] ?? -1.0,
          'longitude':
              result.data["activities"][i]["location"]["longitude"] ?? -1.0
        };
      } else {
        location = {'latitude': -1.0, 'longitude': -1.0};
      }
      Map<String, String> time = {
        'startTime': result.data["activities"][i]["startTime"] ?? "",
        'endTime': result.data["activities"][i]["endTime"] ?? ""
      };
      listActivity.add(
        Activity(
            id: result.data["activities"][i]["id"],
            title: result.data["activities"][i]["title"],
            desc: result.data["activities"][i]["desc"],
            zone: result.data["activities"][i]["zone"],
            imgUrl: imgUrl,
            time: time,
            location: location,
            profiles: profilesList),
      );
    }
  }
  return listActivity;
}
