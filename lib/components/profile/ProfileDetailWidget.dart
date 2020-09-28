import 'package:artsideout_app/components/common/PlatformSvg.dart';
import 'package:artsideout_app/constants/PlaceholderConstants.dart';
import 'package:artsideout_app/models/Profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:artsideout_app/components/profile/SocialCard.dart';

// TODO Fix Styling
class ProfileDetailWidget extends StatefulWidget {
  final Profile profile;

  ProfileDetailWidget(this.profile);

  @override
  _ProfileDetailWidgetState createState() => _ProfileDetailWidgetState();
}

class _ProfileDetailWidgetState extends State<ProfileDetailWidget> {
  List<String> socials = List<String>();
//move title to widget
  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, children: <Widget>[
      Column(children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 25, bottom: 25),
          alignment: Alignment.center,
          child: SelectableText(widget.profile.name,
              style:
                  TextStyle(backgroundColor: Colors.transparent, fontSize: 40)),
        ),
        Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(left: 50, right: 200),
            width: 200.0,
            height: 200.0,
            child: PlatformSvg.asset(
              PlaceholderConstants.PROFILE_IMAGE,
              width: 200,
              height: 200,
            )),
        SelectableText(widget.profile.desc ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            )),
      ]),
      ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: widget.profile.social.length,
          itemBuilder: (context, index) {
            String key = widget.profile.social.keys.elementAt(index);
            return Container(
                child: SocialCard(key, widget.profile.social[key]));
          }),
    ]);
    // ])
  }
}
