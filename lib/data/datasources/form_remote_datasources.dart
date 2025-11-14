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
    try {
      final response = await client
          .post(
            Uri.parse(
                'https://script.google.com/macros/s/AKfycbxj0iHA9zR3PO1K710D4XToscDHK0pT-t33MRO33T7aZP1QMoD8xYePPrzcBj0FR73Spg/exec'),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: jsonEncode(formData.toJson()),
          )
          .timeout(const Duration(seconds: 30));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 302) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'error') {
          throw Exception(responseData['message']);
        }
        return;
      } else {
        throw Exception('Failed to submit form: ${response.statusCode}');
      }
    } catch (e) {
      print('Error submitting form: $e');
      throw Exception('Failed to submit form: $e');
    }
  }
}