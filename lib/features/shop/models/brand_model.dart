class BrandModel {
  String id;
  String name;
  String image;
  bool? isFeatured;
  int? productsCount;

  BrandModel({
    required this.id,
    required this.name,
    required this.image,
    this.isFeatured,
    this.productsCount,
  });

  static BrandModel empty() {
    return BrandModel(id: '', image: '', name: '');
  }

  toJson() {
    return {
      'Id': id,
      'Name': name,
      'Image': image,
      'ProductsCount': productsCount,
      'IsFeatured': isFeatured,
    };
  }

  factory BrandModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) {
      return BrandModel.empty();
    }
    return BrandModel(
      id: data['Id'] ?? '',
      name: data['Name'] ?? '',
      image: data['Image'] ?? '',
      isFeatured: data['IsFeatured'] ?? false,
      productsCount: data['ProductsCount'] as int?,
    );
  }

  factory BrandModel.fromMap(Map<String, dynamic> data) {
    return BrandModel(
      id: data['id']?.toString() ?? '',
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      productsCount: data['products_count'] ?? '',
      isFeatured: data['is_featured'] ?? false,
    );
  }
}
