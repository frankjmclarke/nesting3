import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SplashUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/ic_launcher.png',
                width: 35.h,
                height: 35.h,
              ),
              SizedBox(height: 2.h), // Add some spacing between the image and text
              Text(
                'Getting ready...',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
