import 'package:flutter/material.dart';
import '../../helpers/auth_helper.dart';

class MusicScreen extends StatelessWidget {
  final AuthHelper authHelper = AuthHelper();

  MusicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('music'),
      ),
    );
  }
}
