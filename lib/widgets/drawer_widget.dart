// lib/widgets/drawer_widget.dart
import 'package:flutter/material.dart';
import 'package:text_editor/Constants/strings.dart';
import 'package:text_editor/Screens/about_screen.dart';
import '../Providers/note_provider.dart';

class DrawerWidget extends StatelessWidget {
  final NoteProvider noteProvider;
  final Function showThemeDialog;
   final Function deleteAllNotes;

  const DrawerWidget({
    Key? key,
    required this.noteProvider,
    required this.showThemeDialog,
    required this.deleteAllNotes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
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
                    AppStrings.appIcon,
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
          // Add "Delete All Notes" button
          ListTile(
            leading: Icon(Icons.delete_forever),
            title: Text('Delete All Notes'),
            onTap: () {
              Navigator.pop(context);
              // Call the function to delete all notes with a confirmation dialog
              deleteAllNotes(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.palette),
            title: Text('Theme Settings'),
            onTap: () {
              showThemeDialog(context);
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
    );
  }
}
