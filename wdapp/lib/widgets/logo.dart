import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Padding(
        padding: EdgeInsets.all(24.0), 
        child: Text(
          "Wing\n Ding",
          style: TextTheme.of(context).displayLarge!.copyWith(
            height: 0.8,
            fontSize: 150,
            color: ColorScheme.of(context).onSurface.withOpacity(0.25),
          ),
        ),
      ),
    );
  }
}