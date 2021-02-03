import 'package:flutter/material.dart';
class LoadingDataInProgress extends StatelessWidget {
  final String message;
  LoadingDataInProgress({this.message = 'Loading data is progress'});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          Padding(
            padding: EdgeInsets.only(top: 30),
          ),
          Text(message),
        ],
      ),
    );
  }
}
