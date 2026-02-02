
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/create_entry_provider.dart';

class FinancialsStep extends StatelessWidget {
  const FinancialsStep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CreateEntryProvider>(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'الرسوم والمالية',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        TextFormField(
          initialValue: provider.feeAmount.toString(),
          decoration: const InputDecoration(
            labelText: 'قيمة الرسوم',
            suffixText: 'ر.ي',
          ),
          keyboardType: TextInputType.number,
          onChanged: (val) => provider.setFeeAmount(double.tryParse(val) ?? 0.0),
        ),

        const SizedBox(height: 16),

        TextFormField(
          initialValue: provider.penaltyAmount.toString(),
          decoration: const InputDecoration(
            labelText: 'الغرامة (إن وجدت)',
             suffixText: 'ر.ي',
          ),
          keyboardType: TextInputType.number,
          onChanged: (val) => provider.setPenaltyAmount(double.tryParse(val) ?? 0.0),
        ),

        const SizedBox(height: 24),

        // Total
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('الإجمالي المستحق:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(
                '${(provider.feeAmount + provider.penaltyAmount).toStringAsFixed(2)} ر.ي',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF006400)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
