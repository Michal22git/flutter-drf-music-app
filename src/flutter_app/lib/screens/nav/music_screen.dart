import 'package:flutter/material.dart';
import '../../helpers/request_helper.dart';
import '../../utils/snackbar_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class MusicScreen extends StatefulWidget {
  const MusicScreen({Key? key}) : super(key: key);

  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  List<Map<String, dynamic>>? musicData;

  @override
  void initState() {
    super.initState();
    _fetchMusicData();
  }

  Future<void> _fetchMusicData() async {
    try {
      final response = await RequestHelper().sendGetRequest('api/app/music/');

      if (response is List<dynamic>) {
        setState(() {
          musicData = response.cast<Map<String, dynamic>>();
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

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
      body: Container(
        child: ListView.builder(
          itemCount: musicData?.length ?? 0,
          itemBuilder: (context, index) {
            final music = musicData![index];
            final id = music['id'];
            final title = music['title'];
            final time = music['time'];
            final mp3File = music['mp3_file'];
            final owner = music['owner'];

            return GestureDetector(
              onTap: () {

              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color.fromRGBO(29, 185, 84, 1.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Time: $time',
                          style: const TextStyle(
                            color: Color.fromRGBO(179, 179, 179, 1.0),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Color.fromRGBO(179, 179, 179, 1.0),
                      ),
                      onPressed: () {
                        _showDeleteDialog(context, id);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    TextEditingController textController = TextEditingController();
    File? selectedFile;

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
                TextButton(
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.audio,
                      allowMultiple: false,
                    );

                    if (result != null && result.files.isNotEmpty) {
                      selectedFile = File(result.files.single.path!);
                      textController.text = selectedFile!.path;
                    }
                  },
                  child: Text('Select File'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(29, 185, 84, 1.0)),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () async {
                    if (selectedFile == null) {
                      print('No file selected');
                      return;
                    }

                    try {
                      final response = await RequestHelper().uploadMP3File(
                        'api/app/music/add/',
                        file: selectedFile,
                      );

                      if (response != null) {
                        showSnackBar(context, SnackBarType.Success, 'Song added successfully');
                        await _fetchMusicData();
                        setState(() {});
                      } else {
                        showSnackBar(context, SnackBarType.Error, 'Failed to add the song');
                      }

                      Navigator.of(context).pop();
                    } catch (e) {
                      print('Error: $e');
                    }
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

  void _showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Align(
            alignment: Alignment.center,
            child: Text('Delete song'),
          ),
          content: const Text('Are you sure you want to delete this song?'),
          actions: [
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(const Color.fromRGBO(29, 185, 84, 1.0)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: () async {
                  try {
                    final response =
                    await RequestHelper().sendDeleteRequest('api/app/music/delete/$id/');

                    if (response != null) {
                      showSnackBar(context, SnackBarType.Error, response['error']);
                    } else {
                      showSnackBar(context, SnackBarType.Success, 'Song deleted');
                      await _fetchMusicData();
                      setState(() {});
                    }

                    Navigator.of(context).pop();
                  } catch (e) {
                    print('Error: $e');
                  }
                },
                child: const Text('Delete'),
              ),
            ),
          ],
        );
      },
    );
  }
}
