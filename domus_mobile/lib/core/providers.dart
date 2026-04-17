import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domus_mobile/api/dio_client.dart';
import 'package:domus_mobile/services/auth_storage_service.dart';

final authStorageProvider = Provider<AuthStorageService>((ref) {
  return AuthStorageService();
});

final dioClientProvider = Provider<DioClient>((ref) {
  final authStorage = ref.watch(authStorageProvider);
  return DioClient(authStorage);
});
