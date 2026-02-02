
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/record_books_provider.dart';

class RecordBooksScreen extends StatefulWidget {
  const RecordBooksScreen({Key? key}) : super(key: key);

  @override
  State<RecordBooksScreen> createState() => _RecordBooksScreenState();
}

class _RecordBooksScreenState extends State<RecordBooksScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<RecordBooksProvider>(context, listen: false).fetchRecordBooks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سجلات وقيود الأمين'),
      ),
      body: Consumer<RecordBooksProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingBooks) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.booksError != null) {
            return Center(child: Text('خطأ: ${provider.booksError}'));
          }

          if (provider.recordBooks.isEmpty) {
            return const Center(child: Text('لا توجد سجلات متاحة'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.recordBooks.length,
            itemBuilder: (context, index) {
              final book = provider.recordBooks[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Icon(Icons.book, color: Colors.blue.shade800),
                  ),
                  title: Text(
                    book.name, // e.g. "Marriage - 1446"
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('سنة: ${book.hijriYear}هـ'),
                      Text('عدد الدفاتر: ${book.notebooksCount ?? 1}'),
                      Text('إجمالي القيود: ${book.totalEntriesCount ?? 0}'),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                     // Navigate to Drill Down 1
                     Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) => RecordBookNotebooksScreen(
                           contractTypeId: book.contractTypeId!,
                           title: book.name,
                         ),
                       ),
                     );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class RecordBookNotebooksScreen extends StatefulWidget {
  final int contractTypeId;
  final String title;

  const RecordBookNotebooksScreen({
    Key? key, 
    required this.contractTypeId,
    required this.title,
  }) : super(key: key);

  @override
  State<RecordBookNotebooksScreen> createState() => _RecordBookNotebooksScreenState();
}

class _RecordBookNotebooksScreenState extends State<RecordBookNotebooksScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<RecordBooksProvider>(context, listen: false)
            .fetchNotebooks(widget.contractTypeId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Consumer<RecordBooksProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingNotebooks) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.notebooksError != null) {
            return Center(child: Text('خطأ: ${provider.notebooksError}'));
          }

          if (provider.notebooks.isEmpty) {
            return const Center(child: Text('لا توجد دفاتر فعلية'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.notebooks.length,
            itemBuilder: (context, index) {
              final notebook = provider.notebooks[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.amber.shade100,
                    child: Text('${notebook.bookNumber ?? "?"}'),
                  ),
                  title: Text('دفتر رقم ${notebook.bookNumber}'),
                  subtitle: Text(
                    'رقم السجل الوزاري: ${notebook.bookNumber}\n' // Using Ministry Number if avail
                    'القيود: ${notebook.totalEntriesCount ?? notebook.completedEntriesCount}',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navigate to Drill Down 2 (Entries)
                    Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) => RegistryEntriesScreen(
                           recordBookId: notebook.id,
                           bookNumber: notebook.bookNumber,
                           title: 'دفتر ${notebook.bookNumber} - ${widget.title}',
                         ),
                       ),
                     );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class RegistryEntriesScreen extends StatefulWidget {
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
  State<RegistryEntriesScreen> createState() => _RegistryEntriesScreenState();
}

class _RegistryEntriesScreenState extends State<RegistryEntriesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<RecordBooksProvider>(context, listen: false)
            .fetchEntries(
              recordBookId: widget.recordBookId,
              bookNumber: widget.bookNumber == 0 ? null : widget.bookNumber, // 0 means virtual sometimes
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Create Entry
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<RecordBooksProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingEntries) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.entriesError != null) {
            return Center(child: Text('خطأ: ${provider.entriesError}'));
          }

          if (provider.entries.isEmpty) {
            return const Center(child: Text('لا توجد قيود مسجلة'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.entries.length,
            itemBuilder: (context, index) {
              final entry = provider.entries[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.shade50,
                    child: Text('${entry.serialNumber ?? "?"}'),
                  ),
                  title: Text('${entry.firstPartyName} \n${entry.secondPartyName}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text('التاريخ: ${entry.transactionDate}'),
                       Text('الحالة: ${entry.statusLabel}'),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () {
                    // View Entry Details
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
