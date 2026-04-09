import 'package:flutter/material.dart';

import '../repos/app_repo.dart';

class ConversationBarModel {
  ConversationBarModel({
    required AppRepo appRepo
  }):
    _appRepo = appRepo
  {
  }

  String? selectedID;

  final AppRepo _appRepo;

}

class ConversationBar extends StatelessWidget {

  final TextEditingController _controller = new TextEditingController();

  void _handleSubmit(String message) {
    _controller.clear();
  }

  void _handleButtonPress() {
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        style: TextTheme.of(context).bodyLarge,
        decoration: InputDecoration(
          hintText: 'start a conversation ... ',
          hintStyle: TextStyle(
            color: ColorScheme.of(context).onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
          hoverColor: Colors.transparent,
          filled: true,
          fillColor: ColorScheme.of(context).surfaceContainerHighest,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28.0),
            borderSide: BorderSide.none,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: IconButton(
              hoverColor: Colors.transparent,
              icon: const Icon(Icons.send),
              onPressed: _handleButtonPress,
              color: ColorScheme.of(context).primary,
            ),
          ),
        ),
        onSubmitted: _handleSubmit,
      ),
    );
  }
}
