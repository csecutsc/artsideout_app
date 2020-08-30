// import 'package:artsideout_app/pages/activity/ActivityDetailPage.dart';
// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:artsideout_app/theme.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final String desc;
  final String image;
  final Map<String, String> time;
  final String zone;
  final Widget detailPageButton;
  // final Widget pageButton;

  const ActivityCard({
    Key key,
    this.title,
    this.desc,
    this.time,
    this.image,
    this.zone,
    this.detailPageButton,
    // this.pageButton,
  }) : super(key: key);

  String startTimeDisplay(String startTimeGiven, BuildContext context) {
    if (startTimeGiven == "") {
      return "ALL DAY";
    } else {
      return TimeOfDay.fromDateTime(DateTime.parse(startTimeGiven)).format(context);
    }
  }

  String endTimeDisplay(String endTimeGiven, BuildContext context) {
    if (endTimeGiven == "") {
      return "";
    } else {
      return TimeOfDay.fromDateTime(DateTime.parse(endTimeGiven)).format(context);
    }
  }

  String displayDesc(String desc) {
    if (desc == "") {
      return "No Description available.";
    }
    return desc;
  }

  String displayZone(String zone) {
    if (zone == null) {
      return "Unknown Zone";
    }
    return zone;
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 6, 
      width: MediaQuery.of(context).size.width, 
      margin: EdgeInsets.all(7),
      decoration: BoxDecoration(  
        color: Colors.white, 
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 1,
            spreadRadius: 1,
            color: Colors.grey[500],
          ),
        ],
      ),
      child: Stack( 
        children: <Widget>[
          Row( 
            children: <Widget>[ 
              Expanded( 
                flex: 3,
                child: Column(
                    children: <Widget>[
                      Padding( 
                        padding: EdgeInsets.only(left: 20.0, top: 10.0), 
                        child: Text( 
                          startTimeDisplay(time["startTime"], context),
                          style: TextStyle( 
                            fontWeight: FontWeight.w900,  
                            fontSize: 25.0,
                            fontFamily: 'Roboto',
                            color: asoPrimary,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Divider(
                          color: Color(0xFFBE4C59),
                          thickness: 1.0,
                          indent: 45.0,
                          endIndent: 30.0,
                        )
                      ),
                      // "to" divider

                      // Padding( 
                      //   padding: EdgeInsets.all(10.0),
                      //   child: Text(
                      //     to(time["startTime"]),
                      //     textAlign: TextAlign.center,
                      //     style: TextStyle( 
                      //       fontSize: 16.0,
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   )
                      // ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
                        child: Text( 
                          endTimeDisplay(time["endTime"], context),
                          style: TextStyle( 
                            fontWeight: FontWeight.w900,  
                            fontSize: 25.0,
                            fontFamily: 'Roboto',
                            color: asoPrimary,
                          ),
                        ),
                      ),
                  ]
                ),
              ),
              Expanded( 
                flex: 7,
                child: Column(
                  children: <Widget>[
                    Expanded( 
                      flex: 30,
                      child: Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                        child: Text( 
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle( 
                            fontSize: 24.0, 
                            fontWeight: FontWeight.bold,
                            color: asoPrimary,
                          ),
                        ),
                      ),
                    ),
                    Expanded( 
                      flex: 45,
                      child: Container( 
                        // TODO: ELLIPSIS BELOW NOT WORKING PROPERLY, possibly Flutter bug?
                        padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                        alignment: Alignment.topLeft,
                        // testing purposes
                        // width: 300,
                        // height: 85,
                        // width: MediaQuery.of(context).size.width*0.7,
                        // height: MediaQuery.of(context).size.height*0.5,
                        // color: Colors.green[200],
                        //
                        child: Text(
                          displayDesc(desc),
                          style: TextStyle( 
                            fontSize: 14.0,
                            color: Color(0xFFBE4C59),
                          ),
                          overflow: TextOverflow.clip,
                          maxLines: 3,
                          softWrap: true,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Expanded( 
                      flex: 25, 
                      child: Row(
                        children: <Widget>[
                          Container( 
                            padding: EdgeInsets.only(left: 20.0, right: 5.0, bottom: 15.0, top: 3.0),
                            alignment: Alignment.topLeft,
                            child: Icon(
                              Icons.location_on,
                              size: 23.0,
                              color: Color(0xFFBE4C59),
                            ),
                          ),
                          Container( 
                            padding: EdgeInsets.only(left: 5.0, right: 20.0, bottom: 10.0, top: 3.0),
                            alignment: Alignment.topLeft,
                            child: Text( 
                              displayZone(zone),
                              style: TextStyle( 
                                fontSize: 18.0,
                                color: asoPrimary,
                              ),
                              overflow: TextOverflow.clip,
                              maxLines: 3,
                              softWrap: true,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Icon(
                    //       Icons.location_on,
                    //       size: 16.0,
                    //       color: Color(0xFFBE4C59),
                    //     ),
                    //     FittedBox(
                    //       fit: BoxFit.fitWidth,
                    //       child: Text(
                    //         '  ' + zone,
                    //         style: TextStyle(
                    //           color: asoPrimary,
                    //           fontWeight: FontWeight.w500,
                    //           fontSize: 16.0,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          ),
          Material( 
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30), 
            child: detailPageButton,
          ),
        ],
      ),
    );
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
  }
}
