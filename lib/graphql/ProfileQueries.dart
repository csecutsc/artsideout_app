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

  String getOneByName(String id) {
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

  String getAllByName(String name) {
    return """
    {
      profiles(where: {name_contains: "$name"}) {
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
