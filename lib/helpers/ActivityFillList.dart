import 'package:artsideout_app/constants/PlaceholderConstants.dart';
import 'package:artsideout_app/helpers/GraphQlFactory.dart';
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
      listActivity
          .add(GraphQlFactory.buildActivity(result.data["activities"][i]));
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
      listActivity
          .add(GraphQlFactory.buildActivity(result.data["activities"][i]));
    }
  }
  return listActivity;
}
