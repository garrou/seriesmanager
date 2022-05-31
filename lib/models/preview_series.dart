class PreviewSeries {
  final int id;
  final String title;
  final Map<String, dynamic> images;

  PreviewSeries(this.id, this.title, this.images);

  PreviewSeries.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        images = json['images'];
}

List<PreviewSeries> createPreviewSeries(List<dynamic> records) => records
    .map((json) => PreviewSeries.fromJson(json['show']))
    .toList(growable: false);
