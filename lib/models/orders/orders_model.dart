import 'package:sopi/models/orders/order_item_model.dart';

class OrdersModel {
  static List<OrderItemModel> mockedActualOrders = [
    OrderItemModel(
        createDate: DateTime.now(),
        assignedPerson: ['Kamil Nowak', 'Piotr Wiśniewski'],
        currentPositionInQueue: 1,
        humanNumber: 1),
    OrderItemModel(
      createDate: DateTime.parse('2020-05-03 09:08'),
      assignedPerson: ['Ania Hulik'],
      currentPositionInQueue: 1,
      humanNumber: 2,
    ),
  ];

  static List<OrderItemModel> mockedQueueOrders = [
    OrderItemModel(
      createDate: DateTime.parse('2020-05-03 12:15'),
      assignedPerson: ['Karolina Jagodziewska', 'Janusz Nowacki'],
      currentPositionInQueue: 1,
      humanNumber: 3,
    ),
    OrderItemModel(
      createDate: DateTime.parse('2020-05-03 12:25'),
      assignedPerson: ['Ania Hulik'],
      currentPositionInQueue: 1,
      humanNumber: 4,
    ),
    OrderItemModel(
      assignedPerson: ['Monika Wiśniewska'],
      createDate: DateTime.parse('2020-05-03 12:42'),
      currentPositionInQueue: 13,
      humanNumber: 5,
    ),
    OrderItemModel(
      assignedPerson: [],
      createDate: DateTime.parse('2020-05-03 13:32'),
      currentPositionInQueue: 13,
      humanNumber: 6,
    )
  ];
}
