import 'package:intl/intl.dart';

class ApiEpisode {
  static DateFormat df = DateFormat('dd/MM/yyyy');

  final int id;
  final String title;
  final int season;
  final int episode;
  final String code;
  final String description;
  final DateTime? date;
  bool isExpanded = false;

  ApiEpisode(this.id, this.title, this.season, this.episode, this.code,
      this.description, this.date);

  ApiEpisode.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        season = json['season'],
        episode = json['episode'],
        code = json['code'],
        description = json['description'],
        date = json['date'].isEmpty ? null : DateTime.parse(json['date']);

  String formatDate() => date == null ? '' : df.format(date!);
}

List<ApiEpisode> createApiEpisodes(List<dynamic>? records) => records == null
    ? List.empty()
    : records.map((json) => ApiEpisode.fromJson(json)).toList(growable: false);
