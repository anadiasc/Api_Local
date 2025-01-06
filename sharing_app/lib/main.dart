import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart'; 
import 'package:sharing_app/splash_screen.dart';

void main() => runApp(DevicePreview(
      enabled: !kReleaseMode, // Ativa o DevicePreview apenas no modo debug
      builder: (context) => MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sharing',
      home: SplashScreen(),
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      debugShowCheckedModeBanner: false,
    );
  }
}
