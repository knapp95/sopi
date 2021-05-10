import 'package:flutter/material.dart';
import 'package:sopi/common/scripts.dart';
import 'package:sopi/factory/field_builder_factory.dart';
import 'package:sopi/models/assets/asset_item_model.dart';
import 'package:sopi/models/assets/asset_product_model.dart';
import 'package:sopi/models/generic/generic_item_model.dart';
import 'package:sopi/models/products/enums/product_enum_type.dart';
import 'package:sopi/models/products/products_model.dart';
import 'package:sopi/services/products/product_service.dart';
import 'package:sopi/ui/shared/app_colors.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ManagerOrderTimeline extends StatefulWidget {
  final AssetItemModel asset;

  ManagerOrderTimeline(this.asset);

  @override
  _ManagerOrderTimelineState createState() => _ManagerOrderTimelineState(asset);
}

const appSteps = [
  'Configure',
  'Code',
  'Test',
  'Deploy',
  'Scale',
];

class _ManagerOrderTimelineState extends State<ManagerOrderTimeline> {
  DateTime _timeToProcessing = DateTime.now();
  final AssetItemModel _asset;
  final FieldBuilderFactory _formFactory = FieldBuilderFactory.singleton;

  _ManagerOrderTimelineState(this._asset);

  void _calculateTimeToProcessing(int index, int prepareTime) {
    _timeToProcessing = _timeToProcessing.add(Duration(minutes: prepareTime));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: _formFactory.buildDropdownField(
                  fieldName: 'type',
                  initialValue: ProductType.BURGER.toString(),
                  labelText: 'Show by assets',
                  items: ProductsModel.availableProductsTypesGeneric,
                ),
              ),
              Expanded(
                child: _formFactory.buildDropdownField(
                  fieldName: 'type',
                  initialValue: ProductType.BURGER.toString(),
                  labelText: 'Show by employee',
                  items: ProductsModel.availableProductsTypesGeneric,
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _asset.waitingProducts.length,
              itemBuilder: (BuildContext context, int index) {
                AssetProductModel assetProduct = _asset.waitingProducts[index];
                _calculateTimeToProcessing(
                    index, assetProduct.totalPrepareTime);
                print(index == 0);
                print(assetProduct.pid);
                final IndicatorStyle indicator =
                    _indicatorStyleCheckpoint(assetProduct);
                return TimelineTile(
                  alignment: TimelineAlign.manual,
                  isLast: index == _asset.waitingProducts.length - 1,
                  lineXY: 0.25,
                  isFirst: index == 0,
                  indicatorStyle: indicator,
                  startChild: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        formatDateToString(_timeToProcessing, format: 'HH:mm')),
                  ),
                  endChild: _buildPositionDetails(assetProduct),
                  hasIndicator: index % 2 == 1,
                  beforeLineStyle: LineStyle(
                    color: Colors.red,
                    thickness: 1,
                  ),
                  afterLineStyle: LineStyle(
                    color: Colors.blue,
                    thickness: 15,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildPositionDetails(AssetProductModel product) {
  return ConstrainedBox(
    constraints: BoxConstraints(minHeight: 80),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 39, top: 8, bottom: 8, right: 8),
          child: RichText(
            text: TextSpan(children: <TextSpan>[
              TextSpan(
                text: product.name,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.lightGreen,
                ),
              ),
              TextSpan(
                text: '${product.totalPrepareTime}',
                style: TextStyle(
                  fontSize: 22,
                  color: const Color(0xFFF2F2F2),
                ),
              )
            ]),
          ),
        )
      ],
    ),
  );
}

IndicatorStyle _indicatorStyleCheckpoint(AssetProductModel product) {
  return IndicatorStyle(
    width: 24,
    height: 50,
    indicator: Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    ),
  );
}
