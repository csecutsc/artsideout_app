import 'package:artsideout_app/graphql/ProfileQueries.dart';
import 'package:artsideout_app/helpers/GraphQlFactory.dart';
import 'package:artsideout_app/models/Profile.dart';
// GraphQL
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/GraphQLConfiguration.dart';

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
      listProfiles.add(GraphQlFactory.buildProfile(result.data["profiles"][i]));
    }
  }

  return listProfiles;
}
