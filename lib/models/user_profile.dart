import 'package:intl/intl.dart';

class UserProfile {
  final DateFormat _df = DateFormat('dd/MM/yyyy');

  final String username;
  final String email;
  final DateTime joinedAt;
  final String banner;

  UserProfile(this.username, this.email, this.joinedAt, this.banner);

  UserProfile.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        email = json['email'],
        joinedAt = DateTime.parse(json['joinedAt']),
        banner = json['banner'];

  String formatJoinedAt() => _df.format(joinedAt);
}
