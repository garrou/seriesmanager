class UserPreviewSeries {
  final int id;
  final String title;
  final String poster;

  UserPreviewSeries(this.id, this.title, this.poster);

  UserPreviewSeries.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        poster = json['poster'];
}

List<UserPreviewSeries> createUserPreviewSeries(List<dynamic>? records) =>
    records == null
        ? List.empty()
        : records
            .map((json) => UserPreviewSeries.fromJson(json))
            .toList(growable: false);
