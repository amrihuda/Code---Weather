import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/helpers/units.dart';
import 'package:weather_app/helpers/direction.dart';
import 'dart:math' as math;

class DayDetail extends StatefulWidget {
  const DayDetail({
    super.key,
    required this.forecast,
    required this.tabIndex,
    required this.onListPressed,
  });

  final int tabIndex;
  final List forecast;
  final VoidCallback onListPressed;

  @override
  State<DayDetail> createState() => _DayDetailState();
}

class _DayDetailState extends State<DayDetail> {
  List forecastNow = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      forecastNow = widget.forecast;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DefaultTabController(
          length: forecastNow.length,
          initialIndex: widget.tabIndex,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        height: 44,
                        child: TabBar(
                            labelColor: Colors.blue,
                            unselectedLabelColor: Colors.black,
                            labelPadding: const EdgeInsets.all(4),
                            isScrollable: true,
                            indicator: ShapeDecoration(
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                color: Colors.grey.withOpacity(0.2)),
                            tabs: forecastNow
                                .map(
                                  (fc) => SizedBox(
                                    width: 25,
                                    child: Tab(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            DateFormat('EEE').format(DateTime.parse(fc['dt_txt'])),
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.grey.shade600),
                                          ),
                                          Text(
                                            DateFormat('dd').format(DateTime.parse(fc['dt_txt'])),
                                            style:
                                                const TextStyle(fontSize: 15, color: Colors.black),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList()),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      widget.onListPressed();
                    },
                    icon: const Icon(Icons.list),
                    splashRadius: 20,
                  )
                ],
              ),
              const Divider(),
              SizedBox(
                height: 650,
                child: TabBarView(
                  children: forecastNow
                      .map(
                        (fc) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        toBeginningOfSentenceCase(fc['weather'][0]['main'])
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        toBeginningOfSentenceCase(fc['weather'][0]['description'])
                                            .toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          "${(fc['main']['temp'] - 273.15).round()} / ${toCelsius(fc['main']['feels_like'])}"),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(
                                          "http://openweathermap.org/img/wn/${fc['weather'][0]['icon']}@2x.png",
                                          width: 40,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                color: Colors.white70,
                                height: 150,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text("Percipitation"),
                                        Text("-"),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text("Probability of precipitation"),
                                        Text("-"),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Wind"),
                                        Row(
                                          children: [
                                            Text(
                                              "Wind: ${fc['wind']['speed'].toStringAsFixed(1)}m/s ${direction(fc['wind']['deg'])}",
                                            ),
                                            Transform.rotate(
                                              angle: fc['wind']['deg'] * math.pi / 180,
                                              child: const Icon(
                                                Icons.navigation,
                                                size: 16,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Pressure"),
                                        Text("${fc['main']['pressure']}hPa"),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Humidity"),
                                        Text("${fc['main']['humidity']}%"),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text("UV Index"),
                                        Text("-"),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text("Sunrise"),
                                        Text("-"),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text("Sunset"),
                                        Text("-"),
                                      ],
                                    ),
                                  ]
                                      .map(
                                        (widget) => Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                          child: widget,
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
