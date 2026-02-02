
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/create_entry_provider.dart';

class ContractSelectionStep extends StatelessWidget {
  const ContractSelectionStep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CreateEntryProvider>(context);

    // Mock Options (Should come from API/Repository)
    final contracts = [
      {'id': 1, 'name': 'زواج', 'icon': Icons.favorite},
      {'id': 7, 'name': 'طلاق', 'icon': Icons.heart_broken},
      {'id': 10, 'name': 'مبيع', 'icon': Icons.store},
      {'id': 4, 'name': 'وكالة', 'icon': Icons.work},
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'اختر نوع الوثيقة',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (provider.error != null)
           Container(
             padding: const EdgeInsets.all(8),
             color: Colors.red.shade100,
             child: Text(provider.error!, style: const TextStyle(color: Colors.red)),
           ),
        
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: contracts.length,
          itemBuilder: (context, index) {
            final item = contracts[index];
            final id = item['id'] as int;
            final isSelected = provider.contractTypeId == id;

            return GestureDetector(
              onTap: () => provider.setContractType(id),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF006400).withValues(alpha: 0.1) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF006400) : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item['icon'] as IconData, 
                         color: isSelected ? const Color(0xFF006400) : Colors.grey, size: 32),
                    const SizedBox(height: 8),
                    Text(item['name'] as String,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? const Color(0xFF006400) : Colors.black87)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
