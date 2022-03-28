import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zg_beauty_and_hair/model/booking_model.dart';
import 'package:zg_beauty_and_hair/model/services_model.dart';

abstract class DoneServiceViewModel{
  Future<BookingModel> displayDetailBooking(BuildContext context, int timeSlot);
  Future<List<ServicesModel>> displayServices(BuildContext context);
  void finishService(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey);
  double calculateTotalPrice(List<ServicesModel> serviceSelected);
  bool isDone(BuildContext context);
  bool isSelectedService(BuildContext context, ServicesModel servicesModel);
  void onSelectedChip(BuildContext context, bool isSelected, ServicesModel e);
}