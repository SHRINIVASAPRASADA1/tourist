import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:touristguide/authontication/collectUserData.dart';
import 'package:touristguide/homepage/HomePage.dart';
import 'package:touristguide/main.dart';
import 'package:touristguide/variable.dart';

class SignupWithGoogle extends StatefulWidget {
  const SignupWithGoogle({super.key});

  @override
  State<SignupWithGoogle> createState() => _SignupWithGoogleState();
}

class _SignupWithGoogleState extends State<SignupWithGoogle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: const Text(
                  "  Signup With Google ",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await signInWithGoogle();
                  setState(() {
                    userIn = FirebaseAuth.instance.currentUser;
                    print(userIn!.email);
                    FirebaseFirestore.instance
                        .collection("Users")
                        .doc(userIn!.email)
                        .set({
                      "type": "normal",
                      "theme": "black",
                    });
                  });
                  if (userIn != null) {
                    // ignore: use_build_context_synchronously
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                        (route) => false);
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.50,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Image.asset(
                        "assets/icon/googleLogo.ico",
                        width: MediaQuery.of(context).size.width * 0.11,
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: const Text(
                          "Google",
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: const Text(
                  " Please Click On Google to Signup  ",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
