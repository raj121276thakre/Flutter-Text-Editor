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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    await Provider.of<NoteProvider>(context, listen: false)
        .loadNotesFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: SafeArea(
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // DrawerHeader(
              //   decoration: BoxDecoration(
              //     color: Theme.of(context).colorScheme.primary,
              //   ),
              //   child: const Text(
              //     'Settings',
              //     style: TextStyle(
              //       color: Colors.white,
              //       fontSize: 20,
              //     ),
              //   ),
              // ),
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: Provider.of<ThemeProvider>(context).isDarkMode,
                onChanged: (value) {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme(value);
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: noteProvider.notes.length + 1,
                itemBuilder: (context, index) {
                  if (index == noteProvider.notes.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                      child: ElevatedButton.icon(
                        onPressed: () => noteProvider.createNewNote(),
                        icon: const Icon(Icons.add),
                        label: const Text('New'),
                      ),
                    );
                  }

                  final note = noteProvider.notes[index];
                  final isSelected = index == noteProvider.currentNoteIndex;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[200],
                      ),
                      icon: Icon(
                        Icons.edit,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                      onPressed: () => noteProvider.selectNote(index),
                      label: Text(
                        note.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(3.0),
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.menu),
                            tooltip: 'Open Drawer',
                            onPressed: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.undo),
                            tooltip: 'Undo',
                            onPressed: noteProvider.undo,
                          ),
                          IconButton(
                            icon: const Icon(Icons.redo),
                            tooltip: 'Redo',
                            onPressed: noteProvider.redo,
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            tooltip: 'Delete Note',
                            onPressed: () => noteProvider.deleteCurrentNote(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: noteProvider.currentNoteController,
                          maxLines: null,
                          expands: true,
                          onChanged: noteProvider.updateCurrentNoteContent,
                          decoration: const InputDecoration(
                            hintText: "Write your notes here...",
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
