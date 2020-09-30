import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/GraphQLImageService.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ArtListCard extends StatelessWidget {
  final String title;
  final String artist;
  final Map<String, String> image;

  const ArtListCard({
    Key key,
    this.title,
    this.artist,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GraphQlImageService _graphQlImageService = serviceLocator<GraphQlImageService>();
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        height: 300,
        color: ColorConstants.SECONDARY,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: Semantics(
                  child: CachedNetworkImage(
                    imageUrl: image["url"].contains("graphcms")
                        ? _graphQlImageService.getResizedImage(image["url"], 200)
                        : image["url"],
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      size: 50,
                    ),
                  ),
                  label: image["altText"],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1
                    ),
                  ),
                  Center(
                    child: Text(
                      artist,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subtitle2
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
