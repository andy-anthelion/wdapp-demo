import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:result_dart/result_dart.dart';

import '../config/assets.dart';

class LocationService {

  Future<Result<Map<String, String>>> getLocations() async {
    try {
      var fileContent = await rootBundle.loadString(Assets.locations);
      var locations = jsonDecode(fileContent).cast<String,String>();
      return Success(locations);
    } on Exception catch(e) {
      return Failure(e);
    }
  }

  Future<Result<Map<String, List<String>>>> getIndex() async {
    try {
      Map<String, List<String>> index = {};
      var fileContent = await rootBundle.loadString(Assets.locationIndex);
      var content = jsonDecode(fileContent).cast<String, dynamic>();
      for(final entry in content.entries) {
        String prefix = entry.key;
        List<String> codes = (entry.value as List).cast<String>();
        index[prefix] = codes;
      }
      return Success(index);
    } on Exception catch(e) {
      return Failure(e);
    }
  }
}