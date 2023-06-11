import 'package:shipper/core/domain/use_cases/use_case_base.dart';
import 'package:shipper/features/home/data/repos/home_repo.dart';
import 'package:shipper/features/home/domain/entities/order.dart';
import 'package:shipper/features/home/domain/repos/i_home_repo.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final getUpcomingOrdersUCProvider = Provider(
  (ref) => GetUpcomingOrdersUC(
    ref,
    homeRepo: ref.watch(homeRepoProvider),
  ),
);

class GetUpcomingOrdersUC implements UseCaseNoParamsBase<Stream<List<Order>>> {
  GetUpcomingOrdersUC(this.ref, {required this.homeRepo});

  final Ref ref;
  final IHomeRepo homeRepo;

  @override
  Stream<List<Order>> call() {
    return homeRepo.getUpcomingOrders();
  }
}
