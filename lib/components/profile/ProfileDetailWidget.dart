import 'package:artsideout_app/graphql/Profile.dart';
import 'package:artsideout_app/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:artsideout_app/components/common.dart';
import 'package:artsideout_app/components/socialCard.dart';

class ProfileDetailWidget extends StatefulWidget {
  final Profile profile;

  ProfileDetailWidget(this.profile);

  @override
  _ProfileDetailWidgetState createState() => _ProfileDetailWidgetState();
}

class _ProfileDetailWidgetState extends State<ProfileDetailWidget> {
  List<String> socials = List<String>();
//move titlie to wiget
  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 50, right: 200),
            width: 200.0,
            height: 200.0,
            child: PlatformSvg.asset(
              "assets/icons/profilePlaceholder.svg",
              width: 200,
              height: 200,
            )),
        Container(
          padding: EdgeInsets.all(10),
          height: 200,
          width: 300,
          child: Text(widget.profile.desc,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              )),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.pinkAccent,
            borderRadius: BorderRadius.circular(15),
          ),
        )
      ]),
      ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: widget.profile.social.length,
          itemBuilder: (context, index) {
            String key = widget.profile.social.keys.elementAt(index);
            return Container(
                child: SocialCard(key, widget.profile.social[key]));
          }
          /*(context, key) {
          final socialItem = widget.profile.social["$key"]
        }*/
          ),
      // ListView.builder(
      //     scrollDirection: Axis.vertical,
      //     shrinkWrap: true,
      //     itemCount: socials.length,
      //     itemBuilder: (context, index) {
      //       return Container(
      //         margin: EdgeInsets.only(
      //             left: 20, top: 30, right: 20, bottom: 30),
      //         child: ListTile(
      //             leading: IconButton(
      //               icon: Icon(MdiIcons.web),
      //               onPressed: () async {
      //                 var socialLink =
      //                     widget.profile.social[socials[index]];
      //                 if (await canLaunch(socialLink)) {
      //                   await launch(socialLink);
      //                 } else {
      //                   throw 'Could not launch';
      //                 }
      //               },
      //             ),
      //             title: Text((widget.profile.social[socials[index]] !=
      //                     "")
      //                 ? "Click the icon to see this person's ${socials[index]}"
      //                 : "This person has not added their ${socials[index]} information")),
      //       );
      //     }),
      //   ListView(children: <Widget>[
    ]);
    // ])
  }
}

Icon generateIcon(String name) {
  switch (name) {
    case "facebook":
      {
        return Icon(MdiIcons.facebook);
      }
      break;
    case "instagram":
      {
        return Icon(MdiIcons.instagram);
      }
      break;
    case "pinterest":
      {
        return Icon(MdiIcons.pinterest);
      }
      break;
    default:
      {
        return Icon(MdiIcons.web);
      }
      break;
  }
}
