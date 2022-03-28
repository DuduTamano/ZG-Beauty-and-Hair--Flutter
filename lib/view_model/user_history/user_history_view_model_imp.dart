import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zg_beauty_and_hair/cloud_firestore/user_ref.dart';
import 'package:zg_beauty_and_hair/model/booking_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zg_beauty_and_hair/state/state_management.dart';
import 'package:zg_beauty_and_hair/view_model/user_history/user_history_view_model.dart';

class UserHistoryViewModelImp implements UserHistoryViewModel {
  @override
  Future<List<BookingModel>> displayUserHistory() {
    return getUserHistory();
  }

  @override
  void userCancelBooking(BuildContext context, BookingModel bookingModel) {
    var batch = FirebaseFirestore.instance.batch();
    var barberBooking = FirebaseFirestore.instance
        .collection('AllSalon')
        .doc(bookingModel.cityBook)
        .collection('Branch')
        .doc(bookingModel.salonId)
        .collection('Barbers')
        .doc(bookingModel.barberId)
        .collection(DateFormat('dd_MM_yyyy').format(
        DateTime.fromMillisecondsSinceEpoch(bookingModel.timeStamp)))
        .doc(bookingModel.slot.toString());

    var userBooking = bookingModel.reference!;

    //Delete
    batch.delete(userBooking);
    batch.delete(barberBooking);

    batch.commit().then((value) {

      //Refresh Data
      context.read(deleteFlagRefresh).state = !context.read(deleteFlagRefresh).state;
    });
  }

}