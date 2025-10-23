import 'package:flutter/foundation.dart';
import 'data/data_access.dart';
import 'models/media.dart';

class AppDataStore with ChangeNotifier {
  Media? _mediaData;
  bool _isLoading = false;
  String? _errorMessage;

  final MediaDataSource _mediaDataSource;

  // Dependency Injection: Takes the real data source
  AppDataStore({MediaDataSource? mediaDataSource})
      : _mediaDataSource = mediaDataSource ?? MediaRemoteDataSource();

  // Public Getters
  Media? get mediaData => _mediaData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Convenient getter for the titles list
  List<String> get youtubeTitles {
    return _mediaData?.youtubePlaylist
        .map((item) => item.title)
        .toList() ?? [];
  }

  Future<void> loadMediaData() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Start loading indicator

    try {
      final fetchedData = await _mediaDataSource.fetchMediaData();
      _mediaData = fetchedData;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      debugPrint('Error in AppDataStore: $_errorMessage');
    } finally {
      _isLoading = false;
      notifyListeners(); // Stop loading indicator/Display results
    }
  }
}