import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:touristguide/homepage/HomePage.dart';
import 'package:touristguide/placeenq/searchGuide.dart';
import 'package:touristguide/variable.dart';

class CollectUserData extends StatefulWidget {
  const CollectUserData({super.key});

  @override
  State<CollectUserData> createState() => _CollectUserDataState();
}

class _CollectUserDataState extends State<CollectUserData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("Users")
            .doc(userIn!.email)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          try {
            username.text = snapshot.data!['name'];
            addres.text = snapshot.data!['phoneNumber'];
            phonenumber.text = snapshot.data!['addres'];
          } catch (e) {
            print(e);
          }

          return Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Container(
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.all(3),
                child: CupertinoTextField(
                  controller: username,
                  placeholder: "Enter Your Name !",
                ),
              ),
              Container(
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.all(3),
                child: CupertinoTextField(
                  keyboardType: TextInputType.number,
                  controller: phonenumber,
                  placeholder: "Enter Your mobile Number !",
                ),
              ),
              Container(
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.all(3),
                child: CupertinoTextField(
                  controller: addres,
                  placeholder: "Enter Your Address !",
                ),
              ),
              Container(
                margin: const EdgeInsets.all(13),
                child: CupertinoButton(
                  color: Colors.blue,
                  child: const Text("Submit"),
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection("Users")
                        .doc(userIn!.email)
                        .update({
                      "name": username.text,
                      "phoneNumber": phonenumber.text,
                      "addres": addres.text,
                    });

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchGuide(),
                        ),
                        (route) => false);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
