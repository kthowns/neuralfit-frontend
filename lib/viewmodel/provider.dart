import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuralfit_frontend/api/medical_record_repository.dart';
import 'package:neuralfit_frontend/api/user_repository.dart';
import 'package:neuralfit_frontend/viewmodel/auth_state_notifier.dart';
import 'package:neuralfit_frontend/viewmodel/login_viewmodel.dart';
import 'package:neuralfit_frontend/viewmodel/patient_code_viewmodel.dart';
import 'package:neuralfit_frontend/viewmodel/patient_main_viewmodel.dart';
import 'package:neuralfit_frontend/viewmodel/patient_record_viewmodel.dart';
import 'package:neuralfit_frontend/viewmodel/therapist_code_viewmodel.dart';
import 'package:neuralfit_frontend/viewmodel/therapist_main_viewmodel.dart';
import 'package:neuralfit_frontend/viewmodel/therapist_record_viewmodel.dart';

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
    StateNotifierProvider.autoDispose<
      TherapistCodeViewModel,
      TherapistCodeState
    >((ref) {
      final userApi = ref.watch(userApiProvider);
      return TherapistCodeViewModel(userApi, ref);
    });

final therapistMainViewModelProvider =
    StateNotifierProvider.autoDispose<
      TherapistMainViewModel,
      TherapistMainState
    >((ref) {
      final userApi = ref.watch(userApiProvider);
      return TherapistMainViewModel(userApi, ref);
    });

final patientMainViewmodelProvider =
    StateNotifierProvider.autoDispose<PatientMainViewmodel, PatientMainState>((
      ref,
    ) {
      final userApi = ref.watch(userApiProvider);
      return PatientMainViewmodel(userApi, ref);
    });

final patientCodeStateProvider =
    StateNotifierProvider.autoDispose<PatientCodeViewmodel, PatientCodeState>((
      ref,
    ) {
      final userApi = ref.watch(userApiProvider);
      return PatientCodeViewmodel(userApi, ref);
    });

final therapistRecordViewmodelProvider =
    StateNotifierProvider.autoDispose<
      TherapistRecordViewmodel,
      TherapistRecordState
    >((ref) {
      final medicalRecordRepository = ref.watch(medicalRecordApiProvider);
      return TherapistRecordViewmodel(
        medicalRecordRepository: medicalRecordRepository,
        ref: ref,
      );
    });

final patientRecordViewmodelProvider =
    StateNotifierProvider.autoDispose<
      PatientRecordViewmodel,
      PatientRecordState
    >((ref) {
      final medicalRecordRepository = ref.watch(medicalRecordApiProvider);
      return PatientRecordViewmodel(
        medicalRecordRepository: medicalRecordRepository,
        ref: ref,
      );
    });

final loginViewmodelProvider =
    StateNotifierProvider.autoDispose<LoginViewmodel, LoginViewmodelState>((
      ref,
    ) {
      final userApi = ref.watch(userApiProvider);
      return LoginViewmodel(userApi, ref);
    });

final authStateNotifierProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
      return AuthStateNotifier();
    });

final userApiProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return UserRepository(dio);
});

final medicalRecordApiProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return MedicalRecordRepository(dio);
});
