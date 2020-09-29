class ActivityQueries {
  String getAll = """ 
    {
      activities(where: {performanceType_not: Workshops}) {
        id
        title
        desc
        zone
        images {
          url
          altText
        }
        startTime
        endTime
        location {
          latitude
          longitude
        }
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
      activity(where: {id: "$id"}) {
        id
        title
        desc
        zone
        images {
          url
          altText
        }
        startTime
        endTime
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

  String getAllByTitleAndDesc(String term) {
    return """
    {
      activities(where: {OR: [{title_contains: "$term"}, {desc_contains: "$term"}]}) {
        title
        desc
        zone
        performanceType
        images {
          url
          altText
        }
        startTime
        endTime
        location {
          latitude
          longitude
        }
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

  String getAllWorkShops = """
    {
      activities(where: {performanceType: Workshops}) {
        id
        title
        desc
        zone
        images {
          url
          altText
        }
        startTime
        endTime
        location {
          latitude
          longitude
        }
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
