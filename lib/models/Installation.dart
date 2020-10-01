import 'package:artsideout_app/models/Profile.dart';

class Installation {
  String id;
  String title;
  String desc;
  String zone;
  List<Map<String, String>> images;
  String videoURL;
  Map<String, double> location;
  String locationRoom;
  List<Map<String, String>> files;
  List<Profile> profiles;

  Installation(
      {this.id,
      this.title,
      this.desc,
      this.zone,
      this.images,
      this.videoURL,
      this.location,
      this.locationRoom,
      this.files,
      this.profiles});
}
