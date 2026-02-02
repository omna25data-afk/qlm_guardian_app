
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/record_books_provider.dart';
import 'notebooks_list_screen.dart';

class RecordBooksTab extends StatefulWidget {
  const RecordBooksTab({Key? key}) : super(key: key);

  @override
  State<RecordBooksTab> createState() => _RecordBooksTabState();
}

class _RecordBooksTabState extends State<RecordBooksTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<RecordBooksProvider>(context, listen: false).fetchRecordBooks());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecordBooksProvider>(
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

        return RefreshIndicator(
          onRefresh: () => provider.fetchRecordBooks(),
          child: ListView.builder(
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
                         builder: (context) => NotebooksListScreen(
                           contractTypeId: book.contractTypeId!,
                           title: book.name,
                         ),
                       ),
                     );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
