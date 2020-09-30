import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/constants/PlaceholderConstants.dart';
import 'package:artsideout_app/graphql/ActivityQueries.dart';
import 'package:artsideout_app/helpers/GraphQlFactory.dart';
import 'package:artsideout_app/models/Profile.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/GraphQLConfiguration.dart';
import 'package:flutter/material.dart';
import 'package:artsideout_app/models/Activity.dart';
import 'package:artsideout_app/components/activity/ActivityDetailWidget.dart';
// GraphQL
import 'package:graphql_flutter/graphql_flutter.dart';

class ActivityDetailPage extends StatefulWidget {
  final String activityPageId;
  ActivityDetailPage(this.activityPageId);

  @override
  _ActivityDetailPageState createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  Activity activityDetails;

  GraphQLConfiguration graphQLConfiguration =
      serviceLocator<GraphQLConfiguration>();
  @override
  void initState() {
    super.initState();
    _getActivityPost(widget.activityPageId);
  }

  void _getActivityPost(pageId) async {
    ActivityQueries queryActivity = ActivityQueries();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.query(
      QueryOptions(
        documentNode: gql(queryActivity.getOneByID(pageId)),
      ),
    );
    if (!result.hasException) {
      setState(() {
        activityDetails = GraphQlFactory.buildActivity(result.data["activity"]);
      });
    } else {
      print("CANNOT GET ART DETAILS");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO TEMP FIX
    Widget cool;
    if (activityDetails == null) {
      cool = Container();
    } else {
      cool = ActivityDetailWidget(data: activityDetails);
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "PERFORMANCE",
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
      body: cool,
    );
  }
}
