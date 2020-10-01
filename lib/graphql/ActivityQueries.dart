class ActivityQueries {
  String getAll = """ 
    {
      activities(where: {performanceType_not: Workshops}, orderBy: prioritized_ASC) {
        id
        title
        desc
        zone
        videoUrl
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
          id
          name
          desc
          social
          type
        }
        prioritized
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
        videoUrl
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
        zoomMeeting {
          meetingId
          meetingUrl
          meetingPass
        }
        locationRoom
        profile {
          id
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
        videoUrl
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
        zoomMeeting {
          meetingId
          meetingUrl
          meetingPass
        }
        profile {
          id
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
      activities(where: {performanceType: Workshops}, orderBy: startTime_ASC) {
        id
        title
        desc
        zone
        videoUrl
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
        zoomMeeting {
          meetingId
          meetingUrl
          meetingPass
        }
        profile {
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
    }
  """;
}
