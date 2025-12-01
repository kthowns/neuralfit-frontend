import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuralfit_frontend/api/medical_record_repository.dart';
import 'package:neuralfit_frontend/dto/add_medical_record_request.dart';
import 'package:neuralfit_frontend/model/medical_record.dart';
import 'package:neuralfit_frontend/model/patient_info.dart';
import 'package:neuralfit_frontend/viewmodel/provider.dart';

class TherapistRecordViewmodel extends StateNotifier<TherapistRecordState> {
  late final String accessToken;
  final Ref ref;
  final MedicalRecordRepository medicalRecordRepository;

  TherapistRecordViewmodel({
    required this.ref,
    required this.medicalRecordRepository,
  }) : super(TherapistRecordState()) {
    accessToken = ref.read(authStateNotifierProvider).accessToken;
    final currentPatient = ref
        .read(therapistMainViewModelProvider)
        .selectedPatient;

    print("therapistViewmodel init");

    if (currentPatient != null) {
      state = state.copyWith(currentPatient: currentPatient);
      print("currentPatient != null");
      fetchRecords();
    }
  }

  Future<void> fetchRecords() async {
    if (state.currentPatient == null) {
      return;
    }
    final records = await medicalRecordRepository.getMedicalRecord(
      accessToken,
      state.currentPatient!.id,
      state.selectedTime.year,
      state.selectedTime.month,
    );
    state = state.copyWith(medicalRecords: records);
  }

  Future<void> addRecord(AddMedicalRecordRequest request) async {
    if (state.currentPatient == null) {
      return;
    }

    await medicalRecordRepository.addMedicalRecord(
      accessToken,
      request,
      state.currentPatient!,
    );

    await fetchRecords();
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

class TherapistRecordState {
  final List<MedicalRecord> medicalRecords;
  final DateTime selectedTime;
  final PatientInfo? currentPatient;

  TherapistRecordState({
    List<MedicalRecord>? medicalRecords,
    DateTime? selectedTime,
    this.currentPatient,
  }) : medicalRecords = medicalRecords ?? const [],
       selectedTime = selectedTime ?? DateTime.now();

  TherapistRecordState copyWith({
    List<MedicalRecord>? medicalRecords,
    DateTime? selectedTime,
    PatientInfo? currentPatient,
  }) {
    return TherapistRecordState(
      medicalRecords: medicalRecords ?? this.medicalRecords,
      selectedTime: selectedTime ?? this.selectedTime,
      currentPatient: currentPatient ?? this.currentPatient,
    );
  }
}
