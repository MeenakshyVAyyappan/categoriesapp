import 'dart:convert';
import 'package:category/Model/model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://alpha.bytesdelivery.com/api/v3/product/category-products';

  Future<ApiResponse> fetchProducts({String? categoryId, int page = 1}) async {
    final response =
        await http.get(Uri.parse('$baseUrl/123/${categoryId ?? 'null'}/$page'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['data'] != null) {
        return ApiResponse.fromJson(data);
      } else {
        return ApiResponse(products: [], categories: []);
      }
    } else {
      throw Exception('Failed to load products');
    }
  }
}
