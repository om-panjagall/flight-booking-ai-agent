import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../flights/domain/entities/flights.dart';
import '../controllers/booking_controller.dart';
import '../../domain/entities/booking.dart';
import '../../domain/usecases/get_booking.dart';
import '../../../payment/domain/usecases/create_payment.dart';

class BookingScreen extends StatefulWidget {
  final Flight? flight;
  final String? source;
  final String? destination;
  final String? date;
  final int adults;

  const BookingScreen({
    super.key,
    this.flight,
    this.source,
    this.destination,
    this.date,
    this.adults = 1,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late final BookingController controller;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passportController = TextEditingController();
  final _cardController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _payNow = true;
  final _flightNumberController = TextEditingController();
  final _airlineController = TextEditingController();
  final _departureController = TextEditingController();
  final _arrivalController = TextEditingController();
  final _dateController = TextEditingController();
  final _seatNumberController = TextEditingController(text: '12A');
  final _adultsController = TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();
    controller = BookingController(
      getBookings: GetIt.instance<GetBookings>(),
      createBooking: GetIt.instance<CreateBooking>(),
      createPayment: GetIt.instance<CreatePayment>(),
    );
    controller.addListener(_onControllerChanged);
    controller.loadBookings();

    if (widget.flight != null) {
      _flightNumberController.text = widget.flight!.flightNumber;
      _airlineController.text = widget.flight!.airline;
      _departureController.text = widget.source ?? '';
      _arrivalController.text = widget.destination ?? '';
      _dateController.text = widget.date ?? '';
      _seatNumberController.text = '12A';
      _adultsController.text = widget.adults.toString();
    }
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerChanged);
    _nameController.dispose();
    _emailController.dispose();
    _passportController.dispose();
    _flightNumberController.dispose();
    _airlineController.dispose();
    _departureController.dispose();
    _arrivalController.dispose();
    _dateController.dispose();
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _seatNumberController.dispose();
    _adultsController.dispose();
    super.dispose();
  }

  Future<void> _submitBooking() async {
    final booking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      flightNumber: _flightNumberController.text.trim(),
      airline: _airlineController.text.trim(),
      passengerName: _nameController.text.trim(),
      passengerEmail: _emailController.text.trim(),
      passportNumber: _passportController.text.trim(),
      departure: _departureController.text.trim(),
      arrival: _arrivalController.text.trim(),
      date: _dateController.text.trim(),
      seatNumber: _seatNumberController.text.trim(),
      adults: int.tryParse(_adultsController.text) ?? 1,
      totalPrice: (widget.flight?.price ?? 0.0) * (int.tryParse(_adultsController.text) ?? 1),
      status: 'Confirmed',
    );

    final success = await controller.submitBooking(
      booking: booking,
      cardNumber: _payNow ? _cardController.text.trim() : null,
      expiry: _payNow ? _expiryController.text.trim() : null,
      cvv: _payNow ? _cvvController.text.trim() : null,
      payNow: _payNow,
    );
    if (!mounted) return;

    if (success) {
      _resetForm();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking created successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(controller.errorMessage ?? 'Booking failed')),
      );
    }
  }

  void _resetForm() {
    _nameController.clear();
    _emailController.clear();
    _passportController.clear();
    _flightNumberController.clear();
    _airlineController.clear();
    _departureController.clear();
    _arrivalController.clear();
    _dateController.clear();
    _adultsController.text = '1';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildBookingForm(),
              const SizedBox(height: 16),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                child: _buildBookingList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.isSaving ? null : _submitBooking,
        label: controller.isSaving
            ? const Text('Saving...')
            : const Text('Create Booking'),
        icon: const Icon(Icons.book_online),
      ),
    );
  }

  Widget _buildBookingForm() {
    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(_nameController, 'Passenger Name'),
            const SizedBox(height: 10),
            _buildTextField(_emailController, 'Passenger Email', keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 10),
            _buildTextField(_flightNumberController, 'Flight Number'),
            const SizedBox(height: 10),
            _buildTextField(_airlineController, 'Airline'),
            const SizedBox(height: 10),
            _buildTextField(_departureController, 'Departure Airport'),
            const SizedBox(height: 10),
            _buildTextField(_arrivalController, 'Arrival Airport'),
            const SizedBox(height: 10),
            _buildTextField(_dateController, 'Date (YYYY-MM-DD)'),
            const SizedBox(height: 10),
            _buildTextField(_passportController, 'Passport Number'),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Pay now'),
                Switch(
                  value: _payNow,
                  onChanged: (v) => setState(() => _payNow = v),
                ),
              ],
            ),
            if (_payNow) ...[
              const SizedBox(height: 10),
              _buildTextField(_cardController, 'Card Number', keyboardType: TextInputType.number),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _buildTextField(_expiryController, 'MM/YY')),
                  const SizedBox(width: 10),
                  SizedBox(width: 100, child: _buildTextField(_cvvController, 'CVV', keyboardType: TextInputType.number)),
                ],
              ),
            ],
            const SizedBox(height: 10),
            _buildTextField(_seatNumberController, 'Seat Number'),
            const SizedBox(height: 10),
            _buildTextField(_adultsController, 'Adults', keyboardType: TextInputType.number),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildBookingList() {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.errorMessage != null) {
      return Center(child: Text(controller.errorMessage!));
    }

    if (controller.bookings.isEmpty) {
      return const Center(child: Text('No bookings yet'));
    }

    return ListView.separated(
      itemCount: controller.bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final booking = controller.bookings[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${booking.airline} - ${booking.flightNumber}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('Passenger: ${booking.passengerName}'),
                Text('Email: ${booking.passengerEmail}'),
                Text('Route: ${booking.departure} → ${booking.arrival}'),
                Text('Date: ${booking.date}'),
                Text('Seat: ${booking.seatNumber}'),
                Text('Adults: ${booking.adults}'),
                Text('Total: ₹${booking.totalPrice}'),
                const SizedBox(height: 6),
                Text('Status: ${booking.status}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
