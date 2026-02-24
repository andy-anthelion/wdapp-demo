import 'package:result_dart/result_dart.dart';

import '../services/location_service.dart';

class LocationRepo {

  LocationRepo({
    required LocationService locationService
  }):_locationService = locationService;

  Map<String, String>? _cachedLocations;
  Map<String, List<String>>? _cachedIndex;

  final LocationService _locationService;

  Future<Result<String>> getLocationName(String locCode) async {
    try {
      _cachedLocations ??= (await _locationService.getLocations()).getOrThrow();
      String? name = _cachedLocations![locCode];
      return name != null ? Success(name) : Failure(Exception("name not found"));
    } on Exception catch(e) {
      return Failure(e);
    }
  }

  Future<Result<List<String>>> getCodesForPrefix(String prefix) async {
    try {
      _cachedIndex ??= (await _locationService.getIndex()).getOrThrow();
      if(_cachedIndex?.containsKey(prefix) == false) {
        return Success([]);
      }
      List<String>? codes = _cachedIndex![prefix];
      return codes != null ? Success(codes) : Failure(Exception("codes not present"));
    } on Exception catch(e) {
      return Failure(e);
    }
  }
  
}