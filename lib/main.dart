import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data:${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Chat',
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          // primarySwatch: Colors.black,
          backgroundColor: Colors.white,
          accentColor: Colors.black,
          accentColorBrightness: Brightness.dark,
          buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Colors.black,
            textTheme: ButtonTextTheme.accent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                style: BorderStyle.solid,
                color: Colors.black,
              ),
            ),
          )),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }
            if (userSnapshot.hasData) {
              return const ChatScreen();
            }
            return const AuthScreen();
          }),
    );
  }
}
