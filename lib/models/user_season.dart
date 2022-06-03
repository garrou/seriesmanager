import 'package:intl/intl.dart';
import 'package:seriesmanager/models/season.dart';

class UserSeason extends Season {
  static DateFormat df = DateFormat('dd/MM/yyyy');

  final int? id;
  final int? seriesId;
  final DateTime startedAt;
  final DateTime finishedAt;

  UserSeason(
      int number, int episodes, String image, this.startedAt, this.finishedAt,
      [this.seriesId, this.id])
      : super(number, episodes, image);

  UserSeason.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        seriesId = json['seriesId'],
        startedAt = DateTime.parse(json['startedAt']),
        finishedAt = DateTime.parse(json['finishedAt']),
        super.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'number': number,
        'episodes': episodes,
        'image': image,
        'startedAt': startedAt.toString(),
        'finishedAt': startedAt.toString(),
        'id': id,
        'seriesId': seriesId
      };
}

List<UserSeason> createUserSeasons(List<dynamic>? records) => records == null
    ? List.empty()
    : records.map((json) => UserSeason.fromJson(json)).toList(growable: false);
