// lib/widgets/horizontal_scroll_widget.dart
import 'package:flutter/material.dart';
import '../Providers/note_provider.dart';

class HorizontalScrollWidget extends StatelessWidget {
  final NoteProvider noteProvider;

  const HorizontalScrollWidget({
    Key? key,
    required this.noteProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...List.generate(
              noteProvider.notes.length,
              (index) {
                final reversedIndex = noteProvider.notes.length - 1 - index;
                final isSelected = reversedIndex == noteProvider.currentNoteIndex;

                return TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 300),
                  tween: Tween(
                    begin: 1.0,
                    end: isSelected ? 1.1 : 1.0,
                  ),
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.background,
                            foregroundColor: isSelected
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(
                                color: isSelected
                                    ? theme.colorScheme.onPrimary
                                    : const Color.fromARGB(255, 27, 26, 26),
                              ),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () => noteProvider.selectNote(reversedIndex),
                          child: Text(
                            noteProvider.notes[reversedIndex].title,
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
    );
  }
}
