// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:cp_weather/secrets/api_keys.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/weather_response_model.dart';

class WeatherServiceProvider extends ChangeNotifier {
  WeatherModel? _weather;

  WeatherModel? get weather => _weather;

  bool _isloading = false;
  bool get isLoading => _isloading;

  String _error = "";
  String get error => _error;

  Future<void> fetchWeatherDataByCity(String city) async {
    _isloading = true;
    _error = "";
    // https: //api.openweathermap.org/data/2.5/weather?q=dubai&appid=8ba5a0b7fa9ffaf0ad261e05e9e4b573&units=metric
    try {
      final String apiUrl =
          "${APIEndPoints().cityUrl}$city&appid=${APIEndPoints().apikey}${APIEndPoints().unit}";
      print(apiUrl);
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);

        _weather = WeatherModel.fromJson(data);
        print(_weather!.main!.feelsLike);

        notifyListeners();
      } else {
        _error = "Failed to load data";
      }
    } catch (e) {
      _error = "Failed to load data $e";
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }
}
