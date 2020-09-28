import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/models/Installation.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

// TODO Merge with Art Detail Widget
class ArtDetailWidget extends StatefulWidget {
  final Installation data;

  ArtDetailWidget({Key key, this.data}) : super(key: key);

  @override
  _ArtDetailWidgetState createState() => _ArtDetailWidgetState();
}

class _ArtDetailWidgetState extends State<ArtDetailWidget> {
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
              String url = widget.data.images[index]["url"];
              return Center(
                child: Semantics(
                  label: widget.data.images[index]["altText"],
                  child: GestureDetector(
                    onTap: () async {
                      await showDialog(
                          context: context, builder: (_) => ImageDialog(url));
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

    Widget likeAndSaveButtons(Icon icon, int numInteractions) {
      return RaisedButton.icon(
        onPressed: () {},
        padding: EdgeInsets.all(13.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        icon: icon,
        textColor: Colors.white,
        color: ColorConstants.PRIMARY,
        label: SelectableText('$numInteractions'),
      );
    }

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
              removeTop: true,
              context: context,
              child: ListView(
                children: [
                  widget.data.images.isNotEmpty ? imageFeed : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < widget.data.images.length; i++)
                        imageIndicator(i),
                    ],
                  ),
                  widget.data.videoURL.isNotEmpty ? videoPlayer : Container(),
                  widget.data.videoURL.isNotEmpty && widget.data.images.isEmpty
                      ? SizedBox(height: 12)
                      : Container(),
                  Card(
                    margin: EdgeInsets.all(16.0),
                    color: Color(0xFFF9EBEB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(18),
                      leading: CircleAvatar(
                        backgroundColor: Colors.pink,
                        radius: 25.0,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                            'John Appleseed',
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          SelectableText(
                            'Artist',
                            style: TextStyle(
                                fontSize: 14.5,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          likeAndSaveButtons(
                            Icon(Icons.bookmark_border),
                            72,
                          ),
                          SizedBox(
                            width: 7.0,
                          ),
                          likeAndSaveButtons(
                            Icon(Icons.favorite_border),
                            284,
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: SelectableText(
                      'OVERVIEW',
                      style: TextStyle(
                        color: ColorConstants.PRIMARY,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 1.0,
                    height: 0,
                    indent: 15,
                    endIndent: 20,
                  ),
                  SizedBox(
                    height: 15.0,
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
                          child: SelectableText(widget.data.desc),
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
  final String imgURL;
  ImageDialog(this.imgURL);

  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorConstants.PRIMARY,
      content: Image.network(imgURL, fit: BoxFit.cover),
      actions: [
        new FlatButton(
            child: const Text("Close"), onPressed: () => Navigator.pop(context)),
      ],
    );
  }
}
