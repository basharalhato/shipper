import 'dart:async';

import 'package:shipper/features/home/domain/entities/order.dart';
import 'package:shipper/features/home/domain/use_cases/update_delivery_geo_point_uc.dart';
import 'package:shipper/features/home/domain/use_cases/update_delivery_status_uc.dart';

abstract class IHomeRepo {
  Stream<List<Order>> getUpcomingOrders();

  Future<Order> getOrder(String orderId);

  Future<void> updateDeliveryStatus(UpdateDeliveryStatusParams params);

  Future<void> updateDeliveryGeoPoint(UpdateDeliveryGeoPointParams params);
}
