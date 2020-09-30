import 'package:artsideout_app/components/common/ProfileCard.dart';
import 'package:artsideout_app/constants/ASORouteConstants.dart';
import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/constants/DisplayConstants.dart';
import 'package:artsideout_app/constants/PlaceholderConstants.dart';
import 'package:artsideout_app/models/Activity.dart';
import 'package:artsideout_app/models/Profile.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/DisplayService.dart';
import 'package:artsideout_app/services/GraphQLImageService.dart';
import 'package:artsideout_app/services/NavigationService.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

// TODO Merge with Art Detail Widget
class ActivityDetailWidget extends StatefulWidget {
  final Activity data;
  final bool expandedScreen;
  ActivityDetailWidget({Key key, this.data, this.expandedScreen = false})
      : super(key: key);

  @override
  _ActivityDetailWidgetState createState() => _ActivityDetailWidgetState();
}

class _ActivityDetailWidgetState extends State<ActivityDetailWidget> {
  GraphQlImageService _graphQlImageService =
      serviceLocator<GraphQlImageService>();
  bool showProfile = false;
  Profile profileToDetail;
  int currentScrollPos = 0;

  YoutubePlayerController videoController;
  ScrollController _scrollController;
  Widget videoPlayer = YoutubePlayerIFrame();

  @override
  void initState() {
    super.initState();
    initVideoController();
    initScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    videoController?.drain();
    videoController?.close();
  }

