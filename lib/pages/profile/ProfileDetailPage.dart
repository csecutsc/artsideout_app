import 'package:artsideout_app/components/profile/ProfileDetailWidget.dart';
import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/graphql/ProfileQueries.dart';
import 'package:artsideout_app/helpers/GraphQlFactory.dart';
import 'package:artsideout_app/models/Profile.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/GraphQLConfiguration.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ProfileDetailPage extends StatefulWidget {
  final String profilePageId;

  ProfileDetailPage(this.profilePageId);

  @override
  _ProfileDetailPageState createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  Profile profileDetails;
  void _getActivityPost(String pageId) async {
    GraphQLConfiguration graphQLConfiguration =
    serviceLocator<GraphQLConfiguration>();
    ProfileQueries profileQueries = ProfileQueries();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.query(
      QueryOptions(
        documentNode: gql(profileQueries.getOneByID(pageId)),
      ),
    );
    if (!result.hasException) {

      setState(() {
        profileDetails = GraphQlFactory.buildProfile(result.data["profile"]);
      });
    } else {
      print("CANNOT GET ART DETAILS");
    }
  }
  @override
  void initState() {
    super.initState();
    _getActivityPost(widget.profilePageId);
  }
  @override
  Widget build(BuildContext context) {
   Widget second = (profileDetails == null) ?
      Container()
      : ProfileDetailWidget(profileDetails, expandedScreen: true);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "PROFILE",
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
      body: second,
    );
  }
}
