import 'package:flutter/material.dart';
import '../../helpers/auth_helper.dart';


class ProfileScreen extends StatelessWidget {
  final AuthHelper authHelper = AuthHelper();


  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color.fromRGBO(29, 185, 84, 1.0),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Color.fromRGBO(179, 179, 179, 1.0),
            ),
            onPressed: () async {
              await authHelper.logout(context);
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User profile'),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
