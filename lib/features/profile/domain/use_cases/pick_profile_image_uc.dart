import 'dart:io';

import 'package:shipper/core/data/local/image_picker_caller/i_image_picker_caller.dart';
import 'package:shipper/core/domain/use_cases/use_case_base.dart';
import 'package:shipper/features/profile/data/repos/profile_repo.dart';
import 'package:shipper/features/profile/domain/repos/i_profile_repo.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final pickProfileImageUCProvider = Provider(
  (ref) => PickProfileImageUC(
    profileRepo: ref.watch(profileRepoProvider),
  ),
);

class PickProfileImageUC implements UseCaseBase<File, PickSource> {
  PickProfileImageUC({required this.profileRepo});

  final IProfileRepo profileRepo;

  @override
  Future<File> call(PickSource pickSource) async {
    return await profileRepo.pickProfileImage(pickSource);
  }
}
