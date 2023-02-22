import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final dio = Dio();

String apiKey = dotenv.env['OWEATHER_API_KEY'] ?? '123';

getCurrentWeather(lat, lon) async {
  final response = await dio
      .get("https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey");
  return response.data;
}

getForecast(lat, lon) async {
  final response = await dio
      .get("https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey");
  return response.data;
}

getLocation(city) async {
  final response =
      await dio.get("https://api.openweathermap.org/geo/1.0/direct?q=$city&limit=5&appid=$apiKey");
  return response.data;
}

getCountries() async {
  final response = await dio.get("https://restcountries.com/v2/all");
  return response.data;
}
