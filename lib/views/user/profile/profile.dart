import 'package:flutter/material.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/views/drawer/drawer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Mon profil', style: textStyle),
        ),
        drawer: const AppDrawer(),
      );
}
