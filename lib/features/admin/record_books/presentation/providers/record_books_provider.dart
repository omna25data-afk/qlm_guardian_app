
import 'package:flutter/material.dart';
import '../models/record_book_model.dart';
import '../models/registry_entry_model.dart';
import '../repositories/record_books_repository.dart';

class RecordBooksProvider with ChangeNotifier {
  final RecordBooksRepository repository;

  // State for Record Books (Types List)
  List<RecordBookModel> _recordBooks = [];
  bool _isLoadingBooks = false;
  String? _booksError;

  // Filters State
  String _selectedNotebookFilter = 'all'; 
  String _notebookSearchQuery = '';

  String get selectedNotebookFilter => _selectedNotebookFilter;
  String get notebookSearchQuery => _notebookSearchQuery;

  List<RecordBookModel> get filteredNotebooks {
    if (_notebooks.isEmpty) return [];
    return _notebooks.where((book) {
      if (_notebookSearchQuery.isNotEmpty) {
        if (!book.name.toLowerCase().contains(_notebookSearchQuery.toLowerCase())) return false;
      }
      // Add logic for 'my_records' vs 'others' if backend provides that flag
      return true;
    }).toList();
  }

  void setNotebookFilter(String filter) {
    _selectedNotebookFilter = filter;
    notifyListeners();
  }

  void setNotebookSearch(String query) {
    _notebookSearchQuery = query;
    notifyListeners();
  }

  // State for Notebooks (Drill down)
  List<RecordBookModel> _notebooks = [];
  bool _isLoadingNotebooks = false;
  String? _notebooksError;

  // State for Registry Entries
  List<RegistryEntryModel> _entries = [];
  bool _isLoadingEntries = false;
  String? _entriesError;

  // Entries Filter State
  String _entriesFilterStatus = 'all'; 
  String _entriesSearchQuery = '';

  String get entriesFilterStatus => _entriesFilterStatus;
  String get entriesSearchQuery => _entriesSearchQuery;

  List<RegistryEntryModel> get filteredEntries {
    if (_entries.isEmpty) return [];
    return _entries.where((entry) {
        bool matchesSearch = true;
        bool matchesStatus = true;

        if (_entriesSearchQuery.isNotEmpty) {
           final q = _entriesSearchQuery.toLowerCase();
           matchesSearch = (entry.firstPartyName.toLowerCase().contains(q) || 
                            entry.secondPartyName.toLowerCase().contains(q));
        }

        if (_entriesFilterStatus != 'all') {
           matchesStatus = entry.status == _entriesFilterStatus;
        }

        return matchesSearch && matchesStatus;
    }).toList();
  }

  void setEntriesFilter(String status) {
    _entriesFilterStatus = status;
    notifyListeners();
  }

  void setEntriesSearch(String query) {
    _entriesSearchQuery = query;
    notifyListeners();
  }

  RecordBooksProvider({required this.repository});

  // Getters
  List<RecordBookModel> get recordBooks => _recordBooks;
  bool get isLoadingBooks => _isLoadingBooks;
  String? get booksError => _booksError;

  List<RecordBookModel> get notebooks => _notebooks;
  bool get isLoadingNotebooks => _isLoadingNotebooks;
  String? get notebooksError => _notebooksError;

  List<RegistryEntryModel> get entries => _entries;
  bool get isLoadingEntries => _isLoadingEntries;
  String? get entriesError => _entriesError;

  // Fetch Grouped Record Books
  Future<void> fetchRecordBooks() async {
    _isLoadingBooks = true;
    _booksError = null;
    notifyListeners();

    try {
      _recordBooks = await repository.getRecordBooks();
    } catch (e) {
      _booksError = e.toString();
    } finally {
      _isLoadingBooks = false;
      notifyListeners();
    }
  }

  // Fetch Physical Notebooks for a Type
  Future<void> fetchNotebooks(int contractTypeId) async {
    _isLoadingNotebooks = true;
    _notebooksError = null;
    _notebooks = []; // Clear previous
    notifyListeners();

    try {
      _notebooks = await repository.getNotebooks(contractTypeId);
    } catch (e) {
      _notebooksError = e.toString();
    } finally {
      _isLoadingNotebooks = false;
      notifyListeners();
    }
  }

  // Fetch Entries for a specific notebook or generally
  Future<void> fetchEntries({
    int? recordBookId, // If physical book exists
    int? bookNumber,   // If virtual book
    int? contractTypeId,
    String? search,
  }) async {
    _isLoadingEntries = true;
    _entriesError = null;
    _entries = [];
    notifyListeners();

    try {
      _entries = await repository.getRegistryEntries(
        recordBookId: recordBookId,
        bookNumber: bookNumber,
        contractTypeId: contractTypeId,
        search: search,
      );
    } catch (e) {
      _entriesError = e.toString();
    } finally {
      _isLoadingEntries = false;
      notifyListeners();
    }
  }
}
