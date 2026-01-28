import 'package:flutter/material.dart';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:result_dart/result_dart.dart';

import '../models/login_request/login_request.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';


class AuthRepo extends ChangeNotifier {
  AuthRepo({
    required ApiService apiService,
    required StorageService storageService,
  }): 
    _apiService = apiService,
    _storageService = storageService
  {
    _apiService.authHeaderProvider = _addBearerToHeader;
  }

  final ApiService _apiService;
  final StorageService _storageService;
  
  bool? _isAuthenticated;
  String? _token;
  
  Map<String, dynamic>? get info => 
    _token != null ? JwtDecoder.decode(_token as String) : null;
  
  String? _addBearerToHeader() => 
    _token != null ? 'Bearer $_token' : null; 

  Future<bool> get isAuthenticated async {
    
    if(_isAuthenticated != null) {
      return _isAuthenticated!;
    }

    await _fetch();
    return _isAuthenticated ?? false;
  }

  Future<void> _fetch() async {

    (await _storageService.fetchToken()).fold(
      (success) {
        _token = success;
        _isAuthenticated = true;
      },
      (error) {
        _token = null;
        _isAuthenticated = false;
      }
    );
  }

  Future<Result<void>> login({
    required String gender,
    required int age,
    required String location,
    required String name
  }) async {
    try {
      return (await _apiService.login(
        LoginRequest(gender: gender, age: age, location: location, name: name),
      )).fold((token) {
        _isAuthenticated = true;
        _token = token;
        return _storageService.saveToken(token);
      },(failure) {
        return Failure(failure);
      });
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> logout() async {
    try {
      await _storageService.saveToken(null);
      _token = null;
      _isAuthenticated = false;
      return Success(());
    } finally {
      notifyListeners();
    }
  }
}