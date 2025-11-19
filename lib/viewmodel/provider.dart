import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuralfit_frontend/api/api.dart';
import 'package:neuralfit_frontend/viewmodel/auth_state_notifier.dart';
import 'package:neuralfit_frontend/viewmodel/login_viewmodel.dart';

final dioProvider = Provider<Dio>(
  (ref) => Dio(
    BaseOptions(
      baseUrl: "http://192.168.0.16:8080/api",
      headers: {"Content-Type": "application/json"},
      connectTimeout: Duration(milliseconds: 5000),
      receiveTimeout: Duration(milliseconds: 3000),
    ),
  ),
);

final loginViewmodelProvider =
    StateNotifierProvider<LoginViewmodel, LoginViewmodelState>((ref) {
      final userApi = ref.watch(userApiProvider);
      return LoginViewmodel(userApi, ref);
    });

final userApiProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return UserApi(dio);
});

final authStateNotifierProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
      return AuthStateNotifier();
    });
