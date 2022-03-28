import 'package:flutter/cupertino.dart';
import 'package:zg_beauty_and_hair/model/booking_model.dart';

abstract class BarberBookingHistoryViewModel {
  Future<List<BookingModel>> getBarberBookingHistory(
      BuildContext context, DateTime dateTime
      );
}