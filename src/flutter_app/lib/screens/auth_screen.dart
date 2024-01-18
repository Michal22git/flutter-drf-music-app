import 'package:flutter/material.dart';
import '../helpers/auth_helper.dart';
import 'profile_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthHelper authHelper = AuthHelper();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoginMode = true;

  void switchAuthMode() {
    setState(() {
      isLoginMode = !isLoginMode;
    });
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    bool loggedIn = await authHelper.isLoggedIn();
    if (loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLoginMode ? 'Log In' : 'Register'),
        actions: [
          TextButton(
            onPressed: switchAuthMode,
            child: Text(isLoginMode ? 'Switch to Register' : 'Switch to Log In'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (isLoginMode) {
                    final token = await authHelper.login(
                      usernameController.text,
                      passwordController.text,
                      context,
                    );

                    if (token == 'success') {
                      print('Logged in. Token: $token');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen()),
                      );
                    }
                  } else {
                    final result = await authHelper.register(
                      usernameController.text,
                      passwordController.text,
                      context,
                    );

                    if (result == 'success') {
                      switchAuthMode();
                    }
                  }
                } catch (e) {
                  print('${isLoginMode ? 'Login' : 'Registration'} failed: $e');
                }
              },
              child: Text(isLoginMode ? 'Log In' : 'Register'),
            ),
          ],
        ),
      ),
    );
  }
}
