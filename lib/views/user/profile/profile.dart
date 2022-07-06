import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:provider/provider.dart';
import 'package:seriesmanager/models/guard.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_profile.dart';
import 'package:seriesmanager/providers/theme_provider.dart';
import 'package:seriesmanager/services/user_service.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/utils/storage.dart';
import 'package:seriesmanager/views/auth/login.dart';
import 'package:seriesmanager/widgets/error.dart';
import 'package:seriesmanager/views/user/profile/search_banner.dart';
import 'package:seriesmanager/views/user/profile/update_password.dart';
import 'package:seriesmanager/views/user/profile/update_profile.dart';
import 'package:seriesmanager/widgets/loading.dart';
import 'package:seriesmanager/widgets/network_image.dart';
import 'package:seriesmanager/widgets/responsive_layout.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<UserProfile> _profile;
  final StreamController<bool> _streamController = StreamController();

  Future<UserProfile> _loadProfile() async {
    HttpResponse response = await UserService().getProfile();

    if (response.success()) {
      return UserProfile.fromJson(response.content());
    } else {
      throw Exception();
    }
  }

  @override
  void initState() {
    Guard.checkAuth(_streamController);
    _profile = _loadProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Mon profil', style: textStyle),
          actions: [
            IconButton(
              onPressed: () {
                Storage.removeToken();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const LoginPage(),
                    ),
                    (route) => false);
              },
              icon: const Icon(Icons.logout_outlined),
            ),
          ],
        ),
        body: AuthGuard(
          authStream: _streamController.stream,
          signedOut: const LoginPage(),
          signedIn: SingleChildScrollView(
            controller: ScrollController(),
            child: AppResponsiveLayout(
              mobileLayout: mobileLayout(),
              desktopLayout: desktopLayout(),
            ),
          ),
        ),
      );

  Widget desktopLayout() => Padding(
        child: mobileLayout(),
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 8),
      );

  Widget mobileLayout() => FutureBuilder<UserProfile>(
        future: _profile,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const AppError();
          } else if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: AppNetworkImage(image: snapshot.data!.banner),
                ),
                Consumer<ThemeModel>(
                  builder: (context, ThemeModel themeNotifier, child) {
                    return SwitchListTile(
                      title: Text('Thème', style: textStyle),
                      value: themeNotifier.isDark,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (value) => themeNotifier.isDark = value,
                      secondary: Icon(
                        themeNotifier.isDark
                            ? Icons.nightlight_round_outlined
                            : Icons.wb_sunny_outlined,
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.image_outlined),
                  title: Text('Bannière', style: textStyle),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () async {
                      await showSearch(
                          context: context, delegate: SearchBanner());
                      _refresh();
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.list_alt_outlined),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  UpdateProfile(profile: snapshot.data!)));
                      _refresh();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListTile(
                    leading: const Icon(Icons.person_outlined),
                    title: Text("Nom d'utilisateur", style: textStyle),
                    subtitle:
                        Text(snapshot.data!.username, style: minTextStyle),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: Text('Email', style: textStyle),
                    subtitle: Text(snapshot.data!.email, style: minTextStyle),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.password_outlined),
                  title: Text('Mot de passe', style: textStyle),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const UpdatePassword())),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.timelapse_outlined),
                  title: Text('Membre depuis le', style: textStyle),
                  subtitle: Text(
                    snapshot.data!.formatJoinedAt(),
                    style: minTextStyle,
                  ),
                ),
              ],
            );
          }
          return const AppLoading();
        },
      );

  Future<void> _refresh() async {
    setState(() {
      _profile = _loadProfile();
    });
  }
}
