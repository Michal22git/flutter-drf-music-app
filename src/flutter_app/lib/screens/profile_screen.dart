import 'package:flutter/material.dart';
import '../helpers/auth_helper.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  final AuthHelper authHelper = AuthHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User profile'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await authHelper.logout(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AuthScreen()),
                );
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
