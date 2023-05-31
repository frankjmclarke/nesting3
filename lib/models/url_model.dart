class UrlModel {
  late String? uid;
  final String email;
  final String name;
  final String url;
  late final String imageUrl;

  // New fields
  final String address;
  final int quality;
  final int distance;
  final int value;
  final int size;
  final String note;
  final String features;
  final String phoneNumber; // Added field
  final String price; // Added field
  final String category; // Added field

  UrlModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.url,
    required this.imageUrl,
    required this.address,
    required this.quality,
    required this.distance,
    required this.value,
    required this.size,
    required this.note,
    required this.features,
    required this.phoneNumber, // Added field
    required this.price, // Added field
    required this.category, // Added field
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'url': url,
      'imageUrl': imageUrl,
      'address': address,
      'quality': quality,
      'distance': distance,
      'value': value,
      'size': size,
      'note': note,
      'features': features,
      'phoneNumber': phoneNumber, // Added field
      'price': price, // Added field
    };
  }

  factory UrlModel.fromMap(Map data) {
    return UrlModel(
      uid: data['uid'] ?? '07hVeZyY2PM7VK8DC5QX',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      url: data['url'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      address: data['address'] ?? '',
      quality: data['quality'] ?? 0,
      distance: data['distance'] ?? 0,
      value: data['value'] ?? 0,
      size: data['size'] ?? 0,
      note: data['note'] ?? '',
      features: data['features'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '', // Added field
      price: data['price'] ?? '', // Added field
      category: data['category'] ?? '', // Added field
    );
  }

  @override
  String getUrl() {
    return url; // Customize the string representation as per your requirements
  }

  String getImageUrl() {
    return imageUrl; // Customize the string representation as per your requirements
  }

  String getEmail() {
    return email; // Customize the string representation as per your requirements
  }

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "email": email,
    "name": name,
    "url": url,
    "imageUrl": imageUrl,
    "address": address,
    "quality": quality,
    "distance": distance,
    "value": value,
    "size": size,
    "note": note,
    "features": features,
    "phoneNumber": phoneNumber, // Added field
    "price": price, // Added field
    "category": category, // Added field
  };
}

class UrlModelList {
  final List<UrlModel> urls;

  UrlModelList({required this.urls});

  factory UrlModelList.fromList(List<Map<String, dynamic>>? dataList) {
    List<UrlModel> urlModels = [];
    if (dataList != null) {
      urlModels = dataList.map((data) => UrlModel.fromMap(data)).toList();
    }
    return UrlModelList(urls: urlModels);
  }

  List<Map<String, dynamic>> toJson() =>
      urls.map((urlModel) => urlModel.toJson()).toList();

  Map<String, dynamic> toMap() {
    return {
      'urls': urls.map((urlModel) => urlModel.toMap()).toList(),
    };
  }

  bool get isNotEmpty => urls.isNotEmpty;

  UrlModel? get first => urls.isNotEmpty ? urls[0] : null;

  void add(UrlModel urlModel) {
    urls.add(urlModel);
  }
  factory UrlModelList.fromMap(Map<String, dynamic> map) {
    final List<Map> urlMaps = (map['urls'] as List<dynamic>).cast<Map>();
    List<UrlModel> urlModels = urlMaps.map((data) => UrlModel.fromMap(data)).toList(growable: false);
    return UrlModelList(urls: urlModels);
  }

}
