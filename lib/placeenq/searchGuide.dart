import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:touristguide/placeenq/progress.dart';
import 'package:touristguide/variable.dart';

class SearchGuide extends StatefulWidget {
  const SearchGuide({super.key});

  @override
  State<SearchGuide> createState() => _SearchGuideState();
}

final _razorpay = Razorpay();

String placeName = "";

class _SearchGuideState extends State<SearchGuide> {
  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const ProgressDone(),
        ),
        (route) => false);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    String date = DateTime.now().day.toString();
    FirebaseFirestore.instance
        .collection("Bookings")
        .doc("${userIn!.email}$date$placeName$currentSelectedPlace")
        .delete();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    String date = DateTime.now().day.toString();
    FirebaseFirestore.instance
        .collection("Bookings")
        .doc("${userIn!.email}$date$placeName$currentSelectedPlace")
        .delete();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("data"),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.08,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("lang").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData ||
                    snapshot.hasError) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  );
                }
                return DropdownButton(
                  hint: Text("language $searchstr"),
                  items: [
                    for (var item in snapshot.data!.docs) item.id,
                  ].map(
                    (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val),
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    setState(() {
                      searchstr = val!;
                    });
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.40,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Guide")
                  .where('lang', arrayContains: searchstr)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    totalRattingOfGuide = 0;
                    numberOfIteration = 0;
                    return ListTile(
                      onTap: () {
                        showMaterialModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                            padding: const EdgeInsets.all(13),
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
                                      0.004,
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
                                      for (var element
                                          in snapshot1.data!.docs) {
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
                                      width: MediaQuery.of(context).size.width *
                                          0.80,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          RatingBar.builder(
                                            itemSize: 30,
                                            initialRating: totalRattingOfGuide /
                                                numberOfIteration,
                                            minRating: 0.5,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 4.0),
                                            // ignore: prefer_const_constructors
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {},
                                          ),
                                          Text(snapshot1.data!.docs.length
                                              .toString())
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                Text(
                                  "+91 ${snapshot.data!.docs[index]['phonenumber']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 19,
                                  ),
                                ),
                                Text(
                                  snapshot.data!.docs[index]['place'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 19,
                                  ),
                                ),
                                Text(
                                  snapshot.data!.docs[index]['des'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 20,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(12),
                                  width: double.infinity,
                                  height: 2,
                                  color: Colors.black,
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
                                for (var item in snapshot.data!.docs[index]
                                    ['lang'])
                                  Text(
                                    item,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 21,
                                    ),
                                  ),
                                Container(
                                  margin: const EdgeInsets.all(14),
                                  child: CupertinoButton(
                                    color: Colors.blue,
                                    child: const Text("BOOK NOW"),
                                    onPressed: () async {
                                      setState(() {
                                        placeName =
                                            snapshot.data!.docs[index]['name'];
                                      });
                                      String date =
                                          DateTime.now().day.toString();
                                      FirebaseFirestore.instance
                                          .collection("Bookings")
                                          .doc(
                                              "${userIn!.email}$date${snapshot.data!.docs[index]['name']}$currentSelectedPlace")
                                          .set({
                                        "date": DateTime.now(),
                                        "guide": snapshot.data!.docs[index]
                                            ['name'],
                                        "email": userIn!.email,
                                        "guide_id":
                                            snapshot.data!.docs[index].id,
                                        "place": currentSelectedPlace,
                                        "price": price_,
                                        "status": "not yet",
                                        "number": snapshot.data!.docs[index]
                                            ['phonenumber'],
                                      });

                                      var options = {
                                        'key': 'rzp_test_HPR933L2nTKRBP',
                                        'amount': 100 * 100,
                                        'name': 'shrinivasaprasada',
                                        // 'order_id':
                                        //     'order_EMBFqjDHEEn80l', // Generate order_id using Orders API
                                        'description': 'saree',
                                        'timeout': 500, // in seconds
                                        'prefill': {
                                          'contact': '9380869058',
                                          'email':
                                              'shrinivasagowdagowda@gmail.com'
                                        }
                                      };

                                      _razorpay.open(options);
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      subtitle: Text(snapshot.data!.docs[index].id),
                      title: Text(snapshot.data!.docs[index]['name']),
                      leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                        snapshot.data!.docs[index]['profile'],
                      )),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    _razorpay.clear();
    super.dispose();
  }
}
