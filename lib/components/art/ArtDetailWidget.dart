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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(10, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Container(
              width: 450,
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(widget.data.imgUrl),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.pink,
              radius: 25.0,
            ),
            title: Text(
              'John Appleseed',
            ),
            trailing: IconButton(
              icon: Icon(Icons.bookmark),
              color: asoPrimary,
              onPressed: () {},
            ),
          ),
          ListTile(
            leading: Text(
              widget.data.zone,
              style: TextStyle(
                color: asoPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
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
                  child: Text(widget.data.desc),
                ),
              ],
            ),
          ),
        ],
      ),
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
