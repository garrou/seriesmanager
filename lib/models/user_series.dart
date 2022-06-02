import 'package:seriesmanager/models/series.dart';

class UserSeries extends Series {
  final int episodeLength;

  UserSeries(int id, String title, String poster, this.episodeLength)
      : super(id, title, poster);

  UserSeries.fromJson(Map<String, dynamic> json)
      : episodeLength = json['length'],
        super.fromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      {'id': id, 'title': title, 'poster': poster, 'length': episodeLength};
}

List<UserSeries> createUserSeries(List<dynamic>? records) => records == null
    ? List.empty()
    : records.map((json) => UserSeries.fromJson(json)).toList(growable: false);
