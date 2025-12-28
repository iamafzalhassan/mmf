import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mmf/domain/entities/main_form.dart';

abstract class FormRemoteDataSource {
  Future<void> submitForm(MainForm mainForm);
}

class FormRemoteDataSourceImpl implements FormRemoteDataSource {
  final http.Client client;

  FormRemoteDataSourceImpl({required this.client});

  @override
  Future<void> submitForm(MainForm mainForm) async {
    const scriptUrl = 'https://script.google.com/macros/s/AKfycby0TSJ9FXROa-VnQoXIQypT6GxkvaqxP5vscRP8lmiNaUa-3tp8VSDUCVYUgIjZD3U1/exec';

    try {
      final jsonData = jsonEncode(mainForm.toJson());
      final encodedData = base64Url.encode(utf8.encode(jsonData));

      final uri = Uri.parse(scriptUrl).replace(
        queryParameters: {
          'data': encodedData,
          'method': 'submit',
        },
      );

      final response = await client.get(uri).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout - please try again');
        },
      );

      if (response.statusCode == 200 || response.statusCode == 302) {
        try {
          final responseData = jsonDecode(response.body);
          if (responseData['status'] == 'success') {
            return;
          } else if (responseData['status'] == 'error') {
            throw Exception(responseData['message'] ?? 'Submission failed');
          }
        } catch (e) {
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