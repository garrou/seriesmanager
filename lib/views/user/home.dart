import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_profile.dart';
import 'package:seriesmanager/services/user_service.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/views/auth/login.dart';
import 'package:seriesmanager/views/user/drawer/drawer.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final StreamController<bool> _streamController = StreamController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Accueil', style: textStyle),
        ),
        drawer: const AppDrawer(),
        body: AuthGuard(
          authStream: _streamController.stream,
          signedOut: const LoginPage(),
          signedIn: const MobileLayout(),
        ),
      );
}

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 8,
        ),
        child: const MobileLayout(),
      );
}

class MobileLayout extends StatefulWidget {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  late Future<UserProfile> _profile;

  @override
  void initState() {
    _profile = _loadProfile();
    super.initState();
  }

  Future<UserProfile> _loadProfile() async {
    HttpResponse response = await UserService().getProfile();

    if (response.success()) {
      print(response.content());
      return UserProfile.fromJson(response.content());
    } else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) => const Card(
        child: Text('coucou'),
      );
}
