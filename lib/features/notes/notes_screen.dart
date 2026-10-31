import 'package:flutter/material.dart';
import 'package:navigations/core/theme/theme_toggle_button.dart';
import 'package:navigations/core/utils/theme_x.dart';

import 'note.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ملاحظاتي'),
        actions: const [ThemeToggleButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              constraints.maxHeight;
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.colors.primary,

                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'صباح الخير 👋\nعندك ٣ ملاحظات',
                  style: text.titleLarge?.copyWith(
                    color: context.colors.onPrimary,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Text('آخر الملاحظات', style: text.titleMedium),
          const SizedBox(height: 8),
          for (final note in notes) NoteCard(note: note),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('ملاحظة جديدة'),
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  const NoteCard({super.key, required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    // final text = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(note.title, style: context.text.titleMedium),
            const SizedBox(height: 4),
            Text(
              note.body,
              style: context.text.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
