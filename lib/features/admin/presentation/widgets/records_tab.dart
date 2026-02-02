
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../record_books/presentation/screens/record_books_tab.dart' as books;
import '../../record_books/presentation/widgets/registry_entries_list_widget.dart';

class RecordsTab extends StatelessWidget {
  const RecordsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                 BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 3, offset: const Offset(0, 2)),
              ],
            ),
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFF006400),
              labelStyle: GoogleFonts.tajawal(fontWeight: FontWeight.bold, fontSize: 16),
              unselectedLabelStyle: GoogleFonts.tajawal(fontSize: 15),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: const Color(0xFF006400),
              ),
              tabs: const [
                Tab(text: 'السجلات', height: 40),
                Tab(text: 'القيود', height: 40),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [
                books.RecordBooksTab(),
                RegistryEntriesListWidget(fetchOnInit: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
