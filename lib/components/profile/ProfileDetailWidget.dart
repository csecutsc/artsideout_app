import 'package:artsideout_app/components/art/ArtListCard.dart';
import 'package:artsideout_app/components/search/FetchResultCard.dart';
import 'package:artsideout_app/constants/ASORouteConstants.dart';
import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/constants/DisplayConstants.dart';
import 'package:artsideout_app/constants/PlaceholderConstants.dart';
import 'package:artsideout_app/models/Profile.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/DisplayService.dart';
import 'package:artsideout_app/services/NavigationService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:artsideout_app/components/profile/SocialCard.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

// TODO Fix Styling
class ProfileDetailWidget extends StatefulWidget {
  final Profile profile;
  final bool expandedScreen;

  ProfileDetailWidget(this.profile, {this.expandedScreen = false});

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
    DisplaySize _displaySize = serviceLocator<DisplayService>().displaySize;
    int width = MediaQuery.of(context).size.width.toInt();
    return Scaffold(
        backgroundColor: ColorConstants.PREVIEW_SCREEN,
        body: LayoutBuilder(builder: (context, constraints) {
          return MediaQuery.removePadding(
              context: context,
              child: ListView(shrinkWrap: true, children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 25, bottom: 25),
                  alignment: Alignment.center,
                  child: Title(
                      title: widget.profile.name,
                      color: Colors.black,
                      child: SelectableText(widget.profile.name,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline4)),
                ),
                Container(
                    alignment: Alignment.center,
                    height: 300.0,
                    child: Image.network(
                      widget.profile.profilePic,
                      height: 400,
                    )),
                (_displaySize == DisplaySize.LARGE ||
                            _displaySize == DisplaySize.MEDIUM) &&
                        !widget.expandedScreen
                    ? RaisedButton(
                        child: Text("CLICK TO VIEW FULL PAGE",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Colors.white)),
                        textColor: Colors.white70,
                        color: ColorConstants.PRIMARY,
                        onPressed: () {
                          _navigationService.navigateToWithId(
                              ASORoutes.PROFILES, widget.profile.id);
                        })
                    : Container(),
                SizedBox(
                  height: 10.0,
                ),
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
                          onTapLink: (url) async{
                            if (!url.startsWith("http")) {
                              url = "http://" + url;
                            }
                            if (await canLaunch(url)) {
                            await launch(url);
                            } else {
                            throw 'Could not launch';
                            }
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
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: widget.profile.social.length,
                    physics: new NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      String key = widget.profile.social.keys.elementAt(index);
                      return Container(
                          child: SocialCard(key, widget.profile.social[key]));
                    }),
                (widget.profile.installations.length != 0)
                    ? Column(children: [
                        ListTile(
                          leading: SelectableText('Installations',
                              style: Theme.of(context).textTheme.headline5),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          cacheExtent: 200,
                          physics: new NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                (widget.expandedScreen) ? width ~/ 200 : 2,
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
                              child:
                                  fetchResultCard.getCard("Installation", item),
                              onTap: () {
                                _navigationService.navigateToWithId(
                                    ASORoutes.INSTALLATIONS, item.id);
                              },
                            );
                          },
                        )
                      ])
                    : Container(),
                (widget.profile.activities.length != 0)
                    ? Column(children: [
                        ListTile(
                          leading: SelectableText('Performances & Workshops',
                              style: Theme.of(context).textTheme.headline5),
                        ),
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          cacheExtent: 200,
                          addAutomaticKeepAlives: true,
                          physics: new NeverScrollableScrollPhysics(),
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
                      ])
                    : Container(),
                (widget.profile.markets.length != 0)
                    ? Column(children: [
                        ListTile(
                          leading: SelectableText('Art Market',
                              style: Theme.of(context).textTheme.headline5),
                        ),
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          cacheExtent: 200,
                          addAutomaticKeepAlives: true,
                          physics: new NeverScrollableScrollPhysics(),
                          // Let the ListView know how many items it needs to build.
                          itemCount: widget.profile.markets.length,
                          // Provide a builder function. This is where the magic happens.
                          // Convert each item into a widget based on the type of item it is.
                          itemBuilder: (context, index) {
                            final item = widget.profile.markets[index];

                            return GestureDetector(
                              child: ArtListCard(
                                  title: item.title,
                                  artist: item.profiles
                                      .map((profile) => profile.name ?? "")
                                      .toList()
                                      .join(", "),
                                  image: item.images[0]),
                              onTap: () {
                                _navigationService.navigateToWithId(
                                    ASORoutes.MARKETS, item.id);
                              },
                            );
                          },
                        )
                      ])
                    : Container()
              ]));
        }));
    // ])
  }
}
