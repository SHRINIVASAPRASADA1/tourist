import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:touristguide/variable.dart';

class UpdatePlaceSelected extends StatefulWidget {
  const UpdatePlaceSelected({super.key});

  @override
  State<UpdatePlaceSelected> createState() => _UpdatePlaceSelectedState();
}

class _UpdatePlaceSelectedState extends State<UpdatePlaceSelected> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CupertinoButton(
        color: Colors.blue,
        child: const Text("Update"),
        onPressed: () {
          FirebaseFirestore.instance
              .collection("Places")
              .doc(seletedForUpdate)
              .update({
            "title": title.text,
            "des": des.text,
            "address": address.text,
            "history": his.text,
          });
        },
      ),
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Places")
              .doc(seletedForUpdate)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: CupertinoTextField(
                      controller: title,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: CupertinoTextField(
                      controller: des,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: CupertinoTextField(
                      controller: his,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: CupertinoTextField(
                      controller: address,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: const Text(
                      "Near Location ",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: CupertinoTextField(
                      controller: near,
                      suffix: GestureDetector(
                        onTap: () {
                          FirebaseFirestore.instance
                              .collection("Places")
                              .doc(seletedForUpdate)
                              .update({
                            "near": FieldValue.arrayUnion([near.text]),
                          });
                          near.text = "";
                        },
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ),
                  for (var item in snapshot.data!['near'])
                    Dismissible(
                      onDismissed: (Valu) {
                        FirebaseFirestore.instance
                            .collection("Places")
                            .doc(seletedForUpdate)
                            .update({
                          "near": FieldValue.arrayRemove([item]),
                        });
                      },
                      key: Key(item),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.all(6),
                        color: const Color.fromARGB(37, 76, 175, 79),
                        child: Text(item),
                      ),
                    ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: const Text(
                      "KeyWords ",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: CupertinoTextField(
                      controller: search,
                      suffix: GestureDetector(
                        onTap: () {
                          FirebaseFirestore.instance
                              .collection("Places")
                              .doc(seletedForUpdate)
                              .update({
                            "keyword": FieldValue.arrayUnion(
                                [search.text.toLowerCase().trim()]),
                          });
                          search.text = "";
                        },
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ),
                  for (var item in snapshot.data!['keyword'])
                    Dismissible(
                      onDismissed: (Valu) {
                        FirebaseFirestore.instance
                            .collection("Places")
                            .doc(seletedForUpdate)
                            .update({
                          "near": FieldValue.arrayRemove([item]),
                        });
                      },
                      key: Key(item),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.all(6),
                        color: const Color.fromARGB(37, 76, 175, 79),
                        child: Text(item),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
