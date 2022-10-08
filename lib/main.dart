import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do/auth/authscreen.dart';
import 'package:to_do/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'dart:html';
import 'dart:ui';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const myapp());
}

class myapp extends StatelessWidget {
  const myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.teal,
      ),
      debugShowCheckedModeBanner: false,
      // home: const AuthScreen(),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
            if(snapshot.hasData)
            {
              return Home();
            }else{
              return AuthScreen();
            }
          },
          
        
      ),
      
    );
  }
}