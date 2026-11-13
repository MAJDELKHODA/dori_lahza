import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exceptions.dart';
import '../../core/network/api_endpoints.dart';
import '../models/team/team_member_model.dart';

class TeamRepository {
  final ApiClient _apiClient;

  TeamRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<TeamMemberModel>> getTeamMembers() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.staff);

      if (response.data is! Map) {
        throw ApiException(message: 'استجابة السيرفر غير صحيحة');
      }

      final json = Map<String, dynamic>.from(response.data as Map);

      if (json['success'] != true || json['data'] is! List) {
        throw ApiException(
          message: json['message']?.toString() ?? 'تعذر تحميل الفريق',
        );
      }

      final List data = json['data'];

      return data.map((item) {
        return TeamMemberModel.fromJson(Map<String, dynamic>.from(item as Map));
      }).toList();
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}
