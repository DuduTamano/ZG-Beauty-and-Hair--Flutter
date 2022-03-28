
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:zg_beauty_and_hair/main.dart';

void initFirebaseMessagingHandler(AndroidNotificationChannel channel) {
  FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
    RemoteNotification? notification = remoteMessage.notification;
    AndroidNotification? android = remoteMessage.notification?.android;
    if(notification != null && android != null) {
      flutterLocalNotificationsPlugin!.show(
          notification.hashCode, notification.title, notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id,
                channel.name,
              //  channel.description,
                icon: '@mipmap/ic_launcher',
            )
          ));
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

  });
}