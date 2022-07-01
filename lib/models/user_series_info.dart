import 'package:intl/intl.dart';

class UserSeriesInfo {
  final DateFormat _df = DateFormat('MM/yyyy');

  final int duration;
  final int seasons;
  final int episodes;
  final DateTime beginAt;
  final DateTime endAt;

  UserSeriesInfo(
      this.duration, this.seasons, this.episodes, this.beginAt, this.endAt);

  UserSeriesInfo.fromJson(Map<String, dynamic> json)
      : duration = json['duration'],
        seasons = json['seasons'],
        episodes = json['episodes'],
        beginAt = DateTime.parse(json['beginAt']),
        endAt = DateTime.parse(json['endAt']);

  String formatBeginAt() => _df.format(beginAt);

  String formatEndAt() => _df.format(endAt);

  bool isValidDates() => beginAt.year > 1 && endAt.year > 1;
}
