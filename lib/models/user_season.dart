import 'package:seriesmanager/models/season.dart';

class UserSeason extends Season {
  final int id;
  final DateTime startedAt;
  final DateTime finishedAt;

  UserSeason(this.id, int number, int episodes, String image, this.startedAt,
      this.finishedAt)
      : super(number, episodes, image);

  UserSeason.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        startedAt = json['startedAt'],
        finishedAt = json['finishedAt'],
        super.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'number': number,
        'episodes': episodes,
        'image': image,
        'startedAt': startedAt,
        'finishedAt': startedAt
      };
}

List<UserSeason> createUserSeasons(List<dynamic>? records) => records == null
    ? List.empty()
    : records.map((json) => UserSeason.fromJson(json)).toList(growable: false);
