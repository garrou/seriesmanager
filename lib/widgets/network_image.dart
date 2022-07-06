import 'package:flutter/material.dart';
import 'package:seriesmanager/styles/styles.dart';

class AppNetworkImage extends StatelessWidget {
  final String image;
  const AppNetworkImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) => Image.network(
        image,
        loadingBuilder: (context, child, loadingProgress) {
          return loadingProgress == null
              ? child
              : Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                    value: loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!,
                  ),
                );
        },
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) =>
                Center(
          child: Text('Image non disponible', style: textStyle),
        ),
      );
}
