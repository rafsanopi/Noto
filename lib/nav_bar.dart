import 'package:chatnote/Colors/colors.dart';
import 'package:chatnote/screens/note/add_note_screen.dart';
import 'package:chatnote/screens/note/note_screen.dart';
import 'package:chatnote/screens/others/notifications.dart';
import 'package:chatnote/screens/others/profile.dart';
import 'package:chatnote/screens/others/todo.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Note(),
    Todo(),
    Notifications(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButton: _selectedIndex == 0 || _selectedIndex == 1
          ? FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                if (_selectedIndex == 0) {
                  Get.to(() => const AddNoteScreen());
                }
              },
              child: const Icon(
                FontAwesomeIcons.plus,
                color: primaryColor,
              ),
            )
          : null,
      backgroundColor: homeBackground,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
        decoration: BoxDecoration(
            color: primaryColor, borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            rippleColor: secondaryColor,
            gap: 8,
            activeColor: secondaryColor,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: Colors.grey[100]!,
            tabs: const [
              GButton(
                curve: Curves.easeInOut,
                iconColor: Colors.white,
                icon: FontAwesomeIcons.solidNoteSticky,
                text: 'Notes',
              ),
              GButton(
                iconColor: Colors.white,
                iconActiveColor: secondaryColor,
                icon: FontAwesomeIcons.solidRectangleList,
                text: 'To Do',
              ),
              GButton(
                iconColor: Colors.white,
                icon: FontAwesomeIcons.solidBell,
                text: 'Notification',
              ),
              GButton(
                iconColor: Colors.white,
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
