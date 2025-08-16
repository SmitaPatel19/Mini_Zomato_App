import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../main.dart';

Future<void> configureDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize FCM
  final fcm = FirebaseMessaging.instance;
  await fcm.requestPermission();

  // Setup notifications
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final DarwinInitializationSettings iosSettings =
      DarwinInitializationSettings();

  await flutterLocalNotificationsPlugin.initialize(
    InitializationSettings(android: androidSettings, iOS: iosSettings),
  );

  // Handle foreground messages
  FirebaseMessaging.onMessage.listen((message) async {
    if (message.notification != null) {
      await flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.notification!.title,
        message.notification!.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'restaurant_channel',
            'Order Notifications',
            importance: Importance.high,
          ),
        ),
      );
    }
  });

  // Save FCM token
  FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection('restaurants').doc(uid).set({
        'fcmToken': token,
      }, SetOptions(merge: true));
    }
  });
}
