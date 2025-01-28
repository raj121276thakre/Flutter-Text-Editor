import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NoteDatabase {
  static final NoteDatabase instance = NoteDatabase._init();
  static Database? _database;

  NoteDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT
      )
    ''');
  }

  Future<int> insertNote(Map<String, dynamic> note) async {
    final db = await instance.database;
    return db.insert('notes', note);
  }

  Future<List<Map<String, dynamic>>> fetchNotes() async {
    final db = await instance.database;
    return db.query('notes', orderBy: 'id DESC');
  }

  Future<int> updateNote(int id, Map<String, dynamic> note) async {
    final db = await instance.database;
    return db.update('notes', note, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteNote(int id) async {
    final db = await instance.database;
    await db.delete(
      'notes', // The name of the table
      where: 'id = ?', // SQL WHERE clause
      whereArgs: [id], // Arguments for the WHERE clause
    );
  }


 // Add the method to delete all notes
  Future<void> deleteAllNotes() async {
    final db = await instance.database;
    await db.delete('notes'); // This will delete all rows from the 'notes' table
  }


}
