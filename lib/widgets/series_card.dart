import 'package:flutter/material.dart';
import 'package:seriesmanager/styles/text.dart';

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
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 10,
              child: image.isNotEmpty
                  ? Image.network(
                      image,
                      semanticLabel: 'Image de la série',
                      loadingBuilder: (context, child, loadingProgress) {
                        return loadingProgress == null
                            ? child
                            : Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.grey,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                    Colors.black,
                                  ),
                                  value: loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!,
                                ),
                              );
                      },
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text(series.title, style: textStyle)],
                    ),
            ),
          ),
        ),
      );
}
