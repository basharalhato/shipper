import 'package:shipper/auth/data/models/user_model.dart';
import 'package:shipper/auth/domain/use_cases/sign_in_with_email_uc.dart';
import 'package:shipper/core/data/error/app_exception.dart';
import 'package:shipper/core/data/error/server_exception_type.dart';
import 'package:shipper/core/data/network/i_firebase_auth_caller.dart';
import 'package:shipper/core/data/network/i_firebase_firestore_caller.dart';
import 'package:shipper/core/data/network/main_api/api_callers/main_api_auth_caller.dart';
import 'package:shipper/core/data/network/main_api/api_callers/main_api_firestore_caller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class IAuthRemoteDataSource {
  /// Calls the api endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<UserModel> signInWithEmail(SignInWithEmailParams params);

  Future<String> getUserAuthUid();

  Future<UserModel> getUserData(String uid);

  Future<void> setUserData(UserModel userModel);

  Future<void> signOut();
}

final authRemoteDataSourceProvider = Provider<IAuthRemoteDataSource>(
  (ref) => AuthRemoteDataSource(
    ref,
    firebaseAuthCaller: ref.watch(mainApiAuthCaller),
    firebaseFirestoreCaller: ref.watch(mainApiFirestoreCaller),
  ),
);

class AuthRemoteDataSource implements IAuthRemoteDataSource {
  AuthRemoteDataSource(
    this.ref, {
    required this.firebaseAuthCaller,
    required this.firebaseFirestoreCaller,
  });

  final Ref ref;
  final IFirebaseAuthCaller firebaseAuthCaller;
  final IFirebaseFirestoreCaller firebaseFirestoreCaller;

  static const String usersCollectionPath = 'users';

  static String userDocPath(String uid) => '$usersCollectionPath/$uid';

  @override
  Future<UserModel> signInWithEmail(SignInWithEmailParams params) async {
    final userCredential = await firebaseAuthCaller.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
    return UserModel.fromUserCredential(userCredential.user!);
  }

  @override
  Future<String> getUserAuthUid() async {
    final currentUser = await firebaseAuthCaller.getCurrentUser();
    return currentUser.uid;
  }

  @override
  Future<UserModel> getUserData(String uid) async {
    final response =
        await firebaseFirestoreCaller.getData(path: userDocPath(uid));
    if (response.data() != null) {
      return UserModel.fromMap(response.data() as Map<String, dynamic>);
    } else {
      throw const ServerException(
        type: ServerExceptionType.notFound,
        message: 'User data not found.',
      );
    }
  }

  @override
  Future<void> setUserData(UserModel userModel) async {
    return await firebaseFirestoreCaller.setData(
      path: userDocPath(userModel.id),
      data: userModel.toMap(),
    );
  }

  @override
  Future<void> signOut() async {
    return await firebaseAuthCaller.signOut();
  }
}
