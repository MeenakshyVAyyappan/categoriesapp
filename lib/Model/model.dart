class Product {
  final String id;
  final String title;
  final double price;
  final double discountPrice;
  final String imageUrl;
  final bool status;
  final String statusText;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.discountPrice,
    required this.imageUrl,
    required this.status,
    required this.statusText,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      title: json['title'],
      price: json['price'].toDouble(),
      discountPrice: json['discountPrice'].toDouble(),
      imageUrl: json['image'][0]['url'],
      status: json['status'],
      statusText: json['statusText'],
    );
  }
}

class Category {
  final String id;
  final String title;
  final String imageUrl;
  final bool isSelected;

  Category({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.isSelected,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      title: json['title'],
      imageUrl: json['image'],
      isSelected: json['isSelected'],
    );
  }
}

class ApiResponse {
  final List<Product> products;
  final List<Category> categories;

  ApiResponse({
    required this.products,
    required this.categories,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var productsJson = json['data']['products'] as List? ?? [];
    var categoriesJson = json['data']['categories'] as List? ?? [];

    List<Product> productsList =
        productsJson.map((i) => Product.fromJson(i)).toList();
    List<Category> categoriesList =
        categoriesJson.map((i) => Category.fromJson(i)).toList();

    return ApiResponse(
      products: productsList,
      categories: categoriesList,
    );
  }
}
