import 'package:seriesmanager/models/user_series.dart';

class UserSeriesToContinue extends UserSeries {
  final int nbMissing;

  UserSeriesToContinue(this.nbMissing, int id, String title, String poster,
      int episodeLength, int sid, bool isWatching)
      : super(id, title, poster, episodeLength, sid);

  UserSeriesToContinue.fromJson(Map<String, dynamic> json)
      : nbMissing = json['nbMissing'],
        super.fromJson(json);

  UserSeries toUserSeries() =>
      UserSeries(id, title, poster, episodeLength, sid);
}

List<UserSeriesToContinue> createSeriesToContinue(List<dynamic>? records) =>
    records == null
        ? List.empty()
        : records
            .map((json) => UserSeriesToContinue.fromJson(json))
            .toList(growable: true);
