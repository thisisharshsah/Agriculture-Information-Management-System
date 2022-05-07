import 'package:aims/screens/home_page.dart';
import 'package:aims/screens/login_page.dart';
import 'package:aims/screens/profile_screen.dart';
import 'package:flutter/material.dart';

int _selectedIndex = 0;

Widget bottonNavigation(context) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.white,
    selectedItemColor: Colors.green,
    unselectedItemColor: Colors.black,
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
        label: 'Profile',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.logout_rounded),
        label: 'Logout',
      ),
    ],
    currentIndex: _selectedIndex,
    onTap: (int index) {
      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        _selectedIndex = index;
      }
      if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        _selectedIndex = index;
      }
      if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
        _selectedIndex = index;
      }
    },
  );
}
