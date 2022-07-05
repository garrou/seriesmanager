import 'package:seriesmanager/models/season.dart';

class ApiSeason extends Season {
  bool isSelected = false;

  ApiSeason(int number, int episodes, String image)
      : super(number, episodes, image);

  ApiSeason.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'number': number,
        'episodes': episodes,
        'image': image,
      };
}

List<ApiSeason> createApiSeasons(List<dynamic>? records) => records == null
    ? List.empty()
    : records.map((json) => ApiSeason.fromJson(json)).toList(growable: false);
