import 'package:dori_lahza/core/network/api_endpoints.dart';
import 'package:dori_lahza/core/network/dio_client.dart';
import 'package:dori_lahza/core/utils/json.dart';
import 'package:dori_lahza/features/staff/data/models/staff_model.dart';
import 'package:dori_lahza/features/staff/domain/entities/staff_member.dart';

class StaffRemoteDataSource {
  const StaffRemoteDataSource(this._client);

  final DioClient _client;

  Future<List<StaffMember>> team({int? serviceId}) async => asListOf(
        (await _client.get(ApiEndpoints.staff, query: {'service_id': serviceId})).data,
        StaffModel.fromJson,
      );

  Future<StaffMember> member(int id) async =>
      StaffModel.fromJson((await _client.get(ApiEndpoints.staffMember(id))).json);
}
