import 'package:flutter/material.dart';
import '../../helpers/auth_helper.dart';
import '../../helpers/request_helper.dart';
import '../../utils/snackbar_utils.dart';

class PlaylistScreen extends StatefulWidget {
  final AuthHelper authHelper = AuthHelper();
  final Function onTabTapped;

  PlaylistScreen({Key? key, required this.onTabTapped}) : super(key: key);

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  List<Map<String, dynamic>>? playlistData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchPlaylistData();
  }

  Future<void> _fetchPlaylistData() async {
    try {
      final response =
      await RequestHelper().sendGetRequest('api/app/playlist/');

      if (response is List<dynamic>) {
        setState(() {
          playlistData = response.cast<Map<String, dynamic>>();
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
          'Playlist',
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
          itemCount: playlistData?.length ?? 0,
          itemBuilder: (context, index) {
            final playlist = playlistData![index];
            final id = playlist['id'];
            final title = playlist['title'];
            final songsCount = playlist['songs_count'];
            final totalTime = playlist['total_time'];

            return Container(
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
                        'Songs Count: $songsCount',
                        style: const TextStyle(
                          color: Color.fromRGBO(179, 179, 179, 1.0),
                        ),
                      ),
                      Text(
                        'Total Time: $totalTime',
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
            );
          },
        ),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) async {
    TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Align(
            alignment: Alignment.center,
            child: Text('Add Playlist'),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(const Color.fromRGBO(29, 185, 84, 1.0)),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () async {
                    String enteredText = textController.text;

                    try {
                      final response = await RequestHelper().sendPostRequest(
                        'api/app/playlist/add/',
                        body: {'title': enteredText},
                      );

                      if (response.containsKey('error')) {
                        showSnackBar(context, SnackBarType.Error, response['error']);
                      } else {
                        showSnackBar(context, SnackBarType.Success, "Playlist created");
                        await _fetchPlaylistData();
                        setState(() {});
                        widget.onTabTapped(1);
                      }

                      Navigator.pop(context);
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
            child: Text('Delete Playlist'),
          ),
          content: const Text('Are you sure you want to delete this playlist?'),
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
                    await RequestHelper().sendDeleteRequest('api/app/playlist/$id/delete/');

                    if (response != null) {
                      showSnackBar(context, SnackBarType.Error, response['error']);
                    } else {
                      showSnackBar(context, SnackBarType.Success, 'Playlist deleted');
                      await _fetchPlaylistData();
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
