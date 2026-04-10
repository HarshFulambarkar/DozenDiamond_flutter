import 'package:flutter/material.dart';

class CommonImage extends StatelessWidget {
  final String imageUrl;
  final String fallbackAsset;
  final BoxFit fit;
  final double? height;
  final double? width;

  const CommonImage({
    Key? key,
    required this.imageUrl,
    required this.fallbackAsset,
    this.fit = BoxFit.cover,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          fallbackAsset,
          height: height,
          width: width,
          fit: fit,
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: SizedBox(
            height: height,
            width: width,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  }
}
