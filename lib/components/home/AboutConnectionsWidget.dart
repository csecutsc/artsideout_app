import 'package:artsideout_app/components/common/PlatformSvg.dart';
import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/constants/PlaceholderConstants.dart';
import 'package:artsideout_app/models/Profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:artsideout_app/components/profile/SocialCard.dart';

// TODO Fix Styling
class AboutConnectionsWidget extends StatefulWidget {
  @override
  _AboutConnectionsWidgetState createState() => _AboutConnectionsWidgetState();
}

class _AboutConnectionsWidgetState extends State<AboutConnectionsWidget> {
  List<String> socials = List<String>();
//move title to widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.PREVIEW_SCREEN,
        body: ListView(shrinkWrap: true, children: <Widget>[
          Column(children: <Widget>[
            Text("ARTSIDEOUT 2020: Connections"),
            Divider(
              color: Color(0xFFBE4C59),
              thickness: 1.0,
              indent: 45.0,
              endIndent: 30.0,
            ),
            Text("blah Blah"),
            Text("Sponsors"),
            Divider(
              color: Color(0xFFBE4C59),
              thickness: 1.0,
              indent: 45.0,
              endIndent: 30.0,
            ),
            Text("Partners"),
            Divider(
              color: Color(0xFFBE4C59),
              thickness: 1.0,
              indent: 45.0,
              endIndent: 30.0,
            ),
            Text("Partners"),
            Text("Special Thanks to the Following Developers"),
            Divider(
              color: Color(0xFFBE4C59),
              thickness: 1.0,
              indent: 45.0,
              endIndent: 30.0,
            ),
          ]),
        ]));
    // ])
  }
}
