import 'package:artsideout_app/components/common/ASOCard.dart';
import 'package:artsideout_app/components/layout/MasterPageLayout.dart';
import 'package:artsideout_app/constants/ASORouteConstants.dart';
import 'package:artsideout_app/constants/DisplayConstants.dart';
import 'package:artsideout_app/constants/PlaceholderConstants.dart';
import 'package:artsideout_app/models/ASOCardInfo.dart';
import 'package:artsideout_app/models/Installation.dart';
import 'package:artsideout_app/models/Profile.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/DisplayService.dart';
import 'package:artsideout_app/services/GraphQLConfiguration.dart';
import 'package:artsideout_app/services/NavigationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// GraphQL
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:artsideout_app/graphql/InstallationQueries.dart';
// Common
import 'package:artsideout_app/components/art/ArtListCard.dart';
// Art
import 'package:artsideout_app/components/art/ArtDetailWidget.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MasterArtPage extends StatefulWidget {
  @override
  _MasterArtPageState createState() => _MasterArtPageState();
}

class _MasterArtPageState extends State<MasterArtPage> {
  int selectedValue = 0;

  List<Installation> listInstallation = List<Installation>();
  GraphQLConfiguration graphQLConfiguration =
      serviceLocator<GraphQLConfiguration>();

  @override
  void initState() {
    super.initState();
    _fillList();
  }

  // Installation GraphQL Query
  void _fillList() async {
    InstallationQueries queryInstallation = InstallationQueries();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.query(
      QueryOptions(
        documentNode: gql(queryInstallation.getAll),
      ),
    );
    if (!result.hasException) {
      for (var i = 0; i < result.data["installations"].length; i++) {
        List<Profile> profilesList = [];

        if (result.data["installations"][i]["profile"] != null) {
          for (var j = 0;
              j < result.data["installations"][i]["profile"].length;
              j++) {
            Map<String, String> socialMap = new Map();
            for (var key in result
                .data["installations"][i]["profile"][j]["social"].keys) {
              socialMap[key] =
                  result.data["installations"][i]["profile"][j]["social"][key];
            }
            profilesList.add(Profile(
                result.data["installations"][i]["profile"][j]["name"],
                result.data["installations"][i]["profile"][j]["desc"],
                social: socialMap,
                type:
                    result.data["installations"][i]["profile"][j]["type"] ?? "",
                installations: [],
                activities: []));
          }
        }
        setState(() {
          listInstallation.add(
            Installation(
              id: result.data["installations"][i]["id"],
              title: result.data["installations"][i]["title"],
              desc: result.data["installations"][i]["desc"],
              zone: result.data["installations"][i]["zone"] ?? "",
              imgURL: result.data["installations"][i]["image"] == null
                  ? PlaceholderConstants.GENERIC_IMAGE
                  : result.data["installations"][i]["image"]["url"],
              videoURL: result.data["installations"][i]["videoUrl"] ?? "",
              location: {
                'latitude': result.data["installations"][i]["location"] == null
                    ? 0.0
                    : result.data["installations"][i]["location"]["latitude"],
                'longitude': result.data["installations"][i]["location"] == null
                    ? 0.0
                    : result.data["installations"][i]["location"]["longitude"],
              },
              locationRoom:
                  result.data["installations"][i]["locationroom"] ?? "",
              profiles: profilesList,
            ),
          );
        });
      }
    }
  }

  final List<ASOCardInfo> listActions = [
    ASOCardInfo("Featured", Color(0xFF62BAA6),
        "assets/icons/aboutConnections.svg", 300, ASORoutes.ACTIVITIES),
    ASOCardInfo("Activities", Color(0xFFC155A5), "assets/icons/activities.svg",
        300, ASORoutes.ACTIVITIES),
    ASOCardInfo("Saved", Color(0xFF9CC9F5), "assets/icons/saved.svg", 300,
        ASORoutes.ACTIVITIES)
  ];

  @override
  Widget build(BuildContext context) {
    DisplaySize _displaySize = serviceLocator<DisplayService>().displaySize;
    NavigationService _navigationService = serviceLocator<NavigationService>();
    Widget mainPageWidget = Stack(children: [
      Row(
        children: [
          (_displaySize == DisplaySize.LARGE)
              ? Container(
                  width: 325,
                  color: Colors.transparent,
                  child: Container(
                    child: StaggeredGridView.countBuilder(
                      padding: EdgeInsets.zero,
                      crossAxisCount: 1,
                      itemCount: listActions.length,
                      itemBuilder: (BuildContext context, int index) => Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: ASOCard(listActions[index], false)),
                      staggeredTileBuilder: (int index) =>
                          new StaggeredTile.count(
                        1,
                        0.57,
                      ),
                      mainAxisSpacing: 15.0,
                      crossAxisSpacing: 5.0,
                    ),
                  ),
                )
              : Container(),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              // Let the ListView know how many items it needs to build.
              itemCount: listInstallation.length,
              // Provide a builder function. This is where the magic happens.
              // Convert each item into a widget based on the type of item it is.
              itemBuilder: (context, index) {
                final item = listInstallation[index];
                return GestureDetector(
                  child: ArtListCard(
                    title: item.title,
                    artist: item.profiles
                        .map((profile) => profile.name ?? "")
                        .toList()
                        .join(", "),
                    image: item.videoURL.isEmpty
                        ? item.imgURL
                        : getThumbnail(item.videoURL),
                  ),
                  onTap: () {
                    if (_displaySize == DisplaySize.LARGE) {
                      setState(() {
                        selectedValue = index;
                      });
                    } else {
                      _navigationService.navigateToWithId(
                          ASORoutes.INSTALLATIONS, item.id);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    ]);
    Widget secondPageWidget = (listInstallation.length != 0)
        ? ArtDetailWidget(data: listInstallation[selectedValue])
        : Container();
    return MasterPageLayout(
      pageName: "Studio Installations",
      pageDesc: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.\nLorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
      mainPageWidget: mainPageWidget,
      secondPageWidget: secondPageWidget,
    );
  }

  String getThumbnail(String videoURL) {
    return YoutubePlayerController.getThumbnail(
        videoId: YoutubePlayerController.convertUrlToId(videoURL));
  }
}
