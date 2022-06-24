class UserStat {
  final dynamic label;
  final dynamic value;

  UserStat.fromJson(Map<String, dynamic> json)
      : label = json['label'],
        value = json['value'];
}

List<UserStat> createStats(List<dynamic>? records) => records == null
    ? List.empty()
    : records.map((json) => UserStat.fromJson(json)).toList(growable: false);
