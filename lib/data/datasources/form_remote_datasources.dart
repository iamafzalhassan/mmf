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
                'https://script.google.com/macros/s/AKfycbymPlQr5hyQDTzr6AmopT236CB2eEp5VsGzc0wUdORM6wdq5wM-nULl1Z75dkt7Vc3l/exec'),
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