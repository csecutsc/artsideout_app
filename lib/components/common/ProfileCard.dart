import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:artsideout_app/serviceLocator.dart';
import 'package:artsideout_app/services/GraphQLImageService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String imgUrl;
  final String type;

  const ProfileCard({Key key, this.name, this.imgUrl, this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    GraphQlImageService graphQlImageService =
        serviceLocator<GraphQlImageService>();
    String compressedImgUrl =
        graphQlImageService.getResizedImage(this.imgUrl, 100);
    Widget likeAndSaveButtons(Icon icon) {
      return RaisedButton.icon(
        onPressed: () {},
        padding: EdgeInsets.all(13.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        icon: icon,
        textColor: Colors.white,
        color: ColorConstants.PRIMARY,
        label: SelectableText("View"),
      );
    }

    return Card(
      margin: EdgeInsets.all(10.0),
      color: Color(0xFFF9EBEB),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(18),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(compressedImgUrl),
          radius: 25.0,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              this.name,
            ),
            SizedBox(
              height: 4,
            ),
            SelectableText(
              this.type,
              style: TextStyle(
                  fontSize: 14.5,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            likeAndSaveButtons(
              Icon(Icons.arrow_right),
            ),
          ],
        ),
      ),
    );
  }
}
