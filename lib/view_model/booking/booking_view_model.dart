import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zg_beauty_and_hair/model/barber_model.dart';
import 'package:zg_beauty_and_hair/model/city_model.dart';
import 'package:zg_beauty_and_hair/model/salon_model.dart';

abstract class BookingViewModel {
  //City
  Future<List<CityModel>> displayCities();
  void onSelectedCity(BuildContext context, CityModel cityModel);
  bool isCitySelected(BuildContext context, CityModel cityModel);

  //Salon
  Future<List<SalonModel>> displaySalon(String cityName);
  void onSelectedSalon(BuildContext context, SalonModel salonModel);
  bool isSalonSelected(BuildContext context, SalonModel salonModel);

  //Barber
  Future<List<BarberModel>> displayBarber(SalonModel salonModel);
  void onSelectedBarber(BuildContext context, BarberModel barberModel);
  bool isBarberSelected(BuildContext context, BarberModel barberModel);

  //TimeSlot
  Future<int> displayMaxAvailableTimeSlot(DateTime dateTime);
  Future<List<int>> displayTimeSlotOfBarber(BarberModel barberModel, String date);
  bool isAvailableForTapTimeSlot(int maxTime, int index, List<int> listTimeSlot);
  void onSelectedTimeSlot(BuildContext context, int index);
  Color displayColorTimeSlot(BuildContext context, List<int> listTimeSlot, int index, int maxTimeSlot);

  //Confirm Booking
  void confirmBooking(BuildContext context, GlobalKey scaffoldKey);

}