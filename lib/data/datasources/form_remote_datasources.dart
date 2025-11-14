import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mmf/domain/entities/form_data.dart';

abstract class FormRemoteDataSource {
  Future<void> submitForm(FormData formData);
}

class FormRemoteDataSourceImpl implements FormRemoteDataSource {
  final http.Client client;

  FormRemoteDataSourceImpl({required this.client});

  @override
  Future<void> submitForm(FormData formData) async {
    final response = await client.post(
      Uri.parse('https://script.google.com/macros/s/AKfycbxwkLGeyDuh4gvMsfNx7pSmcCYybJ3itLCYYfezpAUW6p0cUu4lwfQyAvyi-sEeNhALLg/exec'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(formData.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to submit form');
    }
  }
}