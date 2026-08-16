import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../models/ai_model.dart';

abstract class AIRemoteDataSource {
  Future<AIModel> chat({required String query});
}

class AIRemoteDataSourceImpl implements AIRemoteDataSource {
  final http.Client client;

  AIRemoteDataSourceImpl({required this.client});

  @override
  Future<AIModel> chat({required String query}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.aiChat}');
    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': query}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to chat with AI: ${response.statusCode}');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    return AIModel.fromJson(data);
  }
}
