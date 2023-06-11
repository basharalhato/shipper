import 'package:shipper/auth/data/repos/auth_repo.dart';
import 'package:shipper/auth/domain/entities/user.dart';
import 'package:shipper/auth/domain/repos/i_auth_repo.dart';
import 'package:shipper/auth/domain/use_cases/get_user_data_uc.dart';
import 'package:shipper/core/domain/use_cases/use_case_base.dart';
import 'package:shipper/core/presentation/services/fcm_service/fcm_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final signInWithEmailUCProvider = Provider(
  (ref) => SignInWithEmailUC(
    ref,
    authRepo: ref.watch(authRepoProvider),
  ),
);

class SignInWithEmailUC implements UseCaseBase<User, SignInWithEmailParams> {
  SignInWithEmailUC(this.ref, {required this.authRepo});

  final Ref ref;
  final IAuthRepo authRepo;

  @override
  Future<User> call(SignInWithEmailParams params) async {
    final userFromCredential = await authRepo.signInWithEmail(params);
    return await getUserData(userFromCredential.id);
  }

  Future<User> getUserData(String uid) async {
    final user = await ref.read(getUserDataUCProvider).call(uid);
    await ref.read(fcmProvider).subscribeToTopic('general');
    return user;
  }
}

class SignInWithEmailParams extends Equatable {
  final String email;
  final String password;

  const SignInWithEmailParams({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }

  @override
  List<Object> get props => [email, password];
}
