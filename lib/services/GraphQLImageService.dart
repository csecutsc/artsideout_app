class GraphQlImageService {
  static const String _baseUrl = "https://media.graphcms.com/";

  String getResizedImage(String imgUrl, int width, {int quality = 100}) {
    String baseCompressed = "${_baseUrl}resize=width:$width/quality=value:$quality/compress/";
    final a = Uri.parse(imgUrl);
    return baseCompressed + a.pathSegments.last;
  }

  String getFullImage(String imgUrl) {
    final a = Uri.parse(imgUrl);
    return _baseUrl + a.pathSegments.last;
  }
}