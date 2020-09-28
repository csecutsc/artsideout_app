import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/constants/PlaceholderConstants.dart';
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
      List<Profile> profilesList = [];

      if (result.data["installation"] != null) {
        if (result.data["installation"]["profile"] != null) {
          for (var j = 0;
              j < result.data["installation"]["profile"].length;
              j++) {
            Map<String, String> socialMap = new Map();

            for (var key
                in result.data["installation"]["profile"][j]["social"].keys) {
              socialMap[key] =
                  result.data["installation"]["profile"][j]["social"][key];
            }
            profilesList.add(Profile(
                result.data["installation"]["profile"][j]["name"],
                result.data["installation"]["profile"][j]["desc"],
                social: socialMap,
                type: result.data["installation"]["profile"][j]["type"] ?? "",
                installations: [],
                activities: []));
          }
        }

        List<String> imgsURL = [];

        if (result.data["installation"]["images"] != null) {
          for (int j = 0;
              j < result.data["installation"]["images"].length;
              j++) {
            imgsURL.add(result.data["installation"]["images"][j]["url"]);
          }
        }
        setState(() {
          artDetails = Installation(
            id: result.data["installation"]["id"],
            title: result.data["installation"]["title"] == null
                ? "N/A"
                : result.data["installation"]["title"],
            desc: result.data["installation"]["desc"] == null
                ? "N/A"
                : result.data["installation"]["desc"],
            zone: result.data["installation"]["zone"] == null
                ? "N/A"
                : result.data["installation"]["zone"],
            imgURL: imgsURL.length == 0
                ? [PlaceholderConstants.GENERIC_IMAGE]
                : imgsURL,
            videoURL: result.data["installation"]["videoUrl"] ?? "",
            location: {
              'latitude': result.data["installation"]["location"] == null
                  ? 0.0
                  : result.data["installation"]["location"]["latitude"],
              'longitude': result.data["installation"]["location"] == null
                  ? 0.0
                  : result.data["installation"]["location"]["longitude"],
            },
            // locationRoom: result.data["installation"]["locationroom"],
            profiles: profilesList,
          );
        });
      } else {
        print("CANNOT GET ART DETAILS");
      }
    }
    // return artDetails;
  }

  Widget build(BuildContext context) {
    // TODO TEMP FIX
    Widget cool;

    if (artDetails == null) {
      cool = Container();
    } else {
      cool = ArtDetailWidget(data: artDetails);
    }
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: ColorConstants.PRIMARY,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0.0,
        ),
        body: cool);
  }
}
