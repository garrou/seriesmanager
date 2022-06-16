import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/models/guard.dart';
import 'package:seriesmanager/utils/redirects.dart';
import 'package:seriesmanager/views/auth/login.dart';
import 'package:seriesmanager/views/user/nav.dart';
import 'package:seriesmanager/widgets/button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StreamController<bool> _streamController = StreamController();

  @override
  void initState() {
    Guard.checkAuth(_streamController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: AuthGuard(
          authStream: _streamController.stream,
          signedIn: const UserNav(initial: 0),
          signedOut: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  'assets/home.svg',
                  semanticsLabel: 'Logo',
                  height: 200,
                ),
                Padding(
                  child: Text('Series Manager', style: titleTextStyle),
                  padding: const EdgeInsets.all(20),
                ),
                AppButton(
                  content: 'Découvrir',
                  onPressed: () {},
                ),
                AppButton(
                  content: "Se connecter",
                  onPressed: () => push(context, const LoginPage()),
                )
              ],
            ),
          ),
        ),
      );
}
