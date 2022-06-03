import 'package:seriesmanager/models/series.dart';

class ApiSeries extends Series {
  final String poster;
  ApiSeries(int id, String title, this.poster) : super(id, title);

  ApiSeries.fromJson(Map<String, dynamic> json)
      : poster = json['images']?['poster'],
        super.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'poster': poster};
}

List<ApiSeries> createApiSeries(List<dynamic>? records) => records == null
    ? List.empty()
    : records.map((json) => ApiSeries.fromJson(json)).toList(growable: false);
