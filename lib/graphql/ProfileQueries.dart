class ProfileQueries {
  String getAll = """
    {
      profiles {
        name
        desc
        social
        type
        profilePic {
          url
        }
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
          profilePic {
            url
          }
        }
    }
    """;
  }

  String getOneByName(String id) {
    return """
    {
      profile (where: {id: $id}) {
          id
          name
          desc
          social 
          type
          profilePic {
            url
          }
        }
    }
    """;
  }

  String getAllByName(String name) {
    return """
    {
      profiles(where: {name_contains: "$name"}) {
          id
          name
          desc
          social 
          type
          profilePic {
            url
          }
      }
    }
    """;
  }
}
