import 'package:artsideout_app/models/Installation.dart';
import 'package:artsideout_app/models/Profile.dart';

class Market {
  String id;
  String title;
  String desc;
  List<Map<String,String>> images;
  List<Profile> profiles;
  Map<String, String> social;

  Market(this.id, this.title, {this.desc, this.images, this.profiles, this.social});
}
