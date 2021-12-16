
// import 'package:firebase_messaging/firebase_messaging.dart';

// Future<void> fcmInitialize () async {
//   /// Update the iOS foreground notification presentation options to allow
//   /// heads up notifications.
//   await FirebaseMessaging
//       .setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );  
//   NotificationSettings settings = await messaging.requestPermission(
//     alert: true,
//     announcement: false,
//     badge: true,
//     carPlay: false,
//     criticalAlert: false,
//     provisional: false,
//     sound: true,
//   );

// }


// class PyFcm {
//   FirebaseMessaging inst;
//   // === Singleton ===
//   PyFcm._onlyOne(): 
//     inst = FirebaseMessaging.instance;
//   static final PyFcm _instance = PyFcm._onlyOne();
//   factory PyFcm() {
//     return _instance;
//   }  
// }

// FirebaseMessaging messaging = FirebaseMessaging.instance;



// print('User granted permission: ${settings.authorizationStatus}');

// FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//   print('Got a message whilst in the foreground!');
//   print('Message data: ${message.data}');

//   if (message.notification != null) {
//     print('Message also contained a notification: ${message.notification}');
//   }
// });