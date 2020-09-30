import 'package:artsideout_app/constants/PlaceholderConstants.dart';
import 'package:artsideout_app/graphql/ActivityQueries.dart';
import 'package:artsideout_app/graphql/ProfileQueries.dart';
import 'package:artsideout_app/helpers/GraphQlFactory.dart';
import 'package:artsideout_app/models/Installation.dart';
import 'package:artsideout_app/models/Profile.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/GraphQLConfiguration.dart';
// GraphQL
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:artsideout_app/graphql/InstallationQueries.dart';
// Activity
import 'package:artsideout_app/models/Activity.dart';

class FetchResults {
  GraphQLClient _client =
      serviceLocator<GraphQLConfiguration>().clientToQuery();

  List<Installation> listInstallations = List<Installation>();
  List<Activity> listActivities = List<Activity>();
  List<Profile> listProfiles = List<Profile>();

  Future<List<dynamic>> getResults(
      String input, Map<String, bool> options) async {
    listInstallations = await getInstallationsByTypes(input, options);
    listActivities = await getActivitiesByTypes(input, options);
    listProfiles = await getProfilesByTypes(input, options);

    return [...listInstallations, ...listActivities, ...listProfiles];
  }

  Future<List<Installation>> getInstallationsByTypes(
      String term, Map<String, bool> types) async {
    listInstallations.clear();
    InstallationQueries queryInstallation = InstallationQueries();
    QueryResult installationsResult = await _client.query(
      QueryOptions(
        documentNode: gql(queryInstallation.getAllByTitleAndDesc(term)),
      ),
    );

    int numInstalls = installationsResult.data["installations"].length;
    if (!installationsResult.hasException) {
      for (var i = 0; i < numInstalls; i++) {
        String installationType =
            installationsResult.data["installations"][i]["mediumType"];

        if (types[installationType] == true ||
            (installationType == null && types["Other"] == true)) {
          listInstallations.add(GraphQlFactory.buildInstallation(
              installationsResult.data["installations"][i]));
        }
      }
    }

    return listInstallations;
  }

  Future<List<Activity>> getActivitiesByTypes(
      String term, Map<String, bool> types) async {
    listActivities.clear();
    ActivityQueries queryActivities = ActivityQueries();
    QueryResult result = await _client.query(
      QueryOptions(
        documentNode: gql(queryActivities.getAllByTitleAndDesc(term)),
      ),
    );

    if (!result.hasException) {
      for (var i = 0; i < result.data["activities"].length; i++) {
        String performanceType =
            result.data["activities"][i]["performanceType"];
        if (types[performanceType] == true ||
            (performanceType == null && types["Other"] == true)) {
          listActivities
              .add(GraphQlFactory.buildActivity(result.data["activities"][i]));
        }
      }
    }

    return listActivities;
  }

  Future<List<Profile>> getProfilesByTypes(
      String term, Map<String, bool> types) async {
    listProfiles.clear();
    ProfileQueries queryProfiles = ProfileQueries();
    QueryResult profilesResult = await _client.query(
      QueryOptions(
        documentNode: gql(queryProfiles.getAllByName(term)),
      ),
    );
    if (!profilesResult.hasException) {
      for (int i = 0; i < profilesResult.data["profiles"].length; i++) {
        String profileType = profilesResult.data["profiles"][i]["type"];
        if (types[profileType] == true ||
            (profileType == null && types["Other"] == true)) {
          listProfiles.add(
              GraphQlFactory.buildProfile(profilesResult.data["profiles"][i]));
        }
      }
    }
    return listProfiles;
  }
}
