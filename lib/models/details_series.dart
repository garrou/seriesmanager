class DetailsSeries {
  final int id;
  final String title;
  final Map<String, dynamic> images;
  final String description;
  final String episodes;
  final List<dynamic> seasons;
  final String creation;
  final Map<String, dynamic> kinds;
  final int length;
  final bool ended;
  final List<dynamic> platforms;

  DetailsSeries(
    this.id,
    this.title,
    this.images,
    this.description,
    this.seasons,
    this.episodes,
    this.creation,
    this.kinds,
    this.length,
    this.ended,
    this.platforms,
  );

  DetailsSeries.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        images = json['images'],
        description = json['description'],
        episodes = json['episodes'],
        seasons = json['seasons_details'],
        creation = json['creation'],
        kinds = json['genres'],
        length = int.tryParse(json['length']) ?? 0,
        ended = json['status'] == "Ended",
        platforms = json['platforms']['svods'] ?? List.empty();
}
