import 'package:flutter/material.dart';

class AppLink extends StatelessWidget {
  final Widget child;
  final Widget destination;
  const AppLink({Key? key, required this.child, required this.destination})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextButton(
          child: child,
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => destination))));
}
