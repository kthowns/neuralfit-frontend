import 'package:neuralfit_frontend/dto/app_user_info.dart';
import 'package:neuralfit_frontend/dto/login_dto.dart';
import 'package:dio/dio.dart';
import 'package:neuralfit_frontend/exception/api_exception.dart';

class UserApi {
  final Dio dio;

  UserApi(this.dio);

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await dio.post('/auth/login', data: request.toJson());
      print('/auth/login ${response.data}');
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleApiException(e);
    } catch (e) {
      print('/auth/login unknown error: $e');
      throw _handleUnknownException(e);
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
      throw _handleApiException(e);
    } catch (e) {
      print('/user/me unknown error: $e');
      throw _handleUnknownException(e);
    }
  }

  ApiException _handleApiException(DioException e) {
    // 반환 타입 안정성 체크
    final data = e.response?.data;
    final Map<String, dynamic> mapData = data is Map<String, dynamic>
        ? data
        : {};

    print('[${e.response?.statusCode}] DioException: $data $e');

    if (mapData.isEmpty) {
      mapData['message'] = '서버에 알 수 없는 문제가 발생했습니다 :500';
    }

    return ApiException(
      message: mapData['message'] ?? '알 수 없는 오류가 발생했습니다.',
      status: mapData['status'] ?? 500,
      errors: mapData['errors'] ?? {},
    );
  }

  ApiException _handleUnknownException(Object e) {
    print('Unknown exception: $e');
    return ApiException(message: '알 수 없는 오류가 발생했습니다.', status: 500, errors: {});
  }
}
