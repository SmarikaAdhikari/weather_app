import 'package:flutter/material.dart';

class WeatherSearchDelegate extends SearchDelegate {
  final Function(String) onCitySelected;

  WeatherSearchDelegate({required this.onCitySelected});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear, color: Colors.blue.shade500),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios, color: Colors.blueAccent),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onCitySelected(query);
      close(context, null);
    });

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.blueAccent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Stack(
          children: [
            Image.asset(
              'images/bgfour.jpeg',
              height: 800,
              fit: BoxFit.cover,
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.5)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> suggestions = [
      'Nepal',
      'London',
      'New York',
      'United Kingdom',
      'Germany',
      'France',
      'Italy',
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade100,
            const Color.fromARGB(255, 81, 138, 184)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ListTile(
            title: Text(
              suggestion,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            onTap: () {
              onCitySelected(suggestion);
              close(context, null);
            },
          );
        },
      ),
    );
  }
}
