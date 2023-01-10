import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:touristguide/variable.dart';

class Mybookings extends StatefulWidget {
  const Mybookings({super.key});

  @override
  State<Mybookings> createState() => _MybookingsState();
}

class _MybookingsState extends State<Mybookings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Bookings")
            .orderBy('date', descending: true)
            .where('email', isEqualTo: userIn!.email)
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
              bool isVisible;
              try {
                isVisible = snapshot.data!.docs[index]['rated'];
              } catch (e) {
                isVisible = true;
              }

              return Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isVisible == true
                      ? Colors.transparent
                      : const Color.fromARGB(55, 76, 175, 79),
                  border: Border.all(
                    width: 0.7,
                    color: isVisible == true ? Colors.black : Colors.green,
                  ),
                ),
                child: Column(
                  children: [
                    Text("Guide Name : ${snapshot.data!.docs[index]['guide']}"),
                    Text(
                        "Phone Number : +91 ${snapshot.data!.docs[index]['number']}"),
                    Text("Price : ₹${snapshot.data!.docs[index]['price']}"),
                    Text(" Email : ${snapshot.data!.docs[index]['email']}"),
                    Text(
                        "Selected Place : ${snapshot.data!.docs[index]['place']}"),
                    Text("Date : ${date.toString()}"),
                    Visibility(
                      visible: isVisible,
                      child: CupertinoButton(
                        child: const Text("Cancel booking"),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection("Bookings")
                              .doc(snapshot.data!.docs[index].id.toString())
                              .delete();
                        },
                      ),
                    ),
                    snapshot.data!.docs[index]['status'] == 'not yet'
                        ? const Text("processing.....")
                        : Visibility(
                            visible: isVisible,
                            child: RatingBar.builder(
                              initialRating: 0,
                              minRating: 0.5,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              // ignore: prefer_const_constructors
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                FirebaseFirestore.instance
                                    .collection("Guide")
                                    .doc(snapshot.data!.docs[index]['guide_id'])
                                    .collection("ratting")
                                    .doc(snapshot.data!.docs[index].id)
                                    .set({
                                  "rattings": rating,
                                  "from": userIn!.email,
                                  "placeOfBooking": snapshot.data!.docs[index]
                                      ['place'],
                                  "date": DateTime.now(),
                                });
                                FirebaseFirestore.instance
                                    .collection("Bookings")
                                    .doc(snapshot.data!.docs[index].id)
                                    .update({
                                  "rated": false,
                                });
                              },
                            ),
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
