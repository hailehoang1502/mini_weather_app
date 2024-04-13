import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

class _WeatherPageState extends State<WeatherPage> {
  // apikey
  final _weatherService = WeatherService("7914db671f69c97f0a38b2022972e97e");
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    // get the current city
    String currentCityName = await _weatherService.getCurrentCity();

    // get weather for city
    try {
      final weather = await _weatherService.getWeather(currentCityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  _fetchWeatherFromAnotherCity(String cityName) {
    var streamController = StreamController<String>();
    Future.delayed(const Duration(milliseconds: 500),
        () => streamController.sink.add(cityName));
    streamController.stream.listen((event) async {
      try {
        final weather = await _weatherService.getWeather(event);
        setState(() {
          _weather = weather;
        });
      } catch (e) {
        print(e);
      }
      ;
    });
  }

  // weather animation
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return "assets/animation/loading.json"; //default weather
    }

    switch (mainCondition.toLowerCase()) {
      case "clouds":
      case "mist":
      case "smoke":
      case "haze":
      case "dust":
      case "fog":
        return 'assets/animation/cloudy.json';
      case "rain":
      case "drizzle":
      case "shower rain":
        return 'assets/animation/rainy.json';
      case "thunderstorm":
        return 'assets/animation/storm.json';
      case "clear":
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

  TextEditingController textEditingController = TextEditingController();

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.only(left: 15, top: 80, right: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 0.5, color: Colors.black)),
      child: TextField(
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        controller: textEditingController,
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
              size: 20,
            ),
            prefixIconConstraints: BoxConstraints(
              maxHeight: 20,
              minWidth: 25,
            ),
            border: InputBorder.none,
            hintText: "Search for a city",
            hintStyle: TextStyle(color: Colors.grey)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: searchBox(),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 80, right: 15),
                    child: Container(
                      height: 45,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                            )
                          ),
                          onPressed: () {
                            _fetchWeatherFromAnotherCity(
                                textEditingController.text);
                            textEditingController.clear();
                          },
                          child: const Icon(
                            Icons.search,
                            color: Colors.black,
                            size: 30,
                          )
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(
                height: 150,
              ),

              //city name
              Text(
                _weather?.cityName ?? "loading city ...",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),

              //animation
              Container(
                  height: 280,
                  width: 280,
                  child: Lottie.asset(getWeatherAnimation(_weather?.mainCondition))),

              const SizedBox(
                height: 10,
              ),

              //temperature
              Text(
                _weather?.temperature != null ? '${_weather?.temperature.round()}°C' : "loading temperature ...",
                style: TextStyle(fontSize: 20),
              ),

              SizedBox(height: 10,),

              //weather condition
              Text(
                _weather?.mainCondition ?? "",
                style: const TextStyle(fontSize: 20),
              )
            ],
          ),
        ));
  }
}
