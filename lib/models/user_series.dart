import 'package:seriesmanager/models/series.dart';

class UserSeries extends Series {
  final int episodeLength;
  final String poster;
  final int? sid;

  UserSeries(int id, String title, this.poster, this.episodeLength, [this.sid])
      : super(id, title);

  UserSeries.fromJson(Map<String, dynamic> json)
      : episodeLength = json['length'],
        poster = json['poster'],
        sid = json['sid'],
        super.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'poster': poster,
        'length': episodeLength,
        'sid': sid,
      };
}

List<UserSeries> createUserSeries(List<dynamic>? records) => records == null
    ? List.empty()
    : records.map((json) => UserSeries.fromJson(json)).toList(growable: false);
