import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../helpers/auth_helper.dart';
import 'nav/profile_screen.dart';
import 'nav/playlist_screen.dart';
import 'nav/music_screen.dart';

class HomeScreen extends StatefulWidget {
  final int selectedIndex;

  const HomeScreen({Key? key, this.selectedIndex = 0}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Add this line to store the selected index

  final AuthHelper authHelper = AuthHelper();

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the local variable instead
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return MusicScreen();
      case 1:
        return PlaylistScreen();
      case 2:
        return ProfileScreen();
      default:
        return Container();
    }
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black, Colors.transparent],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: GNav(
          backgroundColor: Colors.transparent,
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.grey.shade800,
          padding: const EdgeInsets.all(16),
          gap: 8,
          onTabChange: _onTabTapped,
          tabs: const [
            GButton(
              icon: Icons.queue_music_rounded,
              text: 'Music',
            ),
            GButton(
              icon: Icons.library_books_outlined,
              text: 'Playlist',
            ),
            GButton(
              icon: Icons.account_circle,
              text: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}