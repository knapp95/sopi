import 'package:flutter/material.dart';

class LoadingDataInProgressWidget extends StatelessWidget {
  final String message;
  final bool withScaffold;

  const LoadingDataInProgressWidget({
    this.message = 'Loading data is progress',
    this.withScaffold = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return withScaffold
        ? Scaffold(body: _buildLoadingDataInProgressBody())
        : _buildLoadingDataInProgressBody();
  }

  Widget _buildLoadingDataInProgressBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const CircularProgressIndicator(),
          const Padding(
            padding: EdgeInsets.only(top: 30),
          ),
          Text(message),
        ],
      ),
    );
  }
}
