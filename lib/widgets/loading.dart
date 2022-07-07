import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(50),
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor))
          ],
        ),
      );
}
