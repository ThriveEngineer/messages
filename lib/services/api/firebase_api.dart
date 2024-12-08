import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:messages/main.dart';

class FirebaseApi {
  // create an instance of Firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize firebase messaging
  Future<void> initNotifications() async {

    // request permission to send notifications
    await _firebaseMessaging.requestPermission();

    // fetch the FCM token
    final fCMToken = await _firebaseMessaging.getToken();

    // print the token
    print("Token: $fCMToken");
  }

  // function to handle received messages
  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    // navigate to screen
    navigatorKey.currentState?.pushNamed(
      '/message_page',
      arguments: message,
    );
  }

  // function to initialize foreground and background settings
  Future initPushNotifications() async {
    // handle notification if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}