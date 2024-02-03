import 'package:flutter/material.dart';
import '../../helpers/request_helper.dart';
import '../../utils/snackbar_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';

class MusicScreen extends StatefulWidget {
  const MusicScreen({Key? key}) : super(key: key);

  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  List<Map<String, dynamic>>? musicData;
  final _audioPlayer = AudioPlayer();
  int _currentPlayingIndex = -1;

  @override
  void initState() {
    super.initState();
    _fetchMusicData();
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        _playNextSong();
      }
    });
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

            return GestureDetector(
              onTap: () {
                _playMusic(mp3File, index);
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

  void _playMusic(String mp3Url, int index) async {
    if (mp3Url.isNotEmpty) {
      try {
        await _audioPlayer.play(UrlSource(mp3Url));
        setState(() {
          _currentPlayingIndex = index;
        });
        _showNowPlayingSnackBar(index);
      } catch (e) {
        print("Error playing music: $e");
      }
    }
  }

  void _playNextSong() {
    if (_currentPlayingIndex < (musicData?.length ?? 0) - 1) {
      final nextIndex = _currentPlayingIndex + 1;
      final nextSong = musicData![nextIndex];
      _playMusic(nextSong['mp3_file'], nextIndex);
    } else {
      _audioPlayer.stop();
      setState(() {
        _currentPlayingIndex = -1;
      });
      _showNowPlayingSnackBar(-1);
    }
  }

  void _showNowPlayingSnackBar(int index) {
    if (index >= 0 && index < (musicData?.length ?? 0)) {
      final nowPlaying = musicData![index];
      final title = nowPlaying['title'];
      final time = nowPlaying['time'];
      showSnackBar(context, SnackBarType.Information, title);
    }
  }

  void _showAddItemDialog(BuildContext context) {
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
