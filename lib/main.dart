import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_data_store.dart';
import 'data/data_access.dart';

void main() {
  runApp(const PocApp());
}

class PocApp extends StatelessWidget {
  const PocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Initialize the store and trigger the initial data fetch
      create: (_) => AppDataStore(
        mediaDataSource: MediaRemoteDataSource(),
      )..loadMediaData(), // Call fetch immediately
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Provider PoC',
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        home: const DataDisplayScreen(),
      ),
    );
  }
}

class DataDisplayScreen extends StatelessWidget {
  const DataDisplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 💡 context.watch<T>() rebuilds the widget when T changes.
    final store = context.watch<AppDataStore>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider YouTube Playlist (PoC)'),
        actions: [
          // Button to manually refresh the data
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: store.isLoading ? null : store.loadMediaData,
          ),
        ],
      ),
      body: _buildBody(store),
    );
  }

  Widget _buildBody(AppDataStore store) {
    if (store.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (store.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            'Error: ${store.errorMessage}',
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Check if data is present and the list is not empty
    if (store.mediaData != null && store.youtubeTitles.isNotEmpty) {
      return ListView.builder(
        itemCount: store.youtubeTitles.length,
        itemBuilder: (context, index) {
          final title = store.youtubeTitles[index];
          return ListTile(
            leading: Text('${index + 1}.'),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text('Owner: ${store.mediaData!.youtubePlaylist[index].owner}'),
            trailing: const Icon(Icons.video_collection),
            onTap: () {
              // Action when tapping a video item
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped: $title')),
              );
            },
          );
        },
      );
    }

    // Default message if no data is present after loading
    return const Center(child: Text('No playlist data available.'));
  }
}