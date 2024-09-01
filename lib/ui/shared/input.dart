import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String defaultValue;
  const Input({super.key, this.defaultValue = ''});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller =
        TextEditingController(text: defaultValue);

    return Expanded(
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
