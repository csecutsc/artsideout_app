import 'package:artsideout_app/models/ASOCardInfo.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/NavigationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:artsideout_app/components/common/PlatformSvg.dart';
import 'package:url_launcher/url_launcher.dart';

class ASOCard extends StatefulWidget {
  final ASOCardInfo asoCardInfo;
  final bool isBigCard;

  ASOCard(this.asoCardInfo, this.isBigCard);

  @override
  _ASOCardState createState() => _ASOCardState();
}

class _ASOCardState extends State<ASOCard> {
  Widget build(BuildContext context) {
    final NavigationService _navigationService =
        serviceLocator<NavigationService>();
    return GestureDetector(
        onTap: () {
          (widget.asoCardInfo.altUrl != null)
              ? launch(widget.asoCardInfo.altUrl)
              : ((widget.asoCardInfo.itemId != null)
                  ? _navigationService.navigateToWithId(
                      widget.asoCardInfo.route, widget.asoCardInfo.itemId)
                  : _navigationService.navigateTo(widget.asoCardInfo.route));
        },
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              color: widget.asoCardInfo.color,
              child: Stack(
                children: <Widget>[
                  PlatformSvg.asset(
                    widget.asoCardInfo.imgUrl,
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                  new Align(
                      alignment: Alignment(-0.8, 0.8),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(widget.asoCardInfo.title,
                            maxLines: 3,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(shadows: [
                              Shadow(
                                  // bottomLeft
                                  offset: Offset(-1.0, -1.0),
                                  color: Colors.white),
                              Shadow(
                                  // bottomRight
                                  offset: Offset(1.0, -1.0),
                                  color: Colors.white),
                              Shadow(
                                  // topRight
                                  offset: Offset(1.0, 1.0),
                                  color: Colors.white),
                              Shadow(
                                  // topLeft
                                  offset: Offset(-1.0, 1.0),
                                  color: Colors.white),
                            ], color: Colors.black87)),
                      )),
                ],
              ),
            )));
  }
}
