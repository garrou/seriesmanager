import 'package:intl/intl.dart';
import 'package:seriesmanager/models/season.dart';

class UserSeason extends Season {
  final DateFormat _df = DateFormat('dd/MM/yyyy');

  final int? id;
  final int? seriesId;
  final DateTime viewedAt;

  UserSeason(int number, int episodes, String image, this.viewedAt,
      [this.seriesId, this.id])
      : super(number, episodes, image);

  UserSeason.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        seriesId = json['seriesId'],
        viewedAt = DateTime.parse(json['viewedAt']),
        super.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'number': number,
        'episodes': episodes,
        'image': image,
        'viewedAt': viewedAt.toUtc().toIso8601String(),
        'id': id,
        'seriesId': seriesId
      };

  String formatViewedAt() => _df.format(viewedAt);
}

List<UserSeason> createUserSeasons(List<dynamic>? records) => records == null
    ? List.empty()
    : records.map((json) => UserSeason.fromJson(json)).toList(growable: false);
