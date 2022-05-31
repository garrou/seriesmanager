class SearchedSeries {
  final int id;
  final String title;
  final Map<String, dynamic> images;

  SearchedSeries(this.id, this.title, this.images);

  SearchedSeries.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        images = json['images'];
}

List<SearchedSeries> createPreviewsSeries(List<dynamic> records) => records
    .map((json) => SearchedSeries.fromJson(json))
    .toList(growable: false);
