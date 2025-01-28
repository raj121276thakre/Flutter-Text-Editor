// lib/widgets/note_editor_widget.dart
import 'package:flutter/material.dart';
import '../Providers/note_provider.dart';

class NoteEditorWidget extends StatelessWidget {
  final NoteProvider noteProvider;
  final TextAlign currentTextAlign;
  final double currentFontSize;
  final bool isBold;
  final bool isItalic;

  const NoteEditorWidget({
    Key? key,
    required this.noteProvider,
    required this.currentTextAlign,
    required this.currentFontSize,
    required this.isBold,
    required this.isItalic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // TextField for Note Editing
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: TextField(
                controller: noteProvider.notes.isNotEmpty
                    ? noteProvider.currentNoteController
                    : null,
                maxLines: null,
                expands: true,
                onChanged: noteProvider.updateCurrentNoteContent,
                textAlign: currentTextAlign,
                style: TextStyle(
                  fontSize: currentFontSize,
                  fontWeight:
                      isBold ? FontWeight.bold : FontWeight.normal,
                  fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                ),
                decoration: const InputDecoration(
                  hintText: "Write your notes here...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
