import 'package:shipper/auth/data/repos/auth_repo.dart';
import 'package:shipper/auth/domain/entities/user.dart';
import 'package:shipper/auth/domain/repos/i_auth_repo.dart';
import 'package:shipper/core/domain/use_cases/use_case_base.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final getUserDataUCProvider = Provider(
  (ref) => GetUserDataUC(
    ref,
    authRepo: ref.watch(authRepoProvider),
  ),
);

class GetUserDataUC implements UseCaseBase<User, String> {
  GetUserDataUC(this.ref, {required this.authRepo});

  final Ref ref;
  final IAuthRepo authRepo;

  @override
  Future<User> call(String uid) async {
    return await authRepo.getUserData(uid);
  }
}
