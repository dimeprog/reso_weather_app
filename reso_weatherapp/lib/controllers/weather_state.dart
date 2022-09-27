import '../models/weather.dart';

abstract class WeatherState {
  const WeatherState();
}

class Weatherloading extends WeatherState {
  const Weatherloading();
}

class Weatherloaded extends WeatherState {
  final Weather weather;
  const Weatherloaded(this.weather);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Weatherloaded && o.weather == weather;
  }

  @override
  int get hashCode => weather.hashCode;
}

class WeatherError extends WeatherState {
  final String errorMessage;
  const WeatherError(this.errorMessage);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is WeatherError && o.errorMessage == errorMessage;
  }

  @override
  int get hashCode => errorMessage.hashCode;
}

class WeatherInitial extends WeatherState {
  const WeatherInitial();
}
