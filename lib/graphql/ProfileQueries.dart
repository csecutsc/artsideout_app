class ProfileQueries {
  String getAll = """
    {
      profiles(where: {type_not: Sponsor}) {
        id
        name
        desc
        social
        type
          installation {
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
          activity {
            id
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
              id
              name
              desc
              social
              type
            }
          }
        profilePic {
          url
        }
      }
    }
  """;
  String getOneByID(String id) {
    return """
    {
      profile (where: {id: "$id"}) {
          id
          name
          desc
          social 
          type
          installation {
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
          activity {
            id
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
              id
              name
              desc
              social
              type
            }
          }
          artMarketVendor {
            id
            title
            desc
            images {
              url
              altText
            }
            profiles {
              id
              name
              desc
              social 
              type
              profilePic {
                url
              }
            }
            social
          }
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
      profile (where: {id: "$id"}) {
          id
          name
          desc
          social 
          type
          installation {
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
          activity {
            id
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
              id
              name
              desc
              social
              type
            }
          }
          artMarketVendor {
            id
            title
            desc
            images {
              url
              altText
            }
            profiles {
              id
              name
              desc
              social 
              type
              profilePic {
                url
              }
            }
            social
          }
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
          installation {
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
          activity {
            id
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
              id
              name
              desc
              social
              type
            }
          }
          profilePic {
            url
          }
      }
    }
    """;
  }
  String getAllSponsors = """
    {
      profiles(where: {type: Sponsor}) {
        id
        name
        desc
        social
        type
          installation {
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
          activity {
            id
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
              id
              name
              desc
              social
              type
            }
          }
        profilePic {
          url
        }
      }
    }
  """;
  String getAllPartners = """
    {
      profiles(where: {type: Partner}) {
        id
        name
        desc
        social
        type
          installation {
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
          activity {
            id
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
              id
              name
              desc
              social
              type
            }
          }
        profilePic {
          url
        }
      }
    }
  """;
}
