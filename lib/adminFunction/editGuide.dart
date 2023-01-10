import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:touristguide/adminFunction/updateData.dart';
import 'package:touristguide/adminFunction/updateGuideDataSelected.dart';
import 'package:touristguide/variable.dart';

class EDITGUIDE extends StatefulWidget {
  const EDITGUIDE({super.key});

  @override
  State<EDITGUIDE> createState() => _EDITGUIDEState();
}

class _EDITGUIDEState extends State<EDITGUIDE> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Guide").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
                  setState(() {
                    selectedGuid = snapshot.data!.docs[index].id;
                  });

                  name_.text = snapshot.data!.docs[index]['name'];
                  des_on_Guide.text = snapshot.data!.docs[index]['des'];
                  Place__.text = snapshot.data!.docs[index]['place'];

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UpdatGuide(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(7),
                  padding: const EdgeInsets.all(5),
                  color: const Color.fromARGB(44, 33, 149, 243),
                  child: ListTile(
                    subtitle: Text(snapshot.data!.docs[index]['place']),
                    title: Text(snapshot.data!.docs[index]['name']),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        snapshot.data!.docs[index]['profile'],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
