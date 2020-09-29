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
      List<Map<String, String>> images = [];

      if (result.data["activities"][i]["images"].length != 0) {
        for (int j = 0;
        j < result.data["activities"][i]["images"].length;
        j++) {
          String url = result.data["activities"][i]["images"]
          [j]["url"];
          String altText = result.data["activities"][i]["images"]
          [j]["altText"];
          images.add({"url": url, "altText": altText});
        }
      } else {
        images.add({"url": PlaceholderConstants.GENERIC_IMAGE, "altText": null});
      }


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
          String profilePic = PlaceholderConstants.PROFILE_IMAGE;
          if (result.data["activities"][i]["profile"][j]["profilePic"] != null) {
            profilePic = result.data["activities"][i]["profile"][j]["profilePic"]["url"];
          }
          profilesList.add(Profile(
              result.data["activities"][i]["profile"][j]["name"],
              result.data["activities"][i]["profile"][j]["desc"],
              social: socialMap,
              type: result.data["activities"][i]["profile"][j]["type"] ?? "",
              profilePic: profilePic,
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
            images: images,
            time: time,
            location: location,
            profiles: profilesList),
      );
    }
  }
  return listActivity;
}

// Activity GraphQL Query
Future<List<Activity>> fillListWorkShops() async {
  var listActivity = List<Activity>();
  GraphQLConfiguration graphQLConfiguration =
  serviceLocator<GraphQLConfiguration>();
  ActivityQueries queryActivity = ActivityQueries();
  GraphQLClient _client = graphQLConfiguration.clientToQuery();
  QueryResult result = await _client.query(
    QueryOptions(
      documentNode: gql(queryActivity.getAllWorkShops),
    ),
  );
  if (!result.hasException) {
    for (var i = 0; i < result.data["activities"].length; i++) {
      List<Map<String, String>> images = [];

      if (result.data["activities"][i]["images"].length != 0) {
        for (int j = 0;
        j < result.data["activities"][i]["images"].length;
        j++) {
          String url = result.data["activities"][i]["images"]
          [j]["url"];
          String altText = result.data["activities"][i]["images"]
          [j]["altText"];
          images.add({"url": url, "altText": altText});
        }
      } else {
        images.add({"url": PlaceholderConstants.GENERIC_IMAGE, "altText": null});
      }


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
          String profilePic = PlaceholderConstants.PROFILE_IMAGE;
          if (result.data["activities"][i]["profile"][j]["profilePic"] != null) {
            profilePic = result.data["activities"][i]["profile"][j]["profilePic"]["url"];
          }
          profilesList.add(Profile(
              result.data["activities"][i]["profile"][j]["name"],
              result.data["activities"][i]["profile"][j]["desc"],
              social: socialMap,
              type: result.data["activities"][i]["profile"][j]["type"] ?? "",
              profilePic: profilePic,
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
            images: images,
            time: time,
            location: location,
            profiles: profilesList),
      );
    }
  }
  return listActivity;
}