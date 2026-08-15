import 'package:flutter/material.dart';

import '../controllers/flights_controller.dart';
import '../../../../core/di/injection.dart';
import '../../domain/usecases/search_flights.dart';
import '../widgets/flight_result_card.dart';
import '../../../booking/presentation/screens/booking_screen.dart';

class FlightsScreen extends StatefulWidget {
  final String? source;
  final String? destination;
  final String? date;
  final int adults;

  const FlightsScreen({
    super.key,
    this.source,
    this.destination,
    this.date,
    this.adults = 1,
  });

  @override
  State<FlightsScreen> createState() => _FlightsScreenState();
}

class _FlightsScreenState extends State<FlightsScreen> {
  final FlightsController controller =
      FlightsController(searchFlights: getIt<SearchFlights>());

  @override
  void initState() {
    super.initState();

    controller.addListener(_onControllerChanged);

    if (widget.source != null && widget.destination != null && widget.date != null) {
      _searchFlights();
    }
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _searchFlights() async {
    await controller.search(
      source: widget.source!,
      destination: widget.destination!,
      date: widget.date!,
      adults: widget.adults,
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerChanged);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.source != null && widget.destination != null
              ? '${widget.source} → ${widget.destination}'
              : 'Flights',
        ),
      ),

      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (widget.source == null || widget.destination == null || widget.date == null) {
      return const Center(
        child: Text(
          'Search for flights from the home screen.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    if (controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (controller.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Unable to load flights',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(controller.errorMessage!),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  _searchFlights();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (controller.flights.isEmpty) {
      return const Center(
        child: Text(
          'No flights available',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.flights.length,
      itemBuilder: (context, index) {
        final flight = controller.flights[index];

        return FlightResultCard(
          flight: flight,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookingScreen(
                  flight: flight,
                  source: widget.source,
                  destination: widget.destination,
                  date: widget.date,
                  adults: widget.adults,
                ),
              ),
            );
          },
        );
      },
    );
  }
}