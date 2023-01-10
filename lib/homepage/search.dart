import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:touristguide/placeenq/viewPlace.dart';
import 'package:touristguide/variable.dart';

class SEARCHBOX extends StatefulWidget {
  const SEARCHBOX({super.key});

  @override
  State<SEARCHBOX> createState() => _SEARCHBOXState();
}

class _SEARCHBOXState extends State<SEARCHBOX> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Container(
            padding: const EdgeInsets.all(7),
            width: MediaQuery.of(context).size.width * 0.99,
            child: CupertinoTextField(
              onChanged: (val) {
                setState(() {
                  searchList = val;
                });
              },
              autofocus: true,
              placeholder: "Search Places Here !",
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Places")
            .where('keyword', arrayContainsAny: searchList.split(' '))
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
              return GestureDetector(
                onTap: () {
                  setState(() {
                    currentSelectedPlace =
                        snapshot.data!.docs[index].id.toString();
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ViewPlace(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(67, 33, 149, 243),
                    border: Border.all(
                      width: 0.1,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    subtitle: Text(snapshot.data!.docs[index].id),
                    title: Text(snapshot.data!.docs[index]['title']),
                    leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                      snapshot.data!.docs[index]['img'][0],
                    )),
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
