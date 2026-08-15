import '../../domain/entities/payment.dart';

abstract class PaymentRepository {
  Future<Payment> createPayment({required Payment payment});
}
