import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/note_provider.dart';
import '../Providers/theme_provider.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  bool _isFabExpanded = false; // To track FAB expansion

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    await noteProvider.loadNotesFromDatabase();
    await noteProvider.loadLastEditedNoteIndex();

    if (noteProvider.currentNoteIndex != -1) {
      noteProvider.selectNote(noteProvider.currentNoteIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notes",
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        elevation: 4.0,
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: theme.colorScheme.onPrimary,
            ),
            tooltip: themeProvider.isDarkMode ? "Switch to Light Mode" : "Switch to Dark Mode",
            onPressed: () {
              themeProvider.toggleTheme(!themeProvider.isDarkMode);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Tabs Section (Horizontal Buttons)
            Container(
              color: theme.colorScheme.background,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...List.generate(
                      noteProvider.notes.length,
                      (index) {
                        final isSelected =
                            index == noteProvider.currentNoteIndex;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.background,
                              foregroundColor: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                side: BorderSide(
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : Colors.grey.shade300,
                                ),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () => noteProvider.selectNote(index),
                            child: Text(
                              noteProvider.notes[index].title,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Note Editor Section
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: noteProvider.notes.isEmpty
                    ? Center(
                        child: Text(
                          "No notes available. Tap + to create a new note!",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : TextField(
                        controller: noteProvider.currentNoteController,
                        maxLines: null,
                        expands: true,
                        onChanged: noteProvider.updateCurrentNoteContent,
                        decoration: const InputDecoration(
                          hintText: "Write your notes here...",
                          border: InputBorder.none,
                        ),
                        style: theme.textTheme.bodyLarge,
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_isFabExpanded) ...[
            FloatingActionButton.small(
              heroTag: "new_note",
              onPressed: noteProvider.createNewNote,
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.note_add, color: Colors.white),
            ),
            const SizedBox(height: 8),
            FloatingActionButton.small(
              heroTag: "undo",
              onPressed: noteProvider.undo,
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.undo, color: Colors.white),
            ),
            const SizedBox(height: 8),
            FloatingActionButton.small(
              heroTag: "redo",
              onPressed: noteProvider.redo,
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.redo, color: Colors.white),
            ),
            const SizedBox(height: 8),
            FloatingActionButton.small(
              heroTag: "delete",
              onPressed: noteProvider.deleteCurrentNote,
              backgroundColor: Colors.redAccent,
              child: const Icon(Icons.delete, color: Colors.white,),
            ),
            const SizedBox(height: 8),
          ],
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _isFabExpanded = !_isFabExpanded;
              });
            },
            backgroundColor: theme.colorScheme.primary,
            child: Icon(_isFabExpanded ? Icons.close : Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
