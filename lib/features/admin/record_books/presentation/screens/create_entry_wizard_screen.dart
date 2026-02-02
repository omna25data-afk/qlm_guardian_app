
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/record_books_repository.dart';
import '../providers/create_entry_provider.dart';
import 'wizard_steps/contract_selection_step.dart';
import 'wizard_steps/parties_details_step.dart';
import 'wizard_steps/document_data_step.dart';
import 'wizard_steps/financials_step.dart';

class CreateEntryWizardScreen extends StatelessWidget {
  const CreateEntryWizardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inject Provider locally to this screen
    return ChangeNotifierProvider(
      create: (_) => CreateEntryProvider(),
      child: const _CreateEntryWizardContent(),
    );
  }
}

class _CreateEntryWizardContent extends StatelessWidget {
  const _CreateEntryWizardContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CreateEntryProvider>(context);

    // Total Steps count
    final totalSteps = 4;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة قيد جديد'),
      ),
      body: Column(
        children: [
          // Stepper Indicator
          _buildStepperHeader(context, provider.currentStep),
          
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(), // Disable swipe
              children: [
                if (provider.currentStep == 0) const ContractSelectionStep(),
                if (provider.currentStep == 1) const PartiesDetailsStep(),
                if (provider.currentStep == 2) const DocumentDataStep(),
                if (provider.currentStep == 3) const FinancialsStep(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (provider.currentStep > 0)
              OutlinedButton(
                onPressed: provider.previousStep,
                child: const Text('السابق'),
              )
            else
              const SizedBox.shrink(), // Spacer

            ElevatedButton(
              onPressed: () {
                if (provider.currentStep < totalSteps - 1) { 
                   provider.nextStep();
                } else {
                   provider.submitEntry(); // Submit on last step
                   Navigator.pop(context);
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم الحفظ بنجاح')));
                }
              },
              child: Text(provider.currentStep < totalSteps - 1 ? 'التالي' : 'حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepperHeader(BuildContext context, int currentStep) {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStepCircle(0, currentStep, 'نوع العقد'),
          _buildConnector(0, currentStep),
          _buildStepCircle(1, currentStep, 'الأطراف'),
           _buildConnector(1, currentStep),
           _buildStepCircle(2, currentStep, 'الوثيقة'),
           _buildConnector(2, currentStep),
           _buildStepCircle(3, currentStep, 'المالية'),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int index, int currentStep, String label) {
    bool isActive = index == currentStep;
    bool isCompleted = index < currentStep;

    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: isActive ? const Color(0xFF006400) : (isCompleted ? Colors.green : Colors.grey),
          child: isCompleted 
             ? const Icon(Icons.check, color: Colors.white, size: 16)
             : Text('${index + 1}', style: const TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(
          fontSize: 12, 
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? Colors.black : Colors.grey)),
      ],
    );
  }

  Widget _buildConnector(int index, int currentStep) {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 14), // Align with circle
      color: index < currentStep ? Colors.green : Colors.grey.shade300,
    );
  }
}
