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
      project(orderBy: createdAt_DESC, where: {id: "$id"}) {
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
  }
}
