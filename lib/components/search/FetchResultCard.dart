import 'package:artsideout_app/components/activity/ActivityCard.dart';
import 'package:artsideout_app/components/activity/ActivityDetailWidget.dart';
import 'package:artsideout_app/components/art/ArtDetailWidget.dart';
import 'package:artsideout_app/components/art/ArtListCard.dart';
import 'package:artsideout_app/components/profile/ProfileCard.dart';
import 'package:artsideout_app/components/profile/ProfileDetailWidget.dart';
import 'package:artsideout_app/constants/ASORouteConstants.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class FetchResultCard {
  String getThumbnail(String videoURL) {
    return YoutubePlayerController.getThumbnail(
        videoId: YoutubePlayerController.convertUrlToId(videoURL));
  }

  Widget getCard(String type, var item) {
    if (type == "Installation")
      return ArtListCard(
        title: item.title,
        artist: item.profiles
            .map((profile) => profile.name ?? "")
            .toList()
            .join(", "),
        image: item.videoURL.isEmpty
            ? item.images[0]
            : {"url": getThumbnail(item.videoURL), "altText": null},
      );
    else if (type == "Activity")
      return ActivityCard(
          title: item.title,
          desc: item.desc,
          image: item.images[0],
          time: item.time,
          performanceType: item.performanceType,
          zone: item.zone);
    else if (type == "Profile")
      return ProfileCard(
        name: item.name,
        desc: item.desc,
        profileType: item.type,
        socials: item.social,
      );
    else
      return Container();
  }

  Widget getDetailWidget(String type, var item) {
    if (type == "Installation")
      return ArtDetailWidget(data: item);
    else if (type == "Activity")
      return ActivityDetailWidget(data: item);
    else if (type == "Profile")
      return ProfileDetailWidget(item);
    else
      return Container();
  }

  String getRouteConstant(String type) {
    if (type == "Installation")
      return ASORoutes.INSTALLATIONS;
    else if (type == "Activity")
      return ASORoutes.ACTIVITIES;
    else if (type == "Profile")
      return ASORoutes.ACTIVITIES;
    else
      return ASORoutes.ACTIVITIES;
  }
}
