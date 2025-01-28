// lib/widgets/no_notes_widget.dart
import 'package:flutter/material.dart';
import 'package:text_editor/Constants/strings.dart';

class NoNotesWidget extends StatelessWidget {
  const NoNotesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipOval(
          child: Image.asset(
            AppStrings.noNotesImage, // Ensure this image exists in your assets folder
            height: 200,
            width: 200,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "No notes created",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Please create a note by clicking on +",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}
