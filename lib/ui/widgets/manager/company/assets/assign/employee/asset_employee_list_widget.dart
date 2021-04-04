import 'package:flutter/material.dart';
import 'package:sopi/models/user/user_model.dart';
import 'package:sopi/ui/shared/shared_styles.dart';

import 'asset_employee_item_widget.dart';

class AssetEmployeeListWidget extends StatelessWidget {
  final List<UserModel> employees;
  final GlobalKey _draggableKey = GlobalKey();
  AssetEmployeeListWidget(this.employees);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Hold employee to assign',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize20,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 5,
                children: employees
                    .map(
                      (employee) => LongPressDraggable<UserModel>(
                        data: employee,
                        dragAnchor: DragAnchor.pointer,
                        feedback: FractionalTranslation(
                          key: _draggableKey,
                          translation: const Offset(-0.5, -0.5),
                          child: Material(child: AssetEmployeeWidget(employee)),
                        ),
                        child: AssetEmployeeWidget(employee),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
