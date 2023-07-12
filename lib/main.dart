import 'package:chatnote/Auth/login_screen.dart';
import 'package:chatnote/nav_bar.dart';
import 'package:chatnote/root%20methods/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  kIsWeb
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyDhA2AoY1_dYHeD-o4JfK68-MDxNPVKlC8",
              authDomain: "my-note-001.firebaseapp.com",
              projectId: "my-note-001",
              storageBucket: "my-note-001.appspot.com",
              messagingSenderId: "485922204753",
              appId: "1:485922204753:web:b95f6c6cc34d4ba75b9c70",
              measurementId: "G-7VE4J7DT5V"))
      : await Firebase.initializeApp();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
  Global.init();
}

//sdsdsdsd
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        cupertinoOverrideTheme: CupertinoThemeData(
          primaryColor: Colors.white.withOpacity(.9),
          brightness: Brightness.dark,
        ),
        primarySwatch: Colors.blue,
      ),
      home: ScreenUtilInit(
        builder: (context, child) {
          return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (ctx, snapshot) {
                if (!snapshot.hasData) {
                  return const LogInScreen();
                }
                return const NavBar();
              });
        },
      ),
    );
  }
}
