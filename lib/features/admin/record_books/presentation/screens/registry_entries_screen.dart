
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/record_books_provider.dart';
import '../widgets/registry_entries_list_widget.dart';
import 'create_entry_wizard_screen.dart';

class RegistryEntriesScreen extends StatelessWidget {
  final int? recordBookId;
  final int? bookNumber;
  final String title;

  const RegistryEntriesScreen({
    Key? key,
    this.recordBookId,
    this.bookNumber,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateEntryWizardScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: RegistryEntriesListWidget(
        recordBookId: recordBookId,
        bookNumber: bookNumber,
      ),
    );
  }
}
