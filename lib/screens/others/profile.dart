import 'package:chatnote/Auth/login_screen.dart';
import 'package:chatnote/root%20methods/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Profile"),
          const SizedBox(
            height: 100,
          ),
          IconButton(
              onPressed: () {
                GoogleSignIn().signOut();
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout))
        ],
      )),
    );
  }
}
