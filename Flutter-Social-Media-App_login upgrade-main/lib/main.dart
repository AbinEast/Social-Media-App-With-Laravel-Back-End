import 'package:flutter/material.dart';
import 'package:responsi/pages/welcome_page.dart';

void main() {
  runApp(SocialHomePage());
}

class SocialHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Color(0xFFFFF7F3),
      ),
    );
  }
}
