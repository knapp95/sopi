class OrderItemModel {
  final int currentPositionInQueue;
  final int oid;
  final int waitingTimes;
  final int prepareTime;

  OrderItemModel({
    this.currentPositionInQueue,
    this.oid,
    this.waitingTimes,
    this.prepareTime,
  });
}
