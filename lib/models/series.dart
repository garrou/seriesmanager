abstract class Series {
  final int id;
  final String title;
  final String poster;

  Series(this.id, this.title, this.poster);

  Series.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        poster = json['poster'];

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'poster': poster};
}
