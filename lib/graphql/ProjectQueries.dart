class ProjectQueries {
  final String getAllStudio = """ 
    {
      projects(orderBy: createdAt_DESC, where: {projectType: Studio}) {
        id
        title
        desc
        elements {
          ... on Installation {
            id
            title
            desc
            zone
            videoUrl
            images {
              url
              altText
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
      }
    }
  """;
  String getOneStudioById(String id) {
    return """ 
    {
      project(where: {id: "$id"}) {
        id
        title
        desc
        elements {
          ... on Installation {
            id
            title
            desc
            zone
            videoUrl
            images {
              url
              altText
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
      }
    }
  """;
  }
}
