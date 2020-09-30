import 'package:artsideout_app/models/Profile.dart';
import 'package:artsideout_app/models/ZoomMeeting.dart';

class Activity {
  String id;
  String title;
  String desc;
  String zone;
  String performanceType;
  ZoomMeeting zoomMeeting;
  List<Map<String, String>> images;
  Map<String, String> time;
  Map<String, double> location;
  List<Profile> profiles;

  Activity(
      {this.id,
      this.title,
      this.desc,
      this.zone,
      this.zoomMeeting,
      this.images,
      this.performanceType,
      this.time,
      this.location,
      this.profiles});
}
