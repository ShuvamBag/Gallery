class ImageModel {
  final String previewUrl;
  final String largeImageUrl;
  final int likes;
  final int views;

  ImageModel({
    required this.previewUrl,
    required this.largeImageUrl,
    required this.likes,
    required this.views,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      previewUrl: json['previewURL'],
      largeImageUrl: json['largeImageURL'],
      likes: json['likes'],
      views: json['views'],
    );
  }
}
