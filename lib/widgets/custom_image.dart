import 'package:flutter/material.dart';

import '../helpers/api_services.dart';

class CustomImage extends StatelessWidget {
  final String url;
  final double height;
  final double width;
  final BoxFit fit;

  const CustomImage({
    Key? key,
    required this.url,
    this.height = 50,
    this.width = 50,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? _size = height / 3;
    if (height == double.infinity || width == double.infinity) {
      _size = null;
    }

    return Image.network(
      Config.baseUrl + url,
      height: height,
      width: width,
      fit: fit,
      loadingBuilder: (
        BuildContext context,
        Widget child,
        ImageChunkEvent? loadingProgress,
      ) {
        if (loadingProgress == null) return child;
        return SizedBox(
          height: height,
          width: width,
          child: Center(
            child: SizedBox(
              width: _size,
              height: _size,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          ),
        );
      },
    );
  }
}
