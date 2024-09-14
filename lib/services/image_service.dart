import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/image_model.dart';

class ImageService {
  static const String _apiKey = '29140414-d0e7c62fae544e005b7d200e9';  // Replace with your actual API key
  static const String _baseUrl = 'https://pixabay.com/api/';

  static Future<List<ImageModel>> fetchImages(String query, int page) async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl?key=$_apiKey&q=$query&page=$page&per_page=60'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body)['hits'];
      return jsonResponse.map((data) => ImageModel.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }
}