  void initVideoController() {
    String url = (widget.data.videoURL.isEmpty) ? 'xd' : widget.data.videoURL;
    videoController = YoutubePlayerController(
      initialVideoId: YoutubePlayerController.convertUrlToId(url),
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        desktopMode: false,
        autoPlay: true,
      ),
    );
  }

  void initScrollController() {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.hasClients)
          setState(() {
            for (int i = 0; i < widget.data.images.length; i++) {
              if (_scrollController.position.pixels < 270 * (i + 1) &&
                  _scrollController.position.pixels > 270 * i) {
                currentScrollPos = i;
              }
            }
          });
      });
  }

  String startTimeDisplay(String startTimeGiven, BuildContext context) {
    if (startTimeGiven == "") {
      return "ALL DAY";
    } else {
      return TimeOfDay.fromDateTime(DateTime.parse(startTimeGiven))
          .format(context);
    }
  }

  String endTimeDisplay(String endTimeGiven, BuildContext context) {
    if (endTimeGiven == "") {
      return "";
    } else {
      return TimeOfDay.fromDateTime(DateTime.parse(endTimeGiven))
          .format(context);
    }
  }

  String displayDesc(String desc) {
    if (desc == "") {
      return "No Description available.";
    }
    return desc;
  }

  String displayZone(String zone) {
    if (zone == null) {
      return "Unknown Zone";
    }
    return zone;
  }

  @override
  Widget build(BuildContext context) {
    final NavigationService _navigationService =
        serviceLocator<NavigationService>();
    DisplaySize _displaySize = serviceLocator<DisplayService>().displaySize;
    Widget imageFeed = SizedBox(
        height: 400,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: ListView.builder(
            itemCount: widget.data.images.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              String url = _graphQlImageService.getResizedImage(
                  widget.data.images[index]["url"], 450);
              return Center(
                child: Semantics(
                  label: widget.data.images[index]["altText"],
                  child: GestureDetector(
                    onTap: () async {
                      await showDialog(
                          context: context,
                          builder: (_) =>
                              ImageDialog(widget.data.images[index]));
                    },
                    child: Container(
                        width: 400,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.scaleDown,
                            image: NetworkImage(url),
                          ),
                        )),
                  ),
                ),
              );
            },
          ),
        ));

    Widget imageIndicator(int index) {
      return Container(
        width: 8.0,
        height: 8.0,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentScrollPos
                ? Color.fromRGBO(0, 0, 0, 0.9)
                : Colors.grey),
      );
    }

    return YoutubePlayerControllerProvider(
        controller: videoController,
        child: Scaffold(
            backgroundColor: ColorConstants.PREVIEW_SCREEN,
            body: LayoutBuilder(builder: (context, constraints) {
              return MediaQuery.removePadding(
                  context: context,
                  child: ListView(children: [
                    SizedBox(
                      height: 15.0,
                    ),
                    Center(
                      child: Title(
                          title: widget.data.title,
                          color: Colors.black,
                          child: SelectableText(widget.data.title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline4)),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    (widget.data.zoomMeeting != null)
                        ? Column(children: [
                            Text("Meeting ID",
                                style: Theme.of(context).textTheme.subtitle1),
                            SelectableText(widget.data.zoomMeeting.meetingId,
                                style: Theme.of(context).textTheme.headline5),
                            (widget.data.zoomMeeting.meetingPass.isNotEmpty)
                                ? Column(
                                    children: [
                                      Text("Password",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1),
                                      SelectableText(
                                          widget.data.zoomMeeting.meetingPass,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5)
                                    ],
                                  )
                                : Container(),
                            (widget.data.zoomMeeting.meetingUrl.isNotEmpty)
                                ? Column(children: [
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    new InkWell(
                                        child: Text(
                                            widget.data.zoomMeeting.meetingUrl,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                              color: Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0,
                                                    decoration: TextDecoration
                                                        .underline)),
                                        onTap: () => launch(
                                            widget.data.zoomMeeting.meetingUrl))
                                  ])
                                : Container(),
                            SizedBox(
                              height: 15.0,
                            ),
                          ])
                        : Container(),
                    (widget.data.images.isNotEmpty &&
                            !(widget.data.images[0]["url"] ==
                                PlaceholderConstants.GENERIC_IMAGE))
                        ? Column(children: [
                            imageFeed,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int i = 0;
                                    i < widget.data.images.length;
                                    i++)
                                  imageIndicator(i),
                              ],
                            ),
                            Center(
                                child: Title(
                                    color: ColorConstants.PRIMARY,
                                    child: Text(
                                      "Click on the images above to expand or download. Also, scroll down for more information!",
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    )))
                          ])
                        : Container(),
                    widget.data.videoURL.isNotEmpty && widget.expandedScreen
                        ? Container(
                            height: MediaQuery.of(context).size.height / 1.5,
                            child: videoPlayer)
                        : Container(),
                    widget.data.videoURL.isNotEmpty && !widget.expandedScreen
                        ? videoPlayer
                        : Container(),
                    widget.data.videoURL.isNotEmpty &&
                            widget.data.images.isEmpty
                        ? SizedBox(height: 12)
                        : Container(),
                    (_displaySize == DisplaySize.LARGE ||
                                _displaySize == DisplaySize.MEDIUM) &&
                            !widget.expandedScreen
                        ? RaisedButton(
                            child: Text("VIEW PAGE",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(color: Colors.white)),
                            textColor: Colors.white70,
                            color: ColorConstants.PRIMARY,
                            onPressed: () {
                              _navigationService.navigateToWithId(
                                  ASORoutes.ACTIVITIES, widget.data.id);
                            })
                        : Container(),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (Profile profile in widget.data.profiles)
                            ProfileCard(
                                name: profile.name,
                                imgUrl: profile.profilePic,
                                type: profile.type,
                                id: profile.id),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: SelectableText('Overview',
                          style: Theme.of(context).textTheme.headline5),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 16.0,
                          ),
                          Flexible(
                              child: Padding(
                            padding: const EdgeInsets.only(bottom: 14.0),
                            child: MarkdownBody(
                              selectable: true,
                              data: widget.data.desc,
                              onTapLink: (url) {
                                launch(url);
                              },
                              styleSheet: MarkdownStyleSheet.fromTheme(
                                      Theme.of(context))
                                  .copyWith(
                                      p: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(fontSize: 16.0)),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ]));
            })));
  }
}

class ImageDialog extends StatelessWidget {
  final Map<String, String> image;
  ImageDialog(this.image);

  Widget build(BuildContext context) {
    GraphQlImageService _graphQlImageService =
        serviceLocator<GraphQlImageService>();
    String fullResUrl = _graphQlImageService.getResizedImage(image["url"], 800);
    return AlertDialog(
      backgroundColor: Colors.white70,
      content: Semantics(
        child: CachedNetworkImage(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          imageUrl: fullResUrl,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(
            Icons.error,
            size: 50,
          ),
        ),
        label: image["altText"],
      ),
      actions: [
        new FlatButton(
            child: const Text(
              "View Full Resolution",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            onPressed: () async {
              await launch(_graphQlImageService.getFullImage(image["url"]));
            }),
        new FlatButton(
            child: const Text(
              "Close",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context)),
      ],
    );
  }
}
