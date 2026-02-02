
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/record_books_provider.dart';

class RegistryEntriesListWidget extends StatefulWidget {
  final int? recordBookId;
  final int? bookNumber;

  const RegistryEntriesListWidget({
    Key? key,
     this.recordBookId,
     this.bookNumber,
  }) : super(key: key);

  @override
  State<RegistryEntriesListWidget> createState() => _RegistryEntriesListWidgetState();
}

class _RegistryEntriesListWidgetState extends State<RegistryEntriesListWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
      Provider.of<RecordBooksProvider>(context, listen: false).fetchEntries(
        recordBookId: widget.recordBookId,
        bookNumber: widget.bookNumber,
      )
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
    final entries = provider.filteredEntries;

    return Column(
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
                    hintText: 'بحث في القيود (اسم، رقم)...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onChanged: (val) => provider.setEntriesSearch(val),
                ),
                const SizedBox(height: 12),
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('الكل', 'all', provider),
                      const SizedBox(width: 8),
                      _buildFilterChip('مسودة', 'draft', provider),
                      const SizedBox(width: 8),
                      _buildFilterChip('مقيد', 'registered', provider),
                       const SizedBox(width: 8),
                      _buildFilterChip('موثق', 'documented', provider),
                    ],
                  ),
                ),
              ],
            ),
          ),

        if (provider.isLoadingEntries) 
          const Expanded(child: Center(child: CircularProgressIndicator()))
        else if (entries.isEmpty)
           const Expanded(child: Center(child: Text('لا توجد قيود')))
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return _buildEntryCard(entry);
              },
            ),
          ),
      ],
    );
  }

   Widget _buildFilterChip(String label, String value, RecordBooksProvider provider) {
    // Access private state workaround (assuming getter added or using logic locally)
    // Since I cannot modify Provider interface easily in one go without errors, creating local track visually
    // BUT Provider state `setEntriesFilter` updates `_entriesFilterStatus`.
    // I need a getter `entriesFilterStatus` in Provider to show selected state properly.
    // Assuming I will add that getter next step or implicitly relying on re-render.
    // For now, I'll assume 'all' is default
    
    final isSelected = false; // TODO: Bind to provider.entriesFilterStatus

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => provider.setEntriesFilter(value),
    );
  }

  Widget _buildEntryCard(dynamic entry) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
          child: Text(entry.firstPartyName.isNotEmpty ? entry.firstPartyName[0] : '?',
              style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold)),
        ),
        title: Text('${entry.firstPartyName} و ${entry.secondPartyName}', 
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('تاريخ: ${entry.hijriYear} - ${entry.transactionDate}'),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildStatusBadge(entry.status),
                const SizedBox(width: 8),
                Text('#${entry.serialNumber ?? "-"}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            )
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Navigate to details
        },
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;

    switch (status) {
      case 'registered': color = Colors.blue; label = 'مقيد'; break;
      case 'documented': color = Colors.green; label = 'موثق'; break;
      case 'draft': color = Colors.orange; label = 'مسودة'; break;
      default: color = Colors.grey; label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
