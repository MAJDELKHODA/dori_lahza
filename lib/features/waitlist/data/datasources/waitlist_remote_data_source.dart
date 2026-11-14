import 'package:dori_lahza/core/network/api_endpoints.dart';
import 'package:dori_lahza/core/network/dio_client.dart';
import 'package:dori_lahza/core/utils/json.dart';
import 'package:dori_lahza/features/waitlist/data/models/waitlist_model.dart';
import 'package:dori_lahza/features/waitlist/domain/entities/waitlist_entry.dart';

class WaitlistRemoteDataSource {
  const WaitlistRemoteDataSource(this._client);

  final DioClient _client;

  Future<WaitlistEntry> join(JoinWaitlistRequest request) async => WaitlistModel.fromJson(
        (await _client.post(ApiEndpoints.waitlist, body: WaitlistModel.toJson(request))).json,
      );

  Future<List<WaitlistEntry>> list({required bool activeOnly}) async => asListOf(
        (await _client.get(ApiEndpoints.waitlist, query: {if (activeOnly) 'active': 1})).data,
        WaitlistModel.fromJson,
      );

  Future<WaitlistEntry> entry(int id) async =>
      WaitlistModel.fromJson((await _client.get(ApiEndpoints.waitlistEntry(id))).json);

  /// Returns the created booking id when the response includes it.
  Future<int?> claim(int id) async {
    final data = (await _client.post(ApiEndpoints.claimWaitlist(id))).json;
    final booking = asJsonOrNull(data['booking']);
    return asIntOrNull(booking?['id'] ?? data['booking_id']) ??
        (data.containsKey('starts_at') ? asIntOrNull(data['id']) : null);
  }

  Future<void> leave(int id) => _client.delete(ApiEndpoints.waitlistEntry(id));
}
