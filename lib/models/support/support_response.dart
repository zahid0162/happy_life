class SupportPlaces {
  String name;
  String address;
  String url;
  String imageUrl;

  SupportPlaces({
    this.name = '',
    this.address = '',
    this.url = '',
    this.imageUrl = '',
  });

  factory SupportPlaces.fromJson(Map<String, dynamic> json) {
    return SupportPlaces(
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      url: json['url'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
    );
  }
}

class PlacesResponse {
  String message;
  List<SupportPlaces> places;

  PlacesResponse({required this.message, required this.places});

  factory PlacesResponse.fromJson(Map<String, dynamic> json) {
    return PlacesResponse(
      message: json['message'] as String? ?? '',
      places: (json['data']['places'] as List<dynamic>)
          .map((e) => SupportPlaces.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
