import 'package:flutter/material.dart';

class LoadingDataInProgressWidget extends StatelessWidget {
  final String message;
  final bool withScaffold;

  LoadingDataInProgressWidget(
      {this.message = 'Loading data is progress', this.withScaffold = false});

  @override
  Widget build(BuildContext context) {
    return this.withScaffold
        ? Scaffold(body: _buildLoadingDataInProgressBody())
        : _buildLoadingDataInProgressBody();
  }

  Widget _buildLoadingDataInProgressBody() {
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
