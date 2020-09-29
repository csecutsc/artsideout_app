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
          altText
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
          profilePic {
            url
          }
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
          altText
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
          profilePic {
            url
          }
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
          altText
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
          profilePic {
            url
          }
        }
      }
    }
    """;
  }
}
