import 'package:flutter/material.dart';

typedef LocationCallback = Future<List<DropdownMenuEntry<String>>?> Function(
    String searchQuery);

class LocationFormField extends StatefulWidget {
  final String? value;
  final String label;
  final String? hint;
  final ValueChanged<String?>? onSelected;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode autovalidateMode;

  const LocationFormField({
    Key? key,
    required this.value,
    required this.label,
    required this.onSelected,
    this.hint,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
  }) : super(key: key);

  @override
  State<LocationFormField> createState() => _LocationFormFieldState();
}

class _LocationFormFieldState extends State<LocationFormField> {
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();
  late TextEditingController _controller;
  List<DropdownMenuEntry<String>> _dropdownItems = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onTextChanged() async {
    final text = _controller.text.trim();

    // Only trigger when 3 or more characters AND dropdown items are empty
    if (text.length >= 3 && _dropdownItems.isEmpty) {
      setState(() => _isLoading = true);
      setState(() {
        _dropdownItems.add(DropdownMenuEntry<String>(value: 'USCA.', label: 'California (USA)'));
        _dropdownItems.add(DropdownMenuEntry<String>(value: 'USWA.', label: 'Washington DC (USA)'));
        _dropdownItems.add(DropdownMenuEntry<String>(value: 'USIN.', label: 'Indiana (USA)'));
        _isLoading = false;
      });
    }
    
    // Only trigger when less than 3 characters AND dropdown items are NOT empty
    if (text.length < 3 && !_dropdownItems.isEmpty) {
      setState(() {
        _dropdownItems.clear();
        _key.currentState!.reset();
      });
      widget.onSelected?.call(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenuFormField<String>(
      key: _key,
      controller: _controller,
      initialSelection: widget.value,
      label: Text(widget.label),
      hintText: widget.hint,
      dropdownMenuEntries: _dropdownItems,
      onSelected: widget.onSelected,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
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
      trailingIcon: _isLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            )
          : null,
    );
  }
}
