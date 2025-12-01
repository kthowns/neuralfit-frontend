import 'package:dio/dio.dart';
import 'package:neuralfit_frontend/api/repository.dart';
import 'package:neuralfit_frontend/dto/add_medical_record_request.dart';
import 'package:neuralfit_frontend/model/medical_record.dart';
import 'package:neuralfit_frontend/model/patient_info.dart';

class MedicalRecordRepository extends Repository {
  final Dio dio;

  MedicalRecordRepository(this.dio);

  Future<void> addMedicalRecord(
    String accessToken,
    AddMedicalRecordRequest request,
    PatientInfo patient,
  ) async {
    try {
      final response = await dio.post(
        '/record/${patient.id}',
        data: request.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      print('POST /record ${response.data}');
    } on DioException catch (e) {
      throw handleApiException(e);
    } catch (e) {
      print('POST /record unknown error: $e');
      throw handleUnknownException(e);
    }
  }

  Future<List<MedicalRecord>> getMedicalRecord(
    String accessToken,
    int patientId,
    int year,
    int month,
  ) async {
    try {
      final response = await dio.get(
        '/record',
        queryParameters: {
          'patient_id': patientId,
          'year': year,
          'month': month,
        },
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      print('GET /record ${response.data}');
      return (response.data as List<dynamic>)
          .map((item) => MedicalRecord.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw handleApiException(e);
    } catch (e) {
      print('GET /record unknown error: $e');
      throw handleUnknownException(e);
    }
  }
}
