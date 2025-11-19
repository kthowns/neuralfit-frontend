import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuralfit_frontend/dto/app_user_info.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier() : super(const AuthState());

  void setLoginState(
    String accessToken,
    String refreshToken,
    AppUserInfo userInfo,
  ) {
    state = state.copyWith(
      isLoggedIn: true,
      accessToken: accessToken,
      refreshToken: refreshToken,
      userInfo: userInfo,
    );

    print(
      'AuthState updated: ${state.isLoggedIn}, User: ${state.userInfo?.email}',
    );
  }

  void logout() {
    state = state.copyWith(
      isLoggedIn: false,
      accessToken: '',
      refreshToken: '',
      userInfo: null,
    );
  }
}

class AuthState {
  final bool isLoggedIn;
  final String accessToken;
  final String refreshToken;
  final AppUserInfo? userInfo;

  const AuthState({
    this.isLoggedIn = false,
    this.accessToken = '',
    this.refreshToken = '',
    this.userInfo,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    String? accessToken,
    String? refreshToken,
    AppUserInfo? userInfo,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      userInfo: userInfo ?? this.userInfo,
    );
  }
}
