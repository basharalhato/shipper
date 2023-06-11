import 'package:shipper/core/presentation/helpers/localization_helper.dart';
import 'package:shipper/core/presentation/utils/dialogs.dart';
import 'package:shipper/core/presentation/utils/toasts.dart';
import 'package:shipper/features/home/domain/entities/order.dart';
import 'package:shipper/features/home/presentation/components/dialogs/cancel_order_dialog.dart';
import 'package:shipper/features/home/presentation/components/dialogs/confirm_choice_dialog.dart';
import 'package:shipper/features/home/presentation/components/dialogs/order_details_dialog.dart';
import 'package:flutter/material.dart';

abstract class OrderDialogHelper {
  static void showOrderDetailsDialog(
    BuildContext context, {
    required Order order,
  }) {
    Dialogs.showCustomDialog(
      context,
      child: OrderDetailsDialog(
        order: order,
      ),
    );
  }

  static Future<String?> showCancelOrderDialog(BuildContext context) async {
    return await Dialogs.showCustomDialog(
      context,
      child: const CancelOrderDialog(),
    ).then((value) async {
      return value?[0];
    });
  }

  static bool confirmDeliveryId(
    BuildContext context, {
    required String deliveryId,
    required String? orderDeliveryId,
  }) {
    print('meee: $deliveryId');
    print('meee: $orderDeliveryId');
    if (deliveryId == orderDeliveryId) {
      return true;
    } else {
      Toasts.showTitledToast(
        context,
        title: tr(context).youCanNotProceedThisOrder,
        description: tr(context).youCanOnlyProceedOrdersYouDelivering,
      );
      return false;
    }
  }

  static Future<bool> confirmChoiceDialog(
    BuildContext context,
    String message,
  ) async {
    return await Dialogs.showCustomDialog(
      context,
      child: ConfirmChoiceDialog(
        message: message,
      ),
    ).then((value) {
      if (value == null) return false;
      return value[0];
    });
  }
}