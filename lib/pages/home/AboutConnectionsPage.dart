import 'package:artsideout_app/components/home/AboutConnectionsWidget.dart';
import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/constants/PlaceholderConstants.dart';
import 'package:artsideout_app/graphql/ActivityQueries.dart';
import 'package:artsideout_app/models/Profile.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/GraphQLConfiguration.dart';
import 'package:flutter/material.dart';
import 'package:artsideout_app/models/Activity.dart';
import 'package:artsideout_app/components/activity/ActivityDetailWidget.dart';
// GraphQL
import 'package:graphql_flutter/graphql_flutter.dart';

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
      body: AboutConnectionsWidget()
    );
  }
}
