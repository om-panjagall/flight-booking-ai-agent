import '../../domain/entities/ai.dart';

class AIModel extends AIResponse {
  AIModel({required super.query, required super.answer});

  factory AIModel.fromJson(Map<String, dynamic> json) {
    return AIModel(
      query: json['query'] as String,
      answer: json['answer'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'answer': answer,
    };
  }
}
