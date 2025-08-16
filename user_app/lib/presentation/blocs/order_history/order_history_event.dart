sealed class OrderHistoryEvent {}

class LoadOrderHistory extends OrderHistoryEvent {
  final String userId;
  LoadOrderHistory(this.userId);
}
