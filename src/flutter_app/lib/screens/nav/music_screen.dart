import 'package:flutter/material.dart';
import '../../helpers/auth_helper.dart';


class MusicScreen extends StatelessWidget {
  final AuthHelper authHelper = AuthHelper();

  MusicScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Music',
          style: TextStyle(
            color: Color.fromRGBO(29, 185, 84, 1.0),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_rounded,
              color: Color.fromRGBO(179, 179, 179, 1.0),
            ),
            onPressed: () {
              _showAddItemDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Align(
            alignment: Alignment.center,
            child: Text('Add Music'),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    labelText: 'Select File',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(29, 185, 84, 1.0)),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () async {

                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
