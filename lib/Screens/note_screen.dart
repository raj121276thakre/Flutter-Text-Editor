import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_filex/open_filex.dart';
import 'package:text_editor/Constants/strings.dart';
import 'package:text_editor/widgets/drawer_widget.dart';
import 'package:text_editor/widgets/floating_action_button_widget.dart';
import 'package:text_editor/widgets/horizontal_scroll_widget.dart';
import 'package:text_editor/widgets/no_notes_widget.dart';
import 'package:text_editor/widgets/note_editor_widget.dart';

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

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  // Show confirmation dialog before deleting all notes
  void _confirmDeleteAllNotes(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete All Notes'),
          content: Text(
              'Are you sure you want to delete all notes? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Delete All'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Provider.of<NoteProvider>(context, listen: false)
                    .deleteAllNotes(); // Delete all notes
              },
            ),
          ],
        );
      },
    );
  }

  void _showThemeBottomDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.wb_sunny),
                title: Text('Default Theme'),
                onTap: () {
                  themeProvider.setTheme(themeProvider.defaultTheme);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.light_mode),
                title: Text('Purple Theme'),
                onTap: () {
                  themeProvider.setTheme(themeProvider.lightTheme);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.palette),
                title: Text('Blue Theme'),
                onTap: () {
                  themeProvider.setTheme(themeProvider.blueTheme);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.palette),
                title: Text('Green Theme'),
                onTap: () {
                  themeProvider.setTheme(themeProvider.greenTheme);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.palette),
                title: Text('Yellow Theme'),
                onTap: () {
                  themeProvider.setTheme(themeProvider.yellowTheme);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.palette),
                title: Text('Orange Theme'),
                onTap: () {
                  themeProvider.setTheme(themeProvider.orangeTheme);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.palette),
                title: Text('Pink Theme'),
                onTap: () {
                  themeProvider.setTheme(themeProvider.pinkTheme);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showThemeAlertDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Choose Theme'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.wb_sunny),
                  title: Text('Default Theme'), // Your custom theme
                  onTap: () {
                    themeProvider.setTheme(themeProvider
                        .defaultTheme); // Set to your default theme
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.light_mode),
                  title: Text('Purple Theme'),
                  onTap: () {
                    themeProvider.setTheme(
                        themeProvider.lightTheme); // Set to light theme
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
                    themeProvider.setTheme(
                        themeProvider.greenTheme); // Set to green theme
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

      final directory = await getDownloadsDirectory();
      if (directory == null) {
        throw Exception("Downloads directory not available");
      }

      final filePath = "${directory.path}/$title.pdf";
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      await OpenFilex.open(filePath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("PDF saved and opened: $title.pdf"),
        ),
      );
    } catch (e) {
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
                Scaffold.of(context).openDrawer();
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
              _showThemeBottomDialog(context);
            },
          ),
        ],
      ),
      drawer: DrawerWidget(
        noteProvider: noteProvider,
        showThemeDialog: _showThemeAlertDialog,
        deleteAllNotes: _confirmDeleteAllNotes, // Pass the delete function
      ),
      body: SafeArea(
        child: noteProvider.notes.isEmpty
            ? Center(
                child:
                    const NoNotesWidget() // Use the new widget when there are no notes
                )
            : Column(
                children: [
                  HorizontalScrollWidget(noteProvider: noteProvider),
                  NoteEditorWidget(
                    noteProvider: noteProvider,
                    currentTextAlign: _currentTextAlign,
                    currentFontSize: _currentFontSize,
                    isBold: _isBold,
                    isItalic: _isItalic,
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButtonWidget(
        isFabExpanded: _isFabExpanded,
        onFabExpandedChange: () {
          setState(() {
            _isFabExpanded = !_isFabExpanded;
          });
        },
        createNewNote: noteProvider.createNewNote,
        undo: noteProvider.undo,
        redo: noteProvider.redo,
        deleteCurrentNote: noteProvider.deleteCurrentNote,
        downloadCurrentNote: () {
          final currentNote = noteProvider.notes[noteProvider.currentNoteIndex];
          _generateAndOpenPDF(
            currentNote.content,
            currentNote.title,
          );
        },
        hasNotes: noteProvider
            .notes.isNotEmpty, // Pass the flag to check if there are notes
      ),
    );
  }
}
