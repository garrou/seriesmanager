import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seriesmanager/styles/text.dart';

Future<void> alertDialog(BuildContext context, VoidCallback onTap) =>
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Supprimer cette série ?', style: textStyle),
            content: SvgPicture.asset(
              'assets/delete.svg',
              height: MediaQuery.of(context).size.height / 3,
            ),
            actions: <Widget>[
              Padding(
                child: InkWell(
                  child: Text(
                    'Non',
                    style: textStyle,
                  ),
                  onTap: () => Navigator.of(context).pop(),
                ),
                padding: const EdgeInsets.only(right: 20),
              ),
              InkWell(
                child: Text(
                  'Oui',
                  style: textStyle,
                ),
                onTap: onTap,
              )
            ],
          );
        });
