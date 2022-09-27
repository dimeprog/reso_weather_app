import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reso_weatherapp/controllers/providers.dart';
import 'package:reso_weatherapp/services/weather_repo.dart';
import 'package:riverpod/riverpod.dart';

import '../controllers/weather_state.dart';
import '../models/weather.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            color: Colors.pink,
            fontSize: 20,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: ProviderListener(
          provider: weatherNotifierProvider,
          onChange: (context, stateOption, state) {
            if (state is WeatherError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                ),
              );
            }
          },
          child: Consumer(
            builder: (context, watch, child) {
              final state = watch.watch(weatherNotifierProvider);
              if (state is WeatherInitial) {
                return _buildSearchInput();
              } else if (state is Weatherloading) {
                return buildLoadingData();
              } else if (state is Weatherloaded) {
                return buildColumnWithData(state.weather);
              } else if (state is WeatherError) {
                return _buildSearchInput();
              } else {
                return _buildSearchInput();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSearchInput() {
    return Center(
      child: CityInputField(),
    );
  }

  Column buildColumnWithData(Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          weather.cityName,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          // Display the temperature with 1 decimal place
          "${weather.temp.toStringAsFixed(1)} °C",
          style: TextStyle(fontSize: 80),
        ),
        CityInputField(),
      ],
    );
  }

  Widget buildLoadingData() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class CityInputField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final m = ref.watch(weatherNotifierProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        onSubmitted: (value) => submitCityName(ref, value),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Enter a city",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  void submitCityName(WidgetRef ref, String cityName) {
    ref.read(weatherNotifierProvider.notifier).getWeather(cityName);
  }
}
