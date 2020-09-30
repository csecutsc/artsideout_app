import 'package:artsideout_app/graphql/MarketQueries.dart';
import 'package:artsideout_app/helpers/GraphQlFactory.dart';
import 'package:artsideout_app/models/Market.dart';
// GraphQL
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/GraphQLConfiguration.dart';

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
