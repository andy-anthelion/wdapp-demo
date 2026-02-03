import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final Function(Map<String, String>) onSubmit;

  const LoginForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _locationController = TextEditingController();
  String? _selectedGender;

  bool isActive = false;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _locationController.dispose();
    super.dispose();
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
      'gender': _selectedGender ?? '',
      'age': _ageController.text,
      'location': _locationController.text,
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
      width: 350,
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
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
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
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.wc),
                      ),
                      value: _selectedGender,
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
                      onChanged: isActive ? null : (String? value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                      validator: _validateGender,
                      autovalidateMode: AutovalidateMode.onUnfocus,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Location Field
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  hintText: 'Enter your location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.location_on),
                ),
                readOnly: isActive,
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
      ),
    );
  }
}
