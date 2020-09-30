import 'package:artsideout_app/components/market/MarketDetailWidget.dart';
import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/graphql/MarketQueries.dart';
import 'package:artsideout_app/helpers/GraphQlFactory.dart';
import 'package:artsideout_app/models/Market.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/GraphQLConfiguration.dart';
import 'package:flutter/material.dart';

// GraphQL
import 'package:graphql_flutter/graphql_flutter.dart';

class MarketDetailPage extends StatefulWidget {
  final String artPageId;
  MarketDetailPage(this.artPageId);

  @override
  _MarketDetailPageState createState() => _MarketDetailPageState();
}

class _MarketDetailPageState extends State<MarketDetailPage> {
  Market artDetails;

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
    MarketQueries queryMarket = MarketQueries();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.query(
      QueryOptions(
        documentNode: gql(queryMarket.getOneById(pageId)),
      ),
    );

    if (!result.hasException) {
      setState(() {
        artDetails = GraphQlFactory.buildMarket(result.data["artMarketVendor"]);
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
      cool = MarketDetailWidget(data: artDetails, expandedScreen: true);
    }
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "ART MARKET",
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
