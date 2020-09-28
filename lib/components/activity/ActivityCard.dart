// import 'package:artsideout_app/pages/activity/ActivityDetailPage.dart';
// import 'dart:async';
import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final String desc;
  final Map<String, String> image;
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
      return TimeOfDay.fromDateTime(DateTime.parse(startTimeGiven))
          .format(context);
    }
  }

  String endTimeDisplay(String endTimeGiven, BuildContext context) {
    if (endTimeGiven == "") {
      return "";
    } else {
      return TimeOfDay.fromDateTime(DateTime.parse(endTimeGiven))
          .format(context);
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
      //height: 125.0,
      height: 130,
      width: 250,
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
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: SizedBox(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0, top: 9.0),
                        child: Text(
                          startTimeDisplay(time["startTime"], context),
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16.0,
                            fontFamily: 'Roboto',
                            color: ColorConstants.PRIMARY,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                      child: Divider(
                        color: Color(0xFFBE4C59),
                        thickness: 1.0,
                        indent: 45.0,
                        endIndent: 30.0,
                      )),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: SizedBox(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0, bottom: 9.0),
                        child: Text(
                          endTimeDisplay(time["endTime"], context),
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16.0,
                            fontFamily: 'Roboto',
                            color: ColorConstants.PRIMARY,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
          ),
          Expanded(
            flex: 8,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.PRIMARY,
                    ),
                  ),
                ),
                Container(
                  // TODO: ELLIPSIS BELOW NOT WORKING PROPERLY, possibly Flutter bug?
                  padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    displayDesc(desc),
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Color(0xFFBE4C59),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    softWrap: true,
                    textAlign: TextAlign.left,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 5.0, bottom: 15.0, top: 3.0),
                      alignment: Alignment.topLeft,
                      child: Icon(
                        Icons.person,
                        size: 14.0,
                        color: Color(0xFFBE4C59),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 5.0, right: 20.0, bottom: 10.0, top: 3.0),
                      alignment: Alignment.topLeft,
                      child: Text(
                        displayZone(zone),
                        style: TextStyle(
                          fontSize: 14.0,
                          color: ColorConstants.PRIMARY,
                        ),
                        overflow: TextOverflow.clip,
                        maxLines: 3,
                        softWrap: true,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
