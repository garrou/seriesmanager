class Character {
  final String id;
  final String name;
  final String actor;
  final String picture;

  Character(this.id, this.name, this.actor, this.picture);

  Character.fromJson(Map<String, dynamic> json)
      : id = json['person_id'],
        name = json['name'],
        actor = json['actor'],
        picture = json['picture'];
}

List<Character> createCharacters(List<dynamic>? records) => records == null
    ? List.empty()
    : records.map((json) => Character.fromJson(json)).toList(growable: false);
