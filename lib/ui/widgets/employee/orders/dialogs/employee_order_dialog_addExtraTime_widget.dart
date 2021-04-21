import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:sopi/ui/shared/styles/shared_style.dart';

class EmployeeOrderDialogAddExtraTimeWidget extends StatefulWidget {
  final int initialTime;
  final int extraTime;
  final DateTime startOrderTime;

  EmployeeOrderDialogAddExtraTimeWidget(
      this.initialTime, this.extraTime, this.startOrderTime);

  @override
  _EmployeeOrderDialogAddExtraTimeWidgetState createState() =>
      _EmployeeOrderDialogAddExtraTimeWidgetState();
}

class _EmployeeOrderDialogAddExtraTimeWidgetState
    extends State<EmployeeOrderDialogAddExtraTimeWidget> {
  Duration _timePrepare;
  Timer _timer;
  int _extraTime;
  double size = MediaQuery.of(Get.context).size.width / 6;

  @override
  void initState() {
    _extraTime = widget.extraTime;
    _getTime();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void changeExtraTime(int addTime) {
    int newCurrentTime = this._extraTime + addTime;
    setState(() {
      this._extraTime = newCurrentTime;
    });
  }

  void _getTime() {
    setState(() {
      final now = DateTime.now();
      _timePrepare = now.difference(widget.startOrderTime);
    });
  }

  String get _startOrderTimeDisplay {
    return durationInMinutes(_timePrepare);
  }

  Color get colorForOrderTime {
    final int differenceInMinutes =
        _timePrepare.inMinutes - (widget.initialTime + _extraTime);
    Color colorForOrderTime = Colors.black;

    if (differenceInMinutes < -5) {
      colorForOrderTime = primaryColor;
    } else if (differenceInMinutes < 0) {
      colorForOrderTime = Colors.yellow;
    } else if (differenceInMinutes >= 0) {
      colorForOrderTime = Colors.red;
    }

    return colorForOrderTime;
  }

  Color get colorForExtraTime => _extraTime > 0 ? Colors.red : primaryColor;

  Future<void> _submit() async {
    Get.back(result: _extraTime);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('Change order time')),
      shape: shapeDialog,
      elevation: defaultElevation,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSingleBlockTime(-20, withOpacity: 0.8),
              _buildSingleBlockTime(-15, withOpacity: 0.7),
              _buildSingleBlockTime(-10, withOpacity: 0.6),
            ],
          ),
          formSizedBoxHeight,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSingleBlockTime(-5, withOpacity: 0.5),
              _buildCurrencyTime(),
              _buildSingleBlockTime(5, withOpacity: 0.5),
            ],
          ),
          formSizedBoxHeight,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSingleBlockTime(10, withOpacity: 0.6),
              _buildSingleBlockTime(20, withOpacity: 0.7),
              _buildSingleBlockTime(30, withOpacity: 0.8),
            ],
          ),
        ],
      ),
      actions: [
        backDialogButton,
        TextButton(
          onPressed: _submit,
          child: Text(
            'Submit',
            style: TextStyle(color: primaryColor),
          ),
        ),
      ],
    );
  }

  Widget _buildSingleBlockTime(int time, {withOpacity = 1.0}) {
    bool isPositive = time > 0;
    return GestureDetector(
      onTap: () => changeExtraTime(time),
      child: Container(
        width: size,
        height: size,
        decoration: getBoxDecoration(isPositive ? Colors.red : primaryColor,
            withOpacity: withOpacity),
        child: Center(
          child: Text(
            isPositive ? '+ $time' : '- ${time.abs()}',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyTime() {
    return Container(
      width: size,
      height: size,
      child: Center(
        child: FittedBox(
          fit: BoxFit.fill,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    '${widget.initialTime}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  if (_extraTime != 0)
                    Text(
                      _extraTime > 0 ? '+$_extraTime' : '-${_extraTime.abs()}',
                      style: TextStyle(
                        color: colorForExtraTime,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              Text(
                _startOrderTimeDisplay,
                style: TextStyle(
                    color: colorForOrderTime, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
