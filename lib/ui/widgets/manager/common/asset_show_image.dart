import 'package:flutter/material.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';

class AssetShowImage extends StatelessWidget {
  final String? imagePath;
  final double width;
  final double height;
  final bool fromAsset;

  const AssetShowImage(this.imagePath,
      {this.width = 50, this.height = 50, this.fromAsset = true, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String imagePath = this.imagePath ?? 'assets/images/no_photo.png';
    return ClipRRect(
        borderRadius: defaultRadius,
        child: fromAsset
            ? Image.asset(
                imagePath,
                fit: BoxFit.fill,
                height: width,
                width: height,
              )
            : Image.network(
                imagePath,
                fit: BoxFit.fill,
                height: width,
                width: height,
              ));
  }
}
