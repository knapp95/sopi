import 'package:flutter/material.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';

class AssetShowImage extends StatelessWidget {
  final String? imagePath;
  final double width;
  final double height;
  final bool fromAsset;

  AssetShowImage(this.imagePath,
      {this.width = 50, this.height = 50, this.fromAsset = true});

  @override
  Widget build(BuildContext context) {
    String imagePath = this.imagePath ?? 'assets/images/no_photo.png';
    return ClipRRect(
        borderRadius: defaultRadius,
        child: this.fromAsset
            ? Image.asset(
                imagePath,
                fit: BoxFit.fill,
                height: this.width,
                width: this.height,
              )
            : Image.network(
                imagePath,
                fit: BoxFit.fill,
                height: this.width,
                width: this.height,
              ));
  }
}
