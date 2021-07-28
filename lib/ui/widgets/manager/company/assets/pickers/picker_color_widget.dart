import 'package:flutter/material.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';
import 'package:sopi/ui/widgets/manager/company/assets/common/color_box_widget.dart';

class PickerColorWidget extends StatelessWidget {
  void _chooseColor(BuildContext ctx, Color color) {
    Navigator.of(ctx).pop(color);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: defaultElevation,
      child: SizedBox(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
          ),
          itemCount: colors.length,
          itemBuilder: (BuildContext context, int index) {
            Color color = getColorFromHash(colors[index]);
            return InkWell(
              onTap: () => _chooseColor(context, color),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ColorBoxWidget(color),
              ),
            );
          },
        ),
      ),
    );
  }
}
