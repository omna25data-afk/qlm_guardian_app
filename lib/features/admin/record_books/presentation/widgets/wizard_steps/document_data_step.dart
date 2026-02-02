
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hijri/hijri_calendar.dart';
import '../providers/create_entry_provider.dart';

class DocumentDataStep extends StatefulWidget {
  const DocumentDataStep({Key? key}) : super(key: key);

  @override
  State<DocumentDataStep> createState() => _DocumentDataStepState();
}

class _DocumentDataStepState extends State<DocumentDataStep> {
  final TextEditingController _hijriController = TextEditingController();
  final TextEditingController _gregorianController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<CreateEntryProvider>(context, listen: false);
    if (provider.hijriDate != null) {
      _hijriController.text = provider.hijriDate!;
    }
     if (provider.documentDate != null) {
      _gregorianController.text = provider.documentDate!.toString().split(' ')[0];
    }
  }

  Future<void> _selectHijriDate(BuildContext context, CreateEntryProvider provider) async {
    final HijriCalendar? picked = await showHijriDatePicker(
      context: context,
      initialDate: HijriCalendar.now(),
      lastDate: HijriCalendar()..hYear = 1460,
      firstDate: HijriCalendar()..hYear = 1400,
      initialDatePickerMode: DatePickerMode.day,
    );
    if (picked != null) {
      // Format: YYYY-MM-DD
      final formatted = '${picked.hYear}-${picked.hMonth.toString().padLeft(2, '0')}-${picked.hDay.toString().padLeft(2, '0')}';
      _hijriController.text = formatted;
      provider.setHijriDate(formatted);

      // Auto-convert to Gregorian
      final greg = picked.hijriToGregorian(picked.hYear, picked.hMonth, picked.hDay);
      final gregFormatted = '${greg.year}-${greg.month.toString().padLeft(2, '0')}-${greg.day.toString().padLeft(2, '0')}';
      _gregorianController.text = gregFormatted;
      provider.setDocumentDate(greg);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CreateEntryProvider>(context);

    // Writers List (Mock)
    final writers = [
      {'id': 1, 'name': 'أمين شرعي: ${provider.guardianId ?? "الحالي"}'},
      {'id': 2, 'name': 'موثق خارجي'},
      {'id': 3, 'name': 'موظف توثيق'},
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'بيانات المحرر والكاتب',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Date Pickers
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _hijriController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'التاريخ الهجري',
                  suffixIcon: Icon(Icons.calendar_month),
                ),
                onTap: () => _selectHijriDate(context, provider),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _gregorianController,
                readOnly: true, // Auto-calculated
                decoration: const InputDecoration(
                  labelText: 'التاريخ الميلادي',
                   filled: true,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),
        
        // Record Book Info (Auto-detected)
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('معلومات السجل (تلقائي)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
              const SizedBox(height: 8),
              if (provider.contractTypeId == null)
                 const Text('يرجى اختيار نوع العقد أولاً')
              else
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     const Text('السجل المستهدف: سجل عقود الزواج - 1446'),
                     const Text('رقم الدفتر: 005'),
                     Row(
                       children: const [
                         Text('رقم الصفحة: 12', style: TextStyle(fontWeight: FontWeight.bold)),
                         SizedBox(width: 16),
                         Text('رقم القيد: 24', style: TextStyle(fontWeight: FontWeight.bold)),
                       ],
                     ),
                   ],
                 ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Writer Selection
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(labelText: 'صفة الكاتب'),
          items: writers.map((w) => DropdownMenuItem<int>(
            value: w['id'] as int,
            child: Text(w['name'] as String),
          )).toList(),
          onChanged: (val) {
             // provider.setWriterType(val);
          },
        ),
      ],
    );
  }
}
