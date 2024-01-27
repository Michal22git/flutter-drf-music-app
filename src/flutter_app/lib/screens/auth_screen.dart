import 'package:flutter/material.dart';
import '../helpers/auth_helper.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

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
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome back",
              style: TextStyle(
                fontSize: 25.0,
                color: Color.fromRGBO(179, 179, 179, 1.0),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isLoginMode = true;
                    });
                  },
                  child: Text(
                    "Log In",
                    style: TextStyle(
                      fontSize: 25.0,
                      color: isLoginMode
                          ? const Color.fromRGBO(29, 185, 84, 1.0)
                          : const Color.fromRGBO(179, 179, 179, 1.0),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isLoginMode = false;
                    });
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 25.0,
                      color: !isLoginMode
                          ? const Color.fromRGBO(29, 185, 84, 1.0)
                          : const Color.fromRGBO(179, 179, 179, 1.0),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: usernameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
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
              child: const Text(
                  "Submit",
                  style: TextStyle(color: Color.fromRGBO(33, 33, 33, 1.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
