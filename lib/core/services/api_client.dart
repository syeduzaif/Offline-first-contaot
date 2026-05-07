import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

import '../constants/app_constants.dart';

/// HTTP client used for any *non-sync* network calls (e.g. avatar fetches).
/// The sync engine has its own transport — see jsonplaceholder_transport.dart.
class ApiClient {
  ApiClient({CacheStore? cacheStore}) {
    final cacheOptions = CacheOptions(
      store: cacheStore ?? MemCacheStore(),
      policy: CachePolicy.request,
      hitCacheOnErrorExcept: const [401, 403],
      maxStale: const Duration(days: 7),
      priority: CachePriority.normal,
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      allowPostMethod: false,
    );

    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
      ),
    )..interceptors.add(DioCacheInterceptor(options: cacheOptions));
  }

  late final Dio dio;
}
