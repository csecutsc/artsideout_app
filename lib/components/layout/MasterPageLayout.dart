import 'package:artsideout_app/components/common/PageHeader.dart';
import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/constants/DisplayConstants.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/DisplayService.dart';
import 'package:flutter/material.dart';

//TODO add header
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
        break;
      case DisplaySize.MEDIUM:
        secondFlexSize = 5;
        break;
      case DisplaySize.SMALL:
        secondFlexSize = 1;
        secondScreen = Container();
        break;
    }

    return Scaffold(
      backgroundColor: ColorConstants.SCAFFOLD,
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Row(children: <Widget>[
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
                      bottom: MediaQuery.of(context).size.height / 3,
                      child: pageHeader),
                  Positioned(
                    top: MediaQuery.of(context).size.height / 10,
                    right: 0,
                    left: 0,
                    bottom: 0,
                    child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 250),
                        child: (loading == false)
                            ? mainPageWidget
                            : Align(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(),
                              )),
                  )
                ],
              ),
            ),
            secondScreen
          ]);
        },
      ),
    );
  }
}
