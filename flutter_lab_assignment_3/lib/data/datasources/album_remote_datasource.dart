import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/album.dart';
import '../models/api_response.dart';

abstract class AlbumRemoteDataSource {
  Future<ApiResponse<List<Album>>> getAlbums();
  Future<ApiResponse<Album>> getAlbumById(int id);
  void dispose();
}

class AlbumRemoteDataSourceImpl implements AlbumRemoteDataSource {
  final http.Client _client;
  final String _baseUrl;

  AlbumRemoteDataSourceImpl({
    http.Client? client,
    String baseUrl = 'https://jsonplaceholder.typicode.com',
  })  : _client = client ?? http.Client(),
        _baseUrl = baseUrl;

  @override
  Future<ApiResponse<List<Album>>> getAlbums() async {
    try {
      final response = await _client.get(Uri.parse('$_baseUrl/photos'));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final albums = jsonList
            .take(50) // Only take first 50 items for better performance
            .map((json) => Album.fromJson(json))
            .toList();
        return ApiResponse.success(albums);
      } else {
        return ApiResponse.error('Failed to load albums: ${response.statusCode}');
      }
    } catch (e) {
      return ApiResponse.error('Failed to fetch albums: $e');
    }
  }

  @override
  Future<ApiResponse<Album>> getAlbumById(int id) async {
    try {
      final response = await _client.get(Uri.parse('$_baseUrl/photos/$id'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return ApiResponse.success(Album.fromJson(json));
      } else {
        return ApiResponse.error('Failed to load album: ${response.statusCode}');
      }
    } catch (e) {
      return ApiResponse.error('Failed to fetch album: $e');
    }
  }

  @override
  void dispose() {
    _client.close();
  }
} 