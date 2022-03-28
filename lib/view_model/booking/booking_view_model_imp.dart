import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zg_beauty_and_hair/cloud_firestore/all_salon_ref.dart';
import 'package:zg_beauty_and_hair/fcm/notofication_send.dart';
import 'package:zg_beauty_and_hair/model/barber_model.dart';
import 'package:zg_beauty_and_hair/model/booking_model.dart';
import 'package:zg_beauty_and_hair/model/city_model.dart';
import 'package:zg_beauty_and_hair/model/notification_model.dart';
import 'package:zg_beauty_and_hair/model/salon_model.dart';
import 'package:zg_beauty_and_hair/state/state_management.dart';
import 'package:zg_beauty_and_hair/utils/utils.dart';
import 'package:zg_beauty_and_hair/view_model/booking/booking_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookingViewModelImp implements BookingViewModel {

  //City
  @override
  Future<List<CityModel>> displayCities() {
    return getCities();
  }

  @override
  bool isCitySelected(BuildContext context, CityModel cityModel) {
    return context.read(selectedCity).state.name == cityModel.name;
  }

  @override
  void onSelectedCity(BuildContext context, CityModel cityModel) {
    context.read(selectedCity).state = cityModel;
  }


  //Salon
  @override
  Future<List<SalonModel>> displaySalon(String cityName) {
    return getSalonByCity(cityName);
  }

  @override
  bool isSalonSelected(BuildContext context, SalonModel salonModel) {
    return context.read(selectedSalon).state.docId == salonModel.docId;
  }

  @override
  void onSelectedSalon(BuildContext context, SalonModel salonModel) {
    context.read(selectedSalon).state = salonModel;
  }


  //Barber
  @override
  Future<List<BarberModel>> displayBarber(SalonModel salonModel) {
    return getBarbersBySalon(salonModel);
  }

  @override
  bool isBarberSelected(BuildContext context, BarberModel barberModel) {
    return context.read(selectedBarber).state.docId == barberModel.docId;
  }

  @override
  void onSelectedBarber(BuildContext context, BarberModel barberModel) {
    context.read(selectedBarber).state = barberModel;
  }


  //TimeSlot
  @override
  Color displayColorTimeSlot(BuildContext context, List<int> listTimeSlot, int index, int maxTimeSlot) {
    return listTimeSlot.contains(index)
        ? Colors.white30 //מלא
        : maxTimeSlot > index ? Colors.black12 //לא פנוי
        : context.read(selectedTime).state ==
        TIME_SLOT.elementAt(index)
        ? Colors.black45
        : Colors.white;
  }

  @override
  Future<int> displayMaxAvailableTimeSlot(DateTime dateTime) {
    return getMaxAvailableTimeSlot(dateTime);
  }

  @override
  Future<List<int>> displayTimeSlotOfBarber(BarberModel barberModel, String date) {
    return getTimeSlotOfBarber(barberModel, date);
  }

  @override
  bool isAvailableForTapTimeSlot(int maxTime, int index, List<int> listTimeSlot) {
    return (maxTime > index) || listTimeSlot.contains(index);
  }

  @override
  void onSelectedTimeSlot(BuildContext context, int index) {
    context.read(selectedTimeSlot).state = index;
    context.read(selectedTime).state = TIME_SLOT.elementAt(index);
  }


  //Confirm Booking
  @override
  void confirmBooking(BuildContext context, GlobalKey scaffoldKey) {
    var hour = context.read(selectedTime).state.length <= 10
        ? int.parse(
        context.read(selectedTime).state.split(':')[0].substring(0, 1))
        : int.parse(
        context.read(selectedTime).state.split(':')[0].substring(0,2));

    var minutes = context.read(selectedTime).state.length <= 10
        ? int.parse(context.read(selectedTime).state.split(':')[1].substring(0, 1))
        : int.parse(context.read(selectedTime).state.split(':')[1].substring(0,2));

    var timeStamp = DateTime(
        context.read(selectedDate).state.year,
        context.read(selectedDate).state.month,
        context.read(selectedDate).state.day,
        hour, //hour
        minutes//minutes
    ).millisecondsSinceEpoch;

    //Create booking model
    var bookingModel = BookingModel(
      totalPrice: 0,
      barberId: context.read(selectedBarber).state.docId!,
      barberName: context.read(selectedBarber).state.name,
      cityBook: context.read(selectedCity).state.name,
      customerId: FirebaseAuth.instance.currentUser!.uid,
      customerName: context.read(userInformation).state.name,
      customerPhone: FirebaseAuth.instance.currentUser!.phoneNumber!,
      salonAddress: context.read(selectedSalon).state.address,
      salonId: context.read(selectedSalon).state.docId!,
      salonName: context.read(selectedSalon).state.name,
      done: false,
      timeStamp: timeStamp,
      slot: context.read(selectedTimeSlot).state,
      time:
      '${context.read(selectedTime).state} - ${DateFormat('dd/MM/yyyy').format(context.read(selectedDate).state)}',
    );

    var batch = FirebaseFirestore.instance.batch();

    DocumentReference barberBooking = context
        .read(selectedBarber)
        .state
        .reference!
        .collection(
        '${DateFormat('dd_MM_yyyy').format(context.read(selectedDate).state)}')
        .doc(context.read(selectedTimeSlot).state.toString());

    DocumentReference userBooking = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber!)
        .collection('Booking') //For secure info
        .doc('${DateFormat('dd_MM_yyyy').format(context.read(selectedDate).state)}');


    batch.set(barberBooking, bookingModel.toJson());
    batch.set(userBooking, bookingModel.toJson());
    batch.commit().then((value){

      context.read(isLoading).state = true;
      var notificationModel = NotificationModel(to: '/topics/${context.read(selectedBarber).state.docId!}',
          notification: NotificationContent(
            title: 'תור חדש',
            body: 'נקבע תור חדש ע"י ${context.read(userInformation).state.name}  '
                '${FirebaseAuth.instance.currentUser!.phoneNumber!.replaceAll("+972", "0")}'));
      
      sendNotification(notificationModel)
      .then((value){

        context.read(isLoading).state = false;

      Navigator.of(context).pop();
        ScaffoldMessenger.of(scaffoldKey.currentContext!)
            .showSnackBar(SnackBar(content: Text('Booking Successfully'))).closed
            .then((v) => Navigator.of(context).pushNamed('/home'));

      //Reset value
      context.read(selectedDate).state = DateTime.now();
      context.read(selectedBarber).state = BarberModel(name: '');
      context.read(selectedCity).state = CityModel(name: '');
      context.read(selectedSalon).state = SalonModel(name: '', address: '');
      context.read(currentStep).state = 1;
      context.read(selectedTime).state = '';
      context.read(selectedTimeSlot).state = -1;

      //Create Event
      /*   final event = Event(
          title: 'Z&G Beauty and Hair',
          description: 'קביעת תור ${context.read(selectedTime).state} - '
              '${DateFormat('dd/MM/yyyy').format(context.read(selectedDate).state)}',
          location: 'הרצל 44, ראשון לציון',
          startDate: DateTime(
              context.read(selectedDate).state.year,
              context.read(selectedDate).state.month,
              context.read(selectedDate).state.day,
              hour,
              minutes
          ),
          endDate: DateTime(
              context.read(selectedDate).state.year,
              context.read(selectedDate).state.month,
              context.read(selectedDate).state.day,
              hour,
              minutes + 60
          ),
          iosParams: IOSParams(reminder: Duration(minutes: 60)),
          androidParams: AndroidParams(emailInvites: [])
      ); */
      //  Add2Calendar.addEvent2Cal(event).then((value) {});
      });


    });
  }
}