import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuralfit_frontend/api/api.dart';
import 'package:neuralfit_frontend/dto/login_dto.dart';
import 'package:neuralfit_frontend/exception/api_exception.dart';
import 'package:neuralfit_frontend/viewmodel/provider.dart';

class LoginViewmodel extends StateNotifier<LoginViewmodelState> {
  final UserApi _userApi;
  final Ref ref;

  LoginViewmodel(this._userApi, this.ref) : super(LoginViewmodelState());

  Future<void> login() async {
    state = state.copyWith(isLoginButtonEnabled: false, isLoading: true);
    final request = LoginRequest(email: state.email, password: state.password);
    final authState = ref.read(authStateNotifierProvider.notifier);

    try {
      final loginResponse = await _userApi.login(request);
      final userInfo = await _userApi.getUserInfo(loginResponse.accessToken);
      state = state.copyWith(errorMessage: '', isLoading: false);

      authState.setLoginState(
        loginResponse.accessToken,
        loginResponse.refreshToken,
        userInfo,
      );
    } on ApiException catch (e) {
      if (e.status == 401) {
        state = state.copyWith(
          errorMessage: '아이디 또는 비밀번호가 올바르지 않습니다.',
          isLoading: false,
        );
      } else {
        state = state.copyWith(errorMessage: e.message, isLoading: false);
      }
      await Future.delayed(Duration(seconds: 2));
      state = state.copyWith(isLoginButtonEnabled: true, errorMessage: '');
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
      ); // 디버깅용, 실제 앱에서는 적절한 메시지로 변경 필요
      await Future.delayed(Duration(seconds: 2));
      state = state.copyWith(
        isLoginButtonEnabled: true,
        errorMessage: '',
        isLoading: false,
      );
    }
  }

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void checkFullfilled() {
    if (state.email.isNotEmpty && state.password.isNotEmpty) {
      state = state.copyWith(isLoginButtonEnabled: true);
    } else {
      state = state.copyWith(isLoginButtonEnabled: false);
    }
  }
}

class LoginViewmodelState {
  final String email;
  final String password;
  final bool isLoginButtonEnabled;
  final String errorMessage;
  final bool isLoading;

  const LoginViewmodelState({
    this.email = '',
    this.password = '',
    this.isLoginButtonEnabled = false,
    this.errorMessage = '',
    this.isLoading = false,
  });
  LoginViewmodelState copyWith({
    String? email,
    String? password,
    bool? isLoginButtonEnabled,
    String? errorMessage,
    bool? isLoading,
  }) {
    return LoginViewmodelState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoginButtonEnabled: isLoginButtonEnabled ?? this.isLoginButtonEnabled,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
