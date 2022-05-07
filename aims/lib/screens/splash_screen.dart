import 'package:aims/screens/admin_screen.dart';
import 'package:aims/screens/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var role = 'user';
  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  void _navigateToNextScreen(Widget route) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => route,
      ),
    );
  }

  void _checkRole() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    setState(() {
      role = doc['role'];
    });
    if (role == 'admin') {
      _navigateToNextScreen(const AdminScreen());
    } else if (role == 'user') {
      _navigateToNextScreen(const HomePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/black_logo.png'),
          ],
        ),
      ),
    );
  }
}
