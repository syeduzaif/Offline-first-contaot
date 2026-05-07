import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_dummy_app/core/services/jsonplaceholder_transport.dart';
import 'package:offline_first_sync_drift/offline_first_sync_drift.dart';

void main() {
  late Dio dio;
  late JsonPlaceholderTransport transport;

  setUp(() {
    dio = Dio();
    dio.httpClientAdapter = _StubAdapter();
    transport = JsonPlaceholderTransport(dio: dio);
  });

  test(
    'pull(updatedSince=epoch) fetches /users and flattens nested fields',
    () async {
      final page = await transport.pull(
        kind: 'users',
        updatedSince: DateTime.utc(2019, 1, 1),
        pageSize: 50,
      );
      expect(page.items, hasLength(2));
      expect(page.items.first['name'], 'Alice');
      expect(page.items.first['street'], 'Maple');
      expect(page.items.first['city'], 'Springfield');
      expect(page.items.first['companyName'], 'Acme');
    },
  );

  test('pull(updatedSince > epoch) returns empty (cursor-stable)', () async {
    final page = await transport.pull(
      kind: 'users',
      updatedSince: DateTime.utc(2030, 1, 1),
      pageSize: 50,
    );
    expect(page.items, isEmpty);
  });

  test('push of a server-id updates via PUT and reports success', () async {
    final result = await transport.push([
      UpsertOp.create(
        kind: 'users',
        id: '1',
        payloadJson: {'name': 'New Alice'},
      ),
    ]);
    expect(result.allSuccess, isTrue);
    expect(result.results.first.result, isA<PushSuccess>());
  });
}

class _StubAdapter implements HttpClientAdapter {
  static const _users = '''
[
  {
    "id": 1, "name": "Alice", "username": "alice",
    "email": "a@x.io", "phone": "1", "website": "alice.io",
    "address": {"street": "Maple", "suite": "Apt 1",
                "city": "Springfield", "zipcode": "00000"},
    "company": {"name": "Acme"}
  },
  {
    "id": 2, "name": "Bob", "username": "bob",
    "email": "b@x.io", "phone": "2", "website": "bob.io",
    "address": {"street": "Oak", "city": "Shelbyville"},
    "company": {"name": "Globex"}
  }
]''';

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<dynamic>? cancelFuture,
  ) async {
    final path = options.path;
    if (options.method == 'GET' && path == '/users') {
      return ResponseBody.fromString(
        _users,
        200,
        headers: {Headers.contentTypeHeader: ['application/json']},
      );
    }
    if (path.startsWith('/users/') &&
        (options.method == 'PUT' || options.method == 'POST')) {
      return ResponseBody.fromString(
        '{"id": 1, "name": "ok"}',
        200,
        headers: {Headers.contentTypeHeader: ['application/json']},
      );
    }
    if (options.method == 'POST' && path == '/users') {
      return ResponseBody.fromString(
        '{"id": 11, "name": "ok"}',
        201,
        headers: {Headers.contentTypeHeader: ['application/json']},
      );
    }
    if (options.method == 'DELETE') {
      return ResponseBody.fromString(
        '',
        200,
        headers: {Headers.contentTypeHeader: ['application/json']},
      );
    }
    return ResponseBody.fromString('', 404);
  }

  @override
  void close({bool force = false}) {}
}
