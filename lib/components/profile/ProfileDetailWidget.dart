import 'package:artsideout_app/graphql/Profile.dart';
import 'package:artsideout_app/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
        margin: EdgeInsets.all(0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(20),
                width: 450.0,
                height: 200.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage("https://via.placeholder.com/350x150"),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
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
              ),
              /*ListView.builder(
                itemCount: widget.profile.social.keys.length,
                itemBuilder: null)*/
              ListView(children: <Widget>[
                for (var key in widget.profile.social.keys)
                  Container(
                    margin: EdgeInsets.only(
                        left: 20, top: 30, right: 20, bottom: 30),
                    child: ListTile(
                        leading: IconButton(
                          icon: Icon(MdiIcons.web),
                          onPressed: () async {
                            var socialLink = widget.profile.social["$key"];
                            if (await canLaunch(socialLink)) {
                              await launch(socialLink);
                            } else {
                              throw 'Could not launch';
                            }
                          },
                        ),
                        title: Text((widget.profile.social["$key"] != "")
                            ? "Click the icon to see this person's $key"
                            : "This person has not added their $key information")),
                  )
              ]),
            ]));
  }
}
