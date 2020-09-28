import 'package:artsideout_app/constants/ColorConstants.dart';
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Positioned(
        //   top: 0.0,
        //   right: 0.0,
        //   child: PlatformSvg.asset(
        //     widget.image,
        //     width: 300,
        //     fit: BoxFit.fitWidth,
        //     alignment: Alignment.topCenter,
        //   ),
        // ),
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
                          style: Theme.of(context).textTheme.headline3))),
              SelectableText(widget.subtitle,
                  maxLines: 3, style: Theme.of(context).textTheme.headline5)
            ],
          ),
        ),
      ],
    );
  }
}
