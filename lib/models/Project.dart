import 'package:artsideout_app/models/Installation.dart';
import 'package:artsideout_app/models/Profile.dart';

class Project {
  String title;
  String desc;
  Profile artist;
  List<Installation> installations;

  Project(this.title, this.desc, this.artist, this.installations);
}
