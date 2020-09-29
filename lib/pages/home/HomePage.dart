import 'package:artsideout_app/components/home/AboutConnectionsWidget.dart';
import 'package:artsideout_app/components/layout/MasterPageLayout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:artsideout_app/components/home/HomeDetailWidget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget secondScreen = Center(
      child: Container(
        child: AboutConnectionsWidget(),
      ),
    );
    return MasterPageLayout(
        pageName: "ARTSIDEOUT 2020",
        pageDesc: "CONNECTIONS",
        mainPageWidget: HomeDetailWidget(),
        secondPageWidget: secondScreen);
  }
}
