import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuralfit_frontend/api/user_repository.dart';
import 'package:neuralfit_frontend/viewmodel/provider.dart';

class TherapistCodeViewModel extends StateNotifier<TherapistCodeState> {
  final UserRepository _userRepository;
  late final String accessToken;
  final Ref ref;

  TherapistCodeViewModel(this._userRepository, this.ref)
    : super(TherapistCodeState()) {
    accessToken = ref.watch(authStateNotifierProvider).accessToken;
  }

  void generateNewCode() async {
    String newCode = await _userRepository.getInviteCode(accessToken);
    state = state.copyWith(code: newCode);
  }
}

class TherapistCodeState {
  final String code;

  TherapistCodeState({this.code = ''});

  TherapistCodeState copyWith({String? code}) {
    return TherapistCodeState(code: code ?? this.code);
  }
}
