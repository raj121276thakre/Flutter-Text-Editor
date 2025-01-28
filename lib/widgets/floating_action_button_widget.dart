// lib/widgets/floating_action_button_widget.dart
import 'package:flutter/material.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  final bool isFabExpanded;
  final Function onFabExpandedChange;
  final Function createNewNote;
  final Function undo;
  final Function redo;
  final Function deleteCurrentNote;
  final Function downloadCurrentNote;
  final bool hasNotes; // New parameter to check if there are any notes

  const FloatingActionButtonWidget({
    Key? key,
    required this.isFabExpanded,
    required this.onFabExpandedChange,
    required this.createNewNote,
    required this.undo,
    required this.redo,
    required this.deleteCurrentNote,
    required this.downloadCurrentNote,
    required this.hasNotes, // Added to check if notes exist
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, right: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Show these buttons only if there are notes (hasNotes is true)
          if (isFabExpanded && hasNotes) ...[
            FloatingActionButton.small(
              heroTag: "generate_pdf",
              onPressed: () => downloadCurrentNote(),
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.download, color: Colors.white),
            ),
            FloatingActionButton.small(
              heroTag: "create_note",
              onPressed: () => createNewNote(),
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.note_add, color: Colors.white),
            ),
            const SizedBox(height: 8),
            FloatingActionButton.small(
              heroTag: "undo",
              onPressed: () => undo(),
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.undo, color: Colors.white),
            ),
            const SizedBox(height: 8),
            FloatingActionButton.small(
              heroTag: "redo",
              onPressed: () => redo(),
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.redo, color: Colors.white),
            ),
            const SizedBox(height: 8),
            FloatingActionButton.small(
              heroTag: "delete",
              onPressed: () => deleteCurrentNote(),
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            const SizedBox(height: 8),
          ],

          // Only show the "Create Note" button if no notes exist
          if (isFabExpanded && !hasNotes) ...[
            FloatingActionButton.small(
              heroTag: "create_note",
              onPressed: () => createNewNote(),
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.note_add, color: Colors.white),
            ),
            const SizedBox(height: 8),
          ],

          // Show the "Create Note" button if there are no notes or when the FAB is expanded
          if (!hasNotes || isFabExpanded) ...[
            FloatingActionButton(
              onPressed: () {
                onFabExpandedChange();
              },
              backgroundColor: theme.colorScheme.primary,
              child: Icon(isFabExpanded ? Icons.close : Icons.add,
                  color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }
}
