class ApiDetailsSeries {
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

  ApiDetailsSeries(
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

  ApiDetailsSeries.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        images = json['images'],
        description = json['description'],
        episodes = json['episodes'],
        seasons = json['seasons_details'],
        creation = json['creation'],
        kinds = json['genres'].runtimeType == List ? {} : json['genres'],
        length = int.tryParse(json['length']) ?? 0,
        ended = json['status'] == "Ended",
        platforms = json['platforms']['svods'] ?? List.empty(),
        mean = json['notes']?['mean'].toDouble();

  String getImage() =>
      images['poster'].isEmpty ? images['show'] : images['poster'];
}

List<ApiDetailsSeries> createDetailsSeries(List<dynamic>? records) =>
    records == null
        ? List.empty()
        : records
            .map((json) => ApiDetailsSeries.fromJson(json))
            .toList(growable: false);
