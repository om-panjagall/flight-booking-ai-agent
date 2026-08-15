import '../entities/ai.dart';

abstract class AIRepository {
  Future<AIResponse> chat({required String query});
}
