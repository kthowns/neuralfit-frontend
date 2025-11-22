import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuralfit_frontend/api/user_repository.dart';
import 'package:neuralfit_frontend/viewmodel/auth_state_notifier.dart';
import 'package:neuralfit_frontend/viewmodel/login_viewmodel.dart';
import 'package:neuralfit_frontend/viewmodel/therapist_code_viewmodel.dart';
import 'package:neuralfit_frontend/viewmodel/therapist_main_viewmodel.dart';

final dioProvider = Provider<Dio>(
  (ref) => Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? "",
      headers: {"Content-Type": "application/json"},
      connectTimeout: Duration(milliseconds: 5000),
      receiveTimeout: Duration(milliseconds: 3000),
    ),
  ),
);

final therapistCodeViewModelProvider =
    StateNotifierProvider<TherapistCodeViewModel, TherapistCodeState>((ref) {
      final userApi = ref.watch(userApiProvider);
      return TherapistCodeViewModel(userApi, ref);
    });

final therapistMainViewModelProvider =
    StateNotifierProvider<TherapistMainViewModel, TherapistMainState>((ref) {
      final userApi = ref.watch(userApiProvider);
      return TherapistMainViewModel(userApi, ref);
    });

final loginViewmodelProvider =
    StateNotifierProvider<LoginViewmodel, LoginViewmodelState>((ref) {
      final userApi = ref.watch(userApiProvider);
      return LoginViewmodel(userApi, ref);
    });

final userApiProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return UserRepository(dio);
});

final authStateNotifierProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
      return AuthStateNotifier();
    });
