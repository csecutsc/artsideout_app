import 'package:artsideout_app/components/common/PageHeader.dart';
import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/constants/DisplayConstants.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/DisplayService.dart';
import 'package:flutter/material.dart';

class MasterPageLayout extends StatelessWidget {
  final String pageName;
  final String pageDesc;
  final Widget mainPageWidget;
  final Widget secondPageWidget;
  final bool loading;
  const MasterPageLayout(
      {Key key,
      this.pageName,
      this.pageDesc,
      this.mainPageWidget,
      this.secondPageWidget,
      this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int secondFlexSize = 1;
    double topPadding = 10;

    DisplayService _displayService = serviceLocator<DisplayService>();

    Widget secondScreen = Expanded(
        flex: 3,
        key: UniqueKey(),
        child: Center(
          child: Container(
            child: secondPageWidget,
          ),
        ));

    Widget pageHeader = PageHeader(
      textTop: this.pageName,
      subtitle: this.pageDesc,
    );

    switch (_displayService.displaySize) {
      case DisplaySize.LARGE:
        secondFlexSize = 6;
        topPadding = 10;
        break;
      case DisplaySize.MEDIUM:
        secondFlexSize = 5;
        topPadding = 10;
        break;
      case DisplaySize.SMALL:
        secondFlexSize = 1;
        secondScreen = Container();
        topPadding = 20;
        break;
    }

    return Scaffold(
      backgroundColor: ColorConstants.SCAFFOLD,
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Row(
              children: <Widget>[
                Expanded(
                  flex: secondFlexSize,
                  child: Stack(
                    fit: StackFit.passthrough,
                    overflow: Overflow.clip,
                    children: <Widget>[
                      Positioned(
                          top: 0,
                          right: 0,
                          left: 0,
                          bottom: 0,
                          child: pageHeader),
                      Positioned(
                        top: MediaQuery.of(context).size.height / topPadding,
                        right: 0,
                        left: 0,
                        bottom: 0,
                        child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 250),
                            child: (loading == false)
                                ? Center(child: mainPageWidget)
                                : Align(
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(),
                                  )),
                      )
                    ],
                  ),
                ),
                (secondScreen != Container()) ?
                    SizedBox(width: 5) :
                    Container(),
                secondScreen
              ]);
        },
      ),
    );
  }
}
