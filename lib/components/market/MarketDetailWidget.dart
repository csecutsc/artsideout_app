import 'package:artsideout_app/components/common/ProfileCard.dart';
import 'package:artsideout_app/components/profile/SocialCard.dart';
import 'package:artsideout_app/constants/ASORouteConstants.dart';
import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/constants/DisplayConstants.dart';
import 'package:artsideout_app/models/Market.dart';
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

// TODO Merge with Art Detail Widget
class MarketDetailWidget extends StatefulWidget {
  final Market data;
  final bool expandedScreen;

  MarketDetailWidget({Key key, this.data, this.expandedScreen = false}) : super(key: key);

  @override
  _MarketDetailWidgetState createState() => _MarketDetailWidgetState();
}

class _MarketDetailWidgetState extends State<MarketDetailWidget> {
  GraphQlImageService _graphQlImageService =
      serviceLocator<GraphQlImageService>();
  ScrollController _scrollController;
  int currentScrollPos = 0;

  @override
  void initState() {
    super.initState();
    initScrollController();
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
    DisplaySize _displaySize = serviceLocator<DisplayService>().displaySize;
    final NavigationService _navigationService =
    serviceLocator<NavigationService>();
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

    return Scaffold(
      backgroundColor: ColorConstants.PREVIEW_SCREEN,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return MediaQuery.removePadding(
            context: context,
            child: ListView(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Center(
                    child: Title(
                        title: widget.data.title,
                        color: Colors.black,
                        child: SelectableText(widget.data.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline5))),
                SizedBox(
                  height: 10.0,
                ),
                widget.data.images.isNotEmpty ? imageFeed : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < widget.data.images.length; i++)
                      imageIndicator(i),
                  ],
                ),
                (_displaySize == DisplaySize.LARGE ||
                    _displaySize == DisplaySize.MEDIUM) && !widget.expandedScreen
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
                          ASORoutes.MARKETS, widget.data.id);
                    })
                    : Container(),
                widget.data.images.isNotEmpty
                    ? Center(
                        child: Title(
                            color: ColorConstants.PRIMARY,
                            child: Text(
                              "Click on the images above to expand. Also, scroll down for more information!",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyText1,
                            )))
                    : Container(),
                for (Profile profile in widget.data.profiles)
                  ProfileCard(
                      name: profile.name,
                      imgUrl: profile.profilePic,
                      type: profile.type,
                      id: profile.id),
                ListTile(
                  leading: SelectableText(
                    'OVERVIEW',
                    style: Theme.of(context).textTheme.headline5
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
                        child: MarkdownBody(
                          selectable: true,
                          data: widget.data.desc,
                          onTapLink: (url) {
                            launch(url);
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
                (widget.data.social.isNotEmpty)
                    ? Column(children: [
                        ListTile(
                          leading: SelectableText(
                            'SOCIAL',
                            style: Theme.of(context).textTheme.headline5
                          ),
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 1.0,
                          height: 0,
                          indent: 15,
                          endIndent: 20,
                        ),
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: widget.data.social.length,
                            itemBuilder: (context, index) {
                              String key =
                                  widget.data.social.keys.elementAt(index);
                              return Container(
                                  child:
                                      SocialCard(key, widget.data.social[key]));
                            })
                      ])
                    : Container()
              ],
            ),
          );
        },
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
