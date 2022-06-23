class Stat {
  final dynamic label;
  final dynamic value;

  Stat.fromJson(Map<String, dynamic> json)
      : label = json['label'],
        value = json['value'];
}

List<Stat> createStats(List<dynamic>? records) => records == null
    ? List.empty()
    : records.map((json) => Stat.fromJson(json)).toList(growable: false);
