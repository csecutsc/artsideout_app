import 'package:artsideout_app/models/Profile.dart';

class Installation {
  String id;
  String title;
  String desc;
  String zone;
  List<String> imgURL;
  String videoURL;
  Map<String, double> location;
  String locationRoom;
  List<Profile> profiles;

  Installation(
      {this.id,
      this.title,
      this.desc,
      this.zone,
      this.imgURL,
      this.videoURL,
      this.location,
      this.locationRoom,
      this.profiles});
}
