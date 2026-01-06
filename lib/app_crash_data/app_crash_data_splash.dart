import 'package:flutter/material.dart';

class AppCrashDataSplash extends StatelessWidget {
  const AppCrashDataSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/splash-screen.png',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.35),
          ),
          const SafeArea(
            child: Center(
              child: SizedBox(
                width: 42,
                height: 42,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
