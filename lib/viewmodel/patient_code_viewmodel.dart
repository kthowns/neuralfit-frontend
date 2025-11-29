import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuralfit_frontend/api/user_repository.dart';
import 'package:neuralfit_frontend/dto/connection_try_request.dart';
import 'package:neuralfit_frontend/exception/api_exception.dart';
import 'package:neuralfit_frontend/viewmodel/provider.dart';

class PatientCodeViewmodel extends StateNotifier<PatientCodeState> {
  final UserRepository _userRepository;
  late final String accessCode;
  final Ref ref;

  PatientCodeViewmodel(this._userRepository, this.ref)
    : super(PatientCodeState()) {
    accessCode = ref.read(authStateNotifierProvider).accessToken;
  }

  void setCode(String code) {
    state = state.copyWith(inviteCode: code);
  }

  Future<void> tryConnect() async {
    final request = ConnectionTryRequest(key: state.inviteCode);

    try {
      await _userRepository.connect(accessCode, request);
    } on ApiException catch (e) {
      state = state.copyWith(errorMessage: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(errorMessage: "알 수 없는 오류가 발생했습니다.");
      rethrow;
    }
  }

  void setErrorMessage(String errorMessage) {
    state = state.copyWith(errorMessage: errorMessage);
  }
}

class PatientCodeState {
  final String inviteCode;
  final String errorMessage;

  PatientCodeState({this.inviteCode = '', this.errorMessage = ''});

  PatientCodeState copyWith({inviteCode, errorMessage}) {
    return PatientCodeState(
      inviteCode: inviteCode ?? this.inviteCode,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
