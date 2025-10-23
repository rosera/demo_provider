import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/media.dart';

abstract class MediaDataSource {
  Future<Media> fetchMediaData();
}

class MediaRemoteDataSource implements MediaDataSource {
  // 💡 Your specified URL
  static const _endpoint = 'https://storage.googleapis.com/roselabs-poc-images/htbp/htbp_0.json';

  @override
  Future<Media> fetchMediaData() async {
    final uri = Uri.parse(_endpoint);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Decode the JSON string
        final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;

        // Use your Media factory constructor for parsing
        // The data is at the root, so we pass the whole map.
        // We ensure 'media' (youtubePlaylist) is included for the factory to work.
        return Media.fromJson({'media': jsonMap['media'], ...jsonMap});

      } else {
        // Handle server errors (e.g., 404, 500)
        throw Exception('Failed to load media data: Status ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors (e.g., no internet)
      throw Exception('Network error during data fetching: $e');
    }
  }
}