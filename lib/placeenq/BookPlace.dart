import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:touristguide/placeenq/progress.dart';
import 'package:touristguide/placeenq/selectPlace.dart';

import 'package:touristguide/placeenq/viewPlace.dart';
import 'package:touristguide/variable.dart';

class BookPlace extends StatefulWidget {
  const BookPlace({super.key});

  @override
  State<BookPlace> createState() => _BookPlaceState();
}

final _razorpay = Razorpay();

class _BookPlaceState extends State<BookPlace> {
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
        .doc("${userIn!.email}$date$guideName$currentSelectedPlace")
        .delete();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    String date = DateTime.now().day.toString();
    FirebaseFirestore.instance
        .collection("Bookings")
        .doc("${userIn!.email}$date$guideName$currentSelectedPlace")
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection("Places").get(),
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
        return Wrap(
          children: [
            for (var item in snapshot.data!.docs)
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentSelectedPlace = item.id;
                    price_ = item['price'];
                  });
                  showMaterialModalBottomSheet(
                    context: context,
                    builder: (context) => SingleChildScrollView(
                      child: Container(
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
                                  0.04,
                                ),
                                bottom: addHeight(context, 0.03),
                              ),
                            ),
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(
                                item['img'][0],
                              ),
                            ),
                            Text(
                              item['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            Text(
                              " Service charge ₹ ${item['price']}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Color.fromARGB(255, 0, 71, 2),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(12),
                              width: double.infinity,
                              height: 2,
                              color: Colors.black,
                            ),
                            Text(
                              item['history'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 19,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(12),
                              width: double.infinity,
                              height: 2,
                              color: Colors.black,
                            ),
                            Text(
                              item['des'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                              ),
                            ),
                            const Text(
                              "Near Place",
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
                            for (var item in item['near'])
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

                                  FirebaseFirestore.instance
                                      .collection("Bookings")
                                      .doc(
                                          "${userIn!.email}$date$guideName$currentSelectedPlace")
                                      .set({
                                    "date": DateTime.now(),
                                    "guide": guideName,
                                    "email": userIn!.email,
                                    "guide_id": selectedGuid,
                                    "price": price_,
                                    "place": item.id,
                                    "status": "not yet",
                                    "number": selected_mobile_number,
                                  });

                                  var options = {
                                    'key': 'rzp_test_HPR933L2nTKRBP',
                                    'amount': 100 * 100,
                                    'name': 'shrinivasaprasada',

                                    'description': 'saree',
                                    'timeout': 500, // in seconds
                                    'prefill': {
                                      'contact': '9380869058',
                                      'email': 'shrinivasagowdagowda@gmail.com'
                                    }
                                  };

                                  _razorpay.open(options);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.46,
                  height: MediaQuery.of(context).size.height * 0.19,
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(37, 0, 0, 0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        width: MediaQuery.of(context).size.width * 0.42,
                        height: MediaQuery.of(context).size.height * 0.13,
                        child: Image.network(
                          item['img'][0],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        item['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item['address'],
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ),
          ],
        );
      },
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
