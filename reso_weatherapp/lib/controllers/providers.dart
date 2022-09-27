import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reso_weatherapp/controllers/weather_state.dart';
import 'package:reso_weatherapp/services/weather_repo.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return FakeWeatherRespository();
});

final weatherNotifierProvider =
    StateNotifierProvider<WeatherNotifier, WeatherState>(
  (ref) => WeatherNotifier(ref.watch(weatherRepositoryProvider)),
);
