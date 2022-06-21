import 'package:intl/intl.dart';

class UserSeriesInfo {
  static DateFormat df = DateFormat('dd/MM/yyyy');

  final int duration;
  final int seasons;
  final int episodes;

  UserSeriesInfo(this.duration, this.seasons, this.episodes);

  UserSeriesInfo.fromJson(Map<String, dynamic> json)
      : duration = json['duration'],
        seasons = json['seasons'],
        episodes = json['episodes'];
}
