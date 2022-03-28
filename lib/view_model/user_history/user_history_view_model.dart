import 'package:flutter/cupertino.dart';
import 'package:zg_beauty_and_hair/model/booking_model.dart';

abstract class UserHistoryViewModel {
  Future<List<BookingModel>> displayUserHistory();
  void userCancelBooking(BuildContext context, BookingModel bookingModel);
}