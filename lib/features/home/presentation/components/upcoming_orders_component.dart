import 'package:shipper/core/data/error/app_exception.dart';
import 'package:shipper/core/presentation/extensions/app_error_extension.dart';
import 'package:shipper/core/presentation/helpers/localization_helper.dart';
import 'package:shipper/core/presentation/routing/navigation_service.dart';
import 'package:shipper/core/presentation/routing/route_paths.dart';
import 'package:shipper/core/presentation/styles/sizes.dart';
import 'package:shipper/core/presentation/utils/dialogs.dart';
import 'package:shipper/core/presentation/utils/scroll_behaviors.dart';
import 'package:shipper/core/presentation/widgets/custom_text.dart';
import 'package:shipper/core/presentation/widgets/loading_indicators.dart';
import 'package:shipper/core/presentation/widgets/platform_widgets/platform_refresh_indicator.dart';
import 'package:shipper/core/presentation/widgets/seperated_sliver_child_builder_delegate.dart';
import 'package:shipper/features/home/presentation/components/card_item_component.dart';
import 'package:shipper/features/home/presentation/utils/enums.dart';
import 'package:shipper/features/home/presentation/providers/selected_order_provider.dart';
import 'package:shipper/features/home/presentation/providers/upcoming_orders_provider.dart';
import 'package:shipper/features/home/presentation/providers/update_delivery_status_provider/update_delivery_status_provider.dart';
import 'package:shipper/features/home/presentation/providers/update_delivery_status_provider/update_delivery_status_state.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UpcomingOrdersComponent extends ConsumerWidget {
  const UpcomingOrdersComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    ref.listen<AsyncValue<UpdateDeliveryStatusState>>(
      updateDeliveryStatusStateProvider,
      (prevState, newState) {
        prevState?.unwrapPrevious().whenOrNull(
          loading: () {
            NavigationService.dismissDialog(context);
          },
        );
        newState.unwrapPrevious().whenOrNull(
              loading: () => Dialogs.showLoadingDialog(context),
              error: (err, st) {
                Dialogs.showErrorDialog(
                  context,
                  message: (err as AppException).errorMessage(context),
                );
              },
              data: (state) {
                state.whenOrNull(
                  success: (orderId, deliveryStatus) async {
                    if (deliveryStatus != DeliveryStatus.onTheWay) return;
                    final container = ProviderScope.containerOf(context);
                    final sub = container.listen<Option<String>>(
                        selectedOrderIdProvider, (prev, value) {});
                    ref.read(selectedOrderIdProvider.notifier).state =
                        Some(orderId);
                    await NavigationService.push(
                      context,
                      isNamed: true,
                      rootNavigator: true,
                      page: RoutePaths.coreNoInternet,
                      arguments: {'offAll': false},
                    );
                    sub.close();
                  },
                );
              },
            );
      },
    );

    final upcomingOrdersAsync = ref.watch(upcomingOrdersProvider);

    return ScrollConfiguration(
      behavior: MainScrollBehavior(),
      child: upcomingOrdersAsync.when(
        skipLoadingOnReload: true,
        skipLoadingOnRefresh: !upcomingOrdersAsync.hasError,
        data: (upcomingOrders) {
          return PlatformRefreshIndicator(
            onRefresh: () => ref.refresh(upcomingOrdersProvider.future),
            slivers: [
              upcomingOrders.isNotEmpty
                  ? SliverPadding(
                      padding: EdgeInsets.symmetric(
                        vertical: Sizes.screenPaddingV20(context),
                        horizontal: Sizes.screenPaddingH36(context),
                      ),
                      sliver: SliverList(
                        delegate: SeparatedSliverChildBuilderDelegate(
                          itemBuilder: (BuildContext context, int index) {
                            return CardItemComponent(
                              key: ValueKey(upcomingOrders[index].orderId),
                              order: upcomingOrders[index],
                            );
                          },
                          itemCount: upcomingOrders.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: Sizes.marginV30(context),
                            );
                          },
                        ),
                      ),
                    )
                  : SliverFillRemaining(
                      child: CustomText.f20(
                        context,
                        tr(context).thereAreNoOrders,
                        alignment: Alignment.center,
                      ),
                    ),
            ],
          );
        },
        error: (error, st) => PlatformRefreshIndicator(
          onRefresh: () => ref.refresh(upcomingOrdersProvider.future),
          slivers: [
            SliverFillRemaining(
              child: CustomText.f20(
                context,
                '${tr(context).somethingWentWrong}\n${tr(context).pleaseTryAgain}',
                alignment: Alignment.center,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        loading: () => LoadingIndicators.smallLoadingAnimation(context),
      ),
    );
  }
}
