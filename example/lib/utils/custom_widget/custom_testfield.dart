import 'package:flutter/material.dart';

class CustomTextField {
  static Row buildTextField(TextEditingController? controller, String? key) {
    return Row(
      children: [
        Expanded(child: Text(key ?? "")),
        Expanded(
          flex: 2,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: key ?? "",
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
