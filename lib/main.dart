import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart'; // Import the generated Firebase options file
import 'screens/home_screen.dart'; // Your HomeScreen widget

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Initialize with the appropriate options
  );

  // Request permission for iOS devices (important for notifications)
  await FirebaseMessaging.instance.requestPermission();

  // Handle background and foreground messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Run the app
  runApp(MyApp());
}

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Here you can handle background messages and notifications
  print('Handling a background message: ${message.messageId}');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Joke App', // Your app's title
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(), // Your app's home screen
    );
  }
}
