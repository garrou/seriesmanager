import 'package:intl/intl.dart';

class UserSeasonInfo {
  static DateFormat df = DateFormat('MM/yyyy');

  final DateTime viewedAt;
  final int duration;

  UserSeasonInfo(this.viewedAt, this.duration);

  UserSeasonInfo.fromJson(Map<String, dynamic> json)
      : viewedAt = DateTime.parse(json['viewedAt']),
        duration = json['duration'];

  String formatViewedAt() => df.format(viewedAt);
}

List<UserSeasonInfo> createUserSeasonInfo(
        List<dynamic>? records) =>
    records == null
        ? List.empty()
        : records
            .map((json) => UserSeasonInfo.fromJson(json))
            .toList(growable: false);
