import 'package:dori_lahza/core/network/guard.dart';
import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/features/staff/data/datasources/staff_remote_data_source.dart';
import 'package:dori_lahza/features/staff/domain/entities/staff_member.dart';
import 'package:dori_lahza/features/staff/domain/repositories/staff_repository.dart';

class StaffRepositoryImpl implements StaffRepository {
  const StaffRepositoryImpl(this._remote);

  final StaffRemoteDataSource _remote;

  @override
  Future<Result<List<StaffMember>>> team({int? serviceId}) => guard(() => _remote.team(serviceId: serviceId));

  @override
  Future<Result<StaffMember>> member(int id) => guard(() => _remote.member(id));
}
