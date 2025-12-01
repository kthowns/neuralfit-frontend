import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuralfit_frontend/api/medical_record_repository.dart';
import 'package:neuralfit_frontend/model/app_user_info.dart';
import 'package:neuralfit_frontend/model/medical_record.dart';
import 'package:neuralfit_frontend/viewmodel/provider.dart';

class PatientRecordViewmodel extends StateNotifier<PatientRecordState> {
  late final String accessToken;
  final Ref ref;
  final MedicalRecordRepository medicalRecordRepository;

  PatientRecordViewmodel({
    required this.ref,
    required this.medicalRecordRepository,
  }) : super(PatientRecordState()) {
    accessToken = ref.read(authStateNotifierProvider).accessToken;
    fetchRecords();
  }

  Future<void> fetchRecords() async {
    AppUserInfo? me = ref.read(authStateNotifierProvider).userInfo;

    final records = await medicalRecordRepository.getMedicalRecord(
      accessToken,
      me!.id,
      state.selectedTime.year,
      state.selectedTime.month,
    );
    state = state.copyWith(medicalRecords: records);
  }

  Future<void> setSelectedTime(DateTime time) async {
    if (time.year == state.selectedTime.year &&
        time.month == state.selectedTime.month) {
      return;
    }
    state = state.copyWith(selectedTime: time);
    await fetchRecords();
  }
}

class PatientRecordState {
  final List<MedicalRecord> medicalRecords;
  final DateTime selectedTime;

  PatientRecordState({
    List<MedicalRecord>? medicalRecords,
    DateTime? selectedTime,
  }) : medicalRecords = medicalRecords ?? const [],
       selectedTime = selectedTime ?? DateTime.now();

  PatientRecordState copyWith({
    List<MedicalRecord>? medicalRecords,
    DateTime? selectedTime,
  }) {
    return PatientRecordState(
      medicalRecords: medicalRecords ?? this.medicalRecords,
      selectedTime: selectedTime ?? this.selectedTime,
    );
  }
}
