import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/helpers/units.dart';

class DayList extends StatefulWidget {
  const DayList(
      {super.key, required this.forecast, required this.onDayPressed});

  final List forecast;
  final Function(int) onDayPressed;

  @override
  State<DayList> createState() => _DayListState();
}

class _DayListState extends State<DayList> {
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
    return ListView.separated(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      separatorBuilder: (context, index) => const Divider(),
      itemCount: forecastNow.length,
      itemBuilder: (context, i) {
        return SizedBox(
          height: 50,
          child: TextButton(
              onPressed: () {
                widget.onDayPressed(i);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(DateFormat('EEE MMM dd')
                        .format(DateTime.parse(forecastNow[i]['dt_txt']))),
                  ),
                  Text(
                      "${(forecastNow[i]['main']['temp'] - 273.15).round()} / ${toCelsius(forecastNow[i]['main']['feels_like'])}"),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Image.network(
                      "http://openweathermap.org/img/wn/${forecastNow[i]['weather'][0]['icon']}@2x.png",
                      width: 40,
                    ),
                  ),
                  const Icon(Icons.navigate_next)
                ],
              )),
        );
      },
    );
  }
}
