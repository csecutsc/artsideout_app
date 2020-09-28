import 'package:artsideout_app/constants/PlaceholderConstants.dart';
import 'package:artsideout_app/models/Profile.dart';
// GraphQL
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/GraphQLConfiguration.dart';
import 'package:artsideout_app/models/Installation.dart';
import 'package:artsideout_app/graphql/InstallationQueries.dart';

// Installation GraphQL Query
Future<List<Installation>> fillList() async {
  var listInstallation = List<Installation>();
  GraphQLConfiguration graphQLConfiguration =
      serviceLocator<GraphQLConfiguration>();
  InstallationQueries queryInstallation = InstallationQueries();
  GraphQLClient _client = graphQLConfiguration.clientToQuery();
  QueryResult result = await _client.query(
    QueryOptions(
      documentNode: gql(queryInstallation.getAll),
    ),
  );
  if (!result.hasException) {
    for (var i = 0; i < result.data["installations"].length; i++) {
      List<Profile> profilesList = [];

      List<Map<String, String>> images = [];

      if (result.data["installations"][i]["images"].length != 0) {
        for (int j = 0;
            j < result.data["installations"][i]["images"].length;
            j++) {
          String url = result.data["installations"][i]["images"][j]["url"];
          String altText =
              result.data["installations"][i]["images"][j]["altText"];
          images.add({"url": url, "altText": altText});
        }
      } else {
        images
            .add({"url": PlaceholderConstants.GENERIC_IMAGE, "altText": null});
      }

      if (result.data["installations"][i]["profile"] != null) {
        for (var j = 0;
            j < result.data["installations"][i]["profile"].length;
            j++) {
          Map<String, String> socialMap = new Map();
          if (result.data["installations"][i]["profile"][j]["social"] != null) {
            for (var key in result
                .data["installations"][i]["profile"][j]["social"].keys) {
              socialMap[key] =
                  result.data["installations"][i]["profile"][j]["social"][key];
            }
          }
          profilesList.add(Profile(
              result.data["installations"][i]["profile"][j]["name"],
              result.data["installations"][i]["profile"][j]["desc"],
              social: socialMap,
              type: result.data["installations"][i]["profile"][j]["type"] ?? "",
              installations: [],
              activities: []));
        }
      }
      print(images);
      listInstallation.add(
        Installation(
          id: result.data["installations"][i]["id"],
          title: result.data["installations"][i]["title"],
          desc: result.data["installations"][i]["desc"],
          zone: result.data["installations"][i]["zone"] ?? "",
          images: images,
          videoURL: result.data["installations"][i]["videoUrl"] ?? "",
          location: {
            'latitude': result.data["installations"][i]["location"] == null
                ? 0.0
                : result.data["installations"][i]["location"]["latitude"],
            'longitude': result.data["installations"][i]["location"] == null
                ? 0.0
                : result.data["installations"][i]["location"]["longitude"],
          },
          locationRoom: result.data["installations"][i]["locationroom"] ?? "",
          profiles: profilesList,
        ),
      );
    }
  }
  return listInstallation;
}
