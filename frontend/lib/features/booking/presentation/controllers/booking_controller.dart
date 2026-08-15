import 'package:flutter/foundation.dart';

import '../../domain/entities/booking.dart';
import '../../domain/usecases/get_booking.dart';
import '../../../payment/domain/usecases/create_payment.dart';


class BookingController extends ChangeNotifier {
  final GetBookings getBookings;
  final CreateBooking createBooking;
  final CreatePayment createPayment;

  BookingController({
    required this.getBookings,
    required this.createBooking,
    required this.createPayment,
  });

  List<Booking> bookings = [];
  bool isLoading = false;
  bool isSaving = false;
  String? errorMessage;

  Future<void> loadBookings() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      bookings = await getBookings();
    } catch (e) {
      bookings = [];
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> submitBooking({
    required Booking booking,
    String? cardNumber,
    String? expiry,
    String? cvv,
    bool payNow = false,
  }) async {
    isSaving = true;
    errorMessage = null;
    notifyListeners();

    try {
      final created = await createBooking(booking: booking);

      if (payNow) {
        // Try to create payment right after booking is created
        try {
          final bookingId = int.tryParse(created.id) ?? 0;
          final txnSuffix = (cardNumber ?? '').replaceAll(RegExp(r'\s+'), '');
          final last4 = txnSuffix.length >= 4 ? txnSuffix.substring(txnSuffix.length - 4) : txnSuffix;
          final transactionId = '${DateTime.now().millisecondsSinceEpoch}-$last4';

          await createPayment(
            bookingId: bookingId,
            amount: created.totalPrice,
            transactionId: transactionId,
            method: 'card',
          );
        } catch (pErr) {
          // Payment failed — surface error but keep booking in list
          errorMessage = 'Payment failed: ${pErr.toString()}';
          bookings = [created, ...bookings];
          return false;
        }
      }

      bookings = [created, ...bookings];
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
