class InstallationQueries {
  String getAll = """ 
    {
      installations {
        id
        title
        desc
        zone
        videoUrl
        images {
          url
        }
        location {
          latitude
          longitude
        }
        locationRoom
        profile {
          name
          desc
          social
          type
        }
      }
    }
  """;
  String getOneByID(String id) {
    return """
    {
      installation (where: {id: "$id"}) {
        id
        title
        desc
        zone
        videoUrl
        images {
          url
        }
        location {
          latitude
          longitude
        }
        locationRoom
        profile {
          name
          desc
          social
          type
        }
      }
    }
  """;
  }

  String getAllByTitleAndDesc(String titleDesc) {
    return """
    {
      installations(where: {OR: [{title_contains: "$titleDesc"}, {desc_contains: "$titleDesc"}]}) {
        id
        title
        desc
        mediumType
        zone
        videoUrl
        images {
          url
        }
        location {
          latitude
          longitude
        }
        locationRoom
        profile {
          name
          desc
          social
          type
        }
      }
    }
    """;
  }
}
