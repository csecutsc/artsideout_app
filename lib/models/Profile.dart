import 'Activity.dart';
import 'Installation.dart';
import 'Market.dart';

class Profile {
  String id;
  String name;
  String desc;
  Map<String, String> social;
  String type;
  String profilePic;
  List<Installation> installations;
  List<Activity> activities;
  List<Market> markets;

  Profile(this.name, this.desc,
      {this.id, this.social, this.type, this.installations, this.activities, this.profilePic, this.markets});
}
