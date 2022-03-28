
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zg_beauty_and_hair/cloud_firestore/all_salon_ref.dart';
import 'package:zg_beauty_and_hair/cloud_firestore/services_ref.dart';
import 'package:zg_beauty_and_hair/model/booking_model.dart';
import 'package:zg_beauty_and_hair/model/services_model.dart';
import 'package:zg_beauty_and_hair/state/state_management.dart';
import 'package:zg_beauty_and_hair/utils/utils.dart';
import 'package:zg_beauty_and_hair/view_model/done_service/done_service_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoneServiceViewModelImp implements DoneServiceViewModel {
  @override
  double calculateTotalPrice(List<ServicesModel> serviceSelected) {
    return serviceSelected
        .map((item) => item.price)
        .fold(0,
            (value, element) => double.parse(value.toString()) + element);
  }

  @override
  Future<BookingModel> displayDetailBooking(BuildContext context, int timeSlot) {
    return getDetailBooking(context, timeSlot);
  }

  @override
  Future<List<ServicesModel>> displayServices(BuildContext context) {
    return getServices(context);
  }

  @override
  void finishService(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    var batch = FirebaseFirestore.instance.batch();
    var barberBook = context.read(selectedBooking).state;

    var userBook = FirebaseFirestore.instance
        .collection('Users')
        .doc('${barberBook.customerPhone}')
        .collection('Booking')
        .doc('${DateFormat('dd_MM_yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(barberBook.timeStamp))}');

    print('${barberBook.timeStamp}');

    Map<String, dynamic> updateDone = new Map();
    updateDone['done'] = true;
    updateDone['services'] = convertServices(context.read(selectedServices).state);
    updateDone['totalPrice'] = context.read(selectedServices).state
        .map((e) => e.price)
        .fold(0, (previousValue, element) => double.parse(previousValue.toString()) + element);

    batch.update(userBook, updateDone);
    batch.update(barberBook.reference!, updateDone);

    batch.commit().then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text('Booking Successfully'))).closed
          .then((v) => Navigator.of(context).pushNamed('/home'));

    });
  }

  @override
  bool isDone(BuildContext context) {
    return context.read(selectedBooking).state.done;
  }

  @override
  bool isSelectedService(BuildContext context, ServicesModel servicesModel) {
    return context.read(selectedServices).state.contains(servicesModel);
  }

  @override
  void onSelectedChip(BuildContext context, bool isSelected, ServicesModel e) {
    var list = context.read(selectedServices).state;
    if (isSelected) {
      list.add(e);
      context.read(selectedServices).state = list;
    }
    else {
      list.remove(e);
      context.read(selectedServices).state = list;
    }
  }
}