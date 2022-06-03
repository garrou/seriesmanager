abstract class Series {
  final int id;
  final String title;

  Series(this.id, this.title);

  Series.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'];

  Map<String, dynamic> toJson();
}
