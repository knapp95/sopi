import 'package:flutter/material.dart';
import 'package:sopi/models/assets/asset_model.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';
import 'package:sopi/ui/widgets/manager/common/asset_show_image.dart';

class PickerTypeWidget extends StatelessWidget {
  final String? initialImage;

  const PickerTypeWidget(this.initialImage, {Key? key}) : super(key: key);

  void _chooseType(BuildContext ctx, String imagePath) {
    Navigator.of(ctx).pop(imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: defaultElevation,
      child: FutureBuilder(
        future: AssetModel.getAvailableTypesImagePath(context),
        builder: (context, AsyncSnapshot typesSnap) {
          if (typesSnap.connectionState == ConnectionState.none ||
              typesSnap.data == null) {
            return Container();
          }
          final List<String> availableTypesImagePath =
              typesSnap.data as List<String>;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemCount: availableTypesImagePath.length,
            itemBuilder: (BuildContext context, int index) {
              final String imagePath = availableTypesImagePath[index];
              return InkWell(
                onTap: () => _chooseType(context, imagePath),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: initialImage == imagePath
                        ? BoxDecoration(border: Border.all(width: 3))
                        : null,
                    child: AssetShowImage(imagePath),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
