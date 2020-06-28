import 'package:artsideout_app/pages/activity/ActivityDetailPage.dart';
import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final String desc;
  final String image;
  final Map<String, String> time;
  final Widget pageButton;

  const ActivityCard({
    Key key,
    this.title,
    this.desc,
    this.time,
    this.image,
    this.pageButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 6, 
      width: MediaQuery.of(context).size.width, 
      margin: EdgeInsets.all(6),
      decoration: BoxDecoration( 
        color: Colors.grey[200], 
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 4,
            spreadRadius: 1,
            color: Colors.grey[500],
          ),
        ],
      ),
      child: InkWell( 
        splashColor: Colors.blue, 
        onTap: () {
          print("owo it wowks");
          // double height = MediaQuery.of(context).size.height / 6; 
          // double width = MediaQuery.of(context).size.width;
          // print("Height of Activity Card: $height px");
          // print("Width of Activity Card: $width px");

          // TODO: Link to Activity Details Page

        },
        child: Row( 
          mainAxisSize: MainAxisSize.min, 
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[ 
            Expanded( 
              child: Align( 
                alignment: Alignment.centerLeft,
                child: Column( 
                  children: <Widget>[ 
                    Expanded(
                      // flex: 3,
                      child: Padding( 
                        padding: EdgeInsets.only(left: 20),
                        child: Text( 
                          time["startTime"],
                          style: TextStyle( 
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Arial Black',
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Expanded( 
                      // flex: 1,
                      child: Padding( 
                        padding: EdgeInsets.only(top: 10),
                        child: Text( 
                          'to'
                        ),
                      ),
                    ),
                    Expanded( 
                      // flex: 2,
                      child: Padding( 
                        padding: EdgeInsets.only(left: 20),
                        child: Text( 
                          time["endTime"],
                          style: TextStyle( 
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Arial Black',
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded( 
              child: Align( 
                alignment: Alignment.centerLeft,
                child: Column( 
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[ 
                    Expanded( 
                      child: Text( 
                        title, 
                        style: TextStyle( 
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Expanded( 
                      child: Text( 
                        // remove placeholder description later
                        desc + 'Description Here', 
                      ),
                    ),
                    Expanded( 
                      child: Icon( 
                        Icons.location_on, 
                        size: 16, 
                        color: Color(0xFFBE4C59),
                      ),
                    ),
                    // temporary Button
                    Expanded( 
                      child: ButtonBar( 
                        children: <Widget>[ 
                          pageButton
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded( 
              child: Align( 
                alignment: Alignment.centerRight,
                child: FittedBox( 
                  child: Image.network(image, width: 200, height: 200),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ],
        ),
      ),
      // child: Card(
      //   color: Colors.transparent,
      //   shape: RoundedRectangleBorder( 
      //     borderRadius: BorderRadius.circular(30),
      //   ),
      //   child: InkWell( 
      //     splashColor: Colors.grey[200],
      //     onTap: () { 
      //       print('owo it works');
      //       print(MediaQuery.of(context).size.height / 4);
      //     },
      //     child: Column(
      //       mainAxisSize: MainAxisSize.min,
      //       children: <Widget>[
      //         Align(
      //           alignment: Alignment.centerRight,
      //           widthFactor: 0.5,
      //           heightFactor: 0.5,
      //           child: FittedBox(
      //             child: Image.network(image, width: 200, height: 200),
      //             fit: BoxFit.fitHeight
      //           )
      //         ),  
      //         ListTile(
      //           leading: Icon( 
      //             Icons.location_on,
      //             size: 32.0,
      //             color: Color(0xFFBE4C59),
      //           ),
      //           title: Text(
      //             title,
      //             style: TextStyle( 
      //               fontSize: 24.0,
      //             )
      //           ),
      //           // remove placeholder subtitle later
      //           subtitle: Text(desc + 'Check it out!'),
      //         ),  
      //         ButtonBar(
      //           children: <Widget>[
      //             pageButton
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
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
    );
  }
}
