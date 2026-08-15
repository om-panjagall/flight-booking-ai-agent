import '../entities/ai.dart';
import '../repositories/ai_repository.dart';

class GetAI {
  final AIRepository repository;

  GetAI({required this.repository});

  Future<AIResponse> call({required String query}) {
    return repository.chat(query: query);
  }
}
