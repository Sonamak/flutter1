import 'package:sonamak_flutter/core/network/interceptors.dart';
import 'package:sonamak_flutter/core/security/secure_storage.dart';
import 'package:sonamak_flutter/data/services/auth_api.dart';
import 'package:sonamak_flutter/data/models/auth_models.dart';

class AuthRepository {
  Future<void> setToken(String token) async {
    await SecureStorage.write(NetKeys.tokenKey, token);
  }

  Future<void> clearToken() async {
    await SecureStorage.delete(NetKeys.tokenKey);
  }

  Future<MePayload> bootstrap() async {
    final res = await AuthApi.me();
    final data = res.data ?? <String, dynamic>{};
    return MePayload.fromJson(data);
  }
}
