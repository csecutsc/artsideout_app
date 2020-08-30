import 'package:artsideout_app/graphql/Activity.dart';
import 'package:artsideout_app/graphql/Installation.dart';

class Profile {
  String name;
  String desc;
  Map<String, String> social;
  String type;
  List<Installation> installations;
  List<Activity> activities;

  Profile(this.name, this.desc,
      {this.social, this.type, this.installations, this.activities});
}

class ProfileQueries {
  String getAll = """
    {
      profiles {
        name
        desc
        social
        type
      }
    }
  """;
  String getOneByID(String id) {
    return """
    {
      profile (where: {id: $id}) {
          id
          name
          desc
          social 
          type
        }
    }
    """;
  }
}
