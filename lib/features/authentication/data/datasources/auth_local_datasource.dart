import 'dart:convert';
import 'package:diar_tunis/core/storage/secure_storage.dart';
import 'package:diar_tunis/features/authentication/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getLastUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearUser();
  Future<String?> getToken();
  Future<void> cacheToken(String token);
  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorage secureStorage;
  
  static const String cachedUserKey = 'CACHED_USER';
  static const String cachedTokenKey = 'CACHED_TOKEN';

  AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<UserModel?> getLastUser() async {
    final jsonString = await secureStorage.read(cachedUserKey);
    if (jsonString != null) {
      return UserModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await secureStorage.write(cachedUserKey, json.encode(user.toJson()));
  }

  @override
  Future<void> clearUser() async {
    await secureStorage.delete(cachedUserKey);
  }

  @override
  Future<String?> getToken() async {
    return await secureStorage.read(cachedTokenKey);
  }

  @override
  Future<void> cacheToken(String token) async {
    await secureStorage.write(cachedTokenKey, token);
  }

  @override
  Future<void> clearToken() async {
    await secureStorage.delete(cachedTokenKey);
  }
}
