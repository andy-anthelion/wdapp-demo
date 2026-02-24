import 'package:flutter/material.dart';

import 'package:result_dart/result_dart.dart';

import '../repos/location_repo.dart';

class LocationFormFieldModel {
  LocationFormFieldModel({
    required LocationRepo locationRepo,
  }): _locationRepo = locationRepo;

  final LocationRepo _locationRepo;
  bool canLoadMenu = false;

  Future<Result<Map<String,String>>> 
  fetchLocationsWithPrefix(String prefix) async {
    try {
      List<String> matchingCodes = (
        await _locationRepo.getCodesForPrefix(prefix.toLowerCase())
      ).getOrThrow();
      Map<String, String> locations = {};
      for(String code in matchingCodes) {
        locations[code] = (
          await _locationRepo.getLocationName(code)
        ).getOrThrow();
      }
      return Success(locations);
    } on Exception catch(e){
      return Failure(e);
    }
  }
}

class LocationFormField extends StatelessWidget {
  final LocationFormFieldModel viewModel;
  final String label;
  final String? hint;
  final Key? key;
  final GlobalKey<FormFieldState>? menuKey;
  final TextEditingController controller;
  final ValueChanged<String?>? onSelected;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode autovalidateMode;

  const LocationFormField({
    this.key,
    required this.menuKey,
    required this.viewModel,
    required this.label,
    required this.onSelected,
    required this.controller,
    this.hint,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Result<Map<String,String>>>(
      future: viewModel.fetchLocationsWithPrefix(controller.text.trim()),
      builder: (
        BuildContext context,
        AsyncSnapshot<Result<Map<String,String>>> snapshot
      ) {
        List<DropdownMenuEntry<String>> dropdownItems;
        if (snapshot.hasData) {
          dropdownItems = snapshot.data!
            .getOrDefault({})
            .entries.map((MapEntry<String,String> entry) {
              return DropdownMenuEntry(value: entry.key, label: entry.value);
            }).toList();
        } else {
          dropdownItems = [];
        }
        return DropdownMenuFormField<String>(
          key: menuKey,
          controller: controller,
          leadingIcon: const Icon(Icons.room),
          label: Text(label),
          hintText: hint,
          dropdownMenuEntries: viewModel.canLoadMenu ? dropdownItems : [],
          onSelected: onSelected,
          validator: validator,
          autovalidateMode: autovalidateMode,
          inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          menuHeight: 300,
          expandedInsets: EdgeInsets.zero,
          enableFilter: true,
          enableSearch: true,
        );
      },
    );
  }
}