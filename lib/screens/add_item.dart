import 'package:flutter/material.dart';

class AddItem extends StatefulWidget {
  static const routeName = '/add-item';

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dodaj produkt'),
      ),
      body: Text(
          'ADDDDD ITEm '), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
