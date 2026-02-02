
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/create_entry_provider.dart';

class PartiesDetailsStep extends StatelessWidget {
  const PartiesDetailsStep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CreateEntryProvider>(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
         const Text(
          'بيانات الأطراف',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          initialValue: provider.firstPartyLabel, // Just for demo, usually controller
          readOnly: true, // Label is dynamic, field is input
          decoration: InputDecoration(
             labelText: provider.firstPartyLabel, // Dynamic Label (e.g. Husband)
             hintText: 'أدخل الاسم هنا',
          ),
          onChanged: (val) => provider.setParties(val, ''), // Partial update
        ),
        const SizedBox(height: 16),
        TextFormField(
           decoration: InputDecoration(
             labelText: provider.secondPartyLabel, // Dynamic Label (e.g. Wife)
             hintText: 'أدخل الاسم هنا',
          ),
          onChanged: (val) => provider.setParties('', val),
        ),
      ],
    );
  }
}
