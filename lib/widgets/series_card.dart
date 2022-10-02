import 'package:flutter/material.dart';
import 'package:seriesmanager/styles/styles.dart';
import 'package:seriesmanager/widgets/network_image.dart';

class AppSeriesCard extends StatelessWidget {
  final dynamic series;
  final String image;
  final VoidCallback onTap;
  const AppSeriesCard(
      {Key? key,
      required this.series,
      required this.image,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(5),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          child: InkWell(
            onTap: onTap,
            child: image.isNotEmpty
                ? AppNetworkImage(image: image)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text(series.title, style: textStyle)],
                  ),
          ),
        ),
      );
}
