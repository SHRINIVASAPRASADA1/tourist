import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:touristguide/adminFunction/updateData.dart';
import 'package:touristguide/variable.dart';

class UpdatePlace extends StatefulWidget {
  const UpdatePlace({super.key});

  @override
  State<UpdatePlace> createState() => _UpdatePlaceState();
}

class _UpdatePlaceState extends State<UpdatePlace> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Places").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
                  setState(() {
                    seletedForUpdate = snapshot.data!.docs[index].id.toString();
                    title.text = snapshot.data!.docs[index]['title'];
                    des.text = snapshot.data!.docs[index]['history'];
                    his.text = snapshot.data!.docs[index]['des'];
                    address.text = snapshot.data!.docs[index]['address'];
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UpdatePlaceSelected(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(7),
                  padding: const EdgeInsets.all(5),
                  color: const Color.fromARGB(44, 33, 149, 243),
                  child: ListTile(
                    subtitle: Text(snapshot.data!.docs[index]['address']),
                    title: Text(snapshot.data!.docs[index]['title']),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        snapshot.data!.docs[index]['img'][0],
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
