import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:zg_beauty_and_hair/model/booking_model.dart';
import 'package:zg_beauty_and_hair/model/user_model.dart';
import 'package:zg_beauty_and_hair/state/state_management.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<UserModel> getUserProfiles(BuildContext context, String phone) async {
  CollectionReference userRef = FirebaseFirestore.instance.collection('Users');
  DocumentSnapshot snapshot = await userRef.doc(phone).get();
  if(snapshot.exists)
  {
    final data = snapshot.data() as Map<String, dynamic>;
    var userModel = UserModel.fromJson(data);
    context.read(userInformation).state = userModel;
    return userModel;
  } else
    return UserModel(name: '', address: '', phoneNumber: '', created: ''); //empty object
}

Future<List<BookingModel>> getUserHistory() async {
  var listBooking = new List<BookingModel>.empty(growable: true);
  var userRef = FirebaseFirestore.instance.collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
      .collection('Booking');

  var snapshot = await userRef.orderBy('timeStamp', descending: true).get();
  snapshot.docs.forEach((element) {
    var booking = BookingModel.fromJson(element.data());
    booking.docId = element.id;
    booking.reference = element.reference;
    listBooking.add(booking);
  });
  return listBooking;
}


Future<List<UserModel>> getAllUsers() async {
  List<UserModel> result = new List<UserModel>.empty(growable: true);
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  QuerySnapshot snapshot = await users.get();
  snapshot.docs.forEach((element) {
    result.add(UserModel.fromJson(element.data() as Map<String, dynamic>));
  });
  return result;
}

