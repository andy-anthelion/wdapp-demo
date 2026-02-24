import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'location_form_field.dart';

class LoginForm extends StatefulWidget {
  final Function(Map<String, String>) onSubmit;

  const LoginForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _genderKey = GlobalKey<FormFieldState<String>>();
  final _locationKey = GlobalKey<FormFieldState<String>>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _locationController = TextEditingController();
  late final LocationFormFieldModel viewModel = LocationFormFieldModel(
    locationRepo: context.read(),
  );
  
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    _locationController.addListener(_onLocationTextChanged);
  }

  @override
  void dispose() {
    _locationController.removeListener(_onLocationTextChanged);
    _nameController.dispose();
    _ageController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _onLocationTextChanged() {
    final text = _locationController.text.trim();

    if(text.length >= 3 && viewModel.canLoadMenu == false) {
      setState(() {
        viewModel.canLoadMenu = true;
      });
    }

    if(text.length < 3 && viewModel.canLoadMenu == true) {
      setState(() {
        viewModel.canLoadMenu = false;
        _locationKey.currentState!.setValue(null);
      });
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Is required';
    }
    if (value.length < 5) {
      return 'At least 5 characters';
    }
    if (value.length > 12) {
      return 'At most 12 characters';
    }
    if (!RegExp(r'^[A-Za-z0-9_]+$').hasMatch(value)) {
      return 'Use only letters, numbers, and underscores';
    }
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Is required';
    }
    final age = int.tryParse(value);
    if (age == null) {
      return 'Invalid age';
    }
    if (age < 18 || age > 99) {
      return 'Between 18-99 only';
    }
    return null;
  }

  String? _validateLocation(String? value) {
    print("Validate location called ${value}");
    if (value == null || value.isEmpty) {
      return 'Is required';
    }
    return null;
  }

  String? _validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Is required';
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() == false) {
      return;
    }

    setState(() { isActive = true; });
    final formData = {
      'gender': _genderKey.currentState!.value ?? '',
      'age': _ageController.text,
      'location':_locationKey.currentState!.value ?? '',
      'name': _nameController.text,
    };
    widget.onSubmit(formData);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Form submitted successfully!'),
        showCloseIcon: true,
      ),
    );
    setState(() { isActive = false; });
  }

  Widget _renderSubmitButtonLabel(BuildContext context) {
    return isActive ? SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.onPrimary,
        strokeWidth: 2,
      ),
    ):Text(
      'Submit',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 600,
      ),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter name (5-12 characters)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
                readOnly: isActive,
                validator: _validateName,
                autovalidateMode: AutovalidateMode.onUnfocus,
              ),
              const SizedBox(height: 16),

              // Age and Gender Row
              Row(
                children: [
                  // Age Field
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Age',
                        hintText: 'Enter age (18-99)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.calendar_today),
                      ),
                      readOnly: isActive,
                      validator: _validateAge,
                      autovalidateMode: AutovalidateMode.onUnfocus,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Gender Dropdown
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      key: _genderKey,
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.wc),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'M',
                          child: Text('Male'),
                        ),
                        DropdownMenuItem(
                          value: 'F',
                          child: Text('Female'),
                        ),
                      ],
                      onChanged: isActive ? null : (String? value) => null,
                      validator: _validateGender,
                      autovalidateMode: AutovalidateMode.onUnfocus,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              LocationFormField(
                menuKey: _locationKey,
                viewModel: viewModel,
                controller: _locationController,
                label: 'Location',
                hint: 'State/Province/Country',
                onSelected: isActive ? null : (String? value) => null,
                validator: _validateLocation,
                autovalidateMode: AutovalidateMode.onUnfocus,
              ),              
              const SizedBox(height: 24),

              // Submit Button
              Center(
                child: FractionallySizedBox(
                  widthFactor: 0.66,
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isActive ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _renderSubmitButtonLabel(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
