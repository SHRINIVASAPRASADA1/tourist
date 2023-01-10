import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:image_picker/image_picker.dart';
import 'package:touristguide/adminFunction/loadImage.dart';
import 'package:touristguide/variable.dart';

TextEditingController name = TextEditingController();
TextEditingController place = TextEditingController();
TextEditingController lang = TextEditingController();
TextEditingController des = TextEditingController();
TextEditingController guideNumber = TextEditingController();

class InsertGuide extends StatefulWidget {
  const InsertGuide({super.key});

  @override
  State<InsertGuide> createState() => _InsertGuideState();
}

List<dynamic> language = ["django", "tensorflow"];

class _InsertGuideState extends State<InsertGuide> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(imageLink),
      ),
      body: SingleChildScrollView(
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            // CupertinoButton(
            //   color: Colors.green,
            //   child: const Text("refresh"),
            //   onPressed: () {},
            // ),
            GestureDetector(
              onTap: () async {
                final ImagePicker _picker = ImagePicker();
                setState(() async {
                  XFile? image = (await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 70,
                  ));
                  File myfile = File(image!.path);
                  imageLink = (await uploadImageToFirebase(
                      myfile, DateTime.now().toString()) as String);
                });

                setState(() {});
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.15,
                child: const Center(
                  child: Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 60,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.30,
                  right: MediaQuery.of(context).size.width * 0.30,
                ),
                color: const Color.fromARGB(96, 0, 0, 0),
                child: imageLink != null
                    ? SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.width * 0.30,
                        child: Image.network(imageLink != ""
                            ? imageLink
                            : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4_cwAMo1aXZLsgCophAJsCB0Xh4suFCk7v5CtYZvHy3mpEa7acXgC4ZoW7uTMazmGya0&usqp=CAU"),
                      )
                    : const Text("Refresh"),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              child: CupertinoTextField(
                keyboardType: TextInputType.emailAddress,
                controller: guideNumber,
                placeholder: "Enter Guide Email ?",
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              child: CupertinoTextField(
                controller: name,
                placeholder: "Enter Guide Name ?",
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              child: CupertinoTextField(
                controller: place,
                placeholder: "Enter Guide Native Place ?",
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              child: CupertinoTextField(
                keyboardType: TextInputType.phone,
                controller: phoneNum,
                placeholder: "Enter Guide phoneNumber ?",
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              child: CupertinoTextField(
                keyboardType: TextInputType.number,
                controller: adhar,
                placeholder: "Enter Guide Adhar Number ?",
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              child: CupertinoTextField(
                keyboardType: TextInputType.number,
                controller: ratting,
                placeholder: "Enter Guide Rattings ?",
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              child: CupertinoTextField(
                controller: des,
                placeholder: "Enter Guide Description ?",
              ),
            ),
            CupertinoButton(
              color: Colors.blue,
              child: const Text("ADD"),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection("Guide")
                    .doc(guideNumber.text)
                    .set({
                  "name": name.text,
                  "place": place.text,
                  "des": des.text,
                  "lang": language,
                  "profile": imageLink,
                  "ratting": ratting.text,
                  "adhar": adhar.text,
                  "phonenumber": phoneNum.text,
                });

                lang.text = "";
                des.text = "";
                place.text = "";
                name.text = "";
                imageLink = "";
                guideNumber.text = "";
                ratting.text = "";
                adhar.text = "";
                phoneNum.text = "";
              },
            )
          ],
        ),
      ),
    );
  }
}
