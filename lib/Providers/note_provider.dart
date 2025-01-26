import 'package:flutter/material.dart';
import '../Models/note.dart';
import '../Database/note_database.dart';
class NoteProvider with ChangeNotifier {
  List<Note> _notes = [];
  int _currentNoteIndex = -1;

  // Persistent controllers for each note
  final Map<int, TextEditingController> _controllers = {};

  // Undo/Redo stacks
  final List<String> _undoStack = [];
  final List<String> _redoStack = [];

  // Expose notes list
  List<Note> get notes => _notes;

  // Expose the current selected note index
  int get currentNoteIndex => _currentNoteIndex;

  // Provide the TextEditingController for the current note
  TextEditingController get currentNoteController {
    if (_currentNoteIndex == -1) return TextEditingController();

    // Return existing controller or create a new one
    _controllers[_currentNoteIndex] ??= TextEditingController(
        text: _notes[_currentNoteIndex].content);
    return _controllers[_currentNoteIndex]!;
  }

  // Getter for the content of the current note
  String get currentNoteContent {
    if (_currentNoteIndex == -1) {
      return ''; // If no note is selected, return an empty string
    }
    return _notes[_currentNoteIndex].content;
  }

  // Load notes from the database
  Future<void> loadNotesFromDatabase() async {
    final noteMaps = await NoteDatabase.instance.fetchNotes();
    _notes = noteMaps.map((noteMap) => Note.fromJson(noteMap)).toList();

    // Initialize controllers for loaded notes
    for (var i = 0; i < _notes.length; i++) {
      _controllers[i] = TextEditingController(text: _notes[i].content);
    }

    notifyListeners();
  }

  // Create a new note
  void createNewNote() async {
    final newNote = Note(
      title: 'Note ${_notes.length + 1}',
      content: '',
    );
    final noteId = await NoteDatabase.instance.insertNote(newNote.toJson());
    newNote.id = noteId;
    _notes.insert(0, newNote);

    // Create a controller for the new note
    _controllers[0] = TextEditingController();
    _currentNoteIndex = 0;

    notifyListeners();
  }

  // Update the content of the current note
  void updateCurrentNoteContent(String content) async {
    if (_currentNoteIndex != -1) {
      // Save the current state for undo
      _undoStack.add(_notes[_currentNoteIndex].content);
      _redoStack.clear();

      final note = _notes[_currentNoteIndex];
      note.content = content;

      // Update the content in the controller
      _controllers[_currentNoteIndex]?.text = content;

      await NoteDatabase.instance.updateNote(note.id!, note.toJson());
      notifyListeners();
    }
  }

  // Undo the last change
  void undo() {
    if (_undoStack.isNotEmpty && _currentNoteIndex != -1) {
      final lastContent = _undoStack.removeLast();
      _redoStack.add(_notes[_currentNoteIndex].content);
      _notes[_currentNoteIndex].content = lastContent;
      _controllers[_currentNoteIndex]?.text = lastContent;

      notifyListeners();
    }
  }

  // Redo the last undone change
  void redo() {
    if (_redoStack.isNotEmpty && _currentNoteIndex != -1) {
      final redoContent = _redoStack.removeLast();
      _undoStack.add(_notes[_currentNoteIndex].content);
      _notes[_currentNoteIndex].content = redoContent;
      _controllers[_currentNoteIndex]?.text = redoContent;

      notifyListeners();
    }
  }

  // Select a specific note by its index
  void selectNote(int index) {
    _currentNoteIndex = index;
    _undoStack.clear();
    _redoStack.clear();
    notifyListeners();
  }

  // Delete the current note
  void deleteCurrentNote() async {
    if (_currentNoteIndex != -1) {
      final noteToDelete = _notes[_currentNoteIndex];

      // Remove the note from the database
      await NoteDatabase.instance.deleteNote(noteToDelete.id!);

      // Remove the note and controller from the local state
      _notes.removeAt(_currentNoteIndex);
      _controllers.remove(_currentNoteIndex);

      // Reset the current note index
      _currentNoteIndex = _notes.isEmpty ? -1 : 0;

      notifyListeners();
    }
  }
}
