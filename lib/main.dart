import 'package:flutter/material.dart';
import 'package:weather_app/pages/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:localstorage/localstorage.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final LocalStorage storage = LocalStorage('weather');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          titleSpacing: 5,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: FutureBuilder(
        future: storage.ready,
        builder: (BuildContext context, snapshot) {
          if (snapshot.data == true) {
            return HomePage(
              position: {
                "lat": storage.getItem('position')['lat'] ?? -6.1753942,
                "lon": storage.getItem('position')['lon'] ?? 106.827183,
              },
            );
          } else {
            return Container(
              color: Colors.white,
            );
          }
        },
      ),
    );
  }
}
