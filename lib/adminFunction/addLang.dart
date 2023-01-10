import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:touristguide/variable.dart';

class AddLanguage extends StatefulWidget {
  const AddLanguage({super.key});

  @override
  State<AddLanguage> createState() => _AddLanguageState();
}

class _AddLanguageState extends State<AddLanguage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              child: CupertinoTextField(
                placeholder: "Enter Language You Want To Add ",
                controller: addlang,
              ),
            ),
            CupertinoButton(
              color: const Color.fromARGB(163, 0, 43, 78),
              child: const Text("Add Language"),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection("lang")
                    .doc(addlang.text.toLowerCase().trim())
                    .set({
                  "lang": addlang.text.toLowerCase().trim(),
                });
                addlang.text = "";
              },
            ),
            Container(
              padding: const EdgeInsets.all(12),
              height: MediaQuery.of(context).size.height * 0.60,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("lang")
                    .orderBy('lang')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(snapshot.data!.docs[index].id),
                        onDismissed: (val) {
                          FirebaseFirestore.instance
                              .collection("lang")
                              .doc(snapshot.data!.docs[index].id)
                              .delete();
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(79, 76, 175, 79),
                            border: Border.all(
                              width: 0.1,
                              color: Colors.black,
                            ),
                          ),
                          child: Text(
                            snapshot.data!.docs[index]['lang'],
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
