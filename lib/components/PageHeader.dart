import 'package:flutter/material.dart';
import 'package:artsideout_app/components/common.dart';

class Header extends StatefulWidget {
  final String image;
  final String textTop;
  final String subtitle;
  const Header({Key key, this.image, this.textTop, this.subtitle})
      : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 20, top: 60, right: 20),
        height: 150,
        decoration: BoxDecoration(color: Color(0xFFFCEAEB)),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0.0,
              right: 0.0,
              child: PlatformSvg.asset(
                widget.image,
                width: 300,
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
            ),
            Positioned(
              top: 10.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("${widget.textTop}",
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(fontWeight: FontWeight.bold)),
                  Text(widget.subtitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontWeight: FontWeight.bold))
                ],
              ),
            ),
          ],
        ));
  }
}
