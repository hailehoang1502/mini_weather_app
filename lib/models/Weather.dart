class Weather {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final double minTemp;
  final double maxTemp;
  final double humidity;
  final double windSpeed;
  final String mainCondition;

  Weather({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.minTemp,
    required this.maxTemp,
    required this.humidity,
    required this.windSpeed,
    required this.mainCondition
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      country: json['sys']['country'],
      temperature: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      minTemp: json['main']['temp_min'].toDouble(),
      maxTemp: json['main']['temp_max'].toDouble(),
      humidity: json['main']['humidity'].toDouble(),
      windSpeed: json['wind']['speed'].toDouble(),
      mainCondition: json['weather'][0]['main'],
    );
  }
}