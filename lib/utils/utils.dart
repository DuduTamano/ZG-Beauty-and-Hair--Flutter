
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:zg_beauty_and_hair/model/services_model.dart';
import 'package:zg_beauty_and_hair/model/shopping_items.dart';

enum LOGIN_STATE {LOGGED, NOT_LOGIN}

const TIME_SLOT = {
  '10:00 - 11:00',
  '11:00 - 12:00',
  '12:00 - 13:00',
  '13:00 - 14:00',
  '14:00 - 15:00',
  '15:00 - 16:00',
  '16:00 - 17:00',
  '17:00 - 18:00',
  '18:00 - 19:00',
};

Future<int> getMaxAvailableTimeSlot(DateTime dt) async {
  DateTime now = dt.toLocal();
  //sync time with server
  int offset = await NTP.getNtpOffset(localTime: now);
  DateTime syncTime = now.add(Duration(milliseconds: offset));

  //Compare syncTime with local time to enable time slot
  if(syncTime.isBefore(DateTime(now.year, now.month, now.day, 10,0)))

    //return next slot available
    return 0;

  else if(syncTime.isAfter(DateTime(now.year, now.month, now.day, 10,0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 11,0)))

    //return next slot available
    return 1;

  else if(syncTime.isAfter(DateTime(now.year, now.month, now.day, 11,0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 12,0)))
    return 2;

  else if(syncTime.isAfter(DateTime(now.year, now.month, now.day, 12,0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 13,0)))
    return 3;

  else if(syncTime.isAfter(DateTime(now.year, now.month, now.day, 13,0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 14,0)))

    return 4;
  else if(syncTime.isAfter(DateTime(now.year, now.month, now.day, 14,0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 15,0)))

    return 5;
  else if(syncTime.isAfter(DateTime(now.year, now.month, now.day, 15,0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 16,0)))

    return 6;
  else if(syncTime.isAfter(DateTime(now.year, now.month, now.day, 16,0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 17,0)))

    return 7;

  else if(syncTime.isAfter(DateTime(now.year, now.month, now.day, 17,0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 18,0)))
    return 8;

  else if(syncTime.isAfter(DateTime(now.year, now.month, now.day, 18,0)) &&
      syncTime.isBefore(DateTime(now.year, now.month, now.day, 19,0)))
    return 9;
  else
    return 10;
}

Future<DateTime> syncTime()async {
  var now = DateTime.now();
 // var offset = await NTP.getNtpOffset(localTime: now);
  //return now.add(Duration(milliseconds: offset));

  return now;
}

String convertServices(List<ServicesModel> services) {
  String result = '';
  if(services.length == 0)
    {
      services.forEach((element) {
        result += '${element.name}, ';
      });
    }
  return result.substring(0, result.length-0);
}