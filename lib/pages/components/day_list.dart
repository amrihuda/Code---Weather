import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/helpers/units.dart';

class DayList extends StatelessWidget {
  const DayList({
    super.key,
    required this.forecast,
    required this.onDayPressed,
  });

  final List forecast;
  final Function(int) onDayPressed;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      separatorBuilder: (context, index) => const Divider(),
      itemCount: forecast.length,
      itemBuilder: (context, i) {
        return SizedBox(
          height: 50,
          child: TextButton(
              onPressed: () {
                onDayPressed(i);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                        DateFormat('EEE MMM dd').format(DateTime.parse(forecast[i]['dt_txt']))),
                  ),
                  Text(
                      "${(forecast[i]['main']['temp'] - 273.15).round()} / ${toCelsius(forecast[i]['main']['feels_like'])}"),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Image.network(
                      "http://openweathermap.org/img/wn/${forecast[i]['weather'][0]['icon']}@2x.png",
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
