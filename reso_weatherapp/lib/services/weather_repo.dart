import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reso_weatherapp/controllers/weather_state.dart';
import 'package:reso_weatherapp/models/weather.dart';

abstract class WeatherRepository {
  Future<Weather> fetchWeather(String cityName);
}

class FakeWeatherRespository extends WeatherRepository {
  @override
  Future<Weather> fetchWeather(String cityName) {
    return Future.delayed(
      Duration(seconds: 1),
      () {
        final random = Random();
        if (random.nextBool()) {
          throw NetworkException();
        }
        double locationTemp = 20 + random.nextInt(15) + random.nextDouble();
        return Weather(
          cityName: cityName,
          temp: locationTemp,
        );
      },
    );
  }
}

class WeatherNotifier extends StateNotifier<WeatherState> {
  final WeatherRepository _weatherRepository;
  WeatherNotifier(this._weatherRepository) : super(const WeatherInitial());

  Future<void> getWeather(String cityName) async {
    try {
      state = const Weatherloading();
      final response = await _weatherRepository.fetchWeather(cityName);
      state = Weatherloaded(response);
    } catch (err) {
      state = const WeatherError("can't fetch weather data from fake Server");
    }
  }
}

class NetworkException implements Exception {}
