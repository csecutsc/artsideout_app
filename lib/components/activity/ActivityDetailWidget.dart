import 'package:artsideout_app/pages/profile/ProfileDetailPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:artsideout_app/graphql/Activity.dart';
import 'package:artsideout_app/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class ActivityDetailWidget extends StatefulWidget {
  final Activity data;

  ActivityDetailWidget(this.data);

  @override
  _ActivityDetailWidgetState createState() => _ActivityDetailWidgetState();
}

class _ActivityDetailWidgetState extends State<ActivityDetailWidget> {
  String startTimeDisplay(String startTimeGiven, BuildContext context) {
    if (startTimeGiven == "") {
      return "ALL DAY";
    } else {
      return TimeOfDay.fromDateTime(DateTime.parse(startTimeGiven)).format(context);
    }
  }

  String endTimeDisplay(String endTimeGiven, BuildContext context) {
    if (endTimeGiven == "") {
      return "";
    } else {
      return TimeOfDay.fromDateTime(DateTime.parse(endTimeGiven)).format(context);
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
    return Container(
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
                  image: NetworkImage(widget.data.imgUrl),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: asoPrimary,
              radius: 25.0,
            ),
            title: Column(
              children: <Widget>[
                Text(
                  startTimeDisplay(widget.data.time["startTime"], context),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'to',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  endTimeDisplay(widget.data.time["endTime"], context),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.bookmark),
              color: asoPrimary,
              onPressed: () {
                print('Save button pressed! uwu');
              },
            ),
          ),
          ListTile(
              leading: Text(displayZone(widget.data.zone),
                  style: TextStyle(
                    color: asoPrimary,
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
            leading: Text(
              'OVERVIEW',
              style: TextStyle(
                color: asoPrimary,
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
                  child: Text(
                    displayDesc(widget.data.desc),
                  ),
                )
              ],
            ),
          ),
          ListTile(
              leading: Text('ORGANIZERS',
                  style: TextStyle(
                    color: asoPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ))),
          Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var profile in widget.data.profiles)
                    RichText(
                        text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: "${profile.name} \t\t\tClick for more",
                          //style: defaultStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (BuildContext context) {
                                    return ProfileDetailPage(profile);
                                  },
                                ),
                              );
                            })
                    ])),
                  /* Text(
                  //   i.name + "\t\t\t" + i.type,
                  //   textAlign: TextAlign.left,
                  // ),
                  for (var j in widget.data.profiles)
                    IconButton(
                      icon: Icon(
                        Icons.web,
                      ),
                      onPressed: () async {
                        var url = j.social["website"];
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch';
                        }
                      },
                    ),
                  for (var k in widget.data.profiles)
                    IconButton(
                      icon: Icon(
                        Icons.web,
                      ),
                      onPressed: () async {
                        var url = k.social["pinterest"];
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch';
                        }
                      },
                    )
                ],
              )),
          Container(
              padding: EdgeInsets.only(bottom: 25),
              child: Row(
                children: [
                  for (var i in widget.data.profiles)
                    Text(
                      i.social.toString(),
                      textAlign: TextAlign.end,
                    ),
                ],
              )), */
                  Divider(
                    color: Colors.black,
                    thickness: 1.0,
                    height: 0.0,
                    indent: 15.0,
                    endIndent: 15.0,
                  ),
                ],
              )),
          Container(
              padding: EdgeInsets.all(25),
              child: Row(
                children: [
                  for (var i in widget.data.profiles) Text(i.social.toString())
                ],
              )),
          Divider(
            color: Colors.black,
            thickness: 1.0,
            height: 0.0,
            indent: 15.0,
            endIndent: 15.0,
          ),
        ],
      ),
    );
  }
}
