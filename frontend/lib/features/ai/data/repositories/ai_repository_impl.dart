import '../../domain/entities/ai.dart';
import '../../domain/repositories/ai_repository.dart';
import '../datasources/ai_remote_datasource.dart';

class AIRepositoryImpl implements AIRepository {
  final AIRemoteDataSource remoteDataSource;

  AIRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AIResponse> chat({required String query}) async {
    final model = await remoteDataSource.chat(query: query);
    return model;
  }
}
