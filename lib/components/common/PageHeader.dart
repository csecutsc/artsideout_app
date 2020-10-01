import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/constants/DisplayConstants.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/DisplayService.dart';
import 'package:flutter/material.dart';

class PageHeader extends StatefulWidget {
  final String textTop;
  final String subtitle;
  const PageHeader({Key key, this.textTop, this.subtitle}) : super(key: key);

  @override
  _PageHeaderState createState() => _PageHeaderState();
}

class _PageHeaderState extends State<PageHeader> {
  static const WEB_TITLE = "ASO2020";
  DisplaySize _displaySize = serviceLocator<DisplayService>().displaySize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 10.0,
          right: 0.0,
          bottom: 0.0,
          top: 10.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Title(
                      title: "$WEB_TITLE | ${widget.textTop.toUpperCase()}",
                      color: ColorConstants.PRIMARY,
                      child: SelectableText("${widget.textTop.toUpperCase()}",
                          style: (_displaySize == DisplaySize.SMALL)
                              ? Theme.of(context).textTheme.headline3
                              : Theme.of(context).textTheme.headline2))),
              SelectableText(widget.subtitle,
                  maxLines: 3,
                  style:  (_displaySize == DisplaySize.SMALL)?
                  Theme.of(context)
                      .textTheme
                      .bodyText1.copyWith(fontWeight: FontWeight.bold)
                  : Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: Colors.black87))
            ],
          ),
        ),
      ],
    );
  }
}
