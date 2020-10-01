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
  final String performanceType;
  final Widget detailPageButton;
  // final Widget pageButton;

  const ActivityCard({
    Key key,
    this.title,
    this.desc,
    this.time,
    this.image,
    this.zone,
    this.performanceType,
    this.detailPageButton,
    // this.pageButton,
  }) : super(key: key);

  String startTimeDisplay(String startTimeGiven, BuildContext context) {
    if (startTimeGiven == "") {
      return "ALL DAY";
    } else {
      return TimeOfDay.fromDateTime(DateTime.parse(startTimeGiven).toLocal())
          .format(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget timeWidget() {
      if (this.time.isNotEmpty || this.time["startTime"].isNotEmpty) {
        String timeText = startTimeDisplay(this.time["startTime"], context);
        if (!(timeText == "ALL DAY") || (this.time["endTime"].isNotEmpty)) {
          String endTime = startTimeDisplay(this.time["endTime"], context);
          timeText = "$timeText - $endTime ${DateTime.now().timeZoneName}";
        }
        return FittedBox(fit:BoxFit.fitWidth, child:SelectableText(timeText.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .subtitle2
                .copyWith(fontSize: 16, color: ColorConstants.PRIMARY)));
      } else {
        return Container();
      }
    }

    return Container(
      //height: 125.0,
      height: 120,
      width: 200,
      margin: EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: ColorConstants.SECONDARY,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Container(
        alignment: Alignment.topLeft,
        padding:
            EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(fontSize: 18.0),
              ),
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    Text(
                      desc,
                      style: Theme.of(context).textTheme.bodyText1,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.left,
                    ),
                    (this.performanceType != "Workshops")
                        ? Text(
                            this.performanceType,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .copyWith(
                                    fontSize: 16,
                                    color: ColorConstants.PRIMARY),
                          )
                        : Container(),
                    (this.performanceType == "Workshops")
                        ? timeWidget()
                        : Container(),
                    Text(
                      zone,
                      style: Theme.of(context).textTheme.subtitle1,
                      overflow: TextOverflow.clip,
                      maxLines: 3,
                      softWrap: true,
                      textAlign: TextAlign.left,
                    )
                  ]))
            ]),
      ),
    );
  }
}
