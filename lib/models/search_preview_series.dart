class SearchPreviewSeries {
  final int id;
  final String title;
  final String poster;

  SearchPreviewSeries(this.id, this.title, this.poster);

  SearchPreviewSeries.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        poster = json['images']['poster'];
}

List<SearchPreviewSeries> createSearchPreviewSeries(List<dynamic> records) =>
    records
        .map((json) => SearchPreviewSeries.fromJson(json))
        .toList(growable: false);
