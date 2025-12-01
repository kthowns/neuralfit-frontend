import 'package:neuralfit_frontend/api/repository.dart';
import 'package:neuralfit_frontend/dto/connection_try_request.dart';
import 'package:neuralfit_frontend/model/app_user_info.dart';
import 'package:neuralfit_frontend/dto/login_dto.dart';
import 'package:dio/dio.dart';
import 'package:neuralfit_frontend/model/patient_info.dart';

class UserRepository extends Repository {
  final Dio dio;

  UserRepository(this.dio);

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await dio.post('/auth/login', data: request.toJson());
      print('/auth/login ${response.data}');
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw handleApiException(e);
    } catch (e) {
      print('/auth/login unknown error: $e');
      throw handleUnknownException(e);
    }
  }

  Future<AppUserInfo> getUserInfo(String accessToken) async {
    try {
      final response = await dio.get(
        '/user/me',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      print('/user/me ${response.data}');
      return AppUserInfo.fromJson(response.data);
    } on DioException catch (e) {
      print('/user/me error : ${e.response?.data} $e');
      throw handleApiException(e);
    } catch (e) {
      print('/user/me unknown error: $e');
      throw handleUnknownException(e);
    }
  }

  Future<String> getInviteCode(String accessToken) async {
    try {
      final response = await dio.post(
        '/user/connection/generate',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      print('/user/connection/generate ${response.data}');
      return response.data['key'];
    } on DioException catch (e) {
      print('/user/connection/generate error : ${e.response?.data} $e');
      throw handleApiException(e);
    } catch (e) {
      print('/user/connection/generate unknown error: $e');
      throw handleUnknownException(e);
    }
  }

  Future<List<PatientInfo>> getPatients(String accessToken) async {
    try {
      final response = await dio.get(
        '/user/my-patients',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      print('/user/my-patients ${response.data}');
      return (response.data as List)
          .map((patient) => PatientInfo.fromJson(patient))
          .toList();
    } on DioException catch (e) {
      throw handleApiException(e);
    } catch (e) {
      print('/user/my-patients unknown error: $e');
      throw handleUnknownException(e);
    }
  }

  Future<void> connect(String accessToken, ConnectionTryRequest request) async {
    try {
      final response = await dio.post(
        '/user/connection/try',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        data: request.toJson(),
      );
      print('/user/connection/try ${response.data}');
    } on DioException catch (e) {
      throw handleApiException(e);
    } catch (e) {
      print('/user/connection/try unknown error: $e');
      throw handleUnknownException(e);
    }
  }

  Future<void> disconnect(String accessToken, PatientInfo patient) async {
    try {
      final response = await dio.delete(
        '/user/connection/${patient.id}',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      print('DELETE /user/connection/ ${response.data}');
    } on DioException catch (e) {
      throw handleApiException(e);
    } catch (e) {
      print('DELETE /user/connection/try unknown error: $e');
      throw handleUnknownException(e);
    }
  }
}
