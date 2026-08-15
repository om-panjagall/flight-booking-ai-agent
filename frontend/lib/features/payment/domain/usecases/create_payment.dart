import '../../domain/entities/payment.dart';
import '../../domain/repositories/payment_repository.dart';

class CreatePayment {
  final PaymentRepository repository;

  CreatePayment(this.repository);

  Future<Payment> call({required int bookingId, required double amount, required String transactionId, required String method}) {
    final payment = Payment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      bookingId: bookingId,
      amount: amount,
      transactionId: transactionId,
      paymentDate: DateTime.now().toIso8601String(),
      paymentMethod: method,
      paymentStatus: 'SUCCESS',
    );

    return repository.createPayment(payment: payment);
  }
}
