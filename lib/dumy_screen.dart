import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_filex/open_filex.dart';
import 'package:text_editor/Constants/strings.dart';
import 'package:text_editor/Screens/about_screen.dart';
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
  // Color _currentFillColor = Colors.black; // Track text fill color

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _showThemeDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Choose Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.wb_sunny),
                title: Text('Default Theme'), // Your custom theme
                onTap: () {
                  themeProvider.setTheme(
                      themeProvider.defaultTheme); // Set to your default theme
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.light_mode),
                title: Text('Light Theme'),
                onTap: () {
                  themeProvider
                      .setTheme(themeProvider.lightTheme); // Set to light theme
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.dark_mode),
                title: Text('Dark Theme'),
                onTap: () {
                  themeProvider
                      .setTheme(themeProvider.darkTheme); // Set to dark theme
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.palette),
                title: Text('Blue Theme'),
                onTap: () {
                  themeProvider
                      .setTheme(themeProvider.blueTheme); // Set to blue theme
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.palette),
                title: Text('Green Theme'),
                onTap: () {
                  themeProvider
                      .setTheme(themeProvider.greenTheme); // Set to green theme
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.palette),
                title: Text('Yellow Theme'),
                onTap: () {
                  themeProvider.setTheme(
                      themeProvider.yellowTheme); // Set to yellow theme
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.palette),
                title: Text('Orange Theme'),
                onTap: () {
                  themeProvider.setTheme(
                      themeProvider.orangeTheme); // Set to orange theme
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.palette),
                title: Text('Pink Theme'),
                onTap: () {
                  themeProvider
                      .setTheme(themeProvider.pinkTheme); // Set to pink theme
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
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
        AppStrings.appName,
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
              //themeProvider.toggleTheme(!themeProvider.isDarkMode);
              _showThemeDialog(context);
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
                      AppStrings.appIcon,// Path to your custom image
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    AppStrings.appName,
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
              leading: Icon(Icons.palette),
              title: Text('Theme Settings'),
              onTap: () {
                _showThemeDialog(context);
              },
            ),
            ListTile(
                leading: Icon(Icons.info),
                title: Text('About'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AboutScreen()), // Navigate to the About Screen
                  );
                }),
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
                                // Reverse the order of notes
                                final reversedIndex =
                                    noteProvider.notes.length - 1 - index;
                                final isSelected = reversedIndex ==
                                    noteProvider.currentNoteIndex;

                                return TweenAnimationBuilder<double>(
                                  duration: const Duration(milliseconds: 300),
                                  tween: Tween(
                                    begin: 1.0,
                                    end: isSelected ? 1.1 : 1.0, // Scale effect
                                  ),
                                  builder: (context, scale, child) {
                                    return Transform.scale(
                                      scale: scale,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6.0, vertical: 4),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: isSelected
                                                ? theme.colorScheme.primary
                                                : theme.colorScheme.background,
                                            foregroundColor: isSelected
                                                ? theme.colorScheme.onPrimary
                                                : theme.colorScheme.onSurface,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              side: BorderSide(
                                                color: isSelected
                                                    ? theme
                                                        .colorScheme.onPrimary
                                                    : const Color.fromARGB(
                                                        255, 27, 26, 26),
                                              ),
                                            ),
                                            elevation: 0,
                                          ),
                                          onPressed: () => noteProvider
                                              .selectNote(reversedIndex),
                                          child: Text(
                                            noteProvider
                                                .notes[reversedIndex].title,
                                            style: TextStyle(
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
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
                                onChanged:
                                    noteProvider.updateCurrentNoteContent,
                                textAlign: _currentTextAlign, // Apply alignment
                                style: TextStyle(
                                  fontSize: _currentFontSize, // Apply font size
                                  fontWeight: _isBold
                                      ? FontWeight.bold
                                      : FontWeight.normal, // Apply bold
                                  fontStyle: _isItalic
                                      ? FontStyle.italic
                                      : FontStyle.normal, // Apply italic
                                  //color: _currentFillColor, // Apply fill color
                                ),
                                decoration: const InputDecoration(
                                  hintText: "Write your notes here...",
                                  border: InputBorder.none,
                                ),
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
                  ],
                ),
              ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, right: 8.0),
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
                backgroundColor: theme.colorScheme.primary,
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
