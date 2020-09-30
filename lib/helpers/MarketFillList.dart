import 'package:artsideout_app/constants/PlaceholderConstants.dart';
import 'package:artsideout_app/graphql/MarketQueries.dart';
import 'package:artsideout_app/helpers/GraphQlFactory.dart';
import 'package:artsideout_app/models/Market.dart';
import 'package:artsideout_app/models/Profile.dart';
// GraphQL
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/GraphQLConfiguration.dart';
import 'package:artsideout_app/models/Installation.dart';
import 'package:artsideout_app/graphql/InstallationQueries.dart';

// Installation GraphQL Query
Future<List<Market>> fillListMarket() async {
  var listInstallation = List<Market>();
  GraphQLConfiguration graphQLConfiguration =
  serviceLocator<GraphQLConfiguration>();
  MarketQueries queryMarket = MarketQueries();
  GraphQLClient _client = graphQLConfiguration.clientToQuery();
  QueryResult result = await _client.query(
    QueryOptions(
      documentNode: gql(queryMarket.getAll),
    ),
  );
  if (!result.hasException) {
    for (var i = 0; i < result.data["artMarketVendors"].length; i++) {
      listInstallation.add(
          GraphQlFactory.buildMarket(result.data["artMarketVendors"][i])
      );
    }
  }
  return listInstallation;
}
