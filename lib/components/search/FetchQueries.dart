import 'package:artsideout_app/constants/PlaceholderConstants.dart';
import 'package:artsideout_app/graphql/ActivityQueries.dart';
import 'package:artsideout_app/graphql/ProfileQueries.dart';
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
        List<Profile> profilesList = [];

        if (installationsResult.data["installations"][i]["profile"] != null) {
          for (var j = 0;
              j <
                  installationsResult
                      .data["installations"][i]["profile"].length;
              j++) {
            Map<String, String> socialMap = new Map();
            if (installationsResult.data["installations"][i]["profile"][j]
                    ["social"] !=
                null) {
              for (var key in installationsResult
                  .data["installations"][i]["profile"][j]["social"].keys) {
                socialMap[key] = installationsResult.data["installations"][i]
                    ["profile"][j]["social"][key];
              }
            }

            String profilePic = PlaceholderConstants.PROFILE_IMAGE;
            if (installationsResult.data["installations"][i]["profile"][j]["profilePic"] != null) {
              profilePic = installationsResult.data["installations"][i]["profile"][j]["profilePic"]["url"];
            }

            profilesList.add(Profile(
                installationsResult.data["installations"][i]["profile"][j]
                    ["name"],
                installationsResult.data["installations"][i]["profile"][j]
                    ["desc"],
                social: socialMap,
                type: installationsResult.data["installations"][i]["profile"][j]
                        ["type"] ??
                    "",
                profilePic: profilePic,
                installations: [],
                activities: []));
          }
        }

        List<Map<String, String>> images = [];
        if (installationsResult.data["installations"][i]["images"] != null) {
          for (int j = 0;
              j < installationsResult.data["installations"][i]["images"].length;
              j++) {
            String url = installationsResult.data["installations"][i]["images"]
            [j]["url"];
            String altText = installationsResult.data["installations"][i]["images"]
            [j]["altText"];
            images.add({"url": url, "altText": altText});
          }
        }

        String installationType =
            installationsResult.data["installations"][i]["mediumType"];

        if (types[installationType] == true ||
            (installationType == null && types["Other"] == true)) {
          listInstallations.add(
            Installation(
              id: installationsResult.data["installations"][i]["id"],
              title: installationsResult.data["installations"][i]["title"],
              desc: installationsResult.data["installations"][i]["desc"],
              zone: installationsResult.data["installations"][i]["zone"] ?? "",
              images: images.length == 0 ? [{"url": PlaceholderConstants.GENERIC_IMAGE, "altText": null}] : images,
              videoURL: installationsResult.data["installations"][i]
                      ["videoUrl"] ??
                  "",
              location: {
                'latitude': installationsResult.data["installations"][i]
                            ["location"] ==
                        null
                    ? 0.0
                    : installationsResult.data["installations"][i]["location"]
                        ["latitude"],
                'longitude': installationsResult.data["installations"][i]
                            ["location"] ==
                        null
                    ? 0.0
                    : installationsResult.data["installations"][i]["location"]
                        ["longitude"],
              },
              locationRoom: installationsResult.data["installations"][i]
                      ["locationroom"] ??
                  "",
              profiles: profilesList,
            ),
          );
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
        List<Map<String, String>> images = [];

        if (result.data["activities"][i]["images"] != null) {
          for (int j = 0;
          j < result.data["activities"][i]["images"].length;
          j++) {
            String url = result.data["activities"][i]["images"]
            [j]["url"];
            String altText = result.data["activities"][i]["images"]
            [j]["altText"];
            images.add({"url": url, "altText": altText});
          }
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
            if (result.data["activity"]["profile"][j]["profilePic"] != null) {
              profilePic = result.data["activity"]["profile"][j]["profilePic"]["url"];
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
        Map<String, double> location =
            (result.data["activities"][i]["location"] != null)
                ? {
                    'latitude': result.data["activities"][i]["location"]
                        ["latitude"],
                    'longitude': result.data["activities"][i]["location"]
                        ["longitude"]
                  }
                : {'latitude': -1.0, 'longitude': -1.0};
        Map<String, String> time = {
          'startTime': result.data["activities"][i]["startTime"] ?? "",
          'endTime': result.data["activities"][i]["endTime"] ?? ""
        };

        String performanceType =
            result.data["activities"][i]["performanceType"];

        if (types[performanceType] == true ||
            (performanceType == null && types["Other"] == true)) {
          listActivities.add(
            Activity(
                id: result.data["activities"][i]["id"],
                title: result.data["activities"][i]["title"],
                desc: result.data["activities"][i]["desc"],
                zone: result.data["activities"][i]["zone"],
                images: images.length == 0 ? [{"url": PlaceholderConstants.GENERIC_IMAGE, "altText": null}] : images,
                time: time,
                location: location,
                profiles: profilesList),
          );
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
        Map<String, String> socialMap = new Map();
        if (profilesResult.data["profiles"][i]["social"] != null) {
          for (var key in profilesResult.data["profiles"][i]["social"].keys) {
            socialMap[key] = profilesResult.data["profiles"][i]["social"][key];
          }
        }
        String profileType = profilesResult.data["profiles"][i]["type"];
        if (types[profileType] == true ||
            (profileType == null && types["Other"] == true)) {
          listProfiles.add(Profile(profilesResult.data["profiles"][i]["name"],
              profilesResult.data["profiles"][i]["desc"],
              social: socialMap,
              type: profilesResult.data["profiles"][i]["type"] ?? "",
              installations: [],
              activities: []));
        }
      }
    }

    return listProfiles;
  }
}
