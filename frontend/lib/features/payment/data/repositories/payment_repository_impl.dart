import '../../domain/entities/payment.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_datasource.dart';
import '../models/payment_model.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Payment> createPayment({required Payment payment}) async {
    final model = payment is PaymentModel ? payment : PaymentModel(
      id: payment.id,
      bookingId: payment.bookingId,
      amount: payment.amount,
      transactionId: payment.transactionId,
      paymentDate: payment.paymentDate,
      paymentMethod: payment.paymentMethod,
      paymentStatus: payment.paymentStatus,
    );

    return remoteDataSource.createPayment(payment: model);
  }
}
