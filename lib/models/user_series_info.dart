import 'package:intl/intl.dart';

class UserSeriesInfo {
  static DateFormat df = DateFormat('dd/MM/yyyy');

  final int duration;
  final int seasons;
  final int episodes;
  final DateTime startedAt;
  final DateTime finishedAt;

  UserSeriesInfo(this.duration, this.seasons, this.episodes, this.startedAt,
      this.finishedAt);

  UserSeriesInfo.fromJson(Map<String, dynamic> json)
      : duration = json['duration'],
        seasons = json['seasons'],
        episodes = json['episodes'],
        startedAt = DateTime.parse(json['startedAt']),
        finishedAt = DateTime.parse(json['finishedAt']);

  String formatStartedAt() => df.format(startedAt);

  String formatFinishedAt() => df.format(finishedAt);

  bool hasValidDate() =>
      startedAt.isAfter(DateTime.utc(1)) && finishedAt.isAfter(DateTime.utc(1));
}
