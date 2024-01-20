import 'package:flutter/material.dart';
import '../../helpers/auth_helper.dart';

class PlaylistScreen extends StatelessWidget {
  final AuthHelper authHelper = AuthHelper();

  PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('playlist'),
      ),
    );
  }
}
