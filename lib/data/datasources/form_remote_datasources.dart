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
    const scriptUrl =
        'https://script.google.com/macros/s/AKfycbwh5SCrUbcEExtG0B0M6pQCBH5y3a1C22F8IaTIHrn-qg7mroJsVZ-Y1if50pvMS6JA/exec';

    try {
      // Encode form data as base64
      final jsonData = jsonEncode(formData.toJson());
      final encodedData = base64Url.encode(utf8.encode(jsonData));

      // Build GET request URL with query parameters
      final uri = Uri.parse(scriptUrl).replace(
        queryParameters: {
          'data': encodedData,
          'method': 'submit',
        },
      );

      // Send GET request
      final response = await client.get(uri).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout - please try again');
        },
      );

      // Handle response
      if (response.statusCode == 200 || response.statusCode == 302) {
        try {
          final responseData = jsonDecode(response.body);
          if (responseData['status'] == 'success') {
            return;
          } else if (responseData['status'] == 'error') {
            throw Exception(responseData['message'] ?? 'Submission failed');
          }
        } catch (e) {
          // If JSON parsing fails but status is 200/302, consider it successful
          if (response.statusCode == 200 || response.statusCode == 302) {
            return;
          }
          rethrow;
        }
      }

      throw Exception('Submission failed: ${response.statusCode}');
    } on http.ClientException {
      throw Exception('Network error. Please check your connection.');
    } catch (e) {
      throw Exception('Failed to submit: ${e.toString()}');
    }
  }
}