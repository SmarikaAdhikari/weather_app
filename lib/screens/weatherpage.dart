import 'package:flutter/material.dart';
import 'package:weather_app/provider/weather_service.dart';
import 'package:weather_app/screens/searchwidget.dart';
import '../provider/weather_model.dart';
import 'package:intl/intl.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
    with SingleTickerProviderStateMixin {
  final WeatherService weatherService = WeatherService();
  String city = 'Kathmandu';
  late Future<Weather> weather;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    weather = weatherService
        .fetchWeather(city)
        .then((data) => Weather.fromJson(data));

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getCurrentDateTime() {
    return DateFormat(' MMM d, EEEE ').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 50, 136, 176),
                  Color.fromARGB(255, 228, 233, 242)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5),
            child: Column(
              children: [
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.menu, color: Colors.white, size: 25),
                    const Text(
                      'Weather App',
                      style: TextStyle(color: Colors.white, fontSize: 32),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search,
                          color: Colors.white, size: 25),
                      onPressed: () {
                        showSearch(
                            context: context,
                            delegate: WeatherSearchDelegate(
                                onCitySelected: (selectedCity) {
                              setState(() {
                                city = selectedCity;
                                weather = weatherService
                                    .fetchWeather(city)
                                    .then((data) => Weather.fromJson(data));
                              });
                            }));
                      },
                    ),
                  ],
                ),
                FadeTransition(
                  opacity: _animation,
                  child: FutureBuilder<Weather>(
                    future: weather,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData) {
                        return const Center(child: Text('No data found'));
                      } else {
                        final weather = snapshot.data!;
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _getCurrentDateTime(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(2, 2),
                                      blurRadius: 4.0,
                                      color: Colors.black38,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 50),
                              Row(
                                children: [
                                  AnimatedSwitcher(
                                    duration:
                                        const Duration(milliseconds: 1000),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              6,
                                      key: ValueKey(weather.icon),
                                      child: Image.network(
                                        'https://openweathermap.org/img/w/${weather.icon}.png',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Column(
                                    children: [
                                      AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        child: Text(
                                          weather.city,
                                          key: ValueKey(weather.city),
                                          style: const TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(
                                                offset: Offset(2, 2),
                                                blurRadius: 4.0,
                                                color: Colors.black38,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        child: Text(
                                          '${weather.temperature}°C',
                                          key: ValueKey(weather.temperature),
                                          style: const TextStyle(
                                            fontSize: 48,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(
                                                offset: Offset(2, 2),
                                                blurRadius: 4.0,
                                                color: Colors.black38,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        child: Text(
                                          '(${weather.description})',
                                          key: ValueKey(weather.description),
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(
                                                offset: Offset(2, 2),
                                                blurRadius: 4.0,
                                                color: Colors.black38,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 80),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  card(weather, 'Wind Speed:',
                                      '${weather.windSpeed} m/s'),
                                  card(weather, 'Feels like:',
                                      '${weather.feelslike}°C'),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  card(weather, 'Pressure:',
                                      '${weather.pressure} hPa'),
                                  card(weather, 'Humidity:',
                                      '${weather.humidity} %'),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  card(weather, 'Visibility:',
                                      '${weather.visibility}'),
                                  card(weather, 'Sea Level:',
                                      '${weather.sealevel} m'),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container card(Weather weather, String title, String value) {
    return Container(
      height: 90,
      width: 120,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 129, 129, 129).withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
