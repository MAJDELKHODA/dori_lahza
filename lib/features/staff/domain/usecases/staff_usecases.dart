import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/core/usecase/usecase.dart';
import 'package:dori_lahza/features/staff/domain/entities/staff_member.dart';
import 'package:dori_lahza/features/staff/domain/repositories/staff_repository.dart';

class GetTeam implements UseCase<List<StaffMember>, int?> {
  const GetTeam(this._repository);
  final StaffRepository _repository;

  @override
  Future<Result<List<StaffMember>>> call([int? serviceId]) => _repository.team(serviceId: serviceId);
}

class GetStaffProfile implements UseCase<StaffMember, int> {
  const GetStaffProfile(this._repository);
  final StaffRepository _repository;

  @override
  Future<Result<StaffMember>> call(int staffId) => _repository.member(staffId);
}
