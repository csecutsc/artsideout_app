import 'package:artsideout_app/graphql/Profile.dart';

class Installation {
  String title;
  String desc;
  String zone;
  String imgURL;
  String videoURL;
  Map<String, double> location;
  String locationRoom;
  List<Profile> profiles;

  Installation(this.title, this.desc,
      {this.zone,
      this.imgURL,
      this.videoURL,
      this.location,
      this.locationRoom,
      this.profiles});
}

class InstallationQueries {
  String getAll = """ 
    {
      installations {
        title
        desc
        zone
        videoUrl
        image {
          url
        }
        location {
          latitude
          longitude
        }
        locationRoom
        profile {
          name
          desc
          social
          type
        }
      }
    }
  """;
  String getOneByID(String id) {
    return """
    {
      Installation(where: {id: $id}) {
        title
        desc
        zone
        image {
          url
        }
        location {
          latitude
          longitude
        }
        locationRoom
        profile {
          name
          desc
          social
          type
        }
      }
    }
  """;
  }
}
