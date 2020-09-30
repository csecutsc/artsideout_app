import 'package:artsideout_app/components/common/ProfileCard.dart';
import 'package:artsideout_app/components/profile/ProfileDetailWidget.dart';
import 'package:artsideout_app/constants/ASORouteConstants.dart';
import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/constants/PlaceholderConstants.dart';
import 'package:artsideout_app/models/Activity.dart';
import 'package:artsideout_app/models/Profile.dart';
import 'package:artsideout_app/pages/profile/ProfileDetailPage.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/GraphQLImageService.dart';
import 'package:artsideout_app/services/NavigationService.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

// TODO Merge with Art Detail Widget
class ActivityDetailWidget extends StatefulWidget {
  final Activity data;
  ActivityDetailWidget({Key key, this.data}) : super(key: key);

  @override
  _ActivityDetailWidgetState createState() => _ActivityDetailWidgetState();
}

class _ActivityDetailWidgetState extends State<ActivityDetailWidget> {
  GraphQlImageService _graphQlImageService =
      serviceLocator<GraphQlImageService>();
  bool showProfile = false;
  Profile profileToDetail;
  int currentScrollPos = 0;

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

    return Scaffold(
        backgroundColor: ColorConstants.PREVIEW_SCREEN,
        body: ListView(children: [
          Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                Center(
                  child: Title(
                      title: widget.data.title,
                      color: Colors.black,
                      child: SelectableText(widget.data.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5)),
                ),
                SizedBox(
                  height: 15.0,
                ),
                widget.data.images.isNotEmpty ? imageFeed : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < widget.data.images.length; i++)
                      imageIndicator(i),
                  ],
                ),
                widget.data.images.isNotEmpty
                    ? Center(
                        child: Title(
                            color: ColorConstants.PRIMARY,
                            child: Text(
                              "Click on the images above to expand or download. Also, scroll down for more information!",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyText1,
                            )))
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
                      Divider(
                        color: Colors.black,
                        thickness: 1.0,
                        height: 0.0,
                        indent: 15.0,
                        endIndent: 15.0,
                      ),
                    ],
                  ),
                ),
                (widget.data.zoomMeeting != null)
                    ? Column(children: [
                        SelectableText(
                            "Meeting ID: ${widget.data.zoomMeeting.meetingId}",
                            style: Theme.of(context).textTheme.bodyText1),
                        (widget.data.zoomMeeting.meetingUrl.isNotEmpty)
                            ? new InkWell(
                                child: Text(
                                    "Meeting Url: ${widget.data.zoomMeeting.meetingUrl}",
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                                onTap: () =>
                                    launch(widget.data.zoomMeeting.meetingUrl))
                            : Container(),
                        (widget.data.zoomMeeting.meetingPass.isNotEmpty)
                            ? SelectableText(
                                "Meeting Password: ${widget.data.zoomMeeting.meetingPass}",
                                style: Theme.of(context).textTheme.bodyText1)
                            : Container()
                      ])
                    : Container(),
                ListTile(
                  leading: SelectableText('OVERVIEW',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: ColorConstants.PRIMARY)),
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
              ]))
        ]));
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
