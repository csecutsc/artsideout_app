import 'package:flutter/material.dart';

class ArtListCard extends StatelessWidget {
  final String title;
  final String artist;
  final String image;
  final Widget pageButton;

  const ArtListCard({
    Key key,
    this.title,
    this.artist,
    this.image,
    this.pageButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Container(
        color: Color(0xFFFBE6E5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 10,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: NetworkImage(image),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Color(0xFFBE4C59),
                          fontSize: 15.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                            '  ' + artist,
                            style: TextStyle(
                              color: Color(0xFFBE4C59),
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Stack(
        //   children: <Widget>[
        //     Positioned(
        //       bottom: 0,
        //       left: 0,
        //       right: 0,
        //       child: Container(
        //         height: 221,
        //         decoration: BoxDecoration(
        //           color: Colors.white,
        //           borderRadius: BorderRadius.circular(29),
        //           boxShadow: [
        //             BoxShadow(
        //               offset: Offset(0, 10),
        //               blurRadius: 33,
        //               color: Colors.grey,
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //     Image.network(image, height:200,width: 150),
        //     Positioned(
        //       top: 35,
        //       right: 10,
        //       child: Column(
        //         children: <Widget>[
        //           IconButton(
        //             icon: Icon(
        //               Icons.favorite_border,
        //             ),
        //             onPressed: () {},
        //           ),
        //         ],
        //       ),
        //     ),
        //     Positioned(
        //       top: 160,
        //       child: Container(
        //         height: 85,
        //         width: 202,
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: <Widget>[
        //             Padding(
        //               padding: EdgeInsets.only(left: 24),
        //               child: RichText(
        //                 maxLines: 2,
        //                 text: TextSpan(
        //                   style: TextStyle(color: Colors.black),
        //                   children: [
        //                     TextSpan(
        //                       text: "$title\n",
        //                       style: TextStyle(
        //                         fontWeight: FontWeight.bold,
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //             Spacer(),
        //             pageButton
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
