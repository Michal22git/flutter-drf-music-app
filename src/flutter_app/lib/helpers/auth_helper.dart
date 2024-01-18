import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api.dart';
import 'package:flutter/material.dart';
import '../utils/snackbar_utils.dart';


class AuthHelper {
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null;
  }

  Future<String?> register(String username, String password, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}api/users/register/'),
        body: {'username': username, 'password': password},
      );

      if (response.statusCode == 201) {
        showSnackBar(context, SnackBarType.Information, 'Registered, now login to your account!');
        return 'success';
      } else {
        final errorMap = jsonDecode(response.body) as Map<String, dynamic>;
        final errorMessage = errorMap['errors']['username'][0] ?? 'Unknown error occurred';
        showSnackBar(context, SnackBarType.Error, errorMessage);
        return 'failed: $errorMessage';
      }
    } catch (e) {
      print('Registration error: $e');
      return 'failed: $e';
    }
  }

  Future<String?> login(String username, String password, BuildContext context) async {
    final response = await http.post(
      Uri.parse('${baseUrl}api/users/login/'),
      body: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final token = data['token'];

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      showSnackBar(context, SnackBarType.Success, "Logged in");
      return "success";
    } else {
      showSnackBar(context, SnackBarType.Error, "Invalid credentials");
      return "Invalid credentials";
    }
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse('${baseUrl}api/users/logout/'),
          headers: {'Authorization': 'Token $token'},
        );

        if (response.statusCode == 200) {
          print('Token deleted on the server');
        }
      } catch (e) {
        print('Error $e');
      } finally {
        prefs.remove('token');
        showSnackBar(context, SnackBarType.Information, "Logged out");
      }
    }
  }
}
