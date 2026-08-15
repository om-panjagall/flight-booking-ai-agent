class Payment {
  final String id;
  final int bookingId;
  final double amount;
  final String transactionId;
  final String paymentDate;
  final String paymentMethod;
  final String paymentStatus;

  const Payment({
    required this.id,
    required this.bookingId,
    required this.amount,
    required this.transactionId,
    required this.paymentDate,
    required this.paymentMethod,
    required this.paymentStatus,
  });
}
