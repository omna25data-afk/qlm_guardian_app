
import 'package:flutter/material.dart';
import '../../data/models/record_book_model.dart';

class CreateEntryProvider with ChangeNotifier {
  // Wizard State
  int _currentStep = 0;
  int get currentStep => _currentStep;

  // Form Data
  int? _contractTypeId;
  int? _guardianId;
  int? _recordBookId;
  DateTime? _documentDate;
  String? _hijriDate; // e.g., 1446-07-15
  
  // Parties
  String? _firstPartyName;
  String? _secondPartyName;

  // Financials
  double _feeAmount = 0.0;
  double _penaltyAmount = 0.0;

  // Getters
  int? get contractTypeId => _contractTypeId;
  int? get guardianId => _guardianId;
  String? get hijriDate => _hijriDate;
  DateTime? get documentDate => _documentDate;
  String? get firstPartyName => _firstPartyName;
  String? get secondPartyName => _secondPartyName;
  double get feeAmount => _feeAmount;
  double get penaltyAmount => _penaltyAmount;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // --- Wizard Navigation ---

  void nextStep() {
    if (_validateCurrentStep()) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  bool _validateCurrentStep() {
    // Basic validation per step
    if (_currentStep == 1) {
      if ((_firstPartyName == null || _firstPartyName!.isEmpty) || 
          (_secondPartyName == null || _secondPartyName!.isEmpty)) {
        _error = 'يرجى إدخال أسماء الأطراف';
        notifyListeners();
        return false;
      }
    }
     if (_currentStep == 2) {
       if (_hijriDate == null) {
          _error = 'يرجى تحديد التاريخ';
          notifyListeners();
          return false;
       }
    }
    
    _error = null;
    return true;
  }

  // --- Data Setters ---

  void setContractType(int? id) {
    _contractTypeId = id;
    notifyListeners();
  }

  void setParties(String first, String second) {
    if (first.isNotEmpty) _firstPartyName = first;
    if (second.isNotEmpty) _secondPartyName = second;
    notifyListeners();
  }

  void setHijriDate(String date) {
    _hijriDate = date;
    notifyListeners();
  }

  void setDocumentDate(DateTime date) {
    _documentDate = date;
    notifyListeners();
  }

  void setFeeAmount(double amount) {
    _feeAmount = amount;
    notifyListeners();
  }

  void setPenaltyAmount(double amount) {
    _penaltyAmount = amount;
    notifyListeners();
  }

  // --- Labels Logic (Mocking Backend Logic) ---
  
  String get firstPartyLabel {
    switch (_contractTypeId) {
      case 1: return 'الزوج';
      case 7: return 'المطلق';
      case 10: return 'البائع';
      default: return 'الطرف الأول';
    }
  }

  String get secondPartyLabel {
    switch (_contractTypeId) {
      case 1: return 'الزوجة';
      case 7: return 'المطلقة';
      case 10: return 'المشتري';
      default: return 'الطرف الثاني';
    }
  }

  // --- Submission ---

  Future<void> submitEntry() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Call Repository to save
      await Future.delayed(const Duration(seconds: 2)); // Mock api call
      
      // On success
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
