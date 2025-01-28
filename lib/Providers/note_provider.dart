import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/note.dart';
import '../Database/note_database.dart';

class NoteProvider with ChangeNotifier {
  List<Note> _notes = [];
  int _currentNoteIndex = -1;

  final Map<int, TextEditingController> _controllers = {};
  final List<String> _undoStack = [];
  final List<String> _redoStack = [];

  List<Note> get notes => _notes;
  int get currentNoteIndex => _currentNoteIndex;

  TextEditingController get currentNoteController {
    if (_currentNoteIndex == -1) return TextEditingController();

    _controllers[_currentNoteIndex] ??= TextEditingController(
        text: _notes[_currentNoteIndex].content);
    return _controllers[_currentNoteIndex]!;
  }

  Future<void> loadNotesFromDatabase() async {
    final noteMaps = await NoteDatabase.instance.fetchNotes();
    _notes = noteMaps.map((noteMap) => Note.fromJson(noteMap)).toList();

    for (var i = 0; i < _notes.length; i++) {
      _controllers[i] = TextEditingController(text: _notes[i].content);
    }

    notifyListeners();
  }

  Future<void> saveLastEditedNoteIndex() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastNoteIndex', _currentNoteIndex);
  }

  Future<void> loadLastEditedNoteIndex() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('lastNoteIndex')) {
      _currentNoteIndex = prefs.getInt('lastNoteIndex') ?? -1;
    }
  }

  void createNewNote() async {
    final newNote = Note(
      title: 'Note ${_notes.length + 1}',
      content: '',
    );
    final noteId = await NoteDatabase.instance.insertNote(newNote.toJson());
    newNote.id = noteId;
    _notes.insert(0, newNote);

    _controllers[0] = TextEditingController();
    _currentNoteIndex = 0;

    notifyListeners();
    await saveLastEditedNoteIndex();
  }

  void updateCurrentNoteContent(String content) async {
    if (_currentNoteIndex != -1) {
      _undoStack.add(_notes[_currentNoteIndex].content);
      _redoStack.clear();

      final note = _notes[_currentNoteIndex];
      note.content = content;

      final controller = _controllers[_currentNoteIndex];
      final cursorPosition = controller?.selection;

      if (controller != null) {
        controller.text = content;

        if (cursorPosition != null) {
          controller.selection = cursorPosition;
        }
      }

      await NoteDatabase.instance.updateNote(note.id!, note.toJson());
      notifyListeners();
      await saveLastEditedNoteIndex();
    }
  }

  void selectNote(int index) async {
    _currentNoteIndex = index;
    _undoStack.clear();
    _redoStack.clear();
    notifyListeners();
    await saveLastEditedNoteIndex();
  }

  void undo() {
    if (_undoStack.isNotEmpty && _currentNoteIndex != -1) {
      final lastContent = _undoStack.removeLast();
      _redoStack.add(_notes[_currentNoteIndex].content);
      _notes[_currentNoteIndex].content = lastContent;
      _controllers[_currentNoteIndex]?.text = lastContent;

      notifyListeners();
    }
  }

  void redo() {
    if (_redoStack.isNotEmpty && _currentNoteIndex != -1) {
      final redoContent = _redoStack.removeLast();
      _undoStack.add(_notes[_currentNoteIndex].content);
      _notes[_currentNoteIndex].content = redoContent;
      _controllers[_currentNoteIndex]?.text = redoContent;

      notifyListeners();
    }
  }

  void deleteCurrentNote() async {
    if (_currentNoteIndex != -1) {
      final noteToDelete = _notes[_currentNoteIndex];
      await NoteDatabase.instance.deleteNote(noteToDelete.id!);

      _notes.removeAt(_currentNoteIndex);
      _controllers.remove(_currentNoteIndex);

      _currentNoteIndex = _notes.isEmpty ? -1 : 0;

      notifyListeners();
    }
  }


 // Add method to delete all notes
  Future<void> deleteAllNotes() async {
    // Clear the in-memory list
    _notes.clear();
    _controllers.clear();
    _currentNoteIndex = -1;

    // Delete all notes from the database
    await NoteDatabase.instance.deleteAllNotes();

    // Notify listeners to update the UI
    notifyListeners();
  }




}