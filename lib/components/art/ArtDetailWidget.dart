import 'package:artsideout_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:artsideout_app/graphql/Installation.dart';

class ArtDetailWidget extends StatefulWidget {
  final Installation data;

  ArtDetailWidget(this.data);

  @override
  _ArtDetailWidgetState createState() => _ArtDetailWidgetState();
}

class _ArtDetailWidgetState extends State<ArtDetailWidget> {
  bool isMarked = false;

  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.data.imgUrl),
              ),
            ),
            height: 330,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.white,
                  Colors.white,
//                  Color(0xFFfaa2d3),
//                  Color(0xFFed79b9),
//                  asoSecondary,
                ],
              ),
            ),
            height: MediaQuery.of(context).size.height - 330,
          ),
        ),
        Positioned(
          top: 285,
          right: 10,
          left: 10,
          child: Card(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 15.0,
                  ),
                  ListTile(
                    title: Text(
                      widget.data.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    trailing: IconButton(
                      icon: isMarked == true
                          ? Icon(
                              Icons.bookmark,
                              size: 28,
                            )
                          : Icon(
                              Icons.bookmark_border,
                              size: 28,
                            ),
                      color: asoPrimary,
                      onPressed: () {
                        setState(() {
                          isMarked = isMarked == false ? true : false;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 13.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Icon(
                            Icons.location_on,
                            size: 16.0,
                            color: Color(0xFFBE4C59),
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            '  ' + widget.data.zone,
                            style: TextStyle(
                              color: Color(0xFFBE4C59),
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.pink,
                      radius: 20.0,
                    ),
                    title: Text(
                      'John Appleseed',
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 1.0,
                    height: 0,
                    indent: 15,
                    endIndent: 20,
                  ),
                  ListTile(
                    leading: Text(
                      'OVERVIEW',
                      style: TextStyle(
                        color: asoPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 16.0,
                        ),
                        Flexible(
                          child: Text(
                            widget.data.desc,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
//      child: Container(
////        decoration: BoxDecoration(
////          color: Colors.white,
////          // borderRadius: BorderRadius.circular(25),
////          boxShadow: [
////            BoxShadow(
////              color: Colors.grey.withOpacity(0.5),
////              spreadRadius: 5,
////              blurRadius: 7,
////              offset: Offset(10, 3),
////            ),
////          ],
////        ),
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.start,
//          children: <Widget>[
//            Card(
////              shape: RoundedRectangleBorder(
////                borderRadius: BorderRadius.circular(25.0),
////              ),
//              child: Container(
//                width: double.infinity,
//                height: 330,
//                decoration: BoxDecoration(
//                  image: DecorationImage(
//                    fit: BoxFit.cover,
//                    image: NetworkImage(widget.data.imgUrl),
//                  ),
//                ),
//              ),
//            ),
//            SizedBox(
//              height: 15.0,
//            ),
//            ListTile(
//              leading: CircleAvatar(
//                backgroundColor: Colors.pink,
//                radius: 25.0,
//              ),
//              title: Text(
//                'John Appleseed',
//              ),
//              trailing: IconButton(
//                icon: isMarked == true
//                    ? Icon(Icons.bookmark)
//                    : Icon(Icons.bookmark_border),
//                color: asoPrimary,
//                onPressed: () {
//                  setState(() {
//                    isMarked = isMarked == false ? true : false;
//                  });
//                },
//              ),
//            ),
//            ListTile(
//              leading: Text(
//                widget.data.zone,
//                style: TextStyle(
//                  color: asoPrimary,
//                  fontWeight: FontWeight.bold,
//                  fontSize: 18.0,
//                ),
//              ),
//            ),
//            Divider(
//              color: Colors.black,
//              thickness: 1.0,
//              height: 0,
//              indent: 15,
//              endIndent: 20,
//            ),
//            ListTile(
//              leading: Text(
//                'OVERVIEW',
//                style: TextStyle(
//                  color: asoPrimary,
//                  fontWeight: FontWeight.bold,
//                  fontSize: 18.0,
//                ),
//              ),
//            ),
//            Container(
//              child: Row(
//                children: <Widget>[
//                  SizedBox(
//                    width: 16.0,
//                  ),
//                  Flexible(
//                    child: Text(widget.data.desc),
//                  ),
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
  }
}
