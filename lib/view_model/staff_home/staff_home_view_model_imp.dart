import 'package:flutter/material.dart';
import 'package:zg_beauty_and_hair/cloud_firestore/all_salon_ref.dart';
import 'package:zg_beauty_and_hair/model/city_model.dart';
import 'package:zg_beauty_and_hair/model/salon_model.dart';
import 'package:zg_beauty_and_hair/state/state_management.dart';
import 'package:zg_beauty_and_hair/utils/utils.dart';
import 'package:zg_beauty_and_hair/view_model/staff_home/staff_home_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StaffHomeViewModelImp implements StaffHomeViewModel{

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


  //Appointment
  @override
  Future<List<int>> displayTimeSlotOfBarber(BuildContext context, String date) {
    return getBookingSlotOfBarber(context, date);
  }

  @override
  Future<int> displayMaxAvailableTimeSlot(DateTime dateTime) {
    return getMaxAvailableTimeSlot(dateTime);
  }

  @override
  Future<bool> isStaffOfThisSalon(BuildContext context) {
    return checkStaffOfThisSalon(context);
  }

  @override
  bool isTimeSlotBooked(List<int> listTimeSlot, int index) {
    return listTimeSlot.contains(index) ? false : true;
  }

  @override
  void processDoneServices(BuildContext context, int index) {
    context.read(selectedTimeSlot).state = index;
    Navigator.of(context).pushNamed('/doneService');
  }

  @override
  Color getColorOfThisSlot(BuildContext context, List<int> listTimeSlot, int index, int maxTimeSlot) {
    return listTimeSlot.contains(index) ? Colors.white30 : //מלא
    maxTimeSlot > index ? Colors.black12 //לא פנוי
        : context.read(selectedTime).state ==
        TIME_SLOT.elementAt(index)
        ? Colors.black45
        : Colors.white;
  }

}