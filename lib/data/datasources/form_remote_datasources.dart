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
        'https://script.google.com/macros/s/AKfycbxOjHiZ1nVfo8u2lhgWrpltKGMBlheLeM09B2E8III_IwmLCSELEPzmtUU3SpaCDjcc/exec';

    try {
      final jsonData = jsonEncode(formData.toJson());
      try {
        final response = await client
            .post(
          Uri.parse(scriptUrl),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonData,
        )
            .timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            throw Exception('Request timeout - please try again');
          },
        );
        if (response.statusCode == 200) {
          try {
            final responseData = jsonDecode(response.body);
            if (responseData['status'] == 'success') {
              return;
            } else if (responseData['status'] == 'error') {
              throw Exception(responseData['message'] ?? 'Submission failed');
            }
          } catch (e) {
            if (response.statusCode == 200) {
              return;
            }
            rethrow;
          }
        }

        if (response.statusCode == 302) {
          return;
        }

        throw Exception('Unexpected response: ${response.statusCode}');
      } catch (e) {
        return await _submitViaGet(scriptUrl, formData);
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error. Please check your connection.');
    } catch (e) {
      throw Exception('Failed to submit: ${e.toString()}');
    }
  }

  Future<void> _submitViaGet(String scriptUrl, FormData formData) async {
    try {
      final jsonData = jsonEncode(formData.toJson());
      final encodedData = base64Url.encode(utf8.encode(jsonData));

      final uri = Uri.parse(scriptUrl).replace(
        queryParameters: {
          'data': encodedData,
          'method': 'submit',
        },
      );

      final response = await client.get(uri).timeout(
            const Duration(seconds: 30),
          );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          return;
        } else {
          throw Exception(responseData['message'] ?? 'Submission failed');
        }
      }

      throw Exception('GET method failed: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }
}