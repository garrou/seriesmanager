import 'package:intl/intl.dart';

class UserSeasonInfo {
  static DateFormat df = DateFormat('dd/MM/yyyy');

  final DateTime startedAt;
  final DateTime finishedAt;
  final int duration;

  UserSeasonInfo(this.startedAt, this.finishedAt, this.duration);

  UserSeasonInfo.fromJson(Map<String, dynamic> json)
      : startedAt = DateTime.parse(json['startedAt']),
        finishedAt = DateTime.parse(json['finishedAt']),
        duration = json['duration'];

  String formatStartedAt() => df.format(startedAt);

  String formatFinishedAt() => df.format(finishedAt);
}

List<UserSeasonInfo> createUserSeasonInfo(
        List<dynamic>? records) =>
    records == null
        ? List.empty()
        : records
            .map((json) => UserSeasonInfo.fromJson(json))
            .toList(growable: false);
