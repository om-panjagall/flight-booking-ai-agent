import 'package:flutter/material.dart';

class FlightOfferCard extends StatelessWidget {
  final String from;
  final String to;
  final String airline;
  final String price;
  final String duration;
  final VoidCallback? onBook;

  const FlightOfferCard({
    super.key,
    required this.from,
    required this.to,
    required this.airline,
    required this.price,
    required this.duration,
    this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 3,
      shadowColor: Colors.black12,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Airline + Price
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.blue.shade50,
                  child: const Icon(
                    Icons.flight,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    airline,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Route
            Row(
              children: [
                Expanded(
                  child: _Location(
                    city: from,
                    label: 'Departure',
                    alignment: CrossAxisAlignment.start,
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    Icons.flight,
                    color: Colors.blue,
                  ),
                ),

                Expanded(
                  child: _Location(
                    city: to,
                    label: 'Arrival',
                    alignment: CrossAxisAlignment.end,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Duration + Book
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.grey,
                ),

                const SizedBox(width: 5),

                Text(
                  duration,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const Spacer(),

                SizedBox(
                  height: 38,
                  child: ElevatedButton(
                    onPressed: onBook,
                    child: const Text('Book Now'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Location extends StatelessWidget {
  final String city;
  final String label;
  final CrossAxisAlignment alignment;

  const _Location({
    required this.city,
    required this.label,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          city,
          textAlign: alignment == CrossAxisAlignment.end
              ? TextAlign.right
              : TextAlign.left,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}