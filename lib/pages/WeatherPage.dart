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
        body: Column(
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
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () {
                          _fetchWeatherFromAnotherCity(
                              textEditingController.text);
                          textEditingController.clear();
                        },
                        child: const Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 30,
                        )),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 150,
            ),
            Expanded(
                child: ListView(children: [
              // weather tab container
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Column(children: [
                  // city name, coutry, main condition and animation Row
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        border:
                            Border.all(width: 0.5, color: Colors.transparent),
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(5),
                            topLeft: Radius.circular(5))),
                    padding: const EdgeInsets.only(
                        left: 20, right: 10, top: 5, bottom: 5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //city name, country and main weather condition Column
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //city name, country name
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    _weather?.cityName != null
                                        ? '${_weather?.cityName}, ${_weather?.country}'
                                        : "loading city ...",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                              offset: Offset(2, 2),
                                              blurRadius: 15,
                                              color: Colors.black45)
                                        ],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                //weather condition
                                Text(
                                  _weather?.mainCondition ?? "",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                            offset: Offset(2, 2),
                                            blurRadius: 15,
                                            color: Colors.black45)
                                      ]),
                                )
                              ]),

                          //animation
                          Container(
                              height: 100,
                              width: 100,
                              child: Lottie.asset(getWeatherAnimation(
                                  _weather?.mainCondition))),
                        ]),
                  ),

                  // temperature and details Row
                  Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFFE8F12D),
                        border:
                            Border.all(width: 0.5, color: Colors.transparent),
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5))),
                    padding: const EdgeInsets.only(
                        left: 20, right: 10, top: 10, bottom: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //temperature
                          SizedBox(
                            width: 180,
                            child: Text(
                                _weather?.temperature != null
                                    ? '${_weather?.temperature.round()}°C'
                                    : "loading temperature ...",
                                style: const TextStyle(
                                    fontSize: 75, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis),
                          ),

                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Details
                                //Container chiều cao = 1 và đổ màu vào
                                const Text("Details",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const Text("--------------------------------",
                                    style: TextStyle(color: Colors.blue),
                                ),
                                // feels like Row
                                Row(children: [
                                  SizedBox(width:90, child: const Text("Feels like")),
                                  Text(
                                      _weather?.feelsLike != null
                                          ? '${_weather?.feelsLike.round()}°C'
                                          : "loading...",
                                      style: const TextStyle(fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis))
                                ]),

                                // wind speed Row
                                Row(children: [
                                  SizedBox(width: 90, child: const Text("Wind")),
                                  Text(
                                      _weather?.windSpeed != null
                                          ? '${_weather?.windSpeed.round()} m/s'
                                          : "loading...",
                                      style: const TextStyle(fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis))
                                ]),

                                // min temperature Row
                                Row(children: [
                                  SizedBox(width: 90, child: const Text("Min Temp")),
                                  Text(
                                      _weather?.minTemp != null
                                          ? '${_weather?.minTemp.round()}°C'
                                          : "loading...",
                                      style: const TextStyle(fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis))
                                ]),

                                // max temperature Row
                                Row(children: [
                                  SizedBox(width: 90, child: const Text("Max Temp")),
                                  Text(
                                      _weather?.maxTemp != null
                                          ? '${_weather?.maxTemp.round()}°C'
                                          : "loading...",
                                      style: const TextStyle(fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis))
                                ]),

                                // humidity Row
                                Row(children: [
                                  SizedBox(width: 90, child: const Text("Humidity")),
                                  Text(
                                      _weather?.humidity != null
                                          ? '${_weather?.humidity.round()}%'
                                          : "loading...",
                                      style: const TextStyle(fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis))
                                ]),
                              ])
                        ]),
                  ),
                ]),
              ),
              SizedBox(
                height: 15,
              ),

              SizedBox(
                height: 15,
              ),

              SizedBox(
                height: 15,
              ),
            ])),
          ],
        ));
  }
}
