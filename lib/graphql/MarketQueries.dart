class MarketQueries {
  final String getAll = """ 
    {
      projects(where: {projectType: Studio}) {
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
            }
          }
        }
      }
    }
  """;
  String getOneById(String id) {
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
              name
              desc
              social
              type
            }
          }
        }
      }
    }
  """;
  }
  String getAllButOne(String id) {
    return """ 
    {
      projects(where: {projectType: Studio, AND: {NOT: {id: "$id"}}}) {
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
            }
          }
        }
      }
    }
  """;
  }
}
