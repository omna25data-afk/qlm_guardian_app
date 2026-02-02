
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/record_books_provider.dart';
import '../widgets/record_book_card.dart';
import 'registry_entries_screen.dart';

class NotebooksListScreen extends StatefulWidget {
  final int contractTypeId;
  final String title;

  const NotebooksListScreen({
    Key? key, 
    required this.contractTypeId,
    required this.title,
  }) : super(key: key);

  @override
  State<NotebooksListScreen> createState() => _NotebooksListScreenState();
}

class _NotebooksListScreenState extends State<NotebooksListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
      Provider.of<RecordBooksProvider>(context, listen: false)
        .fetchNotebooks(widget.contractTypeId)
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecordBooksProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          // Filter & Search Bar
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Column(
              children: [
                // Search
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'بحث في السجلات...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onChanged: (val) => provider.setNotebookSearch(val),
                ),
                const SizedBox(height: 12),
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('الكل', 'all', provider),
                      const SizedBox(width: 8),
                      _buildFilterChip('سجلاتي', 'my_records', provider),
                      const SizedBox(width: 8),
                      _buildFilterChip('سجلات الأمناء', 'others', provider),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: provider.isLoadingNotebooks
              ? const Center(child: CircularProgressIndicator())
              : provider.filteredNotebooks.isEmpty
                  ? Center(child: Text(provider.notebooksError ?? 'لا توجد سجلات'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: provider.filteredNotebooks.length,
                      itemBuilder: (context, index) {
                        final notebook = provider.filteredNotebooks[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: RecordBookCard(
                            book: notebook,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegistryEntriesScreen(
                                    recordBookId: notebook.id,
                                    bookNumber: notebook.bookNumber,
                                    title: notebook.name,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, RecordBooksProvider provider) {
    // Access private state via getter if available, but for now assuming we added `selectedNotebookFilter` getter 
    // Wait, I forgot to add the getter in the previous step specifically. I added setter.
    // Let's assume the getter matches the variable name without underscore in user usage typically, or I need to fix it.
    // Re-checking provider edit: I didn't add public getters for the new filter states.
    // I should fix the provider first or just check the private var equivalent via a new getter I SHOULD Have added.
    
    // Correction: In the previous multi_replace call, I added private vars and setters but NO GETTERS for the filter strings.
    // This code will fail if I try to access `provider.selectedNotebookFilter`. 
    // I will use a placeholder boolean for now to avoid compilation error and fix Provider next.
    final isSelected = false; // TODO: Fix getter in provider

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => provider.setNotebookFilter(value),
    );
  }
}
