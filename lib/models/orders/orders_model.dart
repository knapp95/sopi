import 'package:sopi/models/orders/order_item_model.dart';

class OrdersModel {
  static List<OrderItemModel> mockedActualOrders = [
    OrderItemModel(
        createDate: DateTime.now(),
        assignedPerson: ['Kamil Nowak', 'Piotr Wiśniewski'],
        currentPositionInQueue: 1,
        waitingTimes: 20,
        prepareTime: 20,
        oid: 35226123789),
    OrderItemModel(
      createDate: DateTime.parse('2020-05-03 09:08'),
      assignedPerson: ['Ania Hulik'],
      currentPositionInQueue: 1,
      waitingTimes: 32,
      prepareTime: 123,
      oid: 14221094839,
    ),

  ];

  static List<OrderItemModel> mockedQueueOrders = [
    OrderItemModel(
        createDate: DateTime.parse('2020-05-03 12:15'),
        assignedPerson: ['Karolina Jagodziewska', 'Janusz Nowacki'],
        currentPositionInQueue: 1,
        waitingTimes: 4,
        prepareTime: 2,
        oid: 38273984278),
    OrderItemModel(
      createDate: DateTime.parse('2020-05-03 12:25'),
      assignedPerson: ['Ania Hulik'],
      currentPositionInQueue: 1,
      waitingTimes: 32,
      prepareTime: 123,
      oid: 30987412983,
    ),
    OrderItemModel(
      assignedPerson: ['Monika Wiśniewska'],
      createDate: DateTime.parse('2020-05-03 12:42'),
      currentPositionInQueue: 13,
      waitingTimes: 52,
      prepareTime: 24,
      oid: 29183091221,
    ),
    OrderItemModel(
      assignedPerson: [],
      createDate: DateTime.parse('2020-05-03 13:32'),
      currentPositionInQueue: 13,
      waitingTimes: 52,
      prepareTime: 24,
      oid: 29183091221,
    )
  ];
}
