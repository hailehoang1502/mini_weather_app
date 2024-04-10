import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/Weather.dart';
import '../services/WeatherService.dart';


class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() {
    return _WeatherPageState();
  }
}

class _WeatherPageState extends State<WeatherPage>{

  // apikey
  final _weatherService = WeatherService("7914db671f69c97f0a38b2022972e97e");
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {

    // get the current city
    String cityName = await _weatherService.getCurrentCity();

    // get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    catch (e) {
      print(e);
    }
  }

  // weather animation
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return "assets/animation/sunny.json"; //default weather

    switch (mainCondition.toLowerCase()) {
      case "clouds" :
      case "mist" :
      case "smoke" :
      case "haze" :
      case "dust" :
      case "fog" :
        return 'assets/animation/cloudy.json';
      case "rain" :
      case "drizzle" :
      case "shower rain" :
        return 'assets/animation/rainy.json';
      case "thunderstorm" :
        return 'assets/animation/storm.json';
      case "clear" :
        return 'assets/animation/sunny.json';
      default:
        return 'assets/animation/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();

    // fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //city name
              Text(_weather?.cityName ?? "loading city ..."),

              //animation
              Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

              //temperature
              Text('${_weather?.temperature.round()}°C'),

              //weather condition
              Text(_weather?.mainCondition ?? "")
            ],
          ),
        )
    );
  }

}