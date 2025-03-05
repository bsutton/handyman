import 'package:shelf_rate_limiter/shelf_rate_limiter.dart';

/// define a memory backed ratelimiter to 10 requests per minute.
final memoryStorage = MemStorage();
final rateLimiter = ShelfRateLimiter(
  storage: memoryStorage,
  duration: const Duration(seconds: 60),
  maxRequests: 100,
);
