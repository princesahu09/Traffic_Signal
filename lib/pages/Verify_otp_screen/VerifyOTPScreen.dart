import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signal/pages/home_screen/HomeScreen.dart';

class VerifyOTPScreen extends StatefulWidget {
  final String verificationId;
  const VerifyOTPScreen({Key? key, required this.verificationId})
    : super(key: key);

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  TextEditingController otp = TextEditingController();
  void verifyOTP() async {
    String otp = this.otp.text.trim();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: otp,
    );
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      if (userCredential.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (ex) {
      log(ex.code.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Positioned(
              top: 50,
              left: 50,
              right: 50,
              bottom: 50,
              child: TextField(
                controller: otp,
                maxLength: 6,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  // prefixIcon: Icon(Icons.),)
                  label: Text('Verify OTP'),
                  hintText: 'Enter OTP',
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              verifyOTP();
            },
            child: Text('Verify'),
          ),
        ],
      ),
    );
  }
}
