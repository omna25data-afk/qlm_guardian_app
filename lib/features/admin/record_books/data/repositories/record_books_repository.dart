
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../core/config/app_config.dart';
import '../models/record_book_model.dart';
import '../models/registry_entry_model.dart';

class RecordBooksRepository {
  final AppConfig appConfig;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  RecordBooksRepository({required this.appConfig});

  Future<String?> _getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Get grouped record books (Types/Years)
  Future<List<RecordBookModel>> getRecordBooks() async {
    final token = await _getToken();
    final uri = Uri.parse('${appConfig.apiBaseUrl}/guardian/record-books');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as List)
          .map((item) => RecordBookModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load record books: ${response.statusCode}');
    }
  }

  // Get physical notebooks for a specific group
  Future<List<RecordBookModel>> getNotebooks(int contractTypeId) async {
    final token = await _getToken();
    final uri = Uri.parse('${appConfig.apiBaseUrl}/guardian/record-books/notebooks?contract_type_id=$contractTypeId');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as List)
          .map((item) => RecordBookModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load notebooks: ${response.statusCode}');
    }
  }

  // Get registry entries (with filters)
  Future<List<RegistryEntryModel>> getRegistryEntries({
    int? recordBookId,
    int? bookNumber,
    int? contractTypeId,
    int? page = 1,
    String? search,
  }) async {
    final token = await _getToken();
    final queryParams = {
      'page': page.toString(),
      if (recordBookId != null) 'guardian_record_book_id': recordBookId.toString(),
      if (bookNumber != null) 'book_number': bookNumber.toString(),
      if (contractTypeId != null) 'contract_type_id': contractTypeId.toString(),
      if (search != null && search.isNotEmpty) 'search': search,
    };

    final uri = Uri.parse('${appConfig.apiBaseUrl}/registry-entries')
        .replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as List)
          .map((item) => RegistryEntryModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load registry entries: ${response.statusCode}');
    }
  }
}
