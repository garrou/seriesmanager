import 'package:flutter/material.dart';
import 'package:seriesmanager/styles/styles.dart';
import 'package:seriesmanager/views/user/home.dart';

class AppError extends StatelessWidget {
  const AppError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset('assets/warning.png'),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text('Erreur de connexion', style: boldTextStyle),
                ),
                IconButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const MemberHome()),
                      (route) => false),
                  icon: const Icon(Icons.refresh_outlined, size: 40),
                )
              ],
            ),
          ),
        ),
      );
}
