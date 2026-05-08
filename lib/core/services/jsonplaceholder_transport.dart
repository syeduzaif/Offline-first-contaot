import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:offline_first_sync_drift/offline_first_sync_drift.dart';

import '../../features/contacts/data/remote/contact_dto_mapper.dart';

/// TransportAdapter that bridges the package's expected
/// `{items, nextPageToken}` envelope to JSONPlaceholder's plain-array
/// responses. Push operations against JSONPlaceholder are mock-acked
/// (the body is echoed) — perfect for exercising the outbox without
/// requiring a real backend.
class JsonPlaceholderTransport implements TransportAdapter {
  JsonPlaceholderTransport({required this.dio});

  final Dio dio;

  @override
  Future<PullPage> pull({
    required String kind,
    required DateTime updatedSince,
    required int pageSize,
    String? pageToken,
    String? afterId,
    bool includeDeleted = true,
  }) async {
    // After the first successful pull, the cursor's `updatedSince` will exceed
    // our static server epoch, so we return empty pages — only the canonical
    // first pull seeds the local DB.
    if (updatedSince.isAfter(ContactDtoMapper.serverEpoch)) {
      return PullPage(items: const [], nextPageToken: null);
    }
    final res = await dio.get<List<dynamic>>('/$kind');
    final raw = res.data ?? const [];
    final items = raw
        .cast<Map<String, dynamic>>()
        .map(ContactDtoMapper.fromServer)
        .toList(growable: false);
    return PullPage(items: items, nextPageToken: null);
  }

  @override
  Future<BatchPushResult> push(List<Op> ops) async {
    final results = <OpPushResult>[];
    for (final op in ops) {
      results.add(OpPushResult(opId: op.opId, result: await _pushOne(op)));
    }
    return BatchPushResult(results: results);
  }

  Future<PushResult> _pushOne(Op op) async {
    try {
      if (op is UpsertOp) return await _pushUpsert(op);
      if (op is DeleteOp) return await _pushDelete(op);
      return PushError(ArgumentError('Unknown op: $op'));
    } on DioException catch (e, st) {
      return e.response?.statusCode == 404
          ? const PushNotFound()
          : PushError(e, st);
    } catch (e, st) {
      return PushError(e, st);
    }
  }

  Future<PushResult> _pushUpsert(UpsertOp op) async {
    final isCreate = !_looksLikeServerId(op.id);
    final res = await dio.request<Map<String, dynamic>>(
      isCreate ? '/${op.kind}' : '/${op.kind}/${op.id}',
      data: op.payloadJson,
      options: Options(method: isCreate ? 'POST' : 'PUT'),
    );
    return PushSuccess(serverData: res.data);
  }

  Future<PushResult> _pushDelete(DeleteOp op) async {
    await dio.delete<dynamic>('/${op.kind}/${op.id}');
    return const PushSuccess();
  }

  @override
  Future<PushResult> forcePush(Op op) => _pushOne(op);

  @override
  Future<FetchResult> fetch({required String kind, required String id}) async {
    try {
      final res = await dio.get<Map<String, dynamic>>('/$kind/$id');
      final data = res.data;
      if (data == null) return const FetchNotFound();
      return FetchSuccess(data: ContactDtoMapper.fromServer(data));
    } on DioException catch (e, st) {
      if (e.response?.statusCode == 404) return const FetchNotFound();
      return FetchError(e, st);
    } catch (e, st) {
      return FetchError(e, st);
    }
  }

  @override
  Future<bool> health() async {
    try {
      final res = await dio.get<dynamic>('/users/1');
      return res.statusCode != null &&
          res.statusCode! >= 200 &&
          res.statusCode! < 300;
    } catch (_) {
      return false;
    }
  }

  /// JSONPlaceholder ids are integers; client-created ids are UUIDs.
  /// We only PUT on records that look like they came from the server.
  bool _looksLikeServerId(String id) =>
      id.isNotEmpty && int.tryParse(id) != null;
}

/// Used in tests: encode/decode round-trip helper.
String encodePayload(Map<String, dynamic> payload) => jsonEncode(payload);
