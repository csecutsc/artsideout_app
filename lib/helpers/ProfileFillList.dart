import 'package:artsideout_app/constants/PlaceholderConstants.dart';
import 'package:artsideout_app/graphql/ProfileQueries.dart';
import 'package:artsideout_app/models/Profile.dart';
// GraphQL
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/GraphQLConfiguration.dart';
import 'package:artsideout_app/models/Installation.dart';
import 'package:artsideout_app/graphql/InstallationQueries.dart';

// Installation GraphQL Query
Future<List<Profile>> fillProfileList() async {
  var listProfiles = List<Profile>();
  GraphQLConfiguration graphQLConfiguration =
  serviceLocator<GraphQLConfiguration>();
  ProfileQueries queryProfile = ProfileQueries();
  GraphQLClient _client = graphQLConfiguration.clientToQuery();
  QueryResult result = await _client.query(
    QueryOptions(
      documentNode: gql(queryProfile.getAll),
    ),
  );
  if (!result.hasException) {
    for (int i = 0; i < result.data["profiles"].length; i++) {
      Map<String, String> socialMap = new Map();
      if (result.data["profiles"][i]["social"] != null) {
        for (var key in result.data["profiles"][i]["social"].keys) {
          socialMap[key] = result.data["profiles"][i]["social"][key];
        }
      }
        listProfiles.add(Profile(result.data["profiles"][i]["name"],
            result.data["profiles"][i]["desc"],
            social: socialMap,
            type: result.data["profiles"][i]["type"] ?? "",
            installations: [],
            activities: []));
    }
  }

  return listProfiles;
}
