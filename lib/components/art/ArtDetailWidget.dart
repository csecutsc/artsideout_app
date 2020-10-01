import 'package:artsideout_app/components/common/FileCard.dart';
import 'package:artsideout_app/components/common/ProfileCard.dart';
import 'package:artsideout_app/constants/ASORouteConstants.dart';
import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/constants/DisplayConstants.dart';
import 'package:artsideout_app/constants/PlaceholderConstants.dart';
import 'package:artsideout_app/models/Installation.dart';
import 'package:artsideout_app/models/Profile.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/DisplayService.dart';
import 'package:artsideout_app/services/GraphQLImageService.dart';
import 'package:artsideout_app/services/NavigationService.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

// TODO Merge with Art Detail Widget
class ArtDetailWidget extends StatefulWidget {
  final Installation data;
  final bool expandedScreen;

  ArtDetailWidget({Key key, this.data, this.expandedScreen = false})
      : super(key: key);

  @override
  _ArtDetailWidgetState createState() => _ArtDetailWidgetState();
}

class _ArtDetailWidgetState extends State<ArtDetailWidget> {
  GraphQlImageService _graphQlImageService =
      serviceLocator<GraphQlImageService>();
  DisplaySize _displaySize = serviceLocator<DisplayService>().displaySize;
  final NavigationService _navigationService =
      serviceLocator<NavigationService>();
  YoutubePlayerController videoController;
  ScrollController _scrollController;
  int currentScrollPos = 0;
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
        autoPlay: false,
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    Widget imageFeed = SizedBox(
        height: 400,
        width: width,
        child: Center(
          child: ListView.builder(
            controller: _scrollController,
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
        body: LayoutBuilder(
          builder: (context, constraints) {
            return MediaQuery.removePadding(
              context: context,
              child: ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(
                    height: 15.0,
                  ),
                  Center(
                      child: Title(
                          title: widget.data.title,
                          color: Colors.black,
                          child: SelectableText(widget.data.title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline4))),
                  SizedBox(
                    height: 10.0,
                  ),
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
                          for (Map<String, String> files in widget.data.files)
                            FileCard(
                              name: files["altText"],
                              imgUrl: files["url"],
                              type: files["type"],
                            ),
                          Center(
                              child: Title(
                                  color: ColorConstants.PRIMARY,
                                  child: SelectableText(
                                    "Click on the images or files above to expand. Copyrights are reserved to the artists. Also, scroll down for more information!",
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  )))
                        ])
                      : Container(),
                  widget.data.videoURL.isNotEmpty && widget.expandedScreen
                      ? Container(
                          height: MediaQuery.of(context).size.height / 2,
                          child: videoPlayer)
                      : Container(),
                  widget.data.videoURL.isNotEmpty && !widget.expandedScreen
                      ? videoPlayer
                      : Container(),
                  (_displaySize == DisplaySize.LARGE ||
                              _displaySize == DisplaySize.MEDIUM) &&
                          !widget.expandedScreen
                      ? RaisedButton(
                          child: Text("CLICK TO VIEW FULL PAGE",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(color: Colors.white)),
                          textColor: Colors.white70,
                          color: ColorConstants.PRIMARY,
                          onPressed: () {
                            _navigationService.navigateToWithId(
                                ASORoutes.INSTALLATIONS, widget.data.id);
                          })
                      : Container(),
                  widget.data.videoURL.isNotEmpty && widget.data.images.isEmpty
                      ? SizedBox(height: 12)
                      : Container(),
                  for (Profile profile in widget.data.profiles)
                    ProfileCard(
                        name: profile.name,
                        imgUrl: profile.profilePic,
                        type: profile.type,
                        id: profile.id),
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
                            onTapLink: (url) async {
                              if (!url.startsWith("http")) {
                                url = "http://" + url;
                              }
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch';
                              }
                            },
                            styleSheet:
                                MarkdownStyleSheet.fromTheme(Theme.of(context))
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
                ],
              ),
            );
          },
        ),
      ),
    );
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
