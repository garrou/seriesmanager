class SearchDetailsSeries {
  final int id;
  final String title;
  final Map<String, dynamic> images;
  final String description;
  final String episodes;
  final List<dynamic> seasons;
  final String creation;
  final Map<String, dynamic> kinds;
  final String length;
  final bool ended;
  final List<dynamic> platforms;

  SearchDetailsSeries(
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
      this.platforms);

  SearchDetailsSeries.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        images = json['images'],
        description = json['description'],
        episodes = json['episodes'],
        seasons = json['seasons_details'],
        creation = json['creation'],
        kinds = json['genres'],
        length = json['length'],
        ended = json['status'] == "Ended",
        platforms = json['platforms']['svods'] ?? List.empty();

  int totalMinutes() => int.parse(episodes) * int.parse(length);

  double totalHours() => totalMinutes() / 60;

  double totalDays() => totalHours() / 24;
}
