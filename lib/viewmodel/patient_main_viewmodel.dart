import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuralfit_frontend/api/user_repository.dart';

class PatientMainViewmodel extends StateNotifier<PatientMainState> {
  final UserRepository _userRepository;
  final Ref ref;

  PatientMainViewmodel(this._userRepository, this.ref)
    : super(PatientMainState());
}

class PatientMainState {
  PatientMainState();

  PatientMainState copyWith() {
    return PatientMainState();
  }
}
