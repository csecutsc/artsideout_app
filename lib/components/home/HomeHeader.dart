import 'package:artsideout_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:artsideout_app/components/common.dart';

class Header extends StatefulWidget {
  final String image;
  final String textTop;
  final String textBottom;
  final String subtitle;
  final double offset;
  const Header(
      {Key key,
      this.image,
      this.textTop,
      this.textBottom,
      this.subtitle,
      this.offset})
      : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        //padding: EdgeInsets.only(left: 20, top: 60, right: 20),
        height: 20,
        width: double.infinity,
//        decoration: widget.isLargeScreen
//            ? null
//            : BoxDecoration(
//                gradient: LinearGradient(
//                  begin: Alignment.topRight,
//                  end: Alignment.bottomLeft,
//                  colors: [
//                    Color(0xFFE5549B),
//                    Color(0xfff30075),
//                  ],
//                ),
//              ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: (widget.offset < 0) ? 0 : widget.offset,
                    child: PlatformSvg.asset(
                      widget.image,
                      width: 1200, //300,
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topLeft,
                    ),
                  ),
                  Positioned(
                    top: 20 - widget.offset / 2,
                    left: 20 - widget.offset / 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("${widget.textTop} \n${widget.textBottom}",
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: asoPrimary)),
                        Text(widget.subtitle,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
