import 'package:flutter/material.dart';

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
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.black,
                    ),
                    value: loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!,
                  ),
                );
        },
      );
}
