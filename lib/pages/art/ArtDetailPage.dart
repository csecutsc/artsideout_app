import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/constants/PlaceholderConstants.dart';
import 'package:artsideout_app/helpers/GraphQlFactory.dart';
import 'package:artsideout_app/models/Profile.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/GraphQLConfiguration.dart';
import 'package:artsideout_app/graphql/InstallationQueries.dart';
import 'package:artsideout_app/models/Installation.dart';
import 'package:flutter/material.dart';
import 'package:artsideout_app/components/art/ArtDetailWidget.dart';

// GraphQL
import 'package:graphql_flutter/graphql_flutter.dart';

class ArtDetailPage extends StatefulWidget {
  final String artPageId;
  ArtDetailPage(this.artPageId);

  @override
  _ArtDetailPageState createState() => _ArtDetailPageState();
}

class _ArtDetailPageState extends State<ArtDetailPage> {
  Installation artDetails;

  GraphQLConfiguration graphQLConfiguration =
      serviceLocator<GraphQLConfiguration>();

  @override
  void initState() {
    super.initState();
    //  this._getArtPost(widget.artPageId);

    _getArtPost(widget.artPageId);
  }

  // Installation GraphQL Query
  _getArtPost(pageId) async {
    InstallationQueries queryInstallation = InstallationQueries();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.query(
      QueryOptions(
        documentNode: gql(queryInstallation.getOneByID(pageId)),
      ),
    );

    if (!result.hasException) {
        setState(() {
          artDetails = GraphQlFactory.buildInstallation(result.data["installation"]);
        });
      } else {
        print("CANNOT GET ART DETAILS");
      }
    }

  @override
  Widget build(BuildContext context) {
    // TODO TEMP FIX
    Widget cool;
    if (artDetails == null) {
      cool = Container();
    } else {
      cool = ArtDetailWidget(data: artDetails, expandedScreen: true);
    }
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "STUDIO INSTALLATION",
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
        body: cool);
  }
}
