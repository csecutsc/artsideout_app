import 'package:artsideout_app/graphql/Profile.dart';
import 'package:artsideout_app/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileDetailWidget extends StatefulWidget {
  final Profile profile;

  ProfileDetailWidget(this.profile);

  @override
  _ProfileDetailWidgetState createState() => _ProfileDetailWidgetState();
}

class _ProfileDetailWidgetState extends State<ProfileDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Text(widget.profile.desc),
          // widget.profile.social.forEach((key, value) => ListTile(
          //     leading: Icon(Icons.web),
          //     title: InkWell(
          //       child: Text("$key"),
          //       onTap: () => launch("$value"),
          //     ))),
          ListTile(
            leading: Icon(Icons.web),
            title: InkWell(
              child: Text((widget.profile.social["instagram"] != null)
                  ? "Website"
                  : "This artist has not added their Instagram information."),
              onTap: () async {
                var instagramLink = widget.profile.social["instagram"];
                if (await canLaunch(instagramLink)) {
                  await launch(instagramLink);
                } else {
                  throw 'Could not launch';
                }
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.web),
            title: InkWell(
              child: Text((widget.profile.social["facebook"] != null)
                  ? "Website"
                  : "This artist has not added their Facebook information."),
              onTap: () async {
                var facebookLink = widget.profile.social["facebook"];
                if (await canLaunch(facebookLink)) {
                  await launch(facebookLink);
                } else {
                  throw 'Could not launch';
                }
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.web),
            title: InkWell(
              child: Text((widget.profile.social["pinterest"] != null)
                  ? "Pinterest"
                  : "This artist has not added their Pinterest information."),
              onTap: () async {
                var pinterestLink = widget.profile.social["pinterest"];
                if (await canLaunch(pinterestLink)) {
                  await launch(pinterestLink);
                } else {
                  throw 'Could not launch';
                }
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.web),
            title: InkWell(
              child: Text((widget.profile.social["website"] != null)
                  ? "Website"
                  : "This artist has not added their Website information."),
              onTap: () async {
                var websiteLink = widget.profile.social["website"];
                if (await canLaunch(websiteLink)) {
                  await launch(websiteLink);
                } else {
                  throw 'Could not launch';
                }
              },
            ),
          ),
        ]));
  }
}
