class Flight {
  final String flightNumber;
  final String airline;
  final double price;
  final String duration;
  final int availableSeats;

  const Flight({
    required this.flightNumber,
    required this.airline,
    required this.price,
    required this.duration,
    required this.availableSeats,
  });
}