import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controllers/home_controller.dart';
import '../widgets/search_card.dart';
import '../widgets/flight_offer_card.dart';
import '../widgets/section_title.dart';
import '../../../../features/flights/presentation/screens/flights_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeController controller;

  @override
  void initState() {
    super.initState();

    controller = GetIt.instance<HomeController>();

    controller.loadAirports();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF7F8FC),

          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: const Text(
              'Flight Agent',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome Back 👋',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Where do you want to fly?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                SearchCard(
                  airports: controller.airports,
                  loadingAirports:
                      controller.isLoadingAirports,
                  onSearch: ({
                    required source,
                    required destination,
                    required date,
                    required adults,
                  }) async {
                    await _searchFlights(
                      source: source,
                      destination: destination,
                      date: date,
                      adults: adults,
                    );
                  },
                ),

                const SizedBox(height: 30),

                const SectionTitle(
                  title: 'Popular Flights',
                ),

                const SizedBox(height: 15),

                if (controller.isSearchingFlights)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _searchFlights({
    required source,
    required destination,
    required DateTime date,
    required int adults,
  }) async {
    try {
      final results = await controller.search(
        source: source,
        destination: destination,
        date: date,
        adults: adults,
      );

      if (!mounted) {
        return;
      }

      debugPrint('Found ${results.length} flights');

      final dateString = '${date.year}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.day.toString().padLeft(2, '0')}';

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FlightsScreen(
            source: source.code,
            destination: destination.code,
            date: dateString,
            adults: adults,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Flight search failed: $e',
          ),
        ),
      );
    }
  }
}