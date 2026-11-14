import 'dart:async';

import 'package:dori_lahza/app/routes/app_nav.dart';
import 'package:dori_lahza/app/routes/app_routes.dart';
import 'package:dori_lahza/core/utils/feedback.dart';
import 'package:dori_lahza/features/auth/domain/entities/user.dart';
import 'package:dori_lahza/features/auth/domain/repositories/auth_repository.dart';
import 'package:dori_lahza/features/auth/domain/usecases/auth_usecases.dart';
import 'package:get/get.dart';

/// App-wide sign-in state. Guests can browse; protected actions call
/// [ensureSignedIn], which opens login and resumes once the user is in.
class SessionController extends GetxController {
  SessionController({
    required AuthRepository repository,
    required GetCurrentUser getCurrentUser,
    required Logout logout,
  })  : _repository = repository,
        _getCurrentUser = getCurrentUser,
        _logout = logout;

  final AuthRepository _repository;
  final GetCurrentUser _getCurrentUser;
  final Logout _logout;

  final user = Rxn<User>();

  bool get isSignedIn => user.value != null;

  /// Restores the session from a stored token. A rejected token is cleared;
  /// any other failure keeps it so the next launch can try again.
  Future<void> restore() async {
    if (!await _repository.hasSession()) return;
    final result = await _getCurrentUser();
    if (result.failureOrNull?.isUnauthorized ?? false) await _repository.clearSession();
    user.value = result.dataOrNull;
  }

  /// Re-reads `auth/me` (profile screen, reliability after a cancellation).
  Future<void> refreshUser() async {
    if (!isSignedIn) return;
    final result = await _getCurrentUser();
    result.fold((_) {}, (value) => user.value = value);
  }

  void signedIn(User value) => user.value = value;

  void updateUser(User value) =>
      user.value = value.copyWith(reliability: value.reliability ?? user.value?.reliability);

  /// Returns true when the user is (or just became) signed in.
  Future<bool> ensureSignedIn() async {
    if (isSignedIn) return true;
    return await AppNav.login() && isSignedIn;
  }

  Future<void> signOut() async {
    await _logout();
    user.value = null;
    unawaited(Get.offAllNamed<void>(AppRoutes.shell));
  }

  /// Called by the auth interceptor when the server rejects the token.
  Future<void> onTokenRejected() async {
    if (!isSignedIn) return;
    user.value = null;
    AppFeedback.info('انتهت الجلسة، سجّل الدخول مرة أخرى');
  }
}
