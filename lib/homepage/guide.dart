import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:touristguide/authontication/collectUserDataOnPlace.dart';
import 'package:touristguide/placeenq/progress.dart';
import 'package:touristguide/placeenq/selectPlace.dart';
import 'package:touristguide/variable.dart';

class GuideList extends StatefulWidget {
  const GuideList({super.key});

  @override
  State<GuideList> createState() => _GuideListState();
}

class _GuideListState extends State<GuideList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection("Guide").get(),
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
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  totalRattingOfGuide = 0;
                  numberOfIteration = 0;
                  selected_mobile_number =
                      snapshot.data!.docs[index]['phonenumber'];
                  guideName = snapshot.data!.docs[index]['name'];
                });
                showMaterialModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    padding: const EdgeInsets.all(13),
                    child: SizedBox(
                      height: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: addHeight(context, 0.07),
                            height: addHeight(context, 0.01),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(130, 0, 0, 0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.only(
                              top: addHeight(
                                context,
                                0.04,
                              ),
                              bottom: addHeight(context, 0.03),
                            ),
                          ),
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                              snapshot.data!.docs[index]['profile'],
                            ),
                          ),
                          Text(
                            snapshot.data!.docs[index]['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            "+91 ${snapshot.data!.docs[index]['phonenumber']}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                          ),
                          FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection("Guide")
                                .doc(snapshot.data!.docs[index].id)
                                .collection("ratting")
                                .get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot1) {
                              if (snapshot1.connectionState ==
                                      ConnectionState.waiting ||
                                  !snapshot1.hasData ||
                                  snapshot1.hasError) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.green,
                                  ),
                                );
                              }
                              try {
                                for (var element in snapshot1.data!.docs) {
                                  double? now = double.tryParse(
                                      element['rattings'].toString());
                                  totalRattingOfGuide =
                                      (now! + totalRattingOfGuide);
                                  numberOfIteration++;
                                }
                              } catch (e) {
                                totalRattingOfGuide = 0;
                                numberOfIteration = 0;
                              }

                              return SizedBox(
                                width: MediaQuery.of(context).size.width * 0.80,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RatingBar.builder(
                                      itemSize: 30,
                                      initialRating: totalRattingOfGuide /
                                          numberOfIteration,
                                      minRating: 0.5,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      // ignore: prefer_const_constructors
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {},
                                    ),
                                    Text(snapshot1.data!.docs.length.toString())
                                  ],
                                ),
                              );
                            },
                          ),
                          Text(
                            snapshot.data!.docs[index]['place'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                          ),
                          Text(
                            snapshot.data!.docs[index]['des'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          ),
                          const Text(
                            "Languages",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(12),
                            width: double.infinity,
                            height: 2,
                            color: Colors.black,
                          ),
                          for (var item in snapshot.data!.docs[index]['lang'])
                            Text(
                              item,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 21,
                              ),
                            ),
                          Container(
                            margin: const EdgeInsets.all(14),
                            child: CupertinoButton(
                              color: Colors.blue,
                              child: const Text("BOOK NOW"),
                              onPressed: () {
                                String date = DateTime.now().day.toString();
                                selectedGuid =
                                    snapshot.data!.docs[index].id.toString();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CollectUserDataP(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    snapshot.data!.docs[index]['profile'],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
