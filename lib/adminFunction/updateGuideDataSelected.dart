import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:touristguide/variable.dart';

class UpdatGuide extends StatefulWidget {
  const UpdatGuide({super.key});

  @override
  State<UpdatGuide> createState() => _UpdatGuidedState();
}

class _UpdatGuidedState extends State<UpdatGuide> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CupertinoButton(
        color: Colors.blue,
        child: const Text("Update Guide"),
        onPressed: () {
          FirebaseFirestore.instance
              .collection("Guide")
              .doc(selectedGuid)
              .update({
            "name": title.text,
            "des": des.text,
            "place": address.text,
          });
        },
      ),
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Guide")
              .doc(selectedGuid)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: CupertinoTextField(
                      controller: name_,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: CupertinoTextField(
                      controller: des_on_Guide,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: CupertinoTextField(
                      controller: Place__,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: CupertinoTextField(
                      controller: lang_,
                      suffix: GestureDetector(
                        onTap: () {
                          FirebaseFirestore.instance
                              .collection("Guide")
                              .doc(selectedGuid)
                              .update({
                            "lang": FieldValue.arrayUnion(
                                [lang_.text.toLowerCase().trim()]),
                          });
                          lang_.text = "";
                        },
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ),
                  for (var item in snapshot.data!['lang'])
                    Dismissible(
                      onDismissed: (Valu) {
                        FirebaseFirestore.instance
                            .collection("Guide")
                            .doc(selectedGuid)
                            .update({
                          "lang": FieldValue.arrayRemove([item]),
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
