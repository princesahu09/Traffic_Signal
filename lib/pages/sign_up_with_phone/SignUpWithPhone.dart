import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signal/pages/Verify_otp_screen/VerifyOTPScreen.dart';

class SignUpWithPhone extends StatefulWidget {
  const SignUpWithPhone({super.key});

  @override
  State<SignUpWithPhone> createState() => _SignUpWithPhoneState();
}

class _SignUpWithPhoneState extends State<SignUpWithPhone> {
  var name = TextEditingController();
  var number = TextEditingController();
  var password = TextEditingController();
  var confirmPassword = TextEditingController();

  void sendOTP() async {
    String phone = "+91" + number.text.trim();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      codeSent: (verificationId, resendToken) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                VerifyOTPScreen(verificationId: verificationId),
          ),
        );
      },
      verificationCompleted: (credential) {},
      verificationFailed: (ex) {
        log(ex.code.toString());
      },
      codeAutoRetrievalTimeout: (verificationId) {},
      timeout: Duration(seconds: 30),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white, width: 1),
                      ),
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Enter Name',
                      label: Text('Enter Name'),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.white, width: 1),
                      ),

                      prefixIcon: Icon(Icons.phone),
                      suffixIcon: Icon(Icons.call),
                      label: Text('Mobile No'),
                      hintText: 'Enter Contact number',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: password,

                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: Icon(Icons.password_outlined),
                      hintText: 'Enter password',
                      label: Text(' password'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: confirmPassword,

                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: Icon(Icons.password_outlined),
                      hintText: 'Confirm password',
                      label: Text('Confirm password'),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: FloatingActionButton(
                          backgroundColor: Colors.blue,
                          onPressed: () {
                            sendOTP();
                          },
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
