import 'package:shipper/core/data/error/app_exception.dart';
import 'package:shipper/core/data/error/server_exception_type.dart';
import 'package:shipper/core/data/network/i_firebase_firestore_caller.dart';
import 'package:shipper/core/data/network/main_api/api_callers/main_api_firestore_caller.dart';
import 'package:shipper/features/home/data/models/order_model.dart';
import 'package:shipper/features/home/domain/use_cases/update_delivery_geo_point_uc.dart';
import 'package:shipper/features/home/domain/use_cases/update_delivery_status_uc.dart';
import 'package:shipper/features/home/presentation/utils/enums.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class IHomeRemoteDataSource {
  /// Calls the api endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Stream<List<OrderModel>> getUpcomingOrders();

  Future<OrderModel> getOrder(String orderId);

  Future<void> updateDeliveryStatus(UpdateDeliveryStatusParams params);

  Future<void> updateDeliveryGeoPoint(UpdateDeliveryGeoPointParams params);
}

final homeRemoteDataSourceProvider = Provider<IHomeRemoteDataSource>(
  (ref) => HomeRemoteDataSource(
    ref,
    firebaseFirestoreCaller: ref.watch(mainApiFirestoreCaller),
  ),
);

class HomeRemoteDataSource implements IHomeRemoteDataSource {
  HomeRemoteDataSource(
    this.ref, {
    required this.firebaseFirestoreCaller,
  });

  final Ref ref;
  final IFirebaseFirestoreCaller firebaseFirestoreCaller;

  static const String ordersCollectionPath = 'orders';

  static String orderDocPath(String id) => '$ordersCollectionPath/$id';

  @override
  Stream<List<OrderModel>> getUpcomingOrders() {
    final snapshots = firebaseFirestoreCaller.collectionStream(
      path: ordersCollectionPath,
      queryBuilder: (query) => query
          .where('pickupOption', isEqualTo: PickupOption.delivery.name)
          .where('deliveryStatus', whereIn: [
        DeliveryStatus.upcoming.name,
        DeliveryStatus.onTheWay.name
      ]).orderBy('date', descending: true),
    );

    return snapshots
        .map((snapshot) => OrderModel.parseListOfDocument(snapshot.docs));
  }

  @override
  Future<OrderModel> getOrder(String orderId) async {
    final response =
        await firebaseFirestoreCaller.getData(path: orderDocPath(orderId));
    if (response.data() != null) {
      return OrderModel.fromMap(
        response.data() as Map<String, dynamic>,
        response.id,
      );
    } else {
      throw const ServerException(
        type: ServerExceptionType.notFound,
        message: 'Order not found.',
      );
    }
  }

  @override
  Future<void> updateDeliveryStatus(UpdateDeliveryStatusParams params) async {
    await firebaseFirestoreCaller.updateData(
      path: orderDocPath(params.orderId),
      data: params.toMap(),
    );
  }

  @override
  Future<void> updateDeliveryGeoPoint(
      UpdateDeliveryGeoPointParams params) async {
    await firebaseFirestoreCaller.updateData(
      path: orderDocPath(params.orderId),
      data: params.toMap(),
    );
  }
}
