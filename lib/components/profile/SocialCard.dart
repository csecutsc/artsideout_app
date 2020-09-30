import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialCard extends StatelessWidget {
  final String socialName;
  final String urlToSocial;

  const SocialCard(
    this.socialName,
    this.urlToSocial,
  );

  Widget generateIcon(String name, double iconSize) {
    switch (name.toLowerCase()) {
      case "facebook":
        return Icon(MdiIcons.facebook, size: iconSize);
      case "instagram":
        return Icon(MdiIcons.instagram, size: iconSize);
      case "pinterest":
        return Icon(MdiIcons.pinterest, size: iconSize);
      case "youtube":
        return Icon(MdiIcons.youtube, size: iconSize);
      case "etsy":
        return ImageIcon(NetworkImage("assets/assets/icons/etsy.webp"),
            size: iconSize);
      default:
        return Icon(MdiIcons.web, size: iconSize);
    }
  }

  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: GestureDetector(
          child: SizedBox(
            width: 100,
            child: Card(
              color: Color(0xFFF9EBEB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(18),
                leading: CircleAvatar(
                    backgroundColor: ColorConstants.PRIMARY,
                    radius: 25.0,
                    child: ClipOval(
                      child: generateIcon(this.socialName, 30.0),
                    )),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                        (this.socialName.toLowerCase() == "email")
                            ? this.urlToSocial
                            : this.socialName,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.pink, fontSize: 18.0))
                  ],
                ),
              ),
            ),
          ),
          onTap: () async {
            print(urlToSocial);
            var url = urlToSocial.toLowerCase();
            if (this.socialName.toLowerCase() == "email") {
              url = "mailto:" + url;
            } else if (!url.startsWith("http")) {
              url = "http://" + url;
            }
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch';
            }
          },
        ));
  }
}
