import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuralfit_frontend/api/user_repository.dart';
import 'package:neuralfit_frontend/model/patient_info.dart';
import 'package:neuralfit_frontend/viewmodel/provider.dart';

class TherapistMainViewModel extends StateNotifier<TherapistMainState> {
  final UserRepository _userRepository;
  late final String accessToken;
  final Ref ref;

  TherapistMainViewModel(this._userRepository, this.ref)
    : super(TherapistMainState()) {
    accessToken = ref.read(authStateNotifierProvider).accessToken;
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    final patients = await _userRepository.getPatients(accessToken);
    state = state.copyWith(patients: patients);
  }

  Future<void> setCurrentPatient(PatientInfo patient) async {
    state = state.copyWith(selectedPatient: patient);
    print("setCurrentPatientInfo : ${patient.name}");
  }

  Future<void> disconnect(PatientInfo patient) async {
    await _userRepository.disconnect(accessToken, patient);
    await fetchPatients();
  }
}

class TherapistMainState {
  final List<PatientInfo> patients;
  final PatientInfo? selectedPatient;

  TherapistMainState({this.patients = const [], this.selectedPatient});

  TherapistMainState copyWith({
    List<PatientInfo>? patients,
    PatientInfo? selectedPatient,
  }) {
    return TherapistMainState(
      patients: patients ?? this.patients.toList(),
      selectedPatient: selectedPatient ?? this.selectedPatient,
    );
  }
}
