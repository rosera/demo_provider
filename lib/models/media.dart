// YouTube Playlist
// YouTube API v3 Playlist information
// -----------------------------------------------------------------------------

class YouTubeItem {
  final String article;
  final String channel;
  final String description;
  final String filter_id;
  final String playlist;
  final String medres;
  final String highres;
  final String link;
  final String thumbnail;
  final String publishedat;
  final String position;
  final String owner;
  final String topic;
  final String title;
  // final String learning; // GEN AI Generated
  // final String summary;  // GEN AI Generated

  // Constructor
  YouTubeItem({
    required this.article,
    required this.channel,
    required this.description,
    required this.filter_id,
    required this.playlist,
    required this.medres,
    required this.highres,
    required this.link,
    required this.thumbnail,
    required this.publishedat,
    required this.position,
    required this.owner,
    required this.title,
    required this.topic,
    // required this.learning,
    // required this.summary,
  });

  // Use a Factory to process a list + return value
  factory YouTubeItem.fromJson(Map<String, dynamic> json) {
    // var listPlans = json['plan'] as List;
    // var listLearnings = json['learning'] as List;

    // print(json['title']);

    return YouTubeItem(
      article: json['article'],
      channel: json['channel'],
      description: json['description'],
      filter_id: json['filter_id'],
      playlist: json['playlist'],
      medres: json['image_standard'], // V2 amend from image
      highres: json['image_highres'], // V2 amend from image
      link: json['link'],
      thumbnail: json['image_thumbnail'], // V2 amend from image
      publishedat: json['published'],
      position: json['position'],
      owner: json['owner'],
      title: json['title'],
      topic: json['topic'],
      // learning: json['learning'], // GEN AI
      // summary: json['summary'],   // GEN AI
      // plans: plans,   // GEN AI
      // learnings: learnings,   // GEN AI
    );
  }
}

class Media {
  final String author;
  final String timestamp;
  final List<YouTubeItem> youtubePlaylist;

  // Constructor
  Media ({
    required this.author,
    required this.timestamp,
    required this.youtubePlaylist,
  });

  // Use a Factory to enable processing to be perform + return value
  factory Media.fromJson(Map<String, dynamic> json) {
    var list = json['media'] as List;

    // Process YouTube playlist information
    List<YouTubeItem> media = list
        .map((productItems) => YouTubeItem.fromJson(productItems))
        .toList();

    return Media (
      author: json['author'],
      timestamp: json['timestamp'],
      youtubePlaylist: media,
    );
  }
}