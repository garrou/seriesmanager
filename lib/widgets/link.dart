import 'package:flutter/material.dart';
import 'package:seriesmanager/utils/redirects.dart';

class AppLink extends StatelessWidget {
  final Widget child;
  final Widget destination;
  const AppLink({Key? key, required this.child, required this.destination})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 5),
        child: TextButton(
          child: child,
          onPressed: () => push(context, destination),
        ),
      );
}
