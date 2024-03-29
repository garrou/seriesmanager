import 'package:intl/intl.dart';

class UserSeriesInfo {
  final DateFormat _df = DateFormat('MM/yyyy');

  final int id;
  final int duration;
  final int seasons;
  final int episodes;
  final DateTime beginAt;
  final DateTime endAt;
  bool isWatching;

  UserSeriesInfo(this.id, this.duration, this.seasons, this.episodes,
      this.beginAt, this.endAt, this.isWatching);

  UserSeriesInfo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        duration = json['duration'],
        seasons = json['seasons'],
        episodes = json['episodes'],
        beginAt = DateTime.parse(json['beginAt']),
        endAt = DateTime.parse(json['endAt']),
        isWatching = json['isWatching'];

  String formatBeginAt() => _df.format(beginAt);

  String formatEndAt() => _df.format(endAt);

  bool hasValidDates() => beginAt.year > 1 && endAt.year > 1;
}
