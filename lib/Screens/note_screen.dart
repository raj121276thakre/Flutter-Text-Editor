import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_filex/open_filex.dart';
import '../Providers/note_provider.dart';
import '../Providers/theme_provider.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  bool _isFabExpanded = false; // To track FAB expansion
  TextAlign _currentTextAlign = TextAlign.left; // Track text alignment
  double _currentFontSize = 16.0; // Track font size
  bool _isBold = false; // Track bold toggle
  bool _isItalic = false; // Track italic toggle
  Color _currentFillColor = Colors.transparent; // Track text fill color

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

  Future<void> _generateAndOpenPDF(String content, String title) async {
    try {
      // Create the PDF document
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Padding(
            padding: const pw.EdgeInsets.all(16),
            child: pw.Text(
              content,
              style: const pw.TextStyle(fontSize: 18),
            ),
          ),
        ),
      );

      // Get the Downloads directory
      final directory = await getDownloadsDirectory();
      if (directory == null) {
        throw Exception("Downloads directory not available");
      }

      // Save the PDF file
      final filePath = "${directory.path}/$title.pdf";
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      // Open the PDF file
      await OpenFilex.open(filePath);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("PDF saved and opened: $title.pdf"),
        ),
      );
    } catch (e) {
      // Show an error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to save/open PDF: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu, color: theme.colorScheme.onPrimary),
              onPressed: () {
                Scaffold.of(context)
                    .openDrawer(); // Use the correct context to open the drawer
              },
              tooltip: "Menu",
            );
          },
        ),
        title: Text(
          " NotePad App",
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        centerTitle: false,
        backgroundColor: theme.colorScheme.primary,
        elevation: 4.0,
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: theme.colorScheme.onPrimary,
            ),
            tooltip: themeProvider.isDarkMode
                ? "Switch to Light Mode"
                : "Switch to Dark Mode",
            onPressed: () {
              themeProvider.toggleTheme(!themeProvider.isDarkMode);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
              ),
              child: Column(
                children: [
                  ClipOval(
                    child: Image.asset(
                      "assets/icon/icon.png", // Path to your custom image
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    'NotePad App',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.note_add),
              title: Text('Create New Note'),
              onTap: () {
                Navigator.pop(context);
                noteProvider.createNewNote();
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Add navigation to Settings screen if needed
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.pop(context);
                // Add navigation to About screen if needed
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: noteProvider.notes.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/no_notes.png', // Ensure this image is added to the assets folder and listed in pubspec.yaml
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
                ),
              )
            : Container(
                color: theme.colorScheme.primary,
                child: Column(
                  children: [
                    // Custom Tabs Section (Horizontal Buttons)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          theme.colorScheme.background,
                                      foregroundColor: isSelected
                                          ? theme.colorScheme.onPrimary
                                          : theme.colorScheme.onSurface,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        side: BorderSide(
                                          color: isSelected
                                              ? theme.colorScheme.onPrimary
                                              : const Color.fromARGB(
                                                  255, 27, 26, 26),
                                        ),
                                      ),
                                      elevation: 0,
                                    ),
                                    onPressed: () =>
                                        noteProvider.selectNote(index),
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

                   

                    // Note Editor Section with Download Button
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                            TextField(
                              controller: noteProvider.notes.isNotEmpty
                                  ? noteProvider.currentNoteController
                                  : null,
                              maxLines: null,
                              expands: true,
                              onChanged: noteProvider.updateCurrentNoteContent,
                              textAlign: _currentTextAlign, // Apply alignment
                              style: TextStyle(
                                fontSize: _currentFontSize, // Apply font size
                                fontWeight: _isBold
                                    ? FontWeight.bold
                                    : FontWeight.normal, // Apply bold
                                fontStyle: _isItalic
                                    ? FontStyle.italic
                                    : FontStyle.normal, // Apply italic
                                color: _currentFillColor, // Apply fill color
                              ),
                              decoration: const InputDecoration(
                                hintText: "Write your notes here...",
                                border: InputBorder.none,
                              ),
                            ),
                            // Download Icon Positioned in the Top-Right Corner
                            if (noteProvider.notes.isNotEmpty)
                              Positioned(
                                top: 8,
                                right: 2,
                                child: IconButton(
                                  onPressed: () {
                                    final currentNote = noteProvider
                                        .notes[noteProvider.currentNoteIndex];
                                    _generateAndOpenPDF(
                                      currentNote.content,
                                      currentNote.title,
                                    );
                                  },
                                  icon: Icon(
                                    Icons.download,
                                    color: theme.colorScheme.primary,
                                    size: 28,
                                  ),
                                  tooltip: "Download as PDF",
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),




 // Font Options Toolbar
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                            255, 247, 246, 246), // Background for the toolbar
                       // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Distribute evenly
                        children: [
                          // Bold Button
                          IconButton(
                            icon: Icon(
                              Icons.format_bold,
                              color: _isBold ? Colors.blue : Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _isBold = !_isBold;
                              });
                            },
                          ),
                    
                          // Italic Button
                          IconButton(
                            icon: Icon(
                              Icons.format_italic,
                              color: _isItalic ? Colors.blue : Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _isItalic = !_isItalic;
                              });
                            },
                          ),
                    
                    // Fill Color Dropdown
                          DropdownButton<Color>(
                            value: _currentFillColor,
                            items: [
                              Colors.transparent,
                              Colors.black,
                              Colors.yellow,
                              Colors.green,
                              Colors.blue,
                              Colors.red,
                              Colors.purple,
                              Colors.orange,
                              Colors.pink,
                              Colors.teal,
                              Colors.brown,
                              Colors.grey,
                              Colors.cyan,
                            ].map((color) {
                              return DropdownMenuItem<Color>(
                                value: color,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: color,
                                    border: Border.all(
                                        color: Colors
                                            .black12), // Optional border for visibility
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (color) {
                              setState(() {
                                _currentFillColor = color ??
                                    Colors
                                        .transparent; // Ensure a valid fallback
                              });
                            },
                          ),
                    
                          // Font Size Dropdown
                          DropdownButton<double>(
                            value: _currentFontSize,
                            items: [12, 14, 16, 18, 20, 24]
                                .map((size) => DropdownMenuItem(
                                      value: size.toDouble(),
                                      child: Text(
                                        "$size",
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                if (value != null) _currentFontSize = value;
                              });
                            },
                          ),
                    
                          // Alignment Dropdown
                          DropdownButton<TextAlign>(
                            value: _currentTextAlign,
                            items: [
                              DropdownMenuItem(
                                value: TextAlign.left,
                                child: Row(
                                  children: [
                                    Icon(Icons.format_align_left, size: 18),
                                    SizedBox(width: 6),
                                    Text("Left"),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: TextAlign.center,
                                child: Row(
                                  children: [
                                    Icon(Icons.format_align_center, size: 18),
                                    SizedBox(width: 6),
                                    Text("Center"),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: TextAlign.right,
                                child: Row(
                                  children: [
                                    Icon(Icons.format_align_right, size: 18),
                                    SizedBox(width: 6),
                                    Text("Right"),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: TextAlign.justify,
                                child: Row(
                                  children: [
                                    Icon(Icons.format_align_justify,
                                        size: 18),
                                    SizedBox(width: 6),
                                    Text("Justify"),
                                  ],
                                ),
                              ),
                            ],
                            onChanged: (align) {
                              setState(() {
                                if (align != null) _currentTextAlign = align;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 55.0, right: 8.0),
        child: Column(
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
                child: const Icon(Icons.delete, color: Colors.white),
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
              child: Icon(_isFabExpanded ? Icons.close : Icons.add,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
