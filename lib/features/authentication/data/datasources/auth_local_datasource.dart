import 'dart:convert';

import 'package:diar_tunis/core/storage/secure_storage.dart';
import 'package:diar_tunis/features/authentication/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final SharedPreferences sharedPreferences;

  static const String cachedUserKey = 'CACHED_USER';
  static const String cachedTokenKey = 'CACHED_TOKEN';

  AuthLocalDataSourceImpl({
    required this.secureStorage,
    required this.sharedPreferences,
  });

  @override
  Future<UserModel?> getLastUser() async {
    final jsonString = sharedPreferences.getString(cachedUserKey);
    if (jsonString != null) {
      return UserModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await sharedPreferences.setString(
      cachedUserKey,
      json.encode(user.toJson()),
    );
  }

  @override
  Future<void> clearUser() async {
    await sharedPreferences.remove(cachedUserKey);
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
