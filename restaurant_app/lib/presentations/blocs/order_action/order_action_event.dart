sealed class OrderActionEvent {
  final String orderId;
  const OrderActionEvent(this.orderId);
}

class AcceptOrder extends OrderActionEvent {
  AcceptOrder(super.orderId);
}

class RejectOrder extends OrderActionEvent {
  RejectOrder(super.orderId);
}

class MarkPreparing extends OrderActionEvent {
  MarkPreparing(super.orderId);
}

class MarkReady extends OrderActionEvent {
  MarkReady(super.orderId);
}
