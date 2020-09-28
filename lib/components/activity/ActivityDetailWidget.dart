import 'package:artsideout_app/components/profile/ProfileDetailWidget.dart';
import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/constants/PlaceholderConstants.dart';
import 'package:artsideout_app/models/Activity.dart';
import 'package:artsideout_app/models/Profile.dart';
import 'package:artsideout_app/pages/profile/ProfileDetailPage.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/GraphQLImageService.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// TODO Merge with Art Detail Widget
class ActivityDetailWidget extends StatefulWidget {
  final Activity data;
  ActivityDetailWidget({Key key, this.data}) : super(key: key);

  @override
  _ActivityDetailWidgetState createState() => _ActivityDetailWidgetState();
}

class _ActivityDetailWidgetState extends State<ActivityDetailWidget> {
  bool showProfile = false;
  Profile profileToDetail;

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
    return AnimatedSwitcher(
        duration: Duration(milliseconds: 250),
        transitionBuilder: (child, animation) {
          return Align(
              child: SlideTransition(
            position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                .animate(animation),
            child: child,
          ));
        },
        child: showProfile
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                    Container(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              setState(() {
                                showProfile = false;
                              });
                            })),
                    ProfileDetailWidget(profileToDetail)
                  ])
            : ListView(children: [
                Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Container(
                          width: 450.0,
                          height: 250.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                  PlaceholderConstants.GENERIC_IMAGE),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: ColorConstants.PRIMARY,
                          radius: 25.0,
                        ),
                        title: Column(
                          children: <Widget>[
                            SelectableText(
                              startTimeDisplay(
                                  widget.data.time["startTime"], context),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SelectableText(
                              'to',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SelectableText(
                              endTimeDisplay(
                                  widget.data.time["endTime"], context),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.bookmark,
                              semanticLabel: "Saved Button"),
                          color: ColorConstants.PRIMARY,
                          onPressed: () {
                            print('Save button pressed! uwu');
                          },
                        ),
                      ),
                      ListTile(
                          leading: SelectableText(displayZone(widget.data.zone),
                              style: TextStyle(
                                color: ColorConstants.PRIMARY,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ))),
                      Divider(
                        color: Colors.black,
                        thickness: 3.0,
                        height: 0.0,
                        indent: 15.0,
                        endIndent: 15.0,
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
                      Container(
                        padding: EdgeInsets.only(bottom: 25),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 16.0,
                            ),
                            Flexible(
                              child: SelectableText(
                                displayDesc(widget.data.desc),
                              ),
                            )
                          ],
                        ),
                      ),
                      ListTile(
                          leading: SelectableText('ORGANIZERS',
                              style: TextStyle(
                                color: ColorConstants.PRIMARY,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ))),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var profile in widget.data.profiles)
                              ListTile(
                                leading: SelectableText(
                                  "${profile.name}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                  ),
                                ),
                                trailing: RichText(
                                    text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: "Click for more",
                                      style: TextStyle(
                                        color: Colors.black,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.red,
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          if (MediaQuery.of(context)
                                                  .size
                                                  .width <
                                              600) {
                                            Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder:
                                                    (BuildContext context) {
                                                  return ProfileDetailPage(
                                                      profile);
                                                }, //islargescreen, return widget
                                              ),
                                            );
                                          } else {
                                            setState(() {
                                              showProfile = true;
                                              profileToDetail = profile;
                                            });
                                          }
                                        })
                                ])),
                              ),
                            Divider(
                              color: Colors.black,
                              thickness: 1.0,
                              height: 0.0,
                              indent: 15.0,
                              endIndent: 15.0,
                            ),
                          ],
                        ),
                      )
                    ]))
              ]));
  }
}
