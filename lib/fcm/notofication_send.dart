import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:zg_beauty_and_hair/cloud_firestore/zg_server_key.dart';
import 'package:zg_beauty_and_hair/model/notification_model.dart';

Future<bool> sendNotification(NotificationModel notificationModel) async {
  var dataSubmit = jsonEncode(notificationModel);
  var key = await getServerKey();
  var result = await Dio().post('https://fcm.googleapis.com/fcm/send',
      options: Options(
        headers: {
          Headers.acceptHeader : 'application/json',
          Headers.contentTypeHeader : 'application/json',
          'Authorization' : 'key=$key'
        },
        sendTimeout: 30000,
        receiveTimeout: 30000,
        followRedirects: false,
        validateStatus: (status) => status! < 500
      ), data: dataSubmit);
  return result.statusCode == 200 ? true : false;
}