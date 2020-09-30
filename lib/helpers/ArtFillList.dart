import 'package:artsideout_app/helpers/GraphQlFactory.dart';
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
      listInstallation.add(
        GraphQlFactory.buildInstallation(result.data["installations"][i])
      );
    }
  }
  return listInstallation;
}
