import 'package:flutter/material.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';

class ManagerOrderWidget extends StatefulWidget {
  @override
  _ManagerOrderWidgetState createState() => _ManagerOrderWidgetState();
}

class _ManagerOrderWidgetState extends State<ManagerOrderWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Orders'),
        actions: [
          Card(
            shape: shapeCard,
            child: IconButton(
              icon: Icon(
                Icons.panorama_horizontal,
                color: primaryColor,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.panorama_vertical,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Text('123'),
          Text('245'),
          Text('245'),
        ],
      ),
    );
  }
}
