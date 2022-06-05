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
  final double mean;

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
    this.mean,
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
        platforms = json['platforms']['svods'] ?? List.empty(),
        mean = json['notes']?['mean'].toDouble();
}

List<DetailsSeries> createDetailsSeries(List<dynamic>? records) =>
    records == null
        ? List.empty()
        : records
            .map((json) => DetailsSeries.fromJson(json))
            .toList(growable: false);
