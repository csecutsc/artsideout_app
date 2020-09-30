import 'package:artsideout_app/constants/PlaceholderConstants.dart';
import 'package:artsideout_app/models/Activity.dart';
import 'package:artsideout_app/models/Installation.dart';
import 'package:artsideout_app/models/Market.dart';
import 'package:artsideout_app/models/Profile.dart';
import 'package:artsideout_app/models/ZoomMeeting.dart';

class GraphQlFactory {
  static Profile buildProfile(Map result) {
    Map<String, String> socialMap = new Map();
    if (result["social"] != null) {
      for (var key in result["social"].keys) {
        socialMap[key] = result["social"][key];
      }
    }
    String profilePic = PlaceholderConstants.PROFILE_IMAGE;
    if (result["profilePic"] != null) {
      profilePic = result["profilePic"]["url"];
    }

    List<Installation> listInstallations = [];
    if (result["installation"] != null) {
      for (var i = 0; i < result["installation"].length; i++) {
        listInstallations.add(buildInstallation(result["installation"][i]));
      }
    }

    List<Activity> listActivities = [];
    if (result["activity"] != null) {
      for (var i = 0; i < result["activity"].length; i++) {
        listActivities.add(buildActivity(result["activity"][i]));
      }
    }

    List<Market> listMarkets = [];
    if (result["artMarketVendor"] != null) {
      listMarkets.add(buildMarket(result["artMarketVendor"]));
    }
    return Profile(
        result["name"],
        result["desc"] ?? "",
        id: result["id"],
        social: socialMap,
        type: result["type"] ?? "",
        profilePic: profilePic,
        installations: listInstallations,
        activities: listActivities,
        markets: listMarkets
    );
  }

  static Installation buildInstallation(Map result) {
    List<Profile> profilesList = [];

    List<Map<String, String>> images = [];

    if (result["images"].length != 0) {
      for (int j = 0; j < result["images"].length; j++) {
        String url = result["images"][j]["url"];
        String altText = result["images"][j]["altText"];
        images.add({"url": url, "altText": altText});
      }
    } else {
      images.add({"url": PlaceholderConstants.GENERIC_IMAGE, "altText": null});
    }

    if (result["profile"] != null) {
      for (var j = 0; j < result["profile"].length; j++) {
        profilesList.add(buildProfile(result["profile"][j]));
      }
    }
    return Installation(
      id: result["id"],
      title: result["title"] ?? "",
      desc: result["desc"] ?? "",
      zone: result["zone"] ?? "",
      images: images,
      videoURL: result["videoUrl"] ?? "",
      location: {
        'latitude': result["location"] == null ? 0.0 : result["latitude"],
        'longitude': result["location"] == null ? 0.0 : result["longitude"],
      },
      locationRoom: result["locationroom"] ?? "",
      profiles: profilesList,
    );
  }

  static Activity buildActivity(Map result) {
    List<Profile> profilesList = [];

    List<Map<String, String>> images = [];

    if (result["images"].length != 0) {
      for (int j = 0; j < result["images"].length; j++) {
        String url = result["images"][j]["url"];
        String altText = result["images"][j]["altText"];
        images.add({"url": url, "altText": altText});
      }
    } else {
      images.add({"url": PlaceholderConstants.GENERIC_IMAGE, "altText": null});
    }

    if (result["profile"] != null) {
      for (var j = 0; j < result["profile"].length; j++) {
        profilesList.add(buildProfile(result["profile"][j]));
      }
    }

    Map<String, String> time = {
      'startTime': result["startTime"] ?? "",
      'endTime': result["endTime"] ?? ""
    };

    ZoomMeeting zoomMeeting;
    if (result["zoomMeeting"] != null) {
      zoomMeeting = new ZoomMeeting(result["zoomMeeting"]["meetingId"],
          meetingUrl: result["zoomMeeting"]["meetingUrl"] ?? "",
          meetingPass: result["zoomMeeting"]["meetingPass"] ?? "");
    }


    return Activity(
        id: result["id"],
        title: result["title"] ?? "",
        desc: result["desc"] ?? "",
        zone: result["zone"],
        images: images,
        time: time,
        videoURL: result["videoUrl"] ?? "",
        zoomMeeting: zoomMeeting,
        performanceType: result["performanceType"] ?? "",
        location: {
          'latitude': result["location"] == null ? 0.0 : result["latitude"],
          'longitude': result["location"] == null ? 0.0 : result["longitude"],
        },
        profiles: profilesList);
  }

  static Market buildMarket(Map result) {
    List<Profile> profilesList = [];

    List<Map<String, String>> images = [];
    Map<String, String> socialMap = new Map();
    if (result["social"] != null) {
      for (var key in result["social"].keys) {
        socialMap[key] = result["social"][key];
      }
    }
    if (result["images"].length != 0) {
      for (int j = 0; j < result["images"].length; j++) {
        String url = result["images"][j]["url"];
        String altText = result["images"][j]["altText"];
        images.add({"url": url, "altText": altText});
      }
    } else {
      images.add({"url": PlaceholderConstants.GENERIC_IMAGE, "altText": null});
    }

    if (result["profiles"] != null) {
      for (var j = 0; j < result["profiles"].length; j++) {
        profilesList.add(buildProfile(result["profiles"][j]));
      }
    }

    return Market(result["id"], result["title"] ?? "",
        desc: result["desc"] ?? "",
        images: images,
        profiles: profilesList,
        social: socialMap);
  }
}
