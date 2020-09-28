import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

const double ICON_SIZE = 26;

class ProfileCard extends StatelessWidget {
  final String name;
  final String profileType;
  final String desc;
  final Map<String, String> socials;

  const ProfileCard(
      {Key key, this.name, this.profileType, this.desc, this.socials})
      : super(key: key);

  Widget getIcon(String socialName) {
    switch (socialName) {
      case "facebook":
        {
          return Icon(
            MdiIcons.facebook,
            size: ICON_SIZE,
            color: Color(0xFF3b5998),
          );
        }
        break;
      case "instagram":
        {
          return Icon(
            MdiIcons.instagram,
            size: ICON_SIZE,
            color: Color(0xFFE1306C),
          );
        }
        break;
      case "pinterest":
        {
          return Icon(
            MdiIcons.pinterest,
            size: ICON_SIZE,
            color: Color(0xFFE60023),
          );
        }
        break;
      default:
        {
          return Icon(MdiIcons.web, size: ICON_SIZE);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      color: Color(0xFFffcccc), //Color(0xFFF9EBEB),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Center(
              child: ClipPath(
                clipper: MyClipper(),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: ColorConstants.PRIMARY,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 60,
                        height: 60,
                        padding: const EdgeInsets.all(2.0), // borde width
                        decoration: new BoxDecoration(
                          color: const Color(0xFFFFFFFF), // border color
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(
                              'http://lorempixel.com/400/200/animals'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                        color: Color(0xFFBE4C59),
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      profileType,
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 11.0,
                      ),
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: socials.length,
                          itemBuilder: (context, index) {
                            String socialName = socials.keys.elementAt(index);
                            String url = socials[socialName];
                            return GestureDetector(
                              child: getIcon(socialName),
                              onTap: () async {
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch';
                                }
                              },
                            );
                          })),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, size.height * 0.25);
    path.quadraticBezierTo(
        size.width / 2.5, size.height / 0.75, size.width, size.height * 0.50);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
