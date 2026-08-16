import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../models/payment_model.dart';

abstract class PaymentRemoteDataSource {
  Future<PaymentModel> createPayment({required PaymentModel payment});
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final http.Client client;

  PaymentRemoteDataSourceImpl({required this.client});

  @override
  Future<PaymentModel> createPayment({required PaymentModel payment}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.payments}');
    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payment.toJson()),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to create payment: ${response.statusCode}');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    return PaymentModel.fromJson(data);
  }
}
