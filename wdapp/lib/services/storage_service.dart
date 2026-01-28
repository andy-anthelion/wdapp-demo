import 'package:result_dart/result_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {

  Future<Result<String>> _fetchString(String key) async {
    try {
      final prefs = SharedPreferencesAsync();
      String? val = await prefs.getString(key);
      return val != null ? Success(val) : Failure(Exception("key doesnt exist"));
    } on Exception catch(e) {
      return Failure(e);
    }
  }

  Future<Result<void>> _saveString(String key, String? value) async {
    try {
      final prefs = SharedPreferencesAsync();
      if (value == null) {
        await prefs.remove(key);
      } else {
        await prefs.setString(key, value);
      }
      return Success(());
    } on Exception catch(e) {
      return Failure(e);
    }
  }

  static const String _tokenKey = 'TOKEN';
  Future<Result<String>> fetchToken() async => await _fetchString(_tokenKey);
  Future<Result<void>> saveToken(String? value) async => await _saveString(_tokenKey, value);

}