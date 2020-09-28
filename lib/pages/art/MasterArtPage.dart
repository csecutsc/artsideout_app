import 'package:artsideout_app/components/common/ASOCard.dart';
import 'package:artsideout_app/components/layout/MasterPageLayout.dart';
import 'package:artsideout_app/constants/ASORouteConstants.dart';
import 'package:artsideout_app/constants/DisplayConstants.dart';
import 'package:artsideout_app/models/ASOCardInfo.dart';
import 'package:artsideout_app/models/Installation.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/DisplayService.dart';
import 'package:artsideout_app/services/GraphQLConfiguration.dart';
import 'package:artsideout_app/services/NavigationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// Common
import 'package:artsideout_app/components/art/ArtListCard.dart';
import 'package:artsideout_app/helpers/ArtFillList.dart';
// Art
import 'package:artsideout_app/components/art/ArtDetailWidget.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MasterArtPage extends StatefulWidget {
  @override
  _MasterArtPageState createState() => _MasterArtPageState();
}

class _MasterArtPageState extends State<MasterArtPage> {
  int selectedValue = 0;
  bool loading = true;

  List<Installation> listInstallation = List<Installation>();
  GraphQLConfiguration graphQLConfiguration =
      serviceLocator<GraphQLConfiguration>();

  Future<void> setList() async {
    listInstallation = await fillList().whenComplete(() => loading = false);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setList();
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
    Widget mainPageWidget = AnimatedSwitcher(
        duration: Duration(milliseconds: 250),
        transitionBuilder: (child, animation) {
          return Align(
              child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              ),
            ),
            child: child,
          ));
        },
        child: (loading == false)
            ? Stack(children: [
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
                                itemBuilder: (BuildContext context,
                                        int index) =>
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 0),
                                        child:
                                            ASOCard(listActions[index], false)),
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
                          crossAxisCount: 2,
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
              ])
            : Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ));
    Widget secondPageWidget = AnimatedSwitcher(
        duration: Duration(milliseconds: 250),
        transitionBuilder: (child, animation) {
          return Align(
              child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              ),
            ),
            child: child,
          ));
        },
        child: (loading == false)
            ? ((listInstallation.length != 0)
                ? ArtDetailWidget(data: listInstallation[selectedValue])
                : Container())
            : Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ));
    return MasterPageLayout(
      pageName: "Studio Installations",
      pageDesc: "Blah Blah Blah",
      mainPageWidget: mainPageWidget,
      secondPageWidget: secondPageWidget,
    );
  }

  String getThumbnail(String videoURL) {
    return YoutubePlayerController.getThumbnail(
        videoId: YoutubePlayerController.convertUrlToId(videoURL));
  }
}
