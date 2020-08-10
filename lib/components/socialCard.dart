import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:artsideout_app/theme.dart';

class SocialCard extends StatelessWidget {
  final String socialName;
  final String urlToSocial;

  const SocialCard(
    this.socialName,
    this.urlToSocial,
  );

  Text formattedSocialName(String socialName) {
    return Text(socialName,
        textAlign: TextAlign.center,
        style: TextStyle(backgroundColor: Colors.pink, fontSize: 30.0));
  }

  Icon generateIcon(String name, double iconSize) {
    switch (name) {
      case "facebook":
        {
          return Icon(MdiIcons.facebook, size: iconSize);
        }
        break;
      case "instagram":
        {
          return Icon(MdiIcons.instagram, size: iconSize);
        }
        break;
      case "pinterest":
        {
          return Icon(MdiIcons.pinterest, size: iconSize);
        }
        break;
      default:
        {
          return Icon(MdiIcons.web, size: iconSize);
        }
        break;
    }
  }

  Widget build(BuildContext context) {
    return Container(
        // color: Colors.red[200],
        margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
        child: InkResponse(
          child: SizedBox(
              width: 300,
              child: Card(
                  color: Colors.red[200],
                  child: Stack(
                      alignment: AlignmentDirectional.centerStart,
                      children: <Widget>[
                        Positioned(
                            child: generateIcon(socialName,
                                MediaQuery.of(context).size.height / 10)),
                        Positioned(
                            left: MediaQuery.of(context).size.height / 5,
                            child: Text(socialName.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.black)))
                      ]))),
          onTap: () async {
            if (await canLaunch(urlToSocial)) {
              await launch(urlToSocial);
            } else {
              throw 'Could not launch';
            }
          },
        ));
  }
}
