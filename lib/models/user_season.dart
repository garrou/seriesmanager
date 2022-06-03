import 'package:intl/intl.dart';
import 'package:seriesmanager/models/season.dart';

class UserSeason extends Season {
  static DateFormat df = DateFormat('dd/MM/yyyy');

  final String? id;
  final String? sid;
  final DateTime startedAt;
  final DateTime finishedAt;

  UserSeason(
      int number, int episodes, String image, this.startedAt, this.finishedAt,
      [this.sid, this.id])
      : super(number, episodes, image);

  UserSeason.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        sid = json['sid'],
        startedAt = DateTime.parse(json['startedAt']),
        finishedAt = DateTime.parse(json['finishedAt']),
        super.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'number': number,
        'episodes': episodes,
        'image': image,
        'startedAt': startedAt.toUtc().toIso8601String(),
        'finishedAt': startedAt.toUtc().toIso8601String(),
        'id': id,
        'sid': sid
      };

  String formatStartedAt() => df.format(startedAt);

  String formatFinishedAt() => df.format(finishedAt);
}

List<UserSeason> createUserSeasons(List<dynamic>? records) => records == null
    ? List.empty()
    : records.map((json) => UserSeason.fromJson(json)).toList(growable: false);
