import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shipment/config/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void showNotification(RemoteMessage message) {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final notification = message.notification;
  final android = message.notification?.android;

  try {
    flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'shipment_channel',
            'shipment_channel',
            channelDescription: 'ShipmentApp Mobile Notification Channel',
            importance: Importance.max,
            priority: Priority.high,
            icon: android.smallIcon,
          ),
        ),
      );
    }
  } catch (e) {
    debugPrint('Error showing notification: $e');
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  showNotification(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      showNotification(message);
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> _initFirebaseToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      debugPrint('FCM Token: $fcmToken');
    } else {
      debugPrint('Failed to get FCM token');
    }
  }

  @override
  void initState() {
    _initFirebaseToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shipment App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      initialRoute: Routes.main,
      routes: Routes.routes,
    );
  }
}
