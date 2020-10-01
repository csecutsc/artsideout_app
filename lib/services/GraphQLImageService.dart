class GraphQlImageService {
  static const String _baseUrl = "https://media.graphcms.com/";

  String getResizedImage(String imgUrl, int width, {int quality = 100}) {
    if (!imgUrl.contains(_baseUrl)){
      return imgUrl;
    }
    String baseCompressed = "${_baseUrl}resize=width:$width/quality=value:$quality/";
    final a = Uri.parse(imgUrl);
    return baseCompressed + a.pathSegments.last;
  }

  String getFullImage(String imgUrl) {
    if (!imgUrl.contains(_baseUrl)){
      return imgUrl;
    }
    final a = Uri.parse(imgUrl);
    return _baseUrl + a.pathSegments.last;
  }
}