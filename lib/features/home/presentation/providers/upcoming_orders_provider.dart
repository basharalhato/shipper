import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shipper/features/home/domain/entities/order.dart';
import 'package:shipper/features/home/domain/use_cases/get_upcoming_orders_uc.dart';

final upcomingOrdersProvider = StreamProvider.autoDispose<List<Order>>((ref) {
  final ordersStream = ref.watch(getUpcomingOrdersUCProvider).call();
  return ordersStream.distinct((previous, next) {
    /// Compare prev,next streams by deep equals and skip if they're not equal,
    /// while ignoring deliveryGeoPoint in Order entity's equatable props list.
    /// This avoid updating the stream when the delivery updates his own deliveryGeoPoint
    /// which will lead to unnecessary api calls.
    return previous.lock == next.lock;
  });
});
