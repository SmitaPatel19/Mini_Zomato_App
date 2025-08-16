import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AppUserType { user, restaurant, delivery }

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Request permissions
    await FirebaseMessaging.instance.requestPermission();

    // Android & iOS initialization
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    // Foreground messages
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Background token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen(_saveFcmToken);
  }

  void _onForegroundMessage(RemoteMessage message) async {
    if (message.notification != null) {
      await flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.notification!.title,
        message.notification!.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel',
            'Default Notifications',
            channelDescription: 'Default app notifications',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  }

  Future<void> _saveFcmToken(String token) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance
          .collection('users') // Change collection: users / restaurants / delivery_partners
          .doc(uid)
          .set({'fcmToken': token}, SetOptions(merge: true));
    }
  }

  void onDidReceiveNotificationResponse(NotificationResponse response) {
    print('Notification clicked: ${response.payload}');
    // Navigate to specific page
  }
}
