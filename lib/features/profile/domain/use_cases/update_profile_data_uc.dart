import 'package:shipper/auth/domain/entities/user.dart';
import 'package:shipper/core/domain/use_cases/use_case_base.dart';
import 'package:shipper/features/profile/data/repos/profile_repo.dart';
import 'package:shipper/features/profile/domain/repos/i_profile_repo.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final updateProfileDataUCProvider = Provider(
  (ref) => UpdateProfileDataUC(
    profileRepo: ref.watch(profileRepoProvider),
  ),
);

class UpdateProfileDataUC implements UseCaseBase<void, User> {
  UpdateProfileDataUC({required this.profileRepo});

  final IProfileRepo profileRepo;

  @override
  Future<void> call(User user) async {
    return await profileRepo.updateProfileData(user);
  }
}
