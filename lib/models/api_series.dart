import 'package:seriesmanager/models/series.dart';

class ApiSeries extends Series {
  ApiSeries(int id, String title, String poster) : super(id, title, poster);

  ApiSeries.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

List<ApiSeries> createApiSeries(List<dynamic> records) =>
    records.map((json) => ApiSeries.fromJson(json)).toList(growable: false);
