import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class UpdateSlider extends StatefulWidget {
  const UpdateSlider({super.key});

  @override
  State<UpdateSlider> createState() => _UpdateSliderState();
}

class _UpdateSliderState extends State<UpdateSlider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection("carouselSlider").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Dismissible(
                // ignore: non_constant_identifier_names
                onDismissed: (Value) {
                  FirebaseFirestore.instance
                      .collection("carouselSlider")
                      .doc(snapshot.data!.docs[index].id)
                      .delete();
                },
                key: Key(snapshot.data!.docs[index].id.toString()),
                child: ListTile(
                  title: Text(snapshot.data!.docs[index]['title']),
                  subtitle: Text(snapshot.data!.docs[index].id),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      snapshot.data!.docs[index]['img'],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: CupertinoButton(
        child: const Text("Update Slider"),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("Places").snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          FirebaseFirestore.instance
                              .collection("carouselSlider")
                              .add({
                            "img": snapshot.data!.docs[index]['img'][0],
                            "title": snapshot.data!.docs[index]['title'],
                            "id": snapshot.data!.docs[index].id,
                          });
                        },
                        title: Text(snapshot.data!.docs[index]['title']),
                        subtitle: Text(snapshot.data!.docs[index]['address']),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            snapshot.data!.docs[index]['img'][0],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
