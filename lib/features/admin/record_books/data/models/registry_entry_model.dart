
class RegistryEntryModel {
  final int id;
  final int? serialNumber;
  final int hijriYear;
  final String firstPartyName;
  final String secondPartyName;
  final String transactionDate;
  final String status; // 'draft', 'registered', etc.
  final String? deliveryStatus;
  final double? feeAmount;
  final int? guardianPageNumber;
  final int? guardianEntryNumber;
  final int? guardianRecordBookNumber;
  final String? notes;

  RegistryEntryModel({
    required this.id,
    this.serialNumber,
    required this.hijriYear,
    required this.firstPartyName,
    required this.secondPartyName,
    required this.transactionDate,
    required this.status,
    this.deliveryStatus,
    this.feeAmount,
    this.guardianPageNumber,
    this.guardianEntryNumber,
    this.guardianRecordBookNumber,
    this.notes,
  });

  factory RegistryEntryModel.fromJson(Map<String, dynamic> json) {
    return RegistryEntryModel(
      id: json['id'] ?? 0,
      serialNumber: json['serial_number'],
      hijriYear: json['hijri_year'] ?? 0,
      firstPartyName: json['first_party_name'] ?? '',
      secondPartyName: json['second_party_name'] ?? '',
      transactionDate: json['document_gregorian_date'] ?? '',
      status: json['status'] ?? 'draft',
      deliveryStatus: json['delivery_status'],
      feeAmount: (json['fee_amount'] as num?)?.toDouble(),
      guardianPageNumber: json['guardian_page_number'],
      guardianEntryNumber: json['guardian_entry_number'],
      guardianRecordBookNumber: json['guardian_record_book_number'],
      notes: json['notes'],
    );
  }
  
  // Status Colors Helper
  String get statusLabel {
     switch (status) {
       case 'draft': return 'مسودة';
       case 'registered_guardian': return 'مقيد (عند الأمين)';
       case 'documented': return 'موثق';
       case 'pending_documentation': return 'بانتظار التوثيق';
       default: return status;
     }
  }
}
