import 'package:artsideout_app/components/search/FetchResultCard.dart';
import 'package:artsideout_app/constants/ASORouteConstants.dart';
import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/constants/PlaceholderConstants.dart';
import 'package:artsideout_app/models/Profile.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/NavigationService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:artsideout_app/components/profile/SocialCard.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

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
    FetchResultCard fetchResultCard = new FetchResultCard();
    NavigationService _navigationService = serviceLocator<NavigationService>();
    return Scaffold(
        backgroundColor: ColorConstants.PREVIEW_SCREEN,
        body: ListView(shrinkWrap: true, children: <Widget>[
          Column(children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 25, bottom: 25),
              alignment: Alignment.center,
              child: Title(
                  title: widget.profile.name,
                  color: Colors.black,
                  child: SelectableText(widget.profile.name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline5)),
            ),
            Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(left: 50, right: 200),
                width: 200.0,
                height: 200.0,
                child: Image.network(
                  PlaceholderConstants.PROFILE_IMAGE,
                  width: 200,
                  height: 200,
                )),
            Container(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 16.0,
                  ),
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.only(bottom: 14.0),
                    child: MarkdownBody(
                      selectable: true,
                      data: widget.profile.desc,
                      onTapLink: (url) {
                        launch(url);
                      },
                      styleSheet:
                          MarkdownStyleSheet.fromTheme(Theme.of(context))
                              .copyWith(
                                  p: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(fontSize: 16.0)),
                    ),
                  )),
                ],
              ),
            ),
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
          (widget.profile.installations.length != 0)
              ? GridView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  cacheExtent: 200,
                  addAutomaticKeepAlives: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                  ),
                  // Let the ListView know how many items it needs to build.
                  itemCount: widget.profile.installations.length,
                  // Provide a builder function. This is where the magic happens.
                  // Convert each item into a widget based on the type of item it is.
                  itemBuilder: (context, index) {
                    final item = widget.profile.installations[index];

                    return GestureDetector(
                      child: fetchResultCard.getCard("Installation", item),
                      onTap: () {
                        _navigationService.navigateToWithId(
                            ASORoutes.INSTALLATIONS, item.id);
                      },
                    );
                  },
                )
              : Container(),
          (widget.profile.activities.length != 0)
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  cacheExtent: 200,
                  addAutomaticKeepAlives: true,
                  // Let the ListView know how many items it needs to build.
                  itemCount: widget.profile.activities.length,
                  // Provide a builder function. This is where the magic happens.
                  // Convert each item into a widget based on the type of item it is.
                  itemBuilder: (context, index) {
                    final item = widget.profile.activities[index];

                    return GestureDetector(
                      child: fetchResultCard.getCard("Activity", item),
                      onTap: () {
                        _navigationService.navigateToWithId(
                            ASORoutes.ACTIVITIES, item.id);
                      },
                    );
                  },
                )
              : Container()
        ]));
    // ])
  }
}
