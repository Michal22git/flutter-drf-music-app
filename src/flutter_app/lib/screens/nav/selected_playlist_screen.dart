import 'package:flutter/material.dart';
import '../../helpers/request_helper.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../utils/snackbar_utils.dart';

class SpecifiedPlaylistScreen extends StatefulWidget {
  final String playlistId;
  final Function onRefresh;

  SpecifiedPlaylistScreen({required Key key, required this.playlistId, required this.onRefresh})
      : super(key: key);

  @override
  SpecifiedPlaylistScreenState createState() => SpecifiedPlaylistScreenState();
}

class SpecifiedPlaylistScreenState extends State<SpecifiedPlaylistScreen> {
  Map<String, dynamic>? playlistData;
  List<Map<String, dynamic>>? availableSongs;

  @override
  void initState() {
    super.initState();
    _fetchSpecifiedPlaylistData();
    _fetchAvailableSongs();
  }

  Future<void> _fetchSpecifiedPlaylistData() async {
    try {
      final response =
      await RequestHelper().sendGetRequest('api/app/playlist/${widget.playlistId}/');

      if (response is Map<String, dynamic>) {
        setState(() {
          playlistData = response;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _fetchAvailableSongs() async {
    try {
      final response = await RequestHelper().sendGetRequest('api/app/music/');
      if (response is List<dynamic>) {
        setState(() {
          availableSongs = response.cast<Map<String, dynamic>>();
        });
      }
    } catch (e) {
      print('Error fetching available songs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromRGBO(29, 185, 84, 1.0),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_rounded,
              color: Color.fromRGBO(179, 179, 179, 1.0),
            ),
            onPressed: () {
              _showAddToPlaylistDialog(context);
            },
          ),
        ],
      ),
      body: playlistData != null
          ? SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Text(
              'Title: ${playlistData!['title']}',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Text(
              'Time: ${playlistData!['total_time']}',
              style: TextStyle(color: Color.fromRGBO(179, 179, 179, 1.0)),
            ),
            Text(
              'Songs Count: ${playlistData!['songs_count']}',
              style: TextStyle(color: Color.fromRGBO(179, 179, 179, 1.0)),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: playlistData!['songs'].length,
              itemBuilder: (context, index) {
                var song = playlistData!['songs'][index];
                return Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color.fromRGBO(29, 185, 84, 1.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Title: ${song['title']}',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            'Time: ${song['time']}',
                            style: TextStyle(color: Color.fromRGBO(179, 179, 179, 1.0)),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Color.fromRGBO(179, 179, 179, 1.0),
                        ),
                        onPressed: () {
                          _showDeleteDialog(context, song['id']);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _showAddToPlaylistDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Align(
            alignment: Alignment.center,
            child: Text('Add Songs to Playlist'),
          ),
          content: Container(
            width: double.maxFinite,
            height: 200,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: availableSongs!.length,
                    itemBuilder: (context, index) {
                      final music = availableSongs![index];
                      final title = music['title'];
                      return ListTile(
                        title: Text(title),
                        onTap: () {
                          _addToPlaylist(context, music['id']);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  void _addToPlaylist(BuildContext context, int songId) async {
    try {
      final response = await RequestHelper().sendPatchRequest(
        'api/app/playlist/${widget.playlistId}/add/$songId/',
      );

      if (response != null && response.containsKey('id')) {
        showSnackBar(context, SnackBarType.Success, 'Song added successfully');

        setState(() {
          playlistData = response;
        });
      } else if (response != null && response.containsKey('error')) {
        showSnackBar(context, SnackBarType.Error, response['error']);
      } else {
        showSnackBar(context, SnackBarType.Error, 'Failed to add the song');
      }
    } catch (e) {
      print('Error adding song to playlist: $e');
    }
  }

  void _showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Align(
            alignment: Alignment.center,
            child: Text('Remove song'),
          ),
          content: const Text('Are you sure you want to remove this song from playlist?'),
          actions: [
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(29, 185, 84, 1.0)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: () async {
                  try {
                    final response = await RequestHelper()
                        .sendDeleteRequest('api/app/playlist/${widget.playlistId}/delete/$id/');

                    if (response != null && response.containsKey('error')) {
                      showSnackBar(context, SnackBarType.Error, response['error']);
                    } else if (response != null && response.containsKey('message')) {
                      showSnackBar(context, SnackBarType.Success, response['message']);
                      Navigator.of(context).pop();
                      _fetchSpecifiedPlaylistData();
                    }
                  } catch (e) {
                    print('Error: $e');
                  }
                },
                child: const Text('Remove'),
              ),
            ),
          ],
        );
      },
    );
  }
}
