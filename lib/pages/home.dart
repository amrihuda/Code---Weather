import 'package:flutter/material.dart';
import 'package:weather_app/helpers/dio.dart';
import 'package:weather_app/helpers/direction.dart';
import 'package:weather_app/helpers/units.dart';
import 'package:weather_app/helpers/date.dart';
import 'package:weather_app/pages/loading.dart';
import 'package:weather_app/pages/search.dart';
import 'package:weather_app/pages/components/day_list.dart';
import 'package:weather_app/pages/components/day_detail.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.lat, required this.lon});

  final double lat;
  final double lon;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const TextStyle detailStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.bold);

  bool viewDetail = false;
  int detailIndex = 0;

  Map currentWeather = {};
  Map forecast = {};
  List forecastNow = [];

  @override
  void initState() {
    super.initState();

    getCurrentWeather(widget.lat, widget.lon).then((result) {
      setState(() {
        currentWeather = result;
      });
    });

    getForecast(widget.lat, widget.lon).then((result) {
      setState(() {
        forecast = result;
      });
      setState(() {
        List temp = result['list']
            .where((e) => DateTime.parse(e['dt_txt'])
                .isAfter(DateTime.now().subtract(const Duration(hours: 3))))
            .toList();
        temp.asMap().forEach((i, v) {
          if (i == 0) {
            forecastNow.add(v);
          } else {
            if (isSameHour(DateTime.parse(v['dt_txt']), DateTime.parse(temp[0]['dt_txt']))) {
              forecastNow.add(v);
            }
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Color(0xFF7AE5F5),
              Color(0xFFC9F6FF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Navigator(
        // key: _homeNavigatorKey,
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
              builder: (context) => SizedBox(
                  child: currentWeather.isNotEmpty && forecast.isNotEmpty
                      ? Scaffold(
                          appBar: AppBar(
                            title: Row(
                              children: [
                                Expanded(
                                  child: TextButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const SearchPage(),
                                          ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.black,
                                        alignment: Alignment.centerLeft,
                                      ),
                                      icon: const Icon(Icons.search),
                                      label: Text(
                                        currentWeather['name'],
                                        style: const TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.settings),
                                )
                              ],
                            ),
                          ),
                          body: ListView(
                            padding: const EdgeInsets.all(10),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Image.network(
                                            "http://openweathermap.org/img/wn/${currentWeather['weather'][0]['icon']}@2x.png",
                                            width: 40,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(toBeginningOfSentenceCase(
                                                    currentWeather['weather'][0]['main'])
                                                .toString()),
                                            Text(
                                              toBeginningOfSentenceCase(
                                                      currentWeather['weather'][0]['description'])
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    Text(
                                      toCelsius(currentWeather['main']['temp']),
                                      style: const TextStyle(
                                        fontSize: 72,
                                      ),
                                    ),
                                    Text(
                                      "Feels like ${toCelsius(currentWeather['main']['feels_like'])}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.white70,
                                height: 150,
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Wind: ${currentWeather['wind']['speed'].toStringAsFixed(1)}m/s ${direction(currentWeather['wind']['deg'])}",
                                              style: detailStyle,
                                            ),
                                            Transform.rotate(
                                              angle: currentWeather['wind']['deg'] * math.pi / 180,
                                              child: const Icon(
                                                Icons.navigation,
                                                size: 16,
                                              ),
                                            )
                                          ],
                                        ),
                                        Text("Humidity: ${currentWeather['main']['humidity']}%",
                                            style: detailStyle),
                                        const Text("UV Index: -", style: detailStyle)
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Pressure: ${currentWeather['main']['pressure']}hPa",
                                            style: detailStyle),
                                        Text(
                                            "Visibility: ${(currentWeather['visibility'] / 1000).toStringAsFixed(1)}km",
                                            style: detailStyle),
                                        const Text("Dew point: -", style: detailStyle),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 72,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: forecast['list'].length,
                                  itemBuilder: (context, i) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            DateFormat('HH:mm').format(DateTime.parse(
                                                        forecast['list'][i]['dt_txt'])) ==
                                                    "00:00"
                                                ? DateFormat('MMM dd').format(
                                                    DateTime.parse(forecast['list'][i]['dt_txt']))
                                                : DateFormat('HH:mm').format(
                                                    DateTime.parse(forecast['list'][i]['dt_txt'])),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          Image.network(
                                            "http://openweathermap.org/img/wn/${forecast['list'][i]['weather'][0]['icon']}@2x.png",
                                            width: 40,
                                          ),
                                          Text(
                                            toCelsius(forecast['list'][i]['main']['temp']),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              !viewDetail
                                  ? DayList(
                                      forecast: forecastNow,
                                      onDayPressed: (index) {
                                        setState(() {
                                          detailIndex = index;
                                          viewDetail = !viewDetail;
                                        });
                                      },
                                    )
                                  : DayDetail(
                                      forecast: forecastNow,
                                      tabIndex: detailIndex,
                                      onListPressed: () {
                                        setState(() {
                                          viewDetail = !viewDetail;
                                        });
                                      },
                                    ),
                            ]
                                .map((widget) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: widget,
                                    ))
                                .toList(),
                          ),
                        )
                      : const LoadingPage()));
        },
      ),
    );
  }
}
