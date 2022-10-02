class Actor {
  final int id;
  final String name;
  final dynamic movies;
  final dynamic shows;

  Actor(this.id, this.name, this.movies, this.shows);

  Actor.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        movies = json['movies'],
        shows = json['shows'];
}
