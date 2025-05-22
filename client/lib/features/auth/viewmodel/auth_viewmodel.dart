import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/model/user_model.dart';
import 'package:client/features/auth/repositories/auth_local_repositories.dart';
import 'package:client/features/auth/repositories/auth_remote_repositories.dart';
import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepositories _authRemoteRepositories;
  late AuthLocalRepositories _authLocalRepositories;
  late CurrentUserNotifier _currentUserNotifier;

  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepositories = ref.watch(authRemoteRepositoriesProvider);
    _authLocalRepositories = ref.watch(authLocalRepositoriesProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
    return null;
  }

  Future<void> initSharedPrefs() async {
    await _authLocalRepositories.init();
  }

  Future<void> signUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepositories.signup(
      name: name,
      email: email,
      password: password,
    );

    final val = switch (res) {
      fpdart.Left(value: final l) =>
        state = AsyncValue.error(l.message, StackTrace.current),
      fpdart.Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepositories.login(
      email: email,
      password: password,
    );

    final val = switch (res) {
      fpdart.Left(value: final l) =>
        state = AsyncValue.error(l.message, StackTrace.current),
      fpdart.Right(value: final r) => _loginSuccess(r),
    };

    print(val);
  }

  AsyncValue<UserModel>? _loginSuccess(UserModel user) {
    _authLocalRepositories.setToken(user.token);
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }

  Future<UserModel?> getData() async {
    state = const AsyncValue.loading();
    final token = _authLocalRepositories.getToken();
    if (token != null) {
      final res = await _authRemoteRepositories.getCurrentUserData(token);
      final val = switch (res) {
        fpdart.Left(value: final l) =>
          state = AsyncValue.error(l.message, StackTrace.current),
        fpdart.Right(value: final r) => _getDataSuccess(r),
      };

      return val.value;
    }
    return null;
  }

  AsyncValue<UserModel> _getDataSuccess(UserModel user) {
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }
}
