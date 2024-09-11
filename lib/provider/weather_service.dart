import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey =
      '2b7cea1c380821e45c1ce27f71370c6a'; 
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final url = Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
