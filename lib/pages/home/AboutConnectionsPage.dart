import 'package:artsideout_app/components/home/AboutConnectionsWidget.dart';
import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:flutter/material.dart';

class AboutConnectionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "ABOUT CONNECTIONS",
          style: TextStyle(
            color: ColorConstants.PRIMARY,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        backgroundColor: ColorConstants.PREVIEW_SCREEN,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0.0,
      ),
      body: AboutConnectionsWidget(expandedScreen: true)
    );
  }
}
