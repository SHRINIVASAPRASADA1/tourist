import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:touristguide/variable.dart';

class Bookings extends StatefulWidget {
  const Bookings({super.key});

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Bookings")
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData ||
              snapshot.hasError) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var date = DateTime.parse(
                  snapshot.data!.docs[index]['date'].toDate().toString());

              return Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: snapshot.data!.docs[index]['status'] == "conform"
                      ? const Color.fromARGB(84, 76, 175, 79)
                      : Colors.transparent,
                  border: Border.all(
                    width: 0.2,
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text("Guide Name : ${snapshot.data!.docs[index]['guide']}"),
                    Text(" Email : ${snapshot.data!.docs[index]['email']}"),
                    Text(
                        "Selected Place : ${snapshot.data!.docs[index]['place']}"),
                    Text("Date : ${date.toString()}"),
                    CupertinoButton(
                      child: const Text("Conform"),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection("Bookings")
                            .doc(snapshot.data!.docs[index].id.toString())
                            .update({
                          "status": "conform",
                        });
                      },
                    ),
                    CupertinoButton(
                      child: const Text("remove conf"),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection("Bookings")
                            .doc(snapshot.data!.docs[index].id.toString())
                            .update({
                          "status": "not yet",
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
