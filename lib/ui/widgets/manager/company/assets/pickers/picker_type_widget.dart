import 'package:flutter/material.dart';
import 'package:sopi/models/assets/asset_model.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';
import 'package:sopi/ui/widgets/manager/common/asset_show_image.dart';

class PickerTypeWidget extends StatelessWidget {
  final String? initialImage;

  PickerTypeWidget(this.initialImage);

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
          List<String> availableTypesImagePath = typesSnap.data as List<String>;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemCount: availableTypesImagePath.length,
            itemBuilder: (BuildContext context, int index) {
              String imagePath = availableTypesImagePath[index];
              return InkWell(
                onTap: () => _chooseType(context, imagePath),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: this.initialImage == imagePath
                        ? BoxDecoration(
                            border: Border.all(color: Colors.black, width: 3))
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
