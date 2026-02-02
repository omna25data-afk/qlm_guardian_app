
class RecordBookModel {
  final int id;
  final String name;
  final int? bookNumber;
  final int hijriYear;
  final String? status;
  final int? totalPages;
  final int? constraintsPerPage;
  final int? contractTypeId;
  final int? totalEntriesCount;
  final int? completedEntriesCount;
  final int? draftEntriesCount;
  final int? notebooksCount; // For grouped view
  final String? recordTypeLabel;
  final String? categoryLabel;
  final String? openingDate;
  final String? closingDate;

  RecordBookModel({
    required this.id,
    required this.name,
    this.bookNumber,
    required this.hijriYear,
    this.status,
    this.totalPages,
    this.constraintsPerPage,
    this.contractTypeId,
    this.totalEntriesCount,
    this.completedEntriesCount,
    this.draftEntriesCount,
    this.notebooksCount,
    this.recordTypeLabel,
    this.categoryLabel,
    this.openingDate,
    this.closingDate,
  });

  factory RecordBookModel.fromJson(Map<String, dynamic> json) {
    return RecordBookModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      bookNumber: json['book_number'],
      hijriYear: json['hijri_year'] ?? 0,
      status: json['status'],
      totalPages: json['total_pages'],
      constraintsPerPage: json['constraints_per_page'],
      contractTypeId: json['contract_type_id'],
      totalEntriesCount: json['total_entries_count'],
      completedEntriesCount: json['completed_entries_count'],
      draftEntriesCount: json['draft_entries_count'],
      notebooksCount: json['notebooks_count'],
      recordTypeLabel: json['record_type_label'],
      categoryLabel: json['category_label'],
      openingDate: json['opening_procedure_date_formatted'],
      closingDate: json['closing_procedure_date_formatted'],
    );
  }
}
