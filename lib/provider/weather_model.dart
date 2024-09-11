class Weather {
  final String city;
  final double temperature;
  final String description;
  final double windSpeed;
  final String icon;
  final String pressure;
  final String humidity;
  final String? visibility;
  final String sealevel;
  final String? feelslike;

  Weather({
    required this.city,
    required this.temperature,
    required this.description,
    required this.windSpeed,
    required this.icon,
    required this.pressure,
    required this.humidity,
    required this.visibility,
    required this.sealevel,
    required this.feelslike,
    

  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'],
      temperature: json['main']['temp'],
      description: json['weather'][0]['description'],
      windSpeed: json['wind']['speed'],
      icon: json['weather'][0]['icon'],
      pressure: json['main']['pressure'].toString(),
      humidity: json['main']['humidity'].toString(),
      visibility: json['visibility'].toString(),
      sealevel: json['main']['sea_level'].toString(),
      feelslike: json['main']['feels_like'].toString(),

    );
  }
}
