import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signal/pages/login_screen/LoginScreen.dart';
import 'package:signal/pages/sign_up_with_phone/SignUpWithPhone.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var email = TextEditingController();
  var password = TextEditingController();
  var confirmPassword = TextEditingController();
  var firstName = TextEditingController();
  var secondName = TextEditingController();
  var college = TextEditingController();
  var phone = TextEditingController();
  void createAccount() async {
    String email = this.email.text.trim();
    String password = this.password.text.trim();
    String confirmPassword = this.confirmPassword.text.trim();
    String firstName = this.firstName.text.trim();
    String secondName = this.secondName.text.trim();
    String college = this.college.text.trim();
    String phone = this.phone.text.trim();

    if (email == "" ||
        password == "" ||
        confirmPassword == "" ||
        firstName == "" ||
        secondName == "" ||
        college == "" ||
        phone == "") {
      log("All fields are required");
    } else if (password != confirmPassword) {
      log("Password does not match");
    } else {
      // create new account

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          log('user created');
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      } on FirebaseAuthException catch (ex) {
        log(ex.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 25),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: firstName,

                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: Icon(Icons.person),
                              hintText: 'Enter First Name',
                              label: Text('First Name'),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: TextField(
                            controller: secondName,

                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: Icon(Icons.person),
                              hintText: 'Enter Surname',
                              label: Text('Surname'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: email,

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
                        prefixIcon: Icon(Icons.email_rounded),
                        hintText: 'Enter Email',
                        label: Text('Email'),
                      ),
                    ),
                  ),

                  SizedBox(width: 8),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: phone,

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
                        prefixIcon: Icon(Icons.phone),
                        hintText: 'Mob.number',
                        label: Text('Mob. No'),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: college,

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
                        prefixIcon: Icon(Icons.school),
                        hintText: 'Enter College Name',
                        label: Text('College Name'),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

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
                        prefixIcon: Icon(Icons.password),
                        hintText: 'Enter password',
                        label: Text('Password'),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      child: FloatingActionButton(
                        backgroundColor: Colors.blue.shade200,
                        onPressed: () {
                          createAccount();
                          print(firstName.text);
                          print(secondName.text);
                          print(college.text);
                          print(phone.text);
                          print(email.text);
                          print(password.text);

                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => HomeScreen(),
                          //   ),
                          // );
                        },
                        child: Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpWithPhone(),
                        ),
                      );
                    },
                    child: Text('Sign Up with Mob No'),
                  ),
                  SizedBox(width: 10),
                  Row(
                    children: [
                      Text(
                        "Already have a Account?",
                        style: TextStyle(
                          color: Colors.black12,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },

                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
