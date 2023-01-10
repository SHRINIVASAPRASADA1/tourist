import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:image_picker/image_picker.dart';
import 'package:touristguide/adminFunction/imageshow.dart';
import 'package:touristguide/adminFunction/updateProductImageAndShow.dart';
import 'package:touristguide/variable.dart';

TextEditingController title = TextEditingController();
TextEditingController des = TextEditingController();
TextEditingController addres = TextEditingController();
TextEditingController near = TextEditingController();
TextEditingController rattings = TextEditingController();
TextEditingController history = TextEditingController();
TextEditingController located = TextEditingController();
TextEditingController Price = TextEditingController();

class InsertPlace extends StatefulWidget {
  const InsertPlace({super.key});

  @override
  State<InsertPlace> createState() => _InsertPlaceState();
}

class _InsertPlaceState extends State<InsertPlace> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CupertinoButton(
        child: const Text("ADD"),
        onPressed: () {
          FirebaseFirestore.instance.collection("Places").doc(title.text).set({
            "title": title.text,
            "des": des.text,
            "address": addres.text,
            "near": [
              near.text,
            ],
            "rattings": rattings.text,
            "history": history.text,
            "located": located.text,
            "img": linkOfImage,
            "price": int.parse(Price.text),
            "date": DateTime.now(),
            "keyword": [
              'mysore',
            ],
          });

          title.text = "";
          des.text = "";
          addres.text = "";
          near.text = "";
          rattings.text = "";
          history.text = "";
          located.text = "";
          linkOfImage.clear();

          setState(() {});
        },
      ),
      appBar: AppBar(
        title: Text(linkOfImage.length.toString()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              child: CupertinoTextField(
                controller: title,
                placeholder: "Title",
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              child: CupertinoTextField(
                controller: des,
                placeholder: "Description ?",
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              child: CupertinoTextField(
                controller: addres,
                placeholder: "Address ?",
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.all(6),
            //   child: CupertinoTextField(
            //     suffix: GestureDetector(
            //         onTap: () {
            //           FirebaseFirestore.instance
            //               .collection("Places")
            //               .doc(title.text)
            //               .update({
            //             "near": FieldValue.arrayUnion([near.text]),
            //           });
            //           near.text = "";
            //         },
            //         child: const Icon(Icons.add)),
            //     controller: near,
            //     placeholder: "Near By Place ex: hotel - example",
            //   ),
            // ),
            Container(
              padding: const EdgeInsets.all(6),
              child: CupertinoTextField(
                controller: rattings,
                placeholder: "Rattings ?",
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              child: CupertinoTextField(
                controller: history,
                placeholder: "History ?",
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              child: CupertinoTextField(
                controller: located,
                placeholder: "Located ?",
              ),
            ),

            Container(
              padding: const EdgeInsets.all(6),
              child: CupertinoTextField(
                keyboardType: TextInputType.number,
                controller: Price,
                placeholder: "Price ?",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(
                      () async {
                        final ImagePicker _picker = ImagePicker();
                        setState(() async {
                          linkOfImage;
                          XFile? image = (await _picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 70,
                          ));
                          File myfile = File(image!.path);
                          setState(() async {
                            linkOfImage.add(await uploadImageToFirebase(
                                myfile, DateTime.now().toString()) as String);
                          });
                        });
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Icon(
                      Icons.filter,
                      size: 70,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  padding: const EdgeInsets.all(6),
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {});
                    },
                    // ignore: prefer_const_constructors
                    child: Icon(
                      Icons.refresh,
                      size: 70,
                    ),
                  ),
                ),
              ],
            ),

            updateUi(),
            //const ImageSelected()
          ],
        ),
      ),
    );
  }

  updateUi() {
    return SizedBox(
      width: double.infinity,
      height: addHeight(context, 0.40),
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: linkOfImage.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(10),
            child: Image.network(
              linkOfImage[index],
            ),
          );
        },
      ),
    );
  }
}
