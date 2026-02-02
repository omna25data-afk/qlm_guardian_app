
import 'package:flutter/material.dart';
import '../../data/models/record_book_model.dart';

class RecordBookCard extends StatelessWidget {
  final RecordBookModel book;
  final VoidCallback onTap;

  const RecordBookCard({
    Key? key,
    required this.book,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine color based on status or type
    final colorScheme = Theme.of(context).colorScheme;
    final isClosed = book.status == 'closed';
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isClosed ? Colors.grey.shade100 : colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.menu_book, 
                      color: isClosed ? Colors.grey : colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'سنة: ${book.hijriYear}',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(isClosed),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat(context, 'الكل', book.totalEntries.toString()),
                  _buildStat(context, 'موثق', (book.totalEntries ?? 0 / 2).floor().toString(), color: Colors.green), // Mock stats
                  _buildStat(context, 'معلق', '0', color: Colors.orange),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isClosed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isClosed ? Colors.grey.shade200 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isClosed ? Colors.grey.shade400 : Colors.green.shade200,
        ),
      ),
      child: Text(
        isClosed ? 'مغلق' : 'مفتوح',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isClosed ? Colors.grey.shade700 : Colors.green.shade800,
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(value, style: TextStyle(
          fontWeight: FontWeight.bold, 
          fontSize: 16,
          color: color ?? Colors.black87
        )),
        Text(label, style: TextStyle(
          fontSize: 10,
          color: Colors.grey.shade600
        )),
      ],
    );
  }
}
