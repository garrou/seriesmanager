class ApiEpisode {
  final int id;
  final String title;
  final int season;
  final int episode;
  final String code;
  final String description;
  final DateTime date;

  ApiEpisode(this.id, this.title, this.season, this.episode, this.code,
      this.description, this.date);

  ApiEpisode.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        season = json['season'],
        episode = json['episode'],
        code = json['code'],
        description = json['description'],
        date = DateTime.parse(json['date']);
}

List<ApiEpisode> createUserSeasons(List<dynamic>? records) => records == null
    ? List.empty()
    : records.map((json) => ApiEpisode.fromJson(json)).toList(growable: false);
