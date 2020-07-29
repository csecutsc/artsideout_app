import 'package:artsideout_app/graphql/Activity.dart';
import 'package:artsideout_app/graphql/Installation.dart';

class Profile {
  String name;
  String desc;
  Object social;
  String type;
  List<Installation> installations;
  List<Activity> activities;

  Profile(this.name, this.desc, {this.social, this.type, this.installations,
      this.activities});
}

class ProfileQueries {
  String placeholder = "";
}
