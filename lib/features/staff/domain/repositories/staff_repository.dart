import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/features/staff/domain/entities/staff_member.dart';

abstract interface class StaffRepository {
  /// [serviceId] narrows the team to who provides that service.
  Future<Result<List<StaffMember>>> team({int? serviceId});

  Future<Result<StaffMember>> member(int id);
}
