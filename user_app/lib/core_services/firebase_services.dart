// very small “DI” + FCM token save hook
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> configureDependencies() async {
  // Notifications: request permission & setup local notifications (Android/iOS)
  final fcm = FirebaseMessaging.instance;
  await fcm.requestPermission();
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: androidInit,
      iOS: DarwinInitializationSettings(),
    ),
  );

  // Foreground message display
  FirebaseMessaging.onMessage.listen((m) async {
    final n = m.notification;
    if (n != null) {
      await flutterLocalNotificationsPlugin.show(
        n.hashCode,
        n.title,
        n.body,
        const NotificationDetails(
          android: AndroidNotificationDetails('default', 'General'),
          iOS: DarwinNotificationDetails(),
        ),
      );
    }
  });

  // Save token for logged-in user on refresh
  FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'fcmToken': token,
      }, SetOptions(merge: true));
    }
  });
}
