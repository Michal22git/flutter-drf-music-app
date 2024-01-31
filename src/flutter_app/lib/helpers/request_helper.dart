import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api.dart';

class RequestHelper {
  Future<dynamic> sendGetRequest(String path) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: _getHeaders(token),
    );
    return _parseResponse(response);
  }

  Future<dynamic> sendPostRequest(String path, {Map<String, dynamic>? body}) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl$path'),
      body: body != null ? jsonEncode(body) : null,
      headers: _getHeaders(token),
    );
    return _parseResponse(response);
  }

  Future<dynamic> sendPatchRequest(String path) async {
    final token = await _getToken();
    final response = await http.patch(
      Uri.parse('$baseUrl$path'),
      headers: _getHeaders(token),
    );
    return _parseResponse(response);
  }

  Future<dynamic> uploadMP3File(String path, {File? file}) async {
    final token = await _getToken();

    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl$path'))
        ..headers.addAll(_getHeaders(token))
        ..files.add(
          await http.MultipartFile.fromPath(
            'mp3_file',
            file!.path,
            filename: file.path.split('/').last,
          ),
        );

      var response = await request.send();

      return _parseResponse(await http.Response.fromStream(response));
    } catch (e) {
      print('Error uploading MP3 file: $e');
      throw e;
    }
  }

  Future<dynamic> sendDeleteRequest(String path) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl$path'),
      headers: _getHeaders(token),
    );
    return _parseResponse(response);
  }

  // headers with token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Map<String, String> _getHeaders(String? token) {
    final headers = {'Content-Type': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Token $token';
    }
    return headers;
  }

  dynamic _parseResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.statusCode == 204) {
        return null;
      }
      return jsonDecode(response.body);
    } else {
      return {'error': 'Error: ${response.statusCode}'};
    }
  }

}
