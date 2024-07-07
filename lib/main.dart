import 'package:flutter/material.dart';
import 'package:restfull_api_modul/SplashScreen/lottie_screen.dart';
import 'package:restfull_api_modul/kabkota_listview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: false,
      ),
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const KabKotaListView(),
      },
    );
  }
}
