import 'package:flutter/material.dart';
import '../../helpers/auth_helper.dart';
import '../auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  final AuthHelper authHelper = AuthHelper();

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('User profile'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await authHelper.logout(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AuthScreen()),
                );
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
