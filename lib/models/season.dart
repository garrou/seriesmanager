abstract class Season {
  final int number;
  final int episodes;
  final String image;

  Season(this.number, this.episodes, this.image);

  Season.fromJson(Map<String, dynamic> json)
      : number = json['number'],
        episodes = json['episodes'],
        image = json['image'];

  Map<String, dynamic> toJson();
}
