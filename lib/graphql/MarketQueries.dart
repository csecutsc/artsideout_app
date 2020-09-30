class MarketQueries {
  final String getAll = """ 
    {
      artMarketVendors{
        id
        title
        desc
        images{
          url
          altText
        }
        profiles{
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
    }
  """;
  String getOneById(String id) {
    return """ 
    {
      artMarketVendor(where: {id: "$id"}){
        id
        title
        desc
        images{
          url
          altText
        }
        profiles{
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
    }
  """;
  }
}
