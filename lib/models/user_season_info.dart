import 'package:intl/intl.dart';

class UserSeasonInfo {
  final DateFormat _df = DateFormat('MM/yyyy');

  int id;
  DateTime viewedAt;
  int duration;

  UserSeasonInfo(this.id, this.viewedAt, this.duration);

  UserSeasonInfo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        viewedAt = DateTime.parse(json['viewedAt']),
        duration = json['duration'];

  String formatViewedAt() => _df.format(viewedAt);
}

List<UserSeasonInfo> createUserSeasonInfo(
        List<dynamic>? records) =>
    records == null
        ? List.empty()
        : records
            .map((json) => UserSeasonInfo.fromJson(json))
            .toList(growable: false);
