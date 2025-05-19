import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shipment/components/button.dart';
import 'package:shipment/config/routes.dart';

class FirebaseCloudMessagingMain extends StatefulWidget {
  const FirebaseCloudMessagingMain({super.key});

  @override
  State<FirebaseCloudMessagingMain> createState() =>
      _FirebaseCloudMessagingMainState();
}

class _FirebaseCloudMessagingMainState
    extends State<FirebaseCloudMessagingMain> {
  TextEditingController fcmTokenController = TextEditingController();

  Widget buildFCMTokenField() {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5.0,
            spreadRadius: 1.0,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),
      child: TextFormField(
        readOnly: true,
        controller: fcmTokenController,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          counterText: '',
          hintText: 'FCM token',
          hintStyle: const TextStyle(
            fontSize: 16,
            color: Colors.black38,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 0.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 0.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 0.0,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _initFirebaseToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      debugPrint('FCM Token: $fcmToken');
      fcmTokenController.text = fcmToken;
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Image.asset(
                'assets/images/tracking.png',
                width: 300,
              ),
            ),
            const Text(
              'Welcome to Shipment Tracker',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Firebase Cloud Messaging Token',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            buildFCMTokenField(),
            const SizedBox(height: 20),
            buildButton(
              onPressed: () {
                final fcmToken = fcmTokenController.text;
                if (fcmToken.isNotEmpty) {
                  Clipboard.setData(ClipboardData(text: fcmToken));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('FCM Token copied to clipboard'),
                    ),
                  );
                }
              },
              title: 'Copy FCM Token',
              color: Colors.red,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.pushNamed(
            context,
            Routes.search,
          );
        },
        tooltip: 'Search Shipment',
        child: const Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
    );
  }
}
